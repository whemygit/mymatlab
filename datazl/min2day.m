%% ������������
function [data]=min2day(sv)
% ���룺a(1).sv

% o h l c v amount oi 
% times:<ʱ��>������ʱȷ�ϣ�������ֵ��
% o:<ʱ��>������ʱȷ�ϣ�������ֵ��
% h:<�Ƚ�>������ʱȷ����׼��
% l:<�Ƚ�>������ʱȷ����׼��
% c:<ʱ��>������ʱȷ�ϣ�������ֵ��
% v:<�ۻ�>������ʱȷ����ʼ��
% amount:<�ۻ�>������ʱȷ����ʼ��
% oi:<ʱ��>������ʱȷ�ϣ�������ֵ��

    [t1,t2]=size(sv);
    code=sv(end,end); % ��ȡ��Լ�·�
    for i=1:t1
       if i==1 % ��һ��Ĵ���
           day=1; % ����
           times(day)=sv(i,2); % ȷ��
           o(day)=sv(i,4);     % ȷ��
           h(day)=sv(i,5);     % �Ƚϣ�ȷ����׼
           l(day)=sv(i,6);     % �Ƚϣ�ȷ����׼
           v(day)=sv(i,8);     % �ۻ���ȷ����ʼ
           amount(day)=sv(i,9);% �ۻ���ȷ����ʼ
       elseif i==t1 % ���һ��Ĵ���,�Ƿ�����ʱ����������
           c(day)=sv(i,7);
           h(day)=max(h(day),sv(i,5));
           l(day)=min(l(day),sv(i,6));
           v(day)=v(day)+sv(i,8);
           amount(day)=amount(day)+sv(i,9);
           oi(day)=sv(i,10);
       else % �ڶ��쿪ʼ��������
           if sv(i,2)~=sv(i-1,2) % ����
               times(day)=sv(i-1,2); % ȷ�����͵�һ���ظ�
               c(day)=sv(i-1,7);     % �º�ȷ��
               oi(day)=sv(i-1,10);   % �º�ȷ��
              day=day+1; % ���ڼ�һ��
               times(day)=sv(i,2); % ȷ��
               o(day)=sv(i,4);     % ȷ��
               h(day)=sv(i,5);     % �Ƚ�
               l(day)=sv(i,6);     % �Ƚ�
               v(day)=sv(i,8);     % �ۻ�
               amount(day)=sv(i,9);% �ۻ�
           else % �ǻ��գ��������
               h(day)=max(h(day),sv(i,5));      % ȷ��
               l(day)=min(l(day),sv(i,6));      % ȷ��
               v(day)=v(day)+sv(i,8);           % ȷ��
               amount(day)=amount(day)+sv(i,9); % ȷ��
           end
       end
    end
    codes=repmat(code,length(times),1);
    data=[times' o' h' l' c' v' amount' oi' codes];
end

% save(['c:\EMPIRE\DATASOURCE\RB\',contract,'_',code,'_',riqi,'_',period],'data');

