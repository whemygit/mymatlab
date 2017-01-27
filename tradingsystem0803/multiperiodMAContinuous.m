%% 添加了品种和周期的输入功能，更改了不同输入下的数据选择功能，将原来的module1_2_3_mutliperioddatachoose.m实现多周期切换模块
%% 改为module1_2_3_datachoose.m，实现多品种多周期的切换。
%% 一、前期准备工作
%% （一）、清理工作空间及窗口
clear all, clc; close all;
cd F:\tradingsystem0803


%% （二）、数据准备
%% 1、从wind提取数据
% 直接运行放在F:\MainandMultiContractDayDataExtraxt和F:\MainandMultiContractMinuDataExtraxt目录下的各周期以dataextract.m结尾的文件,提取各品种多周期多合约数据
% multicontract_dataextract
% multicontractmin_dataextract


%% 2、拼接数据
% 直接运行放在F:\MainandMultiContractDayDataExtraxt和F:\MainandMultiContractMinuDataExtraxt目录下的各周期以contract.m结尾的文件,拼接各周期的主连数据
% continuous_contract
% continuous_mincontract


%% 3、下载数据
% 下载上一步保存好的多品种各周期的mat文件数据，1min、5min、15min和day选项分别对应相应的周期。
module1_2_3_datachoose                % 运行位于当前目录下的module1_2_3_datachoose.m文件，实现不同品种不同周期数据的选择

%% 二、交易系统仿真
result=[];                                       %构造空矩阵，待放入每次循环输出结果
% 根据posm取值不同实现交易手数选择的功能
posm=input('Which posm do you prefer? 0/1/2: ', 's');           % 输入posm选择不同的交易手数计算方法，0时指事先指定特定交易手数，1根据全部动态权益计算可交易手数，2根据一定比例的动态权益计算相应手数
disp(posm)
posm1=str2num(posm);
if posm1==0                                                            % 当设置posm1=0，也即固定手数时
    Lots1=input('Please set the number of lots for trading:', 's');    % 需要输入固定手数的具体值
    Lots2=str2num(Lots1);
end

if posm1==2                                                            % 当设置posm1=3，也即根据某一比例的动态权益值计算手数时
    RatioDyna1=input('Please set the Ratio of dynamic equity for calculating the lots,such as 0.8:', 's');    % 需要输入动态权益的比例的具体值
    RatioDyna=str2num(RatioDyna1);
end

Dy=[];                                           %构造空矩阵，待放入每次循环结果中的动态权益
%% （一）、MA策略仿真
for a=gridpara(10,20,100,300,600,1000,1,2,3,4,5,10)                         % 运行gridpara函数，进行循环参数的网格选择                                                 
    for lag=1:5
        b=a+lag;
        tic  %计时开始
        %% 1、MA策略模块
        %% MA策略模块，利用HG策略仿真交易，并计算各参数下综合评价指标
        % 1、交易信号定义模块
%         SignalBuy=zeros(length(ClosePrice),1);
%         SignalSell=zeros(length(ClosePrice),1);
        LenofShort=a;
        LenofLong=b;
        [MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong);     % 运行IndexSMA计算短期和长期移动平均线
        SignalMA                      % 运行信号定义模块SingalMA.m文件，定义买卖信号

        % 2、系统重要变量初始值定义模块
        module2_1_1_2_TradingParameters           % 运行当前目录下的module2_1_1_2_TradingParameters.m文件，定义系统重要变量的初始值
        

        % 3、HG策略仿真交易模块
        module2_1_1_3_SimuTrading               % 运行当前目录下的module2_1_1_3_SimuTrading_1.m文件，仿真各种信号出现时相应交易策略的选择，及交易结果的记录
         % 保存DynamicEquity序列到Dy矩阵
        Dy=[Dy,[[a,b]';DynamicEquity]];

        % 4、综合评价指标计算
        
        module2_1_1_4_EvaluIndexCal               % 运行当前目录下的module2_1_1_4_EvaluIndexCal.m文件，计算各种参数组合情况下交易结果的综合评价指标
        

        %% 2、综合评价指标汇总
        result1=[LenofShort,LenofLong,CumNetMarginFinal,NetReturnRatio,CumWinNetMarginFinal,CumLoseNetMarginFinal,CumRateofReturnFinal,...
        ClosePosNum,WinNum,LoseNum,WinRatio,LoseRatio,AverWinNetMargin,AverLoseNetMargin,MaxBackRatio,MaxBackRatioDate,...
        ExtrHiDyna,ExtrHiDynaDate,ExtrHiDynatoEnd,ExtrHiDynatoEndactu,maxkperiod,maxactuperiod,maxactuperiodStart,maxactuperiodEnd];  %过程指标
        result=[result;result1];
        toc    %计时
        t=toc;
        timerest=(length(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10))*length(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10))...
            -(find(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10)==a)-1)*5-lag)*t             %4000为a和b的总组合次数，(a-1)*80-lag为已经循环次数
        timerest_min=floor(timerest/60);                    %剩余分钟数
        timerest_sec=mod(timerest,60);                    %剩余秒数
        fprintf('There are %d minutes %d seconds left to run the script.',timerest_min,timerest_sec) 

    end
