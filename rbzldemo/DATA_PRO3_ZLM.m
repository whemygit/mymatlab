function [zl_m]=DATA_PRO3_ZLM(contract,riqi,period,inpath1,inpath_zld,outpath_zlm)
    %% data_process3（_rb_2015_5m）
    % 形成分钟线主连
%     contract='rb';     % 改写使用
%     riqi='2015';       % 改写使用
%     period='5m';  
    
    %% 准备
    % 预制变量
    cd(inpath1); % c:\EMPIRE\DATASOURCE\RB\15M
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    % 导入分钟数据
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
     % 查看是否存在该文件
    lst=ls;
    [l1,l2]=size(lst);
        for l=3:l1 % 1为. 2为..
            if lst(l,:)==fn             %文件存在
                a(i)=load([inpath1,fn]);% 'c:\EMPIRE\DATASOURCE\RB\'%
            end
        end
    end
    % 导入日线主连
    zlname=[contract,'_','zl','_',riqi,'_','day'];
    load([inpath_zld,zlname]); % 导入后变量名为zl_day,'c:\EMPIRE\DATASOURCE\RB\ZL\'
    [d1,d2]=size(zl_day);
    %% 拼接分钟主连
    % 算法1：找到合约号相同的分钟数据，然后进行赋值
    zl_m1=[];
    xhc=0;% 记录循环次数
    for i=1:d1   % 基于日线数据长度循环
        for co=1:24  % 基于分钟线合约数量循环
            if isempty(a(co).sv)~=1 % a(co).sv不为空
                if a(co).sv(1,11)==zl_day(i,9) % 找到合约号相同与日线数据相同的分钟数据a(co).sv(i,2)==zl_day(i,1) && 
                    xhc=xhc+1;
                    % 1、找出当天有多少分钟数据
                    fz=find(a(co).sv(:,2)==zl_day(i,1)); 
                    % 2、将当天所有分钟数据赋值进主连
                    zl_m1=[zl_m1;a(co).sv(fz,:)];
                end
            end
        end
    end
    % 算法2：用zl_day的合约号进行反推co序号（略）
    %% 处理换月事宜
    [m1,m2]=size(zl_m1);
    addm1=zeros(m1,1);
    hy=0;
    zd1=0;
    zd2=0;
    for i=1:d1
        if zl_day(i,10)~=0  % 发现换月
            hy=hy+1;
            for j=1:m1
                if zl_m1(j,2)==zl_day(i,1) % &&  zl_m(j,3)==zl_m(1,3) % 早上9：05 AM那一行
                    zd2=zd2+1;
                    addm1(j)=zl_day(i,10);
                end
            end
        end
    end
    % 换月价格只保留第一个
    addm2=zeros(m1,1);
    addm2(2:end)=diff(addm1);
    hy1=find(addm2>0);
    addm3=addm2>0;
    addm=addm1.*addm3;
    zl_m2=[zl_m1,addm];
    %% 处理明显失真数据
    sz=ones(m1,1);
    for i=1:m1
        if zl_m2(i,4)==zl_m2(i,5) && zl_m2(i,5)==zl_m2(i,6) && zl_m2(i,6)==zl_m2(i,7)...
                && zl_m2(i,8)==0 % 明显失真情况发生（o=h=l=c&&v=0）
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

