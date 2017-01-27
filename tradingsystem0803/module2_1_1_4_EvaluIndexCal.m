%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1���ֱ�����ָ���¼
%% ��1��ÿ�ν��׳ɱ���������ÿ��ӯ�������𣩡�ӯ������
for i=1:ClosePosNum
     CostSeries(i)=(OpenPosPrice(i)+ClosePosPrice(i))*TradingUnit*Lots(i)*TradingCost;
      % ������ͷʱ
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
      % ������ͷʱ
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
 %% ��2������������
 for i=1:ClosePosNum     
     RateofReturn(i)=NetMargin(i)/(OpenPosPrice(i)*TradingUnit*Lots(i)*MarginRatio);
 end
 %% ��3��ÿ���ۼ�ָ��
  %% 1���ۼƾ���,�ۼ�ӯ������ۼƿ����ۼ�������
CumNetMargin=cumsum(NetMargin);                                         %������ʽ��ÿ�ξ������ۼ�ֵ
CumWinNetMargin=cumsum(WinNetMargin);                                   %������ʽ��ÿ��ӯ��ʱ�������ۼ�ֵ
CumLoseNetMargin=cumsum(LoseNetMargin);                                 %������ʽ��ÿ�ο���ʱ���ۼ�ֵ
CumRateofReturn=cumsum(RateofReturn);                                   %������ʽ��ÿ���������ۼ�ֵ


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2���ۺ�����ָ���¼
 %% ��1�������ۼ�ָ��
CumNetMarginFinal=CumNetMargin(length(CumNetMargin));                   %���վ�����
DynamicEquityFinal=DynamicEquity(length(DynamicEquity));                   %����Ȩ��
NetReturnRatio=CumNetMargin(length(CumNetMargin))/InitalFund;           %�������ʣ����������ʼ�ʽ�ı�ֵ
CumWinNetMarginFinal=CumWinNetMargin(length(CumWinNetMargin));          %����ӯ����
CumLoseNetMarginFinal=CumLoseNetMargin(length(CumLoseNetMargin));       %���տ����
CumRateofReturnFinal=CumRateofReturn(length(CumRateofReturn));          %�����ۼ�������
 %% ��2��ƽ��ӯ����ƽ������ʤ�ʺͿ������
AverWinNetMargin=CumWinNetMargin(length(CumWinNetMargin))/WinNum;       %ƽ��ӯ������ӯ����ӯ�������ı�
AverLoseNetMargin=CumLoseNetMargin(length(CumLoseNetMargin))/LoseNum;   %ƽ�������ܿ������������ı�
WinRatio=WinNum/ClosePosNum;                                            %ʤ��
LoseRatio=LoseNum/ClosePosNum;                                          %�������



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3���붯̬Ȩ����ص�ָ��
%% ��1�������СȨ��
ExtrHiDyna=max(DynamicEquity);                     % ���Ȩ��Ϊ������̬Ȩ�����е����ֵ��
ExtrLowDyna=min(DynamicEquity);                     % ��СȨ��Ϊ������̬Ȩ�����е���Сֵ��

% ��������������м����
OrderNum=1:length(ClosePrice);                   %K���������
% ExtrHiDynaDate=0;             %���ߵ�����
% ExtrHiDynatoEnd=0;            %���ߵ�������һ�������վ���

