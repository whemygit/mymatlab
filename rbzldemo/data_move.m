%{
���ܣ�����Ʒ�ֺ���ݣ���ԭʼ����Դ�з��������Ʒ��ÿ������ݣ�������Ʒ�ִ���ָ�����ļ����С�
ԭʼ���ݴ����inpath�У������������ֿ��ţ��ֱ���sc,dc,��zc�ļ����С�
��ȡ���������ݷ���path�У�ÿ��Ʒ��һ���ļ��У����ļ�����ֿ�����rb_data\rb_data_2015
%}
clear all;
clc;
%% ��ʼ��������
contract=inputdlg({'����Ʒ�ִ���'},'',1,{''});
jiaoyisuo=inputdlg({'���뽻��������'},'',1,{''});

yearnum=[2004:2015];
for i=1:length(yearnum)
    riqi=num2str(yearnum(i));

    %% �������մ��·��
    path=['H:\EMPIRE\com_data_source\',contract{1},'_data\',contract{1},'_data_',riqi];
    mkdir(path)

    %% ��ԭʼ���ݴ��·������
    if i==[1:3]
        inpath=['H:\dataanalyse\com_data_source\5MIN-201512\FutAC_Min5_Std_',riqi,'\Fut_Min\Fut_Min5\FutAC_Min5_Std\FutAC_Min5_Std_',riqi,'\',jiaoyisuo{1}];
    else 
        inpath=['H:\dataanalyse\com_data_source\5MIN-201512\FutAC_Min5_Std_',riqi,'\FutAC_Min5_Std_',riqi,'\Fut_Min\Fut_Min5\FutAC_Min5_Std\FutAC_Min5_Std_',riqi,'\',jiaoyisuo{1}];
    end
    lst=ls(inpath);
    [l1,l2]=size(lst);
    for l=3:l1 % 1Ϊ. 2Ϊ..
        if lst(l,(1:2))==contract{1}             %�ļ�����
%             copyfile([inpath,'\',contract{1},'*.csv'],path)
           copyfile([inpath,'\',lst(l,:)],path)
        end
    end
%     Error using copyfile
%     No matching files were found.
end