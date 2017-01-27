%% 根据输入的品种代码不同选择不同的品种，如输入的ContractCode为RB则选择螺纹数据
%% 根据periods的不同值选择不同的周期数据进行仿真交易，periods=1时，选择1分钟数据；periods=5时，选择5分钟数据；periods=15时，选择15分钟数据；periods=0时，选择日数据。

% 1、选择品种
ContractCode=input('Please enter your ContractCode,for example RB:', 's');           % 输入合约代码，如RB
disp(ContractCode)


% 2、选择周期
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