%% HG策略仿真交易模块，处理在各种信号出现的不同情况下，选择相应的交易策略，并对交易结果加以记录。
for i=2:length(ClosePrice)
    if SignalBuy(i)==1
        pos(i)=1;
    elseif SignalSell(i)==1
        pos(i)=-1;
    else
        pos(i)=pos(i-1);
    end
  
    
    %% 1、过程记录指标初始值定义模块
    % 在接下来的开仓模块，如果有相关信号出现，会改写此部分定义的初始值。MarketPosition根据pos的变化而变化，作为中间变量有其存在的必要性。
    % 【开第一单时，OpenPosNum为原始值0，如果此部分以pos作为分类条件，则出现33行的初始值定义错误，OpenPosPrice(OpenPosNum)索引值为0】
    if MarketPosition==0
        Lots(i)=Lots(i-1);
        LongMargin(i)=0;                      %多头保证金
        ShortMargin(i)=0;                     %空头保证金
        StaticEquity(i)=StaticEquity(i-1);     %静态权益
        DynamicEquity(i)=StaticEquity(i);   %动态权益
        Cash(i)=DynamicEquity(i);               %可用资金
        
    end
    if MarketPosition==1
        Lots(i)=Lots(i-1);
        ShortMargin(i)=0;                     %空头保证金
        LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;                      %多头保证金
        StaticEquity(i)=StaticEquity(i-1);     %静态权益
        DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);   %动态权益
        Cash(i)=DynamicEquity(i)-LongMargin(i);             %可用资金
        
    end
    if MarketPosition==-1
        Lots(i)=Lots(i-1);
        LongMargin(i)=0;                      %多头保证金
        ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;                      %空头保证金
        StaticEquity(i)=StaticEquity(i-1);     %静态权益
        DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);   %动态权益
        Cash(i)=DynamicEquity(i)-ShortMargin(i);             %可用资金=动态权益-保证金
        
    end
 

    
    %% 2、开仓模块
    %% （1）存在换月
    if addIdentiPara(i)~=0
        %% 1）多仓状态下换月
        if  pos(i-1)==1;
            MarketPosition=pos(i);
            MyEntryPrice(i)=OpenPrice(i);    %买入价为确定换月后的新主力合约开盘价
            MyEntryPrice(i)=MyEntryPrice(i)+Slip*MinMove*PriceScale;    %计入滑点后实际建仓价格
            
            if posm1==0
                Lots(i)=Lots2;                                                                              % 指定交易手数
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));                % 根据全部动态权益计算交易手数
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % 根据特定比例的动态权益计算交易手数
            end
            
            if Lots(i)<1                                                                                    % 当不足以交易一手时
                Lots(i)=0;                                                                                  % 不交易，即交易手数等于0                                 
            end
            
            % 单次交易变量记录
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=addIdentiPara(i)-Slip*MinMove*PriceScale;  %记录平仓价格
            CloseDate(ClosePosNum)=times(i);       %记录平仓时间
            OpenPosNum=OpenPosNum+1;
            OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %记录开仓价格
            OpenDate(OpenPosNum)=times(i);       %记录开仓时间
            Type(OpenPosNum)=1;                  %方向为多头

            huanduoNum=huanduoNum+1;                               %换多数加1
            huanduoDate(huanduoNum)=times(i);                      %换多时间
            huanduoOrder(i)=huanduoNum;                  %换多序列赋值为当前换空数 



            StaticEquity(i)=StaticEquity(i-1)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %静态权益=上期静态权益+(平仓价格-建仓价格)*交易单位*手数-所平仓的买卖成本，平仓时变化较大

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益
        end
        LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %多头保证金
        Cash(i)=DynamicEquity(i)-LongMargin(i);
        


        %% 2）空仓状态下换月

        if  pos(i-1)==-1;
            MarketPosition=pos(i);
            MyEntryPrice(i)=OpenPrice(i);     %买入价为确定换月后的新主力合约开盘价
            MyEntryPrice(i)=MyEntryPrice(i)-Slip*MinMove*PriceScale*2;    %计入滑点后实际建仓价格

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % 根据特定比例的动态权益计算交易手数
            end
            
            if Lots(i)<1                                                                                    % 当不足以交易一手时
                Lots(i)=0;                                                                                  % 不交易，即交易手数等于0                                 
            end
            
            
            % 单次交易变量记录
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=addIdentiPara(i)+Slip*MinMove*PriceScale*2;  %记录平仓价格
            CloseDate(ClosePosNum)=times(i);       %记录平仓时间
            OpenPosNum=OpenPosNum+1;
            OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %记录开仓价格
            OpenDate(OpenPosNum)=times(i);       %记录开仓时间
            Type(OpenPosNum)=-1;                  %方向为空头

            huankongNum=huankongNum+1;                               %换空数加1
            huankongDate(huankongNum)=times(i);                      %换空时间
            huankongOrder(i)=huankongNum;                  %换空序列赋值为当前换空数             



            StaticEquity(i)=StaticEquity(i-1)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %静态权益=上期静态权益+(平仓价格-建仓价格)*交易单位*手数-所平仓的买卖成本，平仓时变化较大

            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益
        end
        ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %空头保证金
        Cash(i)=DynamicEquity(i)-ShortMargin(i);
    end               

    %% （2）买入信号成立，开多头
    if pos(i-1)~=1 && pos(i)==1
        MarketPosition=pos(i);
        ShortMargin(i)=0;          %平空后空头保证金为0，【有其必要性，改写大前提的原始值，不然交易当天MarketPosition认为前值，大前提下会导致保证金方向也为前一天方向】。
        MyEntryPrice(i)=ClosePrice(i);    %买入价为买入信号确立当天的收盘价
        MyEntryPrice(i)=MyEntryPrice(i)+Slip*MinMove*PriceScale;    %计入滑点后实际建仓价格

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % 根据特定比例的动态权益计算交易手数
            end
            
            if Lots(i)<1                                                                                    % 当不足以交易一手时
                Lots(i)=0;                                                                                  % 不交易，即交易手数等于0                                 
            end
             
        
        % 单次交易变量记录
        if pos(i-1)==-1                       % 之前为空头，需平仓
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=MyEntryPrice(i);  %记录平仓价格
            CloseDate(ClosePosNum)=times(i);       %记录平仓时间
        end
        OpenPosNum=OpenPosNum+1;
        OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %记录开仓价格
        OpenDate(OpenPosNum)=times(i);       %记录开仓时间
        Type(OpenPosNum)=1;                  %方向为多头
