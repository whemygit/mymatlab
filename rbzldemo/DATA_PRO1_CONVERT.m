function []=DATA_PRO1_CONVERT(contract,riqi,inpath,outpath1,outpath2) % period,fname11,,fname12
%% data_process1(_rb_2015_5m)
% 将.csv原始数据转换成.mat
% 输入：均为str字符串
    inpath='G:\EMPIRE\com_data_source\rb_data\rb_data_2015';
    contract='rb';     % 改写使用
    riqi='2015';       % 改写使用
    period='5m';

    %% 预制：
    cd(inpath)
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    %% 
    for i=1:26                                                        % 每个文件夹中最多有26个合约的csv文件
        if i<=9
            code=[riqi(3:4),'0',num2str(i)];                          % 生成合约代码的年份日期部分，1-9月份为一种格式，如1509
        elseif i>9 && i<=12
            code=[riqi(3:4),num2str(i)];                              % 生成合约代码的年份日期部分，10-12月份为一种格式，如1511
        elseif i>12 && i<=21
            code=[num2str(str2num(riqi(3:4))+1),'0',num2str(i-12)];   % 超过12之后，从下一年一月份开始
        elseif i>21 && i<=24
            code=[num2str(str2num(riqi(3:4))+1),num2str(i-12)];       % 超过21之后，从下一年十月份开始
        elseif i==25                                                  % 25时，为‘0000’
            code='0000';
        elseif i==26                                                  % 26时，为‘0001’
            code='0001';
        end
        % 查看是否存在该文件
        lst=ls;
        [l1,l2]=size(lst);
        for i=3:l1 % 1为. 2为..
            if lst(i,:)==[contract,code,'.csv']             %文件存在
                dataim=importdata([contract,code,'.csv']);  %结构数组，包括data和textdata两个变量，data包含7列【double型】，textdata包含10列【cell型】
                data=dataim.data;                           %数据【开、高、低、收、成交量、成交额和持仓量】
                time1=dataim.textdata(:,3);                 %dataim.textdata,【市场代码，sc】，【合约代码，rb1501】，【时间，'2015-01-02 21:05:00'】
                times=datenum(time1(2:end));                %去掉标题行的纯数值型时间轴
                times1=floor(times);                        %时间值取整
                times2=times-times1;                        %时间值小数部分          
                codes=repmat(str2num(code),length(times),1); % 产生与时间列长度相等的月份代码向量
                sv=[times,times1,times2,data,codes];         % 11列
                outpath1=['H:\EMPIRE\DATASOURCE\',contract,'\','SS2','\']; %5m
                fname11=[contract,'_',code,'_',riqi,'_','5m'];
                save([outpath1,fname11],'sv');
                % 转换日线数据
                [data]=min2day(sv);
                outpath2=['H:\EMPIRE\DATASOURCE\',contract,'\SS2\']; %day
                fname12=[contract,'_',code,'_',riqi,'_','day'];
                save([outpath2,fname12],'data');
            end
        end
    end
end

