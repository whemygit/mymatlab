%% （一）、参数寻优及运算过程
% 1、交易信号定义模块
BuyPeriodLen=BestParameter1;                                  %买入移动周期
module2_1_1_1_1_turtraBuySignal;    %买入信号，运行位于当前目录下的turtraBuySignal_module.m文件
SellPeriodLen=BestParameter2;                                 %卖出移动周期
module2_2_1_1_2_turtraSellSignal;   %卖出信号，运行位于当前目录下的turtraSellSignal_module.m文件

% 2、系统重要变量初始值定义模块
module2_1_1_2_TradingParameters           % 运行当前目录下的TradingParameters_module.m文件

% 3、HG策略仿真交易模块
% 运行当前目录下的MASimuTrading_module.m文件
module2_1_1_3_HGSimuTrading

% 4、综合评价指标计算
% 运行当前目录下的EvaluIndexCal_module.m文件
module2_1_1_4_EvaluIndexCal


%% （二）、输出最优参数情况下的收盘价及动态权益变动情况图及保存
%% 1、设置表标题
tfirst='最优参数';                                      % 图标题固定部分一
tsecond='情况下的收盘价及动态权益变动情况图';               % 图标题固定部分二
fgtitle=[tfirst,'(',num2str(BestParameter1),'-',num2str(BestParameter2),')',tsecond]   % 图标题可变参数部分

%% 绘图
scrsz=get(0,'ScreenSize');      %获取当前屏幕大小
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4); %设置图版大小
plotyy(times,DynamicEquity,times,ClosePrice);
hold on;
text(ExtrHiDynaDate,ExtrHiDyna,'\leftarrow最大动态权益','Color','blue');
hold on;
text(times(20),115000,['净收益率',num2str(NetReturnRatio)],'Color','green','FontWeight','Bold');
hold on;
dateaxis('x',12)                                        %更改x轴标记格式
legend('DynamicEquity','ClosePrice','Location','Best');    %添加图例
title(fgtitle,'FontWeight','Bold');    %添加表头，并设置字体格式
hold on;

%% 保存图
saveas(1,[,'output2_最优参数情况下的收盘价及动态权益变动情况图.jpg'])