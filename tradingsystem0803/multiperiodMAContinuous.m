%% �����Ʒ�ֺ����ڵ����빦�ܣ������˲�ͬ�����µ�����ѡ���ܣ���ԭ����module1_2_3_mutliperioddatachoose.mʵ�ֶ������л�ģ��
%% ��Ϊmodule1_2_3_datachoose.m��ʵ�ֶ�Ʒ�ֶ����ڵ��л���
%% һ��ǰ��׼������
%% ��һ�����������ռ估����
clear all, clc; close all;
cd F:\tradingsystem0803


%% ������������׼��
%% 1����wind��ȡ����
% ֱ�����з���F:\MainandMultiContractDayDataExtraxt��F:\MainandMultiContractMinuDataExtraxtĿ¼�µĸ�������dataextract.m��β���ļ�,��ȡ��Ʒ�ֶ����ڶ��Լ����
% multicontract_dataextract
% multicontractmin_dataextract


%% 2��ƴ������
% ֱ�����з���F:\MainandMultiContractDayDataExtraxt��F:\MainandMultiContractMinuDataExtraxtĿ¼�µĸ�������contract.m��β���ļ�,ƴ�Ӹ����ڵ���������
% continuous_contract
% continuous_mincontract


%% 3����������
% ������һ������õĶ�Ʒ�ָ����ڵ�mat�ļ����ݣ�1min��5min��15min��dayѡ��ֱ��Ӧ��Ӧ�����ڡ�
module1_2_3_datachoose                % ����λ�ڵ�ǰĿ¼�µ�module1_2_3_datachoose.m�ļ���ʵ�ֲ�ͬƷ�ֲ�ͬ�������ݵ�ѡ��

%% ��������ϵͳ����
result=[];                                       %����վ��󣬴�����ÿ��ѭ��������
% ����posmȡֵ��ͬʵ�ֽ�������ѡ��Ĺ���
posm=input('Which posm do you prefer? 0/1/2: ', 's');           % ����posmѡ��ͬ�Ľ����������㷽����0ʱָ����ָ���ض�����������1����ȫ����̬Ȩ�����ɽ���������2����һ�������Ķ�̬Ȩ�������Ӧ����
disp(posm)
posm1=str2num(posm);
if posm1==0                                                            % ������posm1=0��Ҳ���̶�����ʱ
    Lots1=input('Please set the number of lots for trading:', 's');    % ��Ҫ����̶������ľ���ֵ
    Lots2=str2num(Lots1);
end

if posm1==2                                                            % ������posm1=3��Ҳ������ĳһ�����Ķ�̬Ȩ��ֵ��������ʱ
    RatioDyna1=input('Please set the Ratio of dynamic equity for calculating the lots,such as 0.8:', 's');    % ��Ҫ���붯̬Ȩ��ı����ľ���ֵ
    RatioDyna=str2num(RatioDyna1);
end

Dy=[];                                           %����վ��󣬴�����ÿ��ѭ������еĶ�̬Ȩ��
%% ��һ����MA���Է���
for a=gridpara(10,20,100,300,600,1000,1,2,3,4,5,10)                         % ����gridpara����������ѭ������������ѡ��                                                 
    for lag=1:5
        b=a+lag;
        tic  %��ʱ��ʼ
        %% 1��MA����ģ��
        %% MA����ģ�飬����HG���Է��潻�ף���������������ۺ�����ָ��
        % 1�������źŶ���ģ��
%         SignalBuy=zeros(length(ClosePrice),1);
%         SignalSell=zeros(length(ClosePrice),1);
        LenofShort=a;
        LenofLong=b;
        [MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong);     % ����IndexSMA������ںͳ����ƶ�ƽ����
        SignalMA                      % �����źŶ���ģ��SingalMA.m�ļ������������ź�

        % 2��ϵͳ��Ҫ������ʼֵ����ģ��
        module2_1_1_2_TradingParameters           % ���е�ǰĿ¼�µ�module2_1_1_2_TradingParameters.m�ļ�������ϵͳ��Ҫ�����ĳ�ʼֵ
        

        % 3��HG���Է��潻��ģ��
        module2_1_1_3_SimuTrading               % ���е�ǰĿ¼�µ�module2_1_1_3_SimuTrading_1.m�ļ�����������źų���ʱ��Ӧ���ײ��Ե�ѡ�񣬼����׽���ļ�¼
         % ����DynamicEquity���е�Dy����
        Dy=[Dy,[[a,b]';DynamicEquity]];

        % 4���ۺ�����ָ�����
        
        module2_1_1_4_EvaluIndexCal               % ���е�ǰĿ¼�µ�module2_1_1_4_EvaluIndexCal.m�ļ���������ֲ����������½��׽�����ۺ�����ָ��
        

        %% 2���ۺ�����ָ�����
        result1=[LenofShort,LenofLong,CumNetMarginFinal,NetReturnRatio,CumWinNetMarginFinal,CumLoseNetMarginFinal,CumRateofReturnFinal,...
        ClosePosNum,WinNum,LoseNum,WinRatio,LoseRatio,AverWinNetMargin,AverLoseNetMargin,MaxBackRatio,MaxBackRatioDate,...
        ExtrHiDyna,ExtrHiDynaDate,ExtrHiDynatoEnd,ExtrHiDynatoEndactu,maxkperiod,maxactuperiod,maxactuperiodStart,maxactuperiodEnd];  %����ָ��
        result=[result;result1];
        toc    %��ʱ
        t=toc;
        timerest=(length(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10))*length(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10))...
            -(find(gridpara(10,20,100,300,600,1000,1,2,3,4,5,10)==a)-1)*5-lag)*t             %4000Ϊa��b������ϴ�����(a-1)*80-lagΪ�Ѿ�ѭ������
        timerest_min=floor(timerest/60);                    %ʣ�������
        timerest_sec=mod(timerest,60);                    %ʣ������
        fprintf('There are %d minutes %d seconds left to run the script.',timerest_min,timerest_sec) 

    end