DynamicEquityData=[OrderNum',times,DynamicEquity];   %��������еĶ�̬Ȩ�����

% (1)ExtrHiDynaDate�����Ȩ�����ڡ�
ExtrHiDynaRow=find(DynamicEquity==ExtrHiDyna);              % �ҳ����Ȩ�������к�ExtrHiDynaRow
ExtrHiDynaDate=times(ExtrHiDynaRow(1));                        % ���Ȩ��ʱ��,���ڶ�����ֵ�Ļ�ȡ��һ��
% datestr(ExtrHiDynaDate,'dd/mm/yyyy');                       % ת��Ϊ�ַ�������

% (2)ExtrHiDynatoEnd�����Ȩ��K�߾��롿��ExtrHiDynatoEndactu�����Ȩ��ʵ��ʱ����롿
ExtrHiDynatoEnd=length(ClosePrice)-ExtrHiDynaRow(1);         % �����Ȩ��K�߾��롿���̬Ȩ��������һ��������K�߾��룬K�߳���-���Ȩ�������кš�
ExtrHiDynatoEndactu=times(end)-ExtrHiDynaDate;            % �����Ȩ��ʵ��ʱ����롿���̬Ȩ��������һ��������ʵ��ʱ����룬K�����ʱ��-���Ȩ��ʱ�䡣

% (3)DyMaxDynamicEquity����̬���Ȩ����������ֹĿǰΪֹ�Ķ�̬Ȩ��ߵ�����,����Ҫ��Ϊ����Ȩ��δ���¸�ʱ��ε��м�������ڣ�
DyMaxDynamicEquity=zeros(length(ClosePrice),1);            %����̬���Ȩ����������ֹĿǰΪֹ�Ķ�̬Ȩ��ߵ�����
DyMaxDynamicEquityDate=zeros(length(ClosePrice),1);        %����̬���Ȩ������������
DyMaxDynamicEquityOrder=zeros(length(ClosePrice),1);       %����̬���Ȩ�����������
DyMaxDynamicEquityNum=1;        %��̬���Ȩ���������Ϊ��һ��ֵΪ����Ȩ�棬���Դ���ԭʼֵ1��

DyMaxDynamicEquity(1)=DynamicEquity(1);
DyMaxDynamicEquityOrder(1)=OrderNum(1);
DyMaxDynamicEquityDate(1)=times(1);


for i=2:length(ClosePrice)
    DyMaxDynamicEquity(i)=max(DynamicEquity(1:i));                           %��ֹĿǰΪֹ�Ķ�̬Ȩ��ߵ�����
    if DyMaxDynamicEquity(i)>DyMaxDynamicEquity(i-1)                                %�����µĸߵ�����Ա��
        DyMaxDynamicEquityNum=DyMaxDynamicEquityNum+1;                               %�ߵ�����1
        DyMaxDynamicEquityDate(DyMaxDynamicEquityNum)=times(i);                      %��Ǹߵ�ʵ��ʱ��
        DyMaxDynamicEquityOrder(DyMaxDynamicEquityNum)=OrderNum(i);                  %�����ߵ�K�����
    end
end

% (4)maxkperiod��Ȩ���δ���¸�K�����ڡ�
p1=zeros(length(ClosePrice),1);                          %�м���������ڸߵ�K�߾�������
for i=2:DyMaxDynamicEquityNum
     p1(i)=DyMaxDynamicEquityOrder(i)-DyMaxDynamicEquityOrder(i-1);
end
maxkperiod=max(p1);
if length(ClosePrice)-DyMaxDynamicEquityOrder(i)>maxkperiod              % �����ڼ�ĳһʱ�㴴���¸ߺ�һֱ�����δ���¸�����������һ��K�����-���һ�δ��¸���ţ���ǰ��δ���¸�����ȡ�ϴ���
    maxkperiod=length(ClosePrice)-DyMaxDynamicEquityOrder(i);
end


% (5)maxactuperiod��Ȩ���δ���¸��ʵ�����ڡ�
p2=zeros(length(ClosePrice),1);                          %�м���������ڸߵ�ʵ�����ھ�������
for i=2:DyMaxDynamicEquityNum
     p2(i)=DyMaxDynamicEquityDate(i)-DyMaxDynamicEquityDate(i-1);
end
maxactuperiod=max(p2);                                           %���¸������ʵ��ʱ��
if maxkperiod==length(ClosePrice)-DyMaxDynamicEquityOrder(i)
    maxactuperiod=times(end)-DyMaxDynamicEquityDate(i);
end


% 6)maxactuperiodStart��Ȩ���δ���¸���ʼʱ�䡿��maxactuperiodEnd��Ȩ���δ���¸߽���ʱ�䡿
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


%% ��2��MaxBackRatio�����س��ȡ���MaxBackRatioDate�����س���ʱ�䡿

for i=1:length(ClosePrice)
   BackRatio(i)=(DyMaxDynamicEquity(i)-DynamicEquity(i))/DyMaxDynamicEquity(i);
end
MaxBackRatio=max(BackRatio);   %�ҳ����������лس��������ֵ����Ϊ���س���

MaxBackRatioRow=find(BackRatio==MaxBackRatio);           % �ҳ����س������ڵ���
MaxBackRatioDate=times(MaxBackRatioRow(1));                 % �ҳ���Ӧ�е����ڣ����ڶ���Ļ�ȡ��һ����


