%% data_pro4
% ƴ����������
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
    % ������γ�zl_m����
    zl=[zl;zl_day];%%%
end

fn2=[contract,'_zl_allperiod_day'];
save([inpath,fn2],'zl');


    