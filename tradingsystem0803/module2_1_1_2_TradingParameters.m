%% 1、合约参数
MarginRatio=0.05;      %【保证金率】
MinMove=1;             %【最小变动单位】
PriceScale=1;          %【商品计价单位】，即1元/吨
TradingUnit=10;        %【交易单位】，即每手10吨

%% 2、交易参数
Slip=1;                %【滑点】
% Lots=1;                %【下单手数】
Lots=zeros(length(ClosePrice),1);   %【买卖手数】
TradingCost=0.00005;   %【交易手续费】为成交金额的万分之0.5
InitalFund=1000000;     %【初始资金】为10万

%% 3、交易过程记录变量及其初始化值（大部分以与收盘价相同长度的向量形式表示）
MyEntryPrice=zeros(length(ClosePrice),1);   %【买卖价格】
MarketPosition=0;                           %【仓位状态】，-1表示持有空头，0表示无持仓，1表示持有多头
pos=zeros(length(ClosePrice),1);            %【记录仓位情况】，-1表示持有空头，0表示无持仓，1表示持有多头
LongMargin=zeros(length(ClosePrice),1);    %【多头保证金】
ShortMargin=zeros(length(ClosePrice),1);   %【空头保证金】
Cash=repmat(InitalFund,length(ClosePrice),1);     %【可用资金】，初始值=初始资金为10万
DynamicEquity=repmat(InitalFund,length(ClosePrice),1);  %【动态权益】，初始值=初始资金10万
StaticEquity=repmat(InitalFund,length(ClosePrice),1);  %【静态权益】，初始值=初始资金为10万
BackRatio=zeros(length(ClosePrice),1);          %【回撤比例】,交易过程中动态权益萎缩向量

%% 4、系统评价指标
%% （1）分笔记录指标
Type=zeros(length(ClosePrice),1);           %【买卖类型】，1标示多头，-1标示空头
OpenPosPrice=zeros(length(ClosePrice),1);   %【建仓价格】记录
ClosePosPrice=zeros(length(ClosePrice),1);  %【平仓价格】记录
OpenPosNum=0;                               %【建仓价格序号】
ClosePosNum=0;                              %【平仓价格序号】
OpenDate=zeros(length(ClosePrice),1);       %【建仓时间】
CloseDate=zeros(length(ClosePrice),1);      %【平仓时间】

%% （2）分笔评价指标
NetMargin=zeros(length(ClosePrice),1);       %【逐笔盈亏】，（每笔净利）向量
CumNetMargin=zeros(length(ClosePrice),1);    %【累计盈亏】，（每笔累计净利）向量
RateofReturn=zeros(length(ClosePrice),1);    %【逐笔收益率】，（每笔收益率）向量
CumRateofReturn=zeros(length(ClosePrice),1); %【累计收益率】，每笔累计收益率，cumsum(RateofReturn)，无实际意义。
WinNetMargin=zeros(length(ClosePrice),1);    %【逐笔盈利】，每笔盈利时记录盈利金额，%逐笔盈利率
CumWinNetMargin=zeros(length(ClosePrice),1); %【累计盈利】，每笔盈利时记录盈利金额的累计值
LoseNetMargin=zeros(length(ClosePrice),1);   %【逐笔亏损】，每笔亏损时记录亏损金额
CumLoseNetMargin=zeros(length(ClosePrice),1);%【累计亏损】，每笔亏损时记录亏损金额的累计值
CostSeries=zeros(length(ClosePrice),1);      %【交易成本】，每笔交易成本向量，
% 增加滑点成本统计


% % 买卖信号记录变量
% % 用于检测计算过程是否正确的变量
% SignalBuyDate=zeros(length(ClosePrice),1);        %【买入信号日期】向量
% SignalBuyOrder=zeros(length(ClosePrice),1);       %【买入信号序号】向量
% SignalBuyNum=0;        %【买入信号计数】
% SignalSellDate=zeros(length(ClosePrice),1);       %【卖出信号日期】向量
% SignalSellOrder=zeros(length(ClosePrice),1);      %【卖出信号序号】向量
% SignalSellNum=0;        %【卖出信号计数】
% 
% 移仓换月记录变量
% 用于检测计算过程是否正确的变量
huanduoDate=zeros(length(ClosePrice),1);        %换多日期向量
huanduoOrder=zeros(length(ClosePrice),1);       %换多序号向量
huanduoNum=0;        %换多计数
huankongDate=zeros(length(ClosePrice),1);       %换空日期向量
huankongOrder=zeros(length(ClosePrice),1);      %换空序号向量
huankongNum=0;        %换空计数   

%% （2）综合评价指标
CumNetMarginFinal=0;                           %【总盈亏】，累计盈亏最后一个值，CumNetMargin(length(CumNetMargin));
CumRateofReturnFinal=0;                        %最终累计收益率，累计收益率最后一个值，CumRateofReturn(length(CumRateofReturn));
NetReturnRatio=0;                            %【总收益率】净收益率，=【总盈亏】/【初始资金】，=CumNetMarginFinal/InitalFund;
CumWinNetMarginFinal=0;                           %【总盈利】，累计盈利最后一个值，CumWinNetMargin(length(CumWinNetMargin));
CumLoseNetMarginFinal=0;                       %【总亏损】，累计亏损最后一个值，CumLoseNetMargin(length(CumLoseNetMargin));
ClosePosNum=0;                               %【交易次数】
WinNum=0;                                   %【盈利次数】
WinRatio=0;                                 %【胜率】
LoseNum=0;                                  %【亏损次数】
LoseRatio=0;                                %【亏损比例】
AverWinNetMargin=0;                         %【平均盈利】，=【总盈利】/【盈利次数】,=WinNetMarginFinal/WinNum.
AverLoseNetMargin=0;                        %【平均亏损】单次平均亏损
MaxBackRatio=0;                             %【最大回撤比】，例，max（BackRatio）
MaxBackRatioDate=0;                         %【最大回撤时间】
ExtrHiDyna=0;                               %【最大权益】极大动态权益
ExtrHiDynaDate=0;                           %【最大权益日期】极大动态权益日期
ExtrHiDynatoEnd=0;                          %【最大权益K线距离】极大动态权益距离最后一根K线距离
ExtrHiDynatoEndactu=0;                      %【最大权益实际时间距离】极大动态权益距离最后一个交易日的实际时间长度
maxkperiod=0;                               %【权益最长未创新高周期数】动态权益创新高所需最大K线周期
maxactuperiod=0;
maxactuperiodStart=0;                       %【权益最长未创新高起始时间】
maxactuperiodEnd=0;                         %【权益最长未创新高结束时间】