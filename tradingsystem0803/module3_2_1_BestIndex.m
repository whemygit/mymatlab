%% ��һ��������Ѱ�ż��������
% 1�������źŶ���ģ��
BuyPeriodLen=BestParameter1;                                  %�����ƶ�����
module2_1_1_1_1_turtraBuySignal;    %�����źţ�����λ�ڵ�ǰĿ¼�µ�turtraBuySignal_module.m�ļ�
SellPeriodLen=BestParameter2;                                 %�����ƶ�����
module2_2_1_1_2_turtraSellSignal;   %�����źţ�����λ�ڵ�ǰĿ¼�µ�turtraSellSignal_module.m�ļ�

% 2��ϵͳ��Ҫ������ʼֵ����ģ��
module2_1_1_2_TradingParameters           % ���е�ǰĿ¼�µ�TradingParameters_module.m�ļ�

% 3��HG���Է��潻��ģ��
% ���е�ǰĿ¼�µ�MASimuTrading_module.m�ļ�
module2_1_1_3_HGSimuTrading

% 4���ۺ�����ָ�����
% ���е�ǰĿ¼�µ�EvaluIndexCal_module.m�ļ�
module2_1_1_4_EvaluIndexCal


%% ��������������Ų�������µ����̼ۼ���̬Ȩ��䶯���ͼ������
%% 1�����ñ����
tfirst='���Ų���';                                      % ͼ����̶�����һ
tsecond='����µ����̼ۼ���̬Ȩ��䶯���ͼ';               % ͼ����̶����ֶ�
fgtitle=[tfirst,'(',num2str(BestParameter1),'-',num2str(BestParameter2),')',tsecond]   % ͼ����ɱ��������

%% ��ͼ
scrsz=get(0,'ScreenSize');      %��ȡ��ǰ��Ļ��С
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4); %����ͼ���С
plotyy(times,DynamicEquity,times,ClosePrice);
hold on;
text(ExtrHiDynaDate,ExtrHiDyna,'\leftarrow���̬Ȩ��','Color','blue');
hold on;
text(times(20),115000,['��������',num2str(NetReturnRatio)],'Color','green','FontWeight','Bold');
hold on;
dateaxis('x',12)                                        %����x���Ǹ�ʽ
legend('DynamicEquity','ClosePrice','Location','Best');    %���ͼ��
title(fgtitle,'FontWeight','Bold');    %��ӱ�ͷ�������������ʽ
hold on;

%% ����ͼ
saveas(1,[,'output2_���Ų�������µ����̼ۼ���̬Ȩ��䶯���ͼ.jpg'])