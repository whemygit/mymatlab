%{
���ܣ�����Ʒ�ֺ���ݣ���ԭʼ����Դ�з��������Ʒ��ÿ������ݣ�������Ʒ�ִ���ָ�����ļ����С�
ԭʼ���ݴ����inpath�У������������ֿ��ţ��ֱ���sc,dc,��zc�ļ����С�
��ȡ���������ݷ���path�У�ÿ��Ʒ��һ���ļ��У����ļ�����ֿ�����rb_data\rv_data_2015
%}
clear all;
clc;
%% ��ʼ��������
contract=inputdlg({'����Ʒ�ִ���'},'',1,{''});
jiaoyisuo=inputdlg({'���뽻��������'},'',1,{''});

yearnum=[2007:2015]
for i=1:length(yearnum)
    riqi=num2str(yearnum(i));

    %% �������մ��·��
    path=['G:\EMPIRE\com_data_source\',contract{1},'_data\',contract{1},'_data_',riqi];
    mkdir(path)

    %% ��ԭʼ���ݴ��·������
    inpath=['H:\dataanalyse\com_data_source\5MIN-201512\FutAC_Min5_Std_',riqi,'\FutAC_Min5_Std_',riqi,'\Fut_Min\Fut_Min5\FutAC_Min5_Std\FutAC_Min5_Std_',riqi,'\',jiaoyisuo{1}]
    copyfile([inpath,'\',contract{1},'*.csv'],path)
    
%     Error using copyfile
%     No matching files were found.
end