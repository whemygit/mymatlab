%% 1����Լ����
MarginRatio=0.05;      %����֤���ʡ�
MinMove=1;             %����С�䶯��λ��
PriceScale=1;          %����Ʒ�Ƽ۵�λ������1Ԫ/��
TradingUnit=10;        %�����׵�λ������ÿ��10��

%% 2�����ײ���
Slip=1;                %�����㡿
% Lots=1;                %���µ�������
Lots=zeros(length(ClosePrice),1);   %������������
TradingCost=0.00005;   %�����������ѡ�Ϊ�ɽ��������֮0.5
InitalFund=1000000;     %����ʼ�ʽ�Ϊ10��

%% 3�����׹��̼�¼���������ʼ��ֵ���󲿷��������̼���ͬ���ȵ�������ʽ��ʾ��
MyEntryPrice=zeros(length(ClosePrice),1);   %�������۸�
MarketPosition=0;                           %����λ״̬����-1��ʾ���п�ͷ��0��ʾ�޳ֲ֣�1��ʾ���ж�ͷ
pos=zeros(length(ClosePrice),1);            %����¼��λ�������-1��ʾ���п�ͷ��0��ʾ�޳ֲ֣�1��ʾ���ж�ͷ
LongMargin=zeros(length(ClosePrice),1);    %����ͷ��֤��
ShortMargin=zeros(length(ClosePrice),1);   %����ͷ��֤��
Cash=repmat(InitalFund,length(ClosePrice),1);     %�������ʽ𡿣���ʼֵ=��ʼ�ʽ�Ϊ10��
DynamicEquity=repmat(InitalFund,length(ClosePrice),1);  %����̬Ȩ�桿����ʼֵ=��ʼ�ʽ�10��
StaticEquity=repmat(InitalFund,length(ClosePrice),1);  %����̬Ȩ�桿����ʼֵ=��ʼ�ʽ�Ϊ10��
BackRatio=zeros(length(ClosePrice),1);          %���س�������,���׹����ж�̬Ȩ��ή������

%% 4��ϵͳ����ָ��
%% ��1���ֱʼ�¼ָ��
Type=zeros(length(ClosePrice),1);           %���������͡���1��ʾ��ͷ��-1��ʾ��ͷ
OpenPosPrice=zeros(length(ClosePrice),1);   %�����ּ۸񡿼�¼
ClosePosPrice=zeros(length(ClosePrice),1);  %��ƽ�ּ۸񡿼�¼
OpenPosNum=0;                               %�����ּ۸���š�
ClosePosNum=0;                              %��ƽ�ּ۸���š�
OpenDate=zeros(length(ClosePrice),1);       %������ʱ�䡿
CloseDate=zeros(length(ClosePrice),1);      %��ƽ��ʱ�䡿

%% ��2���ֱ�����ָ��
NetMargin=zeros(length(ClosePrice),1);       %�����ӯ��������ÿ�ʾ���������
CumNetMargin=zeros(length(ClosePrice),1);    %���ۼ�ӯ��������ÿ���ۼƾ���������
RateofReturn=zeros(length(ClosePrice),1);    %����������ʡ�����ÿ�������ʣ�����
CumRateofReturn=zeros(length(ClosePrice),1); %���ۼ������ʡ���ÿ���ۼ������ʣ�cumsum(RateofReturn)����ʵ�����塣
WinNetMargin=zeros(length(ClosePrice),1);    %�����ӯ������ÿ��ӯ��ʱ��¼ӯ����%���ӯ����
CumWinNetMargin=zeros(length(ClosePrice),1); %���ۼ�ӯ������ÿ��ӯ��ʱ��¼ӯ�������ۼ�ֵ
LoseNetMargin=zeros(length(ClosePrice),1);   %����ʿ��𡿣�ÿ�ʿ���ʱ��¼������
CumLoseNetMargin=zeros(length(ClosePrice),1);%���ۼƿ��𡿣�ÿ�ʿ���ʱ��¼��������ۼ�ֵ
CostSeries=zeros(length(ClosePrice),1);      %�����׳ɱ�����ÿ�ʽ��׳ɱ�������
% ���ӻ���ɱ�ͳ��


% % �����źż�¼����
% % ���ڼ���������Ƿ���ȷ�ı���
% SignalBuyDate=zeros(length(ClosePrice),1);        %�������ź����ڡ�����
% SignalBuyOrder=zeros(length(ClosePrice),1);       %�������ź���š�����
% SignalBuyNum=0;        %�������źż�����
% SignalSellDate=zeros(length(ClosePrice),1);       %�������ź����ڡ�����
% SignalSellOrder=zeros(length(ClosePrice),1);      %�������ź���š�����
% SignalSellNum=0;        %�������źż�����
% 
% �Ʋֻ��¼�¼����
% ���ڼ���������Ƿ���ȷ�ı���
huanduoDate=zeros(length(ClosePrice),1);        %������������
huanduoOrder=zeros(length(ClosePrice),1);       %�����������
huanduoNum=0;        %�������
huankongDate=zeros(length(ClosePrice),1);       %������������
huankongOrder=zeros(length(ClosePrice),1);      %�����������
huankongNum=0;        %���ռ���   

%% ��2���ۺ�����ָ��
CumNetMarginFinal=0;                           %����ӯ�������ۼ�ӯ�����һ��ֵ��CumNetMargin(length(CumNetMargin));
CumRateofReturnFinal=0;                        %�����ۼ������ʣ��ۼ����������һ��ֵ��CumRateofReturn(length(CumRateofReturn));
NetReturnRatio=0;                            %���������ʡ��������ʣ�=����ӯ����/����ʼ�ʽ𡿣�=CumNetMarginFinal/InitalFund;
CumWinNetMarginFinal=0;                           %����ӯ�������ۼ�ӯ�����һ��ֵ��CumWinNetMargin(length(CumWinNetMargin));
CumLoseNetMarginFinal=0;                       %���ܿ��𡿣��ۼƿ������һ��ֵ��CumLoseNetMargin(length(CumLoseNetMargin));
ClosePosNum=0;                               %�����״�����
WinNum=0;                                   %��ӯ��������
WinRatio=0;                                 %��ʤ�ʡ�
LoseNum=0;                                  %�����������
LoseRatio=0;                                %�����������
AverWinNetMargin=0;                         %��ƽ��ӯ������=����ӯ����/��ӯ��������,=WinNetMarginFinal/WinNum.
AverLoseNetMargin=0;                        %��ƽ�����𡿵���ƽ������
MaxBackRatio=0;                             %�����س��ȡ�������max��BackRatio��
MaxBackRatioDate=0;                         %�����س�ʱ�䡿
ExtrHiDyna=0;                               %�����Ȩ�桿����̬Ȩ��
ExtrHiDynaDate=0;                           %�����Ȩ�����ڡ�����̬Ȩ������
ExtrHiDynatoEnd=0;                          %�����Ȩ��K�߾��롿����̬Ȩ��������һ��K�߾���
ExtrHiDynatoEndactu=0;                      %�����Ȩ��ʵ��ʱ����롿����̬Ȩ��������һ�������յ�ʵ��ʱ�䳤��
maxkperiod=0;                               %��Ȩ���δ���¸�����������̬Ȩ�洴�¸��������K������
maxactuperiod=0;
maxactuperiodStart=0;                       %��Ȩ���δ���¸���ʼʱ�䡿
maxactuperiodEnd=0;                         %��Ȩ���δ���¸߽���ʱ�䡿