%             text(times(i),MyEntryPrice(i),'\leftarrow平空开多各1手','Color','red','FontSize',8);

%         SignalBuyNum=SignalBuyNum+1;                               %买入信号数加1
%         SignalBuyDate(SignalBuyNum)=times(i);                      %买入信号时间
%         SignalBuyOrder(i)=SignalBuyNum;                  %买入信号序列赋值为当前买入信号数
        
        
        if addIdentiPara(i)~=0                               % 同时存在换月时，经过换月后再按买卖信号交易静态权益计算方法不同，此处静态权益为当天值加其他变化
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);       
            end

            if pos(i-1)==-1
                StaticEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %静态权益=上期静态权益+(卖价【前建仓价格】-买价（现平仓价）)*交易单位*手数-所平仓的买卖成本，平仓时变化较大   
            end

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益
            LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %多头保证金
            Cash(i)=DynamicEquity(i)-LongMargin(i);
        end
        
        if addIdentiPara(i)==0                               % 与存在换月时的静态权益计算方法略有不同
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);       
            end

            if pos(i-1)==-1
                StaticEquity(i)=StaticEquity(i-1)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %静态权益=上期静态权益+(卖价【前建仓价格】-买价（现平仓价）)*交易单位*手数-所平仓的买卖成本，平仓时变化较大   
            end

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益
            LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %多头保证金
            Cash(i)=DynamicEquity(i)-LongMargin(i);        
        end
    end




    %% （3）卖出信号成立，开空头
     if pos(i-1)~=-1 && pos(i)==-1
        MarketPosition=pos(i);
        LongMargin(i)=0;          %平多后多头保证金为0
        MyEntryPrice(i)=ClosePrice(i);    %买入价为买入信号确立当天的收盘价
        MyEntryPrice(i)=MyEntryPrice(i)-Slip*MinMove*PriceScale;    %计入滑点后实际建仓价格

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % 根据特定比例的动态权益计算交易手数
            end
            
            if Lots(i)<1                                                                                    % 当不足以交易一手时
                Lots(i)=0;                                                                                  % 不交易，即交易手数等于0                                 
            end
            
        
        % 单次交易变量记录
        if pos(i-1)==1
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=MyEntryPrice(i);  %记录平仓价格
            CloseDate(ClosePosNum)=times(i);       %记录平仓时间
        end
        OpenPosNum=OpenPosNum+1;
        OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %记录开仓价格
        OpenDate(OpenPosNum)=times(i);       %记录开仓时间
        Type(OpenPosNum)=-1;                  %方向为空头
%             text(times(i),MyEntryPrice(i),'\leftarrow平多开空各1手','Color','green','FontSize',8);

%         SignalSellNum=SignalSellNum+1;                               %买入信号数加1
%         SignalSellDate(SignalSellNum)=times(i);                      %买入信号时间
%         SignalSellOrder(i)=SignalSellNum;                  %买入信号序列赋值为当前买入信号数              

        if addIdentiPara(i)~=0
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);
            end

            if pos(i-1)==1
                StaticEquity(i)=StaticEquity(i)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;    %静态权益=上期静态权益+(平仓价格-建仓价格)*交易单位*手数-所平仓的买卖成本，平仓时变化较大
            end
            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益        
            ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %空头保证金
            Cash(i)=DynamicEquity(i)-ShortMargin(i);
        end
        
        
        if addIdentiPara(i)==0
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);
            end

            if pos(i-1)==1
                StaticEquity(i)=StaticEquity(i-1)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;    %静态权益=上期静态权益+(平仓价格-建仓价格)*交易单位*手数-所平仓的买卖成本，平仓时变化较大
            end
            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %动态权益=静态权益+所持头寸随价格变化而发生的损益        
            ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %空头保证金
            Cash(i)=DynamicEquity(i)-ShortMargin(i);   
        end                
    end

        
    %% （4）如果最后一天有持仓，则以收盘价平掉
    if i==length(ClosePrice)
        pos(i)=0;
        MarketPosition=pos(i);
        LongMargin(i)=0;
        ShortMargin(i)=0;
        ClosePosNum=ClosePosNum+1;
        ClosePosPrice(ClosePosNum)=ClosePrice(i);  %记录平仓价格
        CloseDate(ClosePosNum)=times(i);       %记录平仓时间

        if pos(i-1)==1
            StaticEquity(i)=StaticEquity(i-1)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;
        end

        if pos(i-1)==-1
            StaticEquity(i)=StaticEquity(i-1)+(OpenPosPrice(OpenPosNum)-ClosePosPrice(ClosePosNum))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;
        end
        DynamicEquity(i)=StaticEquity(i);        %空仓时动态权益和静态权益相等；
        Cash(i)=DynamicEquity(i);                %空仓时可用资金等于动态权益
    end       
end
