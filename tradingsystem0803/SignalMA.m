SignalBuy=zeros(length(ClosePrice),1);
SignalSell=zeros(length(ClosePrice),1);

for i=LenofLong:length(ClosePrice)
    SignalBuy(i)=MAShort(i-1)<=MALong(i-1) && MAShort(i)>MALong(i);                               %�����źű��ʽ
end

for i=LenofLong:length(ClosePrice)
    SignalSell(i)=MAShort(i-1)>=MALong(i-1) && MAShort(i)<MALong(i);                               %�����źű��ʽ
end