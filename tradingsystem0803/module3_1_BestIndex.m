% ��ʼ���������Ϊ�գ��ٴ�ѭ��Ѱ��

BestIndexData=result(:,[1,2,4]);                       % ��ȡ�������Ų����Լ����������ݵ�����ָ�����BestIndexData����
BestIndex=max(BestIndexData(:,3));                     % �ҳ�����ָ������ֵ
BestParameter1=0;
BestParameter2=0;

for i=1:size(result,1)
    if BestIndexData(i,3)==BestIndex                   %ȷ������ָ������ֵ�ھ����е�λ��
       BestParameter1=BestIndexData(i,1);              %����λ��ȷ�����Ų���1��ֵ
       BestParameter2=BestIndexData(i,2);              %����λ��ȷ�����Ų���2��ֵ
    end       
end
BestParameter1;
BestParameter2;