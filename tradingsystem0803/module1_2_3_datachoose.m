%% ���������Ʒ�ִ��벻ͬѡ��ͬ��Ʒ�֣��������ContractCodeΪRB��ѡ����������
%% ����periods�Ĳ�ֵͬѡ��ͬ���������ݽ��з��潻�ף�periods=1ʱ��ѡ��1�������ݣ�periods=5ʱ��ѡ��5�������ݣ�periods=15ʱ��ѡ��15�������ݣ�periods=0ʱ��ѡ�������ݡ�

% 1��ѡ��Ʒ��
ContractCode=input('Please enter your ContractCode,for example RB:', 's');           % �����Լ���룬��RB
disp(ContractCode)


% 2��ѡ������
while 1==1
    mperiods=input('Which period do you prefer, day/1min/3min/5min/15min(0 for day data,1 for 1min data,3 for 3min data and so on)?Please enter your choice:', 's');
    disp(mperiods)
    mperiods1=str2num(mperiods);    
    if mperiods1==0
        disp(['We will download the day peirod data of ',ContractCode,' for you.']);
        load(['F:\continousdata\',ContractCode,'Data_Continuous'])
        break
    elseif mperiods1~=0
        disp(['We will download the ',mperiods,' minute peirod data of ',ContractCode,' for you.']);
        load(['F:\continousdata\',ContractCode,'Data_',mperiods,'minContinuous'])
        break        
    else
        mperiods=input('Type error! You have input a wrong Contract Code or periosds, please press any key to try again');
    end
end