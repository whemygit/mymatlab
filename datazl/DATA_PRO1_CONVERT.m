function []=DATA_PRO1_CONVERT(contract,riqi,inpath,outpath1,outpath2) % period,fname11,,fname12
%% data_process1(_rb_2015_5m)
% 将.csv原始数据转换成.mat
% 输入：均为str字符串
%     path='rb_data\rb_data_2015';
%     contract='rb';     % 改写使用
%     riqi='2015';       % 改写使用
%     period='5m';

    %% 预制：
    cd(inpath)
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    %% 
    for i=1:26
        if i<=9
            code=[riqi(3:4),'0',num2str(i)];
        elseif i>9 && i<=12
            code=[riqi(3:4),num2str(i)];
        elseif i>12 && i<=21
            code=[num2str(str2num(riqi(3:4))+1),'0',num2str(i-12)];
        elseif i>21 && i<=24
            code=[num2str(str2num(riqi(3:4))+1),num2str(i-12)];
        elseif i==25
            code='0000';
        elseif i==26
            code='0001';
        end
        % 查看是否存在该文件
        lst=ls;
        [l1,l2]=size(lst);
        for i=3:l1 % 1为. 2为..
            if lst(i,:)==[contract,code,'.csv']             %文件存在
                dataim=importdata([contract,code,'.csv']);  %文件名汇总处，导入后变量名称为data
                data=dataim.data;
                time1=dataim.textdata(:,3);
                times=datenum(time1(2:end));
                times1=floor(times);
                times2=times-times1;
                codes=repmat(str2num(code),length(times),1);
                sv=[times,times1,times2,data codes];
%                 outpath1=['c:\EMPIRE\DATASOURCE\',contract,'\','SS','\']; %5m
                fname11=[contract,'_',code,'_',riqi,'_','5m'];
                save([outpath1,fname11],'sv');
                % 转换日线数据
                [data]=min2day(sv);
%                 outpath2=['c:\EMPIRE\DATASOURCE\',contract,'\SS\']; %day
                fname12=[contract,'_',code,'_',riqi,'_','day'];
                save([outpath2,fname12],'data');
            end
        end
    end
end

