function [zl_day]=DATA_PRO2_ZLD(contract,riqi,period,inpath,outpath_zld)
%% data_process2��_rb_2015_5m��
% �γ���������
%     path='c:\EMPIRE\DATASOURCE\RB\DAY';
%     contract='rb';     % ��дʹ��
%     riqi='2015';       % ��дʹ��
%     period='day';  

    %% Ԥ��
    cd(inpath)
    % dlmread('rb0000.csv');
    % data=csvread('rb0000,csv');

    %% ����day
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
        for l=3:l1 % 1Ϊ. 2Ϊ..
            fn=[contract,'_',code,'_',riqi,'_',period,'.mat'];
            if lst(l,:)==fn            %�ļ�����
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
    %% ƴ��������������
    % �綨ʱ����
    for i=1:26
        if isempty(b(i).data)~=1 %��==0����b(i)��Ϊ��
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
    % ������׼���ṹ��ȫʱ�䣩
    dayst=struct('data',[]);
    for i=1:24
    dayst(i).data=zeros(ts,9); % ����24����ts*8)�������
    end
    for co=1:24    % coΪ��Լ
        for i=1:ts %iΪʱ��
            [j1,j2]=size(b(co).data); % ȷ��b(co).data������������
            for j=1:j1   
                if timest(i)==b(co).data(j,1)
                    dayst(co).data(i,:)=b(co).data(j,:);
                end
            end
        end
    end
    % ��������
    %times o h l c v amount oi add code
    zl=dayst(1).data;
    coco=ones(ts,1); % ���Լ��ţ�Ĭ�ϵ�һ��
    add=zeros(ts,1);
    % �㷨1�������
    for i=1:ts
       if i==1
            for co=1:24
               if dayst(co).data(i,8)>zl(i,8) %&& dayst(co).data(i,6)>zl(i,6)               
                   zl(i,:)=dayst(co).data(i,:);
                   coco(i)=co;
    %            else,����dataĬ�ϴ������dayst(1)�����ݣ����Բ���else��ֵ��
    %                  codesҲ����Ҫ�ٸ�ֵ��
               end
            end
       else %i~=1,�ӵ�2�쿪ʼ
           %(�ȴ�������������дһ��else��
           coco(i)=coco(i-1);                 % ��Լ����������һ��������Լ
           zl(i,:)=dayst(coco(i-1)).data(i,:); % ��������������һ�պ�Լ��
           for co=1:24 % ѭ���Ƚ�һ�£�����������û�з�������
              if dayst(co).data(i-1,6)>zl(i-1,6) && ...
                      dayst(co).data(i-1,8)>zl(i-1,8) % �������µĺ�Լ������˫�ߣ�����Ҫ����(�������������
                  zl(i,:)=dayst(co).data(i,:);  % �������ݸı䣬ֻ��Ϊ�˱���ѭ���Ƚ��ҵ���ߵ��Ǹ�
                  coco(i)=co; % ��Լ������˫�ߺ�Լ
                  add(i)=dayst(coco(i-1)).data(i,2); % add ���������������յĿ��̼�
               end
           end
       end
    end
    % �㷨2���Ȱ�ѭ�����꣨�ԣ�
    zl_day=[zl add];
    zh=find(zl(:,6)==0);% �ҵ��ɽ���Ϊ0����
    zl_day(zh,:)=[];

    zlname=[contract,'_','zl','_',riqi,'_',period];
%     path_zld='c:\EMPIRE\DATASOURCE\RB\ZL\';
    save([outpath_zld,zlname],'zl_day');

end


