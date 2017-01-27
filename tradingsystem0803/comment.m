%% （一）、清理工作空间及窗口
clear all, clc; close all;
cd F:\tradingsystem0803

[num,txt,raw]=xlsread('F:\tradingMAresult\output1_MA_RB_0_0minContinuous.xlsx',2);
num(:,(length(txt)+1))=num(:,4)./num(:,15);
txt(length(txt)+1)={'newpara'};
sortnum=sortrows(num,-25);

xlswrite('comment.xlsx',[txt;num2cell(sortnum)]);