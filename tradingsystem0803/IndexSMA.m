function [MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong)
    %SMA�������ڼ���ĳһʱ�����е�һ����ƶ�ƽ��ֵ�������������������
    %ClosePrice,LenofShort��LenofLong�����У�ClosePrice��ָ��Ʊ�۸�
    %��ʱ������������LenofShortָ�϶̵��ƶ�ƽ���߼������ڣ�LenofLong
    %ָ�ϳ����ƶ�ƽ���߼������ڡ����������������MAShort��MALong��
    %�ֱ�ָ�����ƶ�ƽ���ߺͳ����ƶ�ƽ���ߡ�
    for i=LenofShort:length(ClosePrice)
        MShort(i)=mean(ClosePrice((i-LenofShort+1):i));    %�������ڣ�ԭʱ�򳤶ȣ�λ�õ�MAShortΪ����ǰ�������ڸ�����ԭʱ��ļ�ƽ��ֵ
    end
    MShort(1:LenofShort-1)=NaN;     %��1��������-1��λ�õ�MAShort�õ�һ��MAShort����
%     MShort(1:LenofShort-1)=ClosePrice(1:LenofShort-1);     %��1��������-1��λ�õ�MAShort��ԭʱ�����в���
    MAShort=MShort';                                       %���������MAShortΪ�м����MShort����ת�ú��������

    for i=LenofLong:length(ClosePrice)
        MLong(i)=mean(ClosePrice((i-LenofLong+1):i));      %�������ڣ�ԭʱ�򳤶ȣ�λ�õ�MALongΪ����ǰ�������ڸ�����ԭʱ��ļ�ƽ��ֵ
    end
    MLong(1:LenofLong-1)=NaN;     %��1��������-1��λ�õ�MLong�õ�һ��MLong����
%     MLong(1:LenofLong-1)=ClosePrice(1:LenofLong-1);        %��1��������-1��λ�õ�MALong��ԭʱ�����в���
    MALong=MLong';                                         %���������MALongΪ�м����MLong����ת�ú��������
end


