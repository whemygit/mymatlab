%% 构造日线数据
function [data]=min2day(sv)
% 输入：a(1).sv

% o h l c v amount oi 
% times:<时点>，换日时确认，赋上期值；
% o:<时点>，换日时确认，赋当期值；
% h:<比较>，换日时确立基准；
% l:<比较>，换日时确立基准；
% c:<时点>，换日时确认，赋上期值；
% v:<累积>，换日时确立起始；
% amount:<累积>，换日时确立起始；
% oi:<时点>，换日时确认，赋上期值；

    [t1,t2]=size(sv);
    code=sv(end,end); % 提取合约月份
    for i=1:t1
       if i==1 % 第一天的处理
           day=1; % 天数
           times(day)=sv(i,2); % 确定
           o(day)=sv(i,4);     % 确定
           h(day)=sv(i,5);     % 比较，确立基准
           l(day)=sv(i,6);     % 比较，确立基准
           v(day)=sv(i,8);     % 累积，确立起始
           amount(day)=sv(i,9);% 累积，确立起始
       elseif i==t1 % 最后一天的处理,是否换日暂时不做区别处理
           c(day)=sv(i,7);
           h(day)=max(h(day),sv(i,5));
           l(day)=min(l(day),sv(i,6));
           v(day)=v(day)+sv(i,8);
           amount(day)=amount(day)+sv(i,9);
           oi(day)=sv(i,10);
       else % 第二天开始正常处理
           if sv(i,2)~=sv(i-1,2) % 换日
               times(day)=sv(i-1,2); % 确定，和第一天重复
               c(day)=sv(i-1,7);     % 事后确定
               oi(day)=sv(i-1,10);   % 事后确定
              day=day+1; % 日期加一天
               times(day)=sv(i,2); % 确定
               o(day)=sv(i,4);     % 确定
               h(day)=sv(i,5);     % 比较
               l(day)=sv(i,6);     % 比较
               v(day)=sv(i,8);     % 累积
               amount(day)=sv(i,9);% 累积
           else % 非换日，多数情况
               h(day)=max(h(day),sv(i,5));      % 确定
               l(day)=min(l(day),sv(i,6));      % 确定
               v(day)=v(day)+sv(i,8);           % 确定
               amount(day)=amount(day)+sv(i,9); % 确定
           end
       end
    end
    codes=repmat(code,length(times),1);
    data=[times' o' h' l' c' v' amount' oi' codes];
end

% save(['c:\EMPIRE\DATASOURCE\RB\',contract,'_',code,'_',riqi,'_',period],'data');

