%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1、分笔评价指标记录
%% （1）每次交易成本、净利润、每次盈利（亏损）、盈亏次数
for i=1:ClosePosNum
     CostSeries(i)=(OpenPosPrice(i)+ClosePosPrice(i))*TradingUnit*Lots(i)*TradingCost;
      % 建立多头时
     if Type(i)==1
         NetMargin(i)=(ClosePosPrice(i)-OpenPosPrice(i))*TradingUnit*Lots(i)-CostSeries(i);
         if NetMargin(i)>=0
             WinNum=WinNum+1;
             WinNetMargin(i)=NetMargin(i);
         else
             LoseNum=LoseNum+1;
             LoseNetMargin(i)=NetMargin(i);
         end
     end
      % 建立空头时
     if Type(i)==-1
         NetMargin(i)=(OpenPosPrice(i)-ClosePosPrice(i))*TradingUnit*Lots(i)-CostSeries(i);
         if NetMargin(i)>=0
             WinNum=WinNum+1;
             WinNetMargin(i)=NetMargin(i);
         else
             LoseNum=LoseNum+1;
             LoseNetMargin(i)=NetMargin(i);
         end
     end
 end
 %% （2）单次收益率
 for i=1:ClosePosNum     
     RateofReturn(i)=NetMargin(i)/(OpenPosPrice(i)*TradingUnit*Lots(i)*MarginRatio);
 end
 %% （3）每次累计指标
  %% 1）累计净利,累计盈利额和累计亏损额，累计收益率
CumNetMargin=cumsum(NetMargin);                                         %向量形式的每次净利润累计值
CumWinNetMargin=cumsum(WinNetMargin);                                   %向量形式的每次盈利时净利润累计值
CumLoseNetMargin=cumsum(LoseNetMargin);                                 %向量形式的每次亏损时润累计值
CumRateofReturn=cumsum(RateofReturn);                                   %向量形式的每次收益率累计值


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2、综合评价指标记录
 %% （1）最终累计指标
CumNetMarginFinal=CumNetMargin(length(CumNetMargin));                   %最终净利润
DynamicEquityFinal=DynamicEquity(length(DynamicEquity));                   %最终权益
NetReturnRatio=CumNetMargin(length(CumNetMargin))/InitalFund;           %净收益率，净利润与初始资金的比值
CumWinNetMarginFinal=CumWinNetMargin(length(CumWinNetMargin));          %最终盈利额
CumLoseNetMarginFinal=CumLoseNetMargin(length(CumLoseNetMargin));       %最终亏损额
CumRateofReturnFinal=CumRateofReturn(length(CumRateofReturn));          %最终累计收益率
 %% （2）平均盈利，平均亏损，胜率和亏损比例
AverWinNetMargin=CumWinNetMargin(length(CumWinNetMargin))/WinNum;       %平均盈利，总盈利与盈利次数的比
AverLoseNetMargin=CumLoseNetMargin(length(CumLoseNetMargin))/LoseNum;   %平均亏损，总亏损与亏损次数的比
WinRatio=WinNum/ClosePosNum;                                            %胜率
LoseRatio=LoseNum/ClosePosNum;                                          %亏损比例



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3、与动态权益相关的指标
%% （1）最大最小权益
ExtrHiDyna=max(DynamicEquity);                     % 最大权益为整个动态权益序列的最大值。
ExtrLowDyna=min(DynamicEquity);                     % 最小权益为整个动态权益序列的最小值。

% 计算过程中所需中间变量
OrderNum=1:length(ClosePrice);                   %K线序号向量
% ExtrHiDynaDate=0;             %极高点日期
% ExtrHiDynatoEnd=0;            %极高点距离最后一个交易日距离

