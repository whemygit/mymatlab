%% �ۺϴ���
% ���ó���data_pro1\data_pro2\data_pro3

clear all;
clc;
%% pro1:.csvת��Ϊ.mat
contract='rb';     % ��дʹ��
riqi='2009';       % ��дʹ��
% period='5m';
% code='0000';  %code�����������ڱ���·���е����ã�ÿ�κ�����ѭ������е���
path=['c:\EMPIRE\com_data_source\',contract,'_data\',contract,'_data_',riqi];% ����·��'rb_data\rb_data_2015'
path11=['c:\EMPIRE\DATASOURCE\',contract,'\5m\']; %5m�����·��1
% fname11=[contract,'-',code,'-',riqi,'_','5m'];% ����ļ�1
path12=['c:\EMPIRE\DATASOURCE\',contract,'\DAY\']; %day�����·��2
% fname12=[contract,'_',code,'_',riqi,'_','day']; % ����ļ�2
tic
DATA_PRO1_CONVERT(contract,riqi,path,path11,path12); % period,fname11,,fname12
t_pro1=toc    % 79��
%% pro2:��������
% clear all;
period='day';
path_zld='c:\EMPIRE\DATASOURCE\RB\ZL\';
tic
zl_day=DATA_PRO2_ZLD(contract,riqi,period,path12,path_zld);
t_pro2=toc   % 4��
%% pro3:��������
tic
period='5m';
path_zlm='c:\EMPIRE\DATASOURCE\RB\ZL\';
[zl_m]=DATA_PRO3_ZLM(contract,riqi,period,path11,path_zld,path_zlm);
t_pro3=toc

