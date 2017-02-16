%% 综合处理
% 调用程序data_pro1\data_pro2\data_pro3

clear all;
clc;
%% pro1:.csv转换为.mat
contract='rb';     % 改写使用
riqi='2009';       % 改写使用
% period='5m';
% code='0000';  %code暂用名，用于保存路径中的设置，每次函数内循环会进行调整
path=['c:\EMPIRE\com_data_source\',contract,'_data\',contract,'_data_',riqi];% 进入路径'rb_data\rb_data_2015'
path11=['c:\EMPIRE\DATASOURCE\',contract,'\5m\']; %5m，输出路径1
% fname11=[contract,'-',code,'-',riqi,'_','5m'];% 输出文件1
path12=['c:\EMPIRE\DATASOURCE\',contract,'\DAY\']; %day，输出路径2
% fname12=[contract,'_',code,'_',riqi,'_','day']; % 输出文件2
tic
DATA_PRO1_CONVERT(contract,riqi,path,path11,path12); % period,fname11,,fname12
t_pro1=toc    % 79秒
%% pro2:日线主连
% clear all;
period='day';
path_zld='c:\EMPIRE\DATASOURCE\RB\ZL\';
tic
zl_day=DATA_PRO2_ZLD(contract,riqi,period,path12,path_zld);
t_pro2=toc   % 4秒
%% pro3:分钟主连
tic
period='5m';
path_zlm='c:\EMPIRE\DATASOURCE\RB\ZL\';
[zl_m]=DATA_PRO3_ZLM(contract,riqi,period,path11,path_zld,path_zlm);
t_pro3=toc