DynamicEquityData=[OrderNum',times,DynamicEquity];   %加入序号列的动态权益矩阵

% (1)ExtrHiDynaDate【最大权益日期】
ExtrHiDynaRow=find(DynamicEquity==ExtrHiDyna);              % 找出最大权益所在行号ExtrHiDynaRow
ExtrHiDynaDate=times(ExtrHiDynaRow(1));                        % 最大权益时间,存在多个最大值的话取第一个
% datestr(ExtrHiDynaDate,'dd/mm/yyyy');                       % 转换为字符串日期

% (2)ExtrHiDynatoEnd【最大权益K线距离】与ExtrHiDynatoEndactu【最大权益实际时间距离】
ExtrHiDynatoEnd=length(ClosePrice)-ExtrHiDynaRow(1);         % 【最大权益K线距离】最大动态权益距离最后一个交易日K线距离，K线长度-最大权益所在行号。
ExtrHiDynatoEndactu=times(end)-ExtrHiDynaDate;            % 【最大权益实际时间距离】最大动态权益距离最后一个交易日实际时间距离，K线最后时间-最大权益时间。

% (3)DyMaxDynamicEquity【动态最大权益向量】截止目前为止的动态权益高点向量,（主要作为计算权益未创新高时间段的中间变量存在）
DyMaxDynamicEquity=zeros(length(ClosePrice),1);            %【动态最大权益向量】截止目前为止的动态权益高点向量
DyMaxDynamicEquityDate=zeros(length(ClosePrice),1);        %【动态最大权益日期向量】
DyMaxDynamicEquityOrder=zeros(length(ClosePrice),1);       %【动态最大权益序号向量】
DyMaxDynamicEquityNum=1;        %动态最大权益计数，因为第一天值为当天权益，所以存在原始值1。

DyMaxDynamicEquity(1)=DynamicEquity(1);
DyMaxDynamicEquityOrder(1)=OrderNum(1);
DyMaxDynamicEquityDate(1)=times(1);


for i=2:length(ClosePrice)
    DyMaxDynamicEquity(i)=max(DynamicEquity(1:i));                           %截止目前为止的动态权益高点向量
    if DyMaxDynamicEquity(i)>DyMaxDynamicEquity(i-1)                                %出现新的高点则加以标记
        DyMaxDynamicEquityNum=DyMaxDynamicEquityNum+1;                               %高点数加1
        DyMaxDynamicEquityDate(DyMaxDynamicEquityNum)=times(i);                      %标记高点实际时间
        DyMaxDynamicEquityOrder(DyMaxDynamicEquityNum)=OrderNum(i);                  %标记最高点K线序号
    end
end

% (4)maxkperiod【权益最长未创新高K线周期】
p1=zeros(length(ClosePrice),1);                          %中间变量，相邻高点K线距离向量
for i=2:DyMaxDynamicEquityNum
     p1(i)=DyMaxDynamicEquityOrder(i)-DyMaxDynamicEquityOrder(i-1);
end
maxkperiod=max(p1);
if length(ClosePrice)-DyMaxDynamicEquityOrder(i)>maxkperiod              % 考虑期间某一时点创完新高后一直到最后未创新高情况，（最后一根K线序号-最后一次创新高序号）与前期未创新高周期取较大者
    maxkperiod=length(ClosePrice)-DyMaxDynamicEquityOrder(i);
end


% (5)maxactuperiod【权益最长未创新高最长实际周期】
p2=zeros(length(ClosePrice),1);                          %中间变量，相邻高点实际日期距离向量
for i=2:DyMaxDynamicEquityNum
     p2(i)=DyMaxDynamicEquityDate(i)-DyMaxDynamicEquityDate(i-1);
end
maxactuperiod=max(p2);                                           %创新高所跨最长实际时间
if maxkperiod==length(ClosePrice)-DyMaxDynamicEquityOrder(i)
    maxactuperiod=times(end)-DyMaxDynamicEquityDate(i);
end


% 6)maxactuperiodStart【权益最长未创新高起始时间】和maxactuperiodEnd【权益最长未创新高结束时间】
DyMaxDynamicEquityDate(1)=times(1);
for i=2:DyMaxDynamicEquityNum
     p2(i)=DyMaxDynamicEquityDate(i)-DyMaxDynamicEquityDate(i-1);
     if p2(i)==maxactuperiod
         maxactuperiodEnd=DyMaxDynamicEquityDate(i);    
         maxactuperiodStart=DyMaxDynamicEquityDate(i-1);
     end
end
if maxkperiod==length(ClosePrice)-DyMaxDynamicEquityOrder(i)
    maxactuperiodEnd=times(end);
    maxactuperiodStart=DyMaxDynamicEquityDate(i);
end


%% （2）MaxBackRatio【最大回撤比】及MaxBackRatioDate【最大回撤比时间】

for i=1:length(ClosePrice)
   BackRatio(i)=(DyMaxDynamicEquity(i)-DynamicEquity(i))/DyMaxDynamicEquity(i);
end
MaxBackRatio=max(BackRatio);   %找出整个序列中回撤比例最大值，作为最大回撤比

MaxBackRatioRow=find(BackRatio==MaxBackRatio);           % 找出最大回撤比所在的行
MaxBackRatioDate=times(MaxBackRatioRow(1));                 % 找出对应行的日期，存在多个的话取第一个。