end

%% （二）、循环汇总结果输出
% 动态权益序列保存在带有分隔符的文件中
dlmwrite(['F:\tradingMAresult\','output3_MA_',ContractCode,'_',posm,'_',num2str(mperiods1),'minContinuous_DynamicEquitySeries.csv'],Dy);   

% 综合评价指标保存在Excel文件中
header1={'短期移动周期','长期移动周期','总盈亏','总收益率','总盈利','总亏损','最终累计收益率',...
    '交易次数','盈利次数','亏损次数','胜率','亏损比例','平均盈利','平均亏损',...
    '最大回撤比','最大回撤时间','最大权益','最大权益日期',...
    '最大权益K线距离','最大权益实际时间距离','权益最长未创新高K线周期','权益最长未创新高实际周期',...
    '权益最长未创新高起始时间','权益最长未创新高结束时间'};                   % 表格标题行
SExcelfileName=['output1_MA_',ContractCode,'_',posm,'_',num2str(mperiods1),'minContinuous.xlsx'];                   % 保存Excel文件的命名
xlswrite(['F:\tradingMAresult\',SExcelfileName],[header1;num2cell(result)],'综合评价指标');


%% 三、参数择优
%% （一）、找出最优参数值
module3_1_BestIndex

%% （二）、根据最优参数运行交易仿真系统
% 1、交易信号定义模块
SignalBuy=zeros(length(ClosePrice),1);
SignalSell=zeros(length(ClosePrice),1);
LenofShort=BestParameter1;
LenofLong=BestParameter2;
[MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong);     % 运行IndexSMA计算短期和长期移动平均线
SignalMA                      % 运行信号定义模块SingalMA.m文件，定义买卖信号

% 2、系统重要变量初始值定义模块
module2_1_1_2_TradingParameters           % 运行当前目录下的module2_1_1_2_TradingParameters.m文件，定义系统重要变量的初始值

% 3、MA策略仿真交易模块
module2_1_1_3_SimuTrading               % 运行当前目录下的module2_1_1_3_SimuTrading_1文件，仿真各种信号出现时相应交易策略的选择，及交易结果的记录

% 4、综合评价指标计算

module2_1_1_4_EvaluIndexCal               % 运行当前目录下的module2_1_1_4_EvaluIndexCal_2.m文件，计算各种参数组合情况下交易结果的综合评价指标

%% （三）输出并保存结果
header2={'日期分时型字符串时间','数值型时间','持仓状态','买入信号','卖出信号','换月标识变量','换多序号','换空序号',...
    '当日收盘价','当日开盘价','入场价格','买卖手数','多头保证金','空头保证金',...
    '可用资金','静态权益','动态权益','回撤比例'};                   % 表格标题行


guocheng=[times,pos,SignalBuy,SignalSell,addIdentiPara,huanduoOrder,huankongOrder,...
ClosePrice,OpenPrice,MyEntryPrice,Lots,LongMargin,ShortMargin,Cash,StaticEquity,DynamicEquity,BackRatio];  %过程指标


if mperiods1==0
    xlswrite(['F:\tradingMAresult\',SExcelfileName],[header2;cellstr(Date),num2cell(guocheng)],'最优过程记录指标');
else
    xlswrite(['F:\tradingMAresult\',SExcelfileName],[header2;cellstr(DateDayHMS),num2cell(guocheng)],'最优过程记录指标');
end

module3_2_2_BestIndex                    % 运行当前目录下的module3_2_2_BestIndex.m文件，保存最优参数组合情况下评价结果，输出报告



%检测
% Date=datestr(ExtrHiComDynaDate,'dd/mm/yyyy');
% find(times==ExtrHiComDynaDate)
% length(ClosePrice)-find(times==ExtrHiComDynaDate)
% find(times==ComMaxBackRatioDate)
% ComBackRatio(find(times==ComMaxBackRatioDate))
% cellstr 函数将字符串改为元组
% xlswrite('testcellstr.xlsx',['date';tt],'日期存储');
% tt=cellstr(Date)