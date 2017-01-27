% 初始化结果矩阵为空，再次循环寻优

BestIndexData=result(:,[1,2,4]);                       % 提取两个择优参数以及择优所依据的评价指标组成BestIndexData矩阵
BestIndex=max(BestIndexData(:,3));                     % 找出择优指标最优值
BestParameter1=0;
BestParameter2=0;

for i=1:size(result,1)
    if BestIndexData(i,3)==BestIndex                   %确定择优指标最优值在矩阵中的位置
       BestParameter1=BestIndexData(i,1);              %根据位置确定最优参数1的值
       BestParameter2=BestIndexData(i,2);              %根据位置确定最优参数2的值
    end       
end
BestParameter1;
BestParameter2;