function []=DATA_PRO1_CONVERT(contract,riqi,inpath,outpath1,outpath2) % period,fname11,,fname12
%% data_process1(_rb_2015_5m)
% ��.csvԭʼ����ת����.mat
% ���룺��Ϊstr�ַ���
    inpath='G:\EMPIRE\com_data_source\rb_data\rb_data_2015';
    contract='rb';     % ��дʹ��
    riqi='2015';       % ��дʹ��
    period='5m';

    %% Ԥ�ƣ�
    cd(inpath)
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    %% 
    for i=1:26                                                        % ÿ���ļ����������26����Լ��csv�ļ�
        if i<=9
            code=[riqi(3:4),'0',num2str(i)];                          % ���ɺ�Լ�����������ڲ��֣�1-9�·�Ϊһ�ָ�ʽ����1509
        elseif i>9 && i<=12
            code=[riqi(3:4),num2str(i)];                              % ���ɺ�Լ�����������ڲ��֣�10-12�·�Ϊһ�ָ�ʽ����1511
        elseif i>12 && i<=21
            code=[num2str(str2num(riqi(3:4))+1),'0',num2str(i-12)];   % ����12֮�󣬴���һ��һ�·ݿ�ʼ
        elseif i>21 && i<=24
            code=[num2str(str2num(riqi(3:4))+1),num2str(i-12)];       % ����21֮�󣬴���һ��ʮ�·ݿ�ʼ
        elseif i==25                                                  % 25ʱ��Ϊ��0000��
            code='0000';
        elseif i==26                                                  % 26ʱ��Ϊ��0001��
            code='0001';
        end
        % �鿴�Ƿ���ڸ��ļ�
        lst=ls;
        [l1,l2]=size(lst);
        for i=3:l1 % 1Ϊ. 2Ϊ..
            if lst(i,:)==[contract,code,'.csv']             %�ļ�����
                dataim=importdata([contract,code,'.csv']);  %�ṹ���飬����data��textdata����������data����7�С�double�͡���textdata����10�С�cell�͡�
                data=dataim.data;                           %���ݡ������ߡ��͡��ա��ɽ������ɽ���ͳֲ�����
                time1=dataim.textdata(:,3);                 %dataim.textdata,���г����룬sc��������Լ���룬rb1501������ʱ�䣬'2015-01-02 21:05:00'��
                times=datenum(time1(2:end));                %ȥ�������еĴ���ֵ��ʱ����
                times1=floor(times);                        %ʱ��ֵȡ��
                times2=times-times1;                        %ʱ��ֵС������          
                codes=repmat(str2num(code),length(times),1); % ������ʱ���г�����ȵ��·ݴ�������
                sv=[times,times1,times2,data,codes];         % 11��
                outpath1=['H:\EMPIRE\DATASOURCE\',contract,'\','SS2','\']; %5m
                fname11=[contract,'_',code,'_',riqi,'_','5m'];
                save([outpath1,fname11],'sv');
                % ת����������
                [data]=min2day(sv);
                outpath2=['H:\EMPIRE\DATASOURCE\',contract,'\SS2\']; %day
                fname12=[contract,'_',code,'_',riqi,'_','day'];
                save([outpath2,fname12],'data');
            end
        end
    end
end

