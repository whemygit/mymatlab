function [MAShort,MALong] = IndexSMA(ClosePrice,LenofShort,LenofLong)
    %SMA函数用于计算某一时间序列的一组简单移动平均值。其输入参数有三个，
    %ClosePrice,LenofShort和LenofLong。其中，ClosePrice是指股票价格
    %等时间序列向量，LenofShort指较短的移动平均线计算周期，LenofLong
    %指较长的移动平均线计算周期。输出参数有两个，MAShort和MALong，
    %分别指短期移动平均线和长期移动平均线。
    for i=LenofShort:length(ClosePrice)
        MShort(i)=mean(ClosePrice((i-LenofShort+1):i));    %（短周期：原时序长度）位置的MAShort为其向前数短周期个数的原时序的简单平均值
    end
    MShort(1:LenofShort-1)=NaN;     %（1：短周期-1）位置的MAShort用第一个MAShort补齐
%     MShort(1:LenofShort-1)=ClosePrice(1:LenofShort-1);     %（1：短周期-1）位置的MAShort用原时间序列补齐
    MAShort=MShort';                                       %最终输出的MAShort为中间输出MShort经过转置后的列向量

    for i=LenofLong:length(ClosePrice)
        MLong(i)=mean(ClosePrice((i-LenofLong+1):i));      %（长周期：原时序长度）位置的MALong为其向前数长周期个数的原时序的简单平均值
    end
    MLong(1:LenofLong-1)=NaN;     %（1：短周期-1）位置的MLong用第一个MLong补齐
%     MLong(1:LenofLong-1)=ClosePrice(1:LenofLong-1);        %（1：长周期-1）位置的MALong用原时间序列补齐
    MALong=MLong';                                         %最终输出的MALong为中间输出MLong经过转置后的列向量
end


