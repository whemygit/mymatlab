%% HG���Է��潻��ģ�飬�����ڸ����źų��ֵĲ�ͬ����£�ѡ����Ӧ�Ľ��ײ��ԣ����Խ��׽�����Լ�¼��
for i=2:length(ClosePrice)
    if SignalBuy(i)==1
        pos(i)=1;
    elseif SignalSell(i)==1
        pos(i)=-1;
    else
        pos(i)=pos(i-1);
    end
  
    
    %% 1�����̼�¼ָ���ʼֵ����ģ��
    % �ڽ������Ŀ���ģ�飬���������źų��֣����д�˲��ֶ���ĳ�ʼֵ��MarketPosition����pos�ı仯���仯����Ϊ�м����������ڵı�Ҫ�ԡ�
    % ������һ��ʱ��OpenPosNumΪԭʼֵ0������˲�����pos��Ϊ���������������33�еĳ�ʼֵ�������OpenPosPrice(OpenPosNum)����ֵΪ0��
    if MarketPosition==0
        Lots(i)=Lots(i-1);
        LongMargin(i)=0;                      %��ͷ��֤��
        ShortMargin(i)=0;                     %��ͷ��֤��
        StaticEquity(i)=StaticEquity(i-1);     %��̬Ȩ��
        DynamicEquity(i)=StaticEquity(i);   %��̬Ȩ��
        Cash(i)=DynamicEquity(i);               %�����ʽ�
        
    end
    if MarketPosition==1
        Lots(i)=Lots(i-1);
        ShortMargin(i)=0;                     %��ͷ��֤��
        LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;                      %��ͷ��֤��
        StaticEquity(i)=StaticEquity(i-1);     %��̬Ȩ��
        DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);   %��̬Ȩ��
        Cash(i)=DynamicEquity(i)-LongMargin(i);             %�����ʽ�
        
    end
    if MarketPosition==-1
        Lots(i)=Lots(i-1);
        LongMargin(i)=0;                      %��ͷ��֤��
        ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;                      %��ͷ��֤��
        StaticEquity(i)=StaticEquity(i-1);     %��̬Ȩ��
        DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);   %��̬Ȩ��
        Cash(i)=DynamicEquity(i)-ShortMargin(i);             %�����ʽ�=��̬Ȩ��-��֤��
        
    end
 

    
    %% 2������ģ��
    %% ��1�����ڻ���
    if addIdentiPara(i)~=0
        %% 1�����״̬�»���
        if  pos(i-1)==1;
            MarketPosition=pos(i);
            MyEntryPrice(i)=OpenPrice(i);    %�����Ϊȷ�����º����������Լ���̼�
            MyEntryPrice(i)=MyEntryPrice(i)+Slip*MinMove*PriceScale;    %���뻬���ʵ�ʽ��ּ۸�
            
            if posm1==0
                Lots(i)=Lots2;                                                                              % ָ����������
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));                % ����ȫ����̬Ȩ����㽻������
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % �����ض������Ķ�̬Ȩ����㽻������
            end
            
            if Lots(i)<1                                                                                    % �������Խ���һ��ʱ
                Lots(i)=0;                                                                                  % �����ף���������������0                                 
            end
            
            % ���ν��ױ�����¼
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=addIdentiPara(i)-Slip*MinMove*PriceScale;  %��¼ƽ�ּ۸�
            CloseDate(ClosePosNum)=times(i);       %��¼ƽ��ʱ��
            OpenPosNum=OpenPosNum+1;
            OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %��¼���ּ۸�
            OpenDate(OpenPosNum)=times(i);       %��¼����ʱ��
            Type(OpenPosNum)=1;                  %����Ϊ��ͷ

            huanduoNum=huanduoNum+1;                               %��������1
            huanduoDate(huanduoNum)=times(i);                      %����ʱ��
            huanduoOrder(i)=huanduoNum;                  %�������и�ֵΪ��ǰ������ 



            StaticEquity(i)=StaticEquity(i-1)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %��̬Ȩ��=���ھ�̬Ȩ��+(ƽ�ּ۸�-���ּ۸�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������
        end
        LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
        Cash(i)=DynamicEquity(i)-LongMargin(i);
        


        %% 2���ղ�״̬�»���

        if  pos(i-1)==-1;
            MarketPosition=pos(i);
            MyEntryPrice(i)=OpenPrice(i);     %�����Ϊȷ�����º����������Լ���̼�
            MyEntryPrice(i)=MyEntryPrice(i)-Slip*MinMove*PriceScale*2;    %���뻬���ʵ�ʽ��ּ۸�

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % �����ض������Ķ�̬Ȩ����㽻������
            end
            
            if Lots(i)<1                                                                                    % �������Խ���һ��ʱ
                Lots(i)=0;                                                                                  % �����ף���������������0                                 
            end
            
            
            % ���ν��ױ�����¼
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=addIdentiPara(i)+Slip*MinMove*PriceScale*2;  %��¼ƽ�ּ۸�
            CloseDate(ClosePosNum)=times(i);       %��¼ƽ��ʱ��
            OpenPosNum=OpenPosNum+1;
            OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %��¼���ּ۸�
            OpenDate(OpenPosNum)=times(i);       %��¼����ʱ��
            Type(OpenPosNum)=-1;                  %����Ϊ��ͷ

            huankongNum=huankongNum+1;                               %��������1
            huankongDate(huankongNum)=times(i);                      %����ʱ��
            huankongOrder(i)=huankongNum;                  %�������и�ֵΪ��ǰ������             



            StaticEquity(i)=StaticEquity(i-1)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %��̬Ȩ��=���ھ�̬Ȩ��+(ƽ�ּ۸�-���ּ۸�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�

            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������
        end
        ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
        Cash(i)=DynamicEquity(i)-ShortMargin(i);
    end               

    %% ��2�������źų���������ͷ
    if pos(i-1)~=1 && pos(i)==1
        MarketPosition=pos(i);
        ShortMargin(i)=0;          %ƽ�պ��ͷ��֤��Ϊ0���������Ҫ�ԣ���д��ǰ���ԭʼֵ����Ȼ���׵���MarketPosition��Ϊǰֵ����ǰ���»ᵼ�±�֤����ҲΪǰһ�췽�򡿡�
        MyEntryPrice(i)=ClosePrice(i);    %�����Ϊ�����ź�ȷ����������̼�
        MyEntryPrice(i)=MyEntryPrice(i)+Slip*MinMove*PriceScale;    %���뻬���ʵ�ʽ��ּ۸�

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % �����ض������Ķ�̬Ȩ����㽻������
            end
            
            if Lots(i)<1                                                                                    % �������Խ���һ��ʱ
                Lots(i)=0;                                                                                  % �����ף���������������0                                 
            end
             
        
        % ���ν��ױ�����¼
        if pos(i-1)==-1                       % ֮ǰΪ��ͷ����ƽ��
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=MyEntryPrice(i);  %��¼ƽ�ּ۸�
            CloseDate(ClosePosNum)=times(i);       %��¼ƽ��ʱ��
        end
        OpenPosNum=OpenPosNum+1;
        OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %��¼���ּ۸�
        OpenDate(OpenPosNum)=times(i);       %��¼����ʱ��
        Type(OpenPosNum)=1;                  %����Ϊ��ͷ
%             text(times(i),MyEntryPrice(i),'\leftarrowƽ�տ����1��','Color','red','FontSize',8);

%         SignalBuyNum=SignalBuyNum+1;                               %�����ź�����1
%         SignalBuyDate(SignalBuyNum)=times(i);                      %�����ź�ʱ��
%         SignalBuyOrder(i)=SignalBuyNum;                  %�����ź����и�ֵΪ��ǰ�����ź���
        
        
        if addIdentiPara(i)~=0                               % ͬʱ���ڻ���ʱ���������º��ٰ������źŽ��׾�̬Ȩ����㷽����ͬ���˴���̬Ȩ��Ϊ����ֵ�������仯
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);       
            end

            if pos(i-1)==-1
                StaticEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %��̬Ȩ��=���ھ�̬Ȩ��+(���ۡ�ǰ���ּ۸�-��ۣ���ƽ�ּۣ�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�   
            end

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������
            LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
            Cash(i)=DynamicEquity(i)-LongMargin(i);
        end
        
        if addIdentiPara(i)==0                               % ����ڻ���ʱ�ľ�̬Ȩ����㷽�����в�ͬ
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);       
            end

            if pos(i-1)==-1
                StaticEquity(i)=StaticEquity(i-1)+(OpenPosPrice(OpenPosNum-1)-ClosePosPrice(ClosePosNum))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;  %��̬Ȩ��=���ھ�̬Ȩ��+(���ۡ�ǰ���ּ۸�-��ۣ���ƽ�ּۣ�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�   
            end

            DynamicEquity(i)=StaticEquity(i)+(ClosePrice(i)-OpenPosPrice(OpenPosNum))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������
            LongMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
            Cash(i)=DynamicEquity(i)-LongMargin(i);        
        end
    end




    %% ��3�������źų���������ͷ
     if pos(i-1)~=-1 && pos(i)==-1
        MarketPosition=pos(i);
        LongMargin(i)=0;          %ƽ����ͷ��֤��Ϊ0
        MyEntryPrice(i)=ClosePrice(i);    %�����Ϊ�����ź�ȷ����������̼�
        MyEntryPrice(i)=MyEntryPrice(i)-Slip*MinMove*PriceScale;    %���뻬���ʵ�ʽ��ּ۸�

            if posm1==0
                Lots(i)=Lots2;
            end
            if posm1==1
                Lots(i)=floor(DynamicEquity(i-1)/(MyEntryPrice(i)*TradingUnit*MarginRatio));
            end
            if posm1==2
                Lots(i)=floor(DynamicEquity(i-1)*RatioDyna/(MyEntryPrice(i)*TradingUnit*MarginRatio));      % �����ض������Ķ�̬Ȩ����㽻������
            end
            
            if Lots(i)<1                                                                                    % �������Խ���һ��ʱ
                Lots(i)=0;                                                                                  % �����ף���������������0                                 
            end
            
        
        % ���ν��ױ�����¼
        if pos(i-1)==1
            ClosePosNum=ClosePosNum+1;
            ClosePosPrice(ClosePosNum)=MyEntryPrice(i);  %��¼ƽ�ּ۸�
            CloseDate(ClosePosNum)=times(i);       %��¼ƽ��ʱ��
        end
        OpenPosNum=OpenPosNum+1;
        OpenPosPrice(OpenPosNum)=MyEntryPrice(i);  %��¼���ּ۸�
        OpenDate(OpenPosNum)=times(i);       %��¼����ʱ��
        Type(OpenPosNum)=-1;                  %����Ϊ��ͷ
%             text(times(i),MyEntryPrice(i),'\leftarrowƽ�࿪�ո�1��','Color','green','FontSize',8);

%         SignalSellNum=SignalSellNum+1;                               %�����ź�����1
%         SignalSellDate(SignalSellNum)=times(i);                      %�����ź�ʱ��
%         SignalSellOrder(i)=SignalSellNum;                  %�����ź����и�ֵΪ��ǰ�����ź���              

        if addIdentiPara(i)~=0
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);
            end

            if pos(i-1)==1
                StaticEquity(i)=StaticEquity(i)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;    %��̬Ȩ��=���ھ�̬Ȩ��+(ƽ�ּ۸�-���ּ۸�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�
            end
            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������        
            ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
            Cash(i)=DynamicEquity(i)-ShortMargin(i);
        end
        
        
        if addIdentiPara(i)==0
            if pos(i-1)==0
                StaticEquity(i)=StaticEquity(i-1);
            end

            if pos(i-1)==1
                StaticEquity(i)=StaticEquity(i-1)+(ClosePosPrice(ClosePosNum)-OpenPosPrice(OpenPosNum-1))...
                    *TradingUnit*Lots(i)-OpenPosPrice(OpenPosNum-1)*TradingUnit*Lots(i)*TradingCost...
                    -ClosePosPrice(ClosePosNum)*TradingUnit*Lots(i)*TradingCost;    %��̬Ȩ��=���ھ�̬Ȩ��+(ƽ�ּ۸�-���ּ۸�)*���׵�λ*����-��ƽ�ֵ������ɱ���ƽ��ʱ�仯�ϴ�
            end
            DynamicEquity(i)=StaticEquity(i)+(OpenPosPrice(OpenPosNum)-ClosePrice(i))*TradingUnit*Lots(i);  %��̬Ȩ��=��̬Ȩ��+����ͷ����۸�仯������������        
            ShortMargin(i)=ClosePrice(i)*Lots(i)*TradingUnit*MarginRatio;     %��ͷ��֤��
            Cash(i)=DynamicEquity(i)-ShortMargin(i);   
        end                
    end

        
    %% ��4��������һ���гֲ֣��������̼�ƽ��
    if i==length(ClosePrice)
        pos(i)=0;
        MarketPosition=pos(i);
        LongMargin(i)=0;
        ShortMargin(i)=0;
        ClosePosNum=ClosePosNum+1;
        ClosePosPrice(ClosePosNum)=ClosePrice(i);  %��¼ƽ�ּ۸�
        CloseDate(ClosePosNum)=times(i);       %��¼ƽ��ʱ��

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
        DynamicEquity(i)=StaticEquity(i);        %�ղ�ʱ��̬Ȩ��;�̬Ȩ����ȣ�
        Cash(i)=DynamicEquity(i);                %�ղ�ʱ�����ʽ���ڶ�̬Ȩ��
    end       
end