end

%% ��������ѭ�����ܽ�����
% ��̬Ȩ�����б����ڴ��зָ������ļ���
dlmwrite(['F:\tradingMAresult\','output3_MA_',ContractCode,'_',posm,'_',num2str(mperiods1),'minContinuous_DynamicEquitySeries.csv'],Dy);   

% �ۺ�����ָ�걣����Excel�ļ���
header1={'�����ƶ�����','�����ƶ�����','��ӯ��','��������','��ӯ��','�ܿ���','�����ۼ�������',...
    '���״���','ӯ������','�������','ʤ��','�������','ƽ��ӯ��','ƽ������',...
    '���س���','���س�ʱ��','���Ȩ��','���Ȩ������',...
    '���Ȩ��K�߾���','���Ȩ��ʵ��ʱ�����','Ȩ���δ���¸�K������','Ȩ���δ���¸�ʵ������',...
    'Ȩ���δ���¸���ʼʱ��','Ȩ���δ���¸߽���ʱ��'};                   % ��������
SExcelfileName=['output1_MA_',ContractCode,'_',posm,'_',num2str(mperiods1),'minContinuous.xlsx'];                   % ����Excel�ļ�������
xlswrite(['F:\tradingMAresult\',SExcelfileName],[header1;num2cell(result)],'�ۺ�����ָ��');


%% ������������
%% ��һ�����ҳ����Ų���ֵ
module3_1_BestIndex

%% ���������������Ų������н��׷���ϵͳ
% 1�������źŶ���ģ��
SignalBuy=zeros(length(ClosePrice),1);
SignalSell=zeros(length(ClosePrice),1);
LenofShort=BestParameter1;
LenofLong=BestParameter2;
[MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong);     % ����IndexSMA������ںͳ����ƶ�ƽ����
SignalMA                      % �����źŶ���ģ��SingalMA.m�ļ������������ź�

% 2��ϵͳ��Ҫ������ʼֵ����ģ��
module2_1_1_2_TradingParameters           % ���е�ǰĿ¼�µ�module2_1_1_2_TradingParameters.m�ļ�������ϵͳ��Ҫ�����ĳ�ʼֵ

% 3��MA���Է��潻��ģ��
module2_1_1_3_SimuTrading               % ���е�ǰĿ¼�µ�module2_1_1_3_SimuTrading_1�ļ�����������źų���ʱ��Ӧ���ײ��Ե�ѡ�񣬼����׽���ļ�¼

% 4���ۺ�����ָ�����

module2_1_1_4_EvaluIndexCal               % ���е�ǰĿ¼�µ�module2_1_1_4_EvaluIndexCal_2.m�ļ���������ֲ����������½��׽�����ۺ�����ָ��

%% �����������������
header2={'���ڷ�ʱ���ַ���ʱ��','��ֵ��ʱ��','�ֲ�״̬','�����ź�','�����ź�','���±�ʶ����','�������','�������',...
    '�������̼�','���տ��̼�','�볡�۸�','��������','��ͷ��֤��','��ͷ��֤��',...
    '�����ʽ�','��̬Ȩ��','��̬Ȩ��','�س�����'};                   % ��������


guocheng=[times,pos,SignalBuy,SignalSell,addIdentiPara,huanduoOrder,huankongOrder,...
ClosePrice,OpenPrice,MyEntryPrice,Lots,LongMargin,ShortMargin,Cash,StaticEquity,DynamicEquity,BackRatio];  %����ָ��


if mperiods1==0
    xlswrite(['F:\tradingMAresult\',SExcelfileName],[header2;cellstr(Date),num2cell(guocheng)],'���Ź��̼�¼ָ��');
else
    xlswrite(['F:\tradingMAresult\',SExcelfileName],[header2;cellstr(DateDayHMS),num2cell(guocheng)],'���Ź��̼�¼ָ��');
end

module3_2_2_BestIndex                    % ���е�ǰĿ¼�µ�module3_2_2_BestIndex.m�ļ����������Ų��������������۽�����������



%���
% Date=datestr(ExtrHiComDynaDate,'dd/mm/yyyy');
% find(times==ExtrHiComDynaDate)
% length(ClosePrice)-find(times==ExtrHiComDynaDate)
% find(times==ComMaxBackRatioDate)
% ComBackRatio(find(times==ComMaxBackRatioDate))
% cellstr �������ַ�����ΪԪ��
% xlswrite('testcellstr.xlsx',['date';tt],'���ڴ洢');
% tt=cellstr(Date)