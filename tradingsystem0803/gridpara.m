function [ GrPaSeries ] = gridpara( VecLength,m1,m2,m3,m4,m5,n1,n2,n3,n4,n5,n6  )
% 20,100,300,600,1000��1,2,3,4,5,10
% gridpar�����������������������м������ȡ����Ѱ�Ų�����������������������ƣ����Խ��Խ��Ҳ��ȡ��Ƶ��Խ��ԽС��
% ��ǰ1��m1�������У�ÿn1����ȡһ�Σ�ǰm1��m2�������У�ÿn2����ȡһ�Σ�ǰm2��m3�������У�ÿn3����ȡһ�Σ��Դ����ơ�
% ���������VecLengthΪ��ԭ���еĳ��ȡ���
% m1,m2,m3,m4��m5Ϊ��ȡ��Ƶ�ʱ任ʱ��ԭʼ�����ٽ�ֵ������һ�����������С�
% n1,n2,n3,n4,n5��n6Ϊ��ȡ��Ƶ�ʡ�����һ�����������С�

    GrPaSeries=[];                       % ���������С������պ���gridpar�����ԭʼ��������ȡ����������
    GrPaSeries2=[];                      % ���м����С���ÿ��ѭ��������γɵ����У���Ϊ�������е��γɹ�������
    GrPaSeries1=0;                       %  ���м�ȡֵ����ÿ��ѭ������ȡ����ԭʼ�����еĵ���ֵ����ʼֵΪ0�������γ��м�����
    OriSeries=[1:VecLength];              % ��ԭʼ���С����Ե�һ���������VecLengthΪ���ȵ�����
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
    GrPaSeries=GrPaSeries2(find(GrPaSeries2~=0));   % �γ���ȡ������������
end

