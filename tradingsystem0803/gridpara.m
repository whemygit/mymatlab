function [ GrPaSeries ] = gridpara( VecLength,m1,m2,m3,m4,m5,n1,n2,n3,n4,n5,n6  )
% 20,100,300,600,1000；1,2,3,4,5,10
% gridpar函数用于在连续的序列中有间隔地提取网格寻优参数，随着数据向量向后推移，间隔越来越大，也即取数频率越来越小；
% 在前1—m1个数据中，每n1个数取一次，前m1—m2个数据中，每n2个数取一次，前m2—m3个数据中，每n3个数取一次，以此类推。
% 其输入参数VecLength为【原序列的长度】，
% m1,m2,m3,m4和m5为【取数频率变换时的原始序列临界值】，是一个递增的序列。
% n1,n2,n3,n4,n5和n6为【取数频率】，是一个递增的序列。

    GrPaSeries=[];                       % 【最终序列】，按照函数gridpar规则从原始序列中所取的最终序列
    GrPaSeries2=[];                      % 【中间序列】，每次循环后的所形成的序列，其为最终序列的形成过程序列
    GrPaSeries1=0;                       %  【中间取值】，每次循环后所取到的原始序列中的单个值，初始值为0，用于形成中间序列
    OriSeries=[1:VecLength];              % 【原始序列】，以第一个输入参数VecLength为长度的向量
    for i=1:VecLength
        if i<=m1 && mod(i,n1)==0
            GrPaSeries1=OriSeries(i);
        elseif i>m1 && i<=m2 && mod(i,n2)==0
            GrPaSeries1=OriSeries(i);
        elseif i>m2 && i<=m3 && mod(i,n3)==0
            GrPaSeries1=OriSeries(i);
        elseif i>m3 && i<=m4 && mod(i,n4)==0
            GrPaSeries1=OriSeries(i);            
        elseif i>m4 && i<=m5 && mod(i,n5)==0
            GrPaSeries1=OriSeries(i);
        elseif i>m5 && mod(i,n6)==0
            GrPaSeries1=OriSeries(i);            
        else    
            GrPaSeries1=0;
        end        
    GrPaSeries2=[GrPaSeries2,GrPaSeries1];    
    end    
    GrPaSeries=GrPaSeries2(find(GrPaSeries2~=0));   % 形成所取到的最终向量
end

