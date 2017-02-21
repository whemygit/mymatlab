function [zl_m]=DATA_PRO3_ZLM(contract,riqi,period,inpath1,inpath_zld,outpath_zlm)
    %% data_process3��_rb_2015_5m��
    % �γɷ���������
%     contract='rb';     % ��дʹ��
%     riqi='2015';       % ��дʹ��
%     period='5m';  
    
    %% ׼��
    % Ԥ�Ʊ���
    cd(inpath1); % c:\EMPIRE\DATASOURCE\RB\15M
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    % �����������
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
    fn=[contract,'_',code,'_',riqi,'_',period,'.mat'];
     % �鿴�Ƿ���ڸ��ļ�
    lst=ls;
    [l1,l2]=size(lst);
        for l=3:l1 % 1Ϊ. 2Ϊ..
            if lst(l,:)==fn             %�ļ�����
                a(i)=load([inpath1,fn]);% 'c:\EMPIRE\DATASOURCE\RB\'%
            end
        end
    end
    % ������������
    zlname=[contract,'_','zl','_',riqi,'_','day'];
    load([inpath_zld,zlname]); % ����������Ϊzl_day,'c:\EMPIRE\DATASOURCE\RB\ZL\'
    [d1,d2]=size(zl_day);
    %% ƴ�ӷ�������
    % �㷨1���ҵ���Լ����ͬ�ķ������ݣ�Ȼ����и�ֵ
    zl_m1=[];
    xhc=0;% ��¼ѭ������
    for i=1:d1   % �����������ݳ���ѭ��
        for co=1:24  % ���ڷ����ߺ�Լ����ѭ��
            if isempty(a(co).sv)~=1 % a(co).sv��Ϊ��
                if a(co).sv(1,11)==zl_day(i,9) % �ҵ���Լ����ͬ������������ͬ�ķ�������a(co).sv(i,2)==zl_day(i,1) && 
                    xhc=xhc+1;
                    % 1���ҳ������ж��ٷ�������
                    fz=find(a(co).sv(:,2)==zl_day(i,1)); 
                    % 2�����������з������ݸ�ֵ������
                    zl_m1=[zl_m1;a(co).sv(fz,:)];
                end
            end
        end
    end
    % �㷨2����zl_day�ĺ�Լ�Ž��з���co��ţ��ԣ�
    %% ����������
    [m1,m2]=size(zl_m1);
    addm1=zeros(m1,1);
    hy=0;
    zd1=0;
    zd2=0;
    for i=1:d1
        if zl_day(i,10)~=0  % ���ֻ���
            hy=hy+1;
            for j=1:m1
                if zl_m1(j,2)==zl_day(i,1) % &&  zl_m(j,3)==zl_m(1,3) % ����9��05 AM��һ��
                    zd2=zd2+1;
                    addm1(j)=zl_day(i,10);
                end
            end
        end
    end
    % ���¼۸�ֻ������һ��
    addm2=zeros(m1,1);
    addm2(2:end)=diff(addm1);
    hy1=find(addm2>0);
    addm3=addm2>0;
    addm=addm1.*addm3;
    zl_m2=[zl_m1,addm];
    %% ��������ʧ������
    sz=ones(m1,1);
    for i=1:m1
        if zl_m2(i,4)==zl_m2(i,5) && zl_m2(i,5)==zl_m2(i,6) && zl_m2(i,6)==zl_m2(i,7)...
                && zl_m2(i,8)==0 % ����ʧ�����������o=h=l=c&&v=0��
            sz(i)=0;
        end
    end
    szh=find(sz==0);
    zl_m=zl_m2;
    zl_m(szh,:)=[];
    zlmname=[contract,'_','zl','_',riqi,'_',period];
%     path_zlm='c:\EMPIRE\DATASOURCE\RB\ZL\';
    save([outpath_zlm,zlmname],'zl_m');
end

