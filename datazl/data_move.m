%{
功能：根据品种和年份，从原始数据源中分离出单个品种每年的数据，放在以品种代码指定的文件夹中。
原始数据存放在inpath中，各个交易所分开放，分别以sc,dc,和zc文件夹中。
提取出来的数据放在path中，每个品种一个文件夹，子文件按年分开，如rb_data\rv_data_2015
%}
clear all;
clc;
%% 初始参数设置
contract=inputdlg({'输入品种代码'},'',1,{''});
jiaoyisuo=inputdlg({'输入交易所代码'},'',1,{''});

yearnum=[2007:2015]
for i=1:length(yearnum)
    riqi=num2str(yearnum(i));

    %% 创建最终存放路径
    path=['G:\EMPIRE\com_data_source\',contract{1},'_data\',contract{1},'_data_',riqi];
    mkdir(path)

    %% 从原始数据存放路径复制
    inpath=['H:\dataanalyse\com_data_source\5MIN-201512\FutAC_Min5_Std_',riqi,'\FutAC_Min5_Std_',riqi,'\Fut_Min\Fut_Min5\FutAC_Min5_Std\FutAC_Min5_Std_',riqi,'\',jiaoyisuo{1}]
    copyfile([inpath,'\',contract{1},'*.csv'],path)
    
%     Error using copyfile
%     No matching files were found.
end