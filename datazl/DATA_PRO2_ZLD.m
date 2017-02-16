function [zl_day]=DATA_PRO2_ZLD(contract,riqi,period,inpath,outpath_zld)
%% data_process2（_rb_2015_5m）
% 形成日线主连
%     path='c:\EMPIRE\DATASOURCE\RB\DAY';
%     contract='rb';     % 改写使用
%     riqi='2015';       % 改写使用
%     period='day';  

    %% 预制
    cd(inpath)
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    %% 导入day
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
    lst=ls;
    [l1,l2]=size(lst);
        for l=3:l1 % 1为. 2为..
            fn=[contract,'_',code,'_',riqi,'_',period,'.mat'];
            if lst(l,:)==fn            %文件存在
                b(i)=load([inpath,fn]);  %
            end
        end
    end
    % check
    % for i=1:26
    %     c(i)=a(i).sv(end,2)-a(i).sv(1,2);
    % end
    % for i=1:26
    %     d(i)=b(i).data(end,1)-b(i).data(1,1);
    % end
    % e=[c' d'];
    % correct1=isequal(c,d);
    %% 拼接主连——日线
    % 界定时间跨度
    for i=1:26
        if isempty(b(i).data)~=1 %或==0，即b(i)不为空
            time1(i)=b(i).data(1,1);
            time2(i)=b(i).data(end,1);
        else
            time1(i)=0;
            time2(i)=0;
        end
    end
    zh1=find(time1==0);
    time1(zh1)=[];
    zh2=find(time2==0);
    time2(zh2)=[];
    time_min=min(time1);
    time_max=max(time2);
    ts=time_max-time_min;
    timest=(time_min:time_max)';
    % 建立标准化结构（全时间）
    dayst=struct('data',[]);
    for i=1:24
    dayst(i).data=zeros(ts,9); % 建立24个（ts*8)的零矩阵
    end
    for co=1:24    % co为合约
        for i=1:ts %i为时间
            [j1,j2]=size(b(co).data); % 确定b(co).data的行数！！！
            for j=1:j1   
                if timest(i)==b(co).data(j,1)
                    dayst(co).data(i,:)=b(co).data(j,:);
                end
            end
        end
    end
    % 构建主连
    %times o h l c v amount oi add code
    zl=dayst(1).data;
    coco=ones(ts,1); % 存合约序号，默认第一张
    add=zeros(ts,1);
    % 算法1：混合做
    for i=1:ts
       if i==1
            for co=1:24
               if dayst(co).data(i,8)>zl(i,8) %&& dayst(co).data(i,6)>zl(i,6)               
                   zl(i,:)=dayst(co).data(i,:);
                   coco(i)=co;
    %            else,由于data默认存入的是dayst(1)的数据，所以不用else赋值了
    %                  codes也不需要再赋值了
               end
            end
       else %i~=1,从第2天开始
           %(先处理多数情况，少写一个else）
           coco(i)=coco(i-1);                 % 合约暂且先用上一日主力合约
           zl(i,:)=dayst(coco(i-1)).data(i,:); % 主连数据沿用上一日合约的
           for co=1:24 % 循环比较一下，看看今天有没有发生换月
              if dayst(co).data(i-1,6)>zl(i-1,6) && ...
                      dayst(co).data(i-1,8)>zl(i-1,8) % 昨天有新的合约产生了双高，今天要换月(少数情况发生）
                  zl(i,:)=dayst(co).data(i,:);  % 主连数据改变，只是为了便于循环比较找到最高的那个
                  coco(i)=co; % 合约换成新双高合约
                  add(i)=dayst(coco(i-1)).data(i,2); % add 存入上期主连今日的开盘价
               end
           end
       end
    end
    % 算法2：先把循环做完（略）
    zl_day=[zl add];
    zh=find(zl(:,6)==0);% 找到成交量为0的行
    zl_day(zh,:)=[];

    zlname=[contract,'_','zl','_',riqi,'_',period];
%     path_zld='c:\EMPIRE\DATASOURCE\RB\ZL\';
    save([outpath_zld,zlname],'zl_day');

end


