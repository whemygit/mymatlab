%% data_pro4
% 拼接主力连续
contract='rb';

inpath='c:\EMPIRE\DATASOURCE\RB\ZL\';
cd(inpath);
riqi_min=2009;
riqi_max=2015;
xhc=0;
zl=[];
for r=riqi_min:riqi_max
    xhc=xhc+1;
    fn=[contract,'_zl_',num2str(r),'_day.mat'];
    load(fn);  % inpath????????
    % 导入后形成zl_m变量
    zl=[zl;zl_day];%%%
end

fn2=[contract,'_zl_allperiod_day'];
save([inpath,fn2],'zl');


    