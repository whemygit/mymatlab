function []=DATA_PRO1_CONVERT(contract,riqi,inpath,outpath1,outpath2) % period,fname11,,fname12
%% data_process1(_rb_2015_5m)
% ��.csvԭʼ����ת����.mat
% ���룺��Ϊstr�ַ���
%     path='rb_data\rb_data_2015';
%     contract='rb';     % ��дʹ��
%     riqi='2015';       % ��дʹ��
%     period='5m';

    %% Ԥ�ƣ�
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
        % �鿴�Ƿ���ڸ��ļ�
        lst=ls;
        [l1,l2]=size(lst);
        for i=3:l1 % 1Ϊ. 2Ϊ..
            if lst(i,:)==[contract,code,'.csv']             %�ļ�����
                dataim=importdata([contract,code,'.csv']);  %�ļ������ܴ���������������Ϊdata
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
                % ת����������
                [data]=min2day(sv);
%                 outpath2=['c:\EMPIRE\DATASOURCE\',contract,'\SS\']; %day
                fname12=[contract,'_',code,'_',riqi,'_','day'];
                save([outpath2,fname12],'data');
            end
        end
    end
end

