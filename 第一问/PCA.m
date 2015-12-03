clc
clear all
close all
%导入数据,data.txt由excel的数据导入，在data_PCA_first.xls文件中
load data.txt
%数据标准化
data=zscore(data);
%计算相关系数矩阵
relation=corrcoef(data);
%%利用相关系数矩阵进行主成分分析，vector_first的列为主成分的系数
%lamda为relation的特征值，rate为各个主成分的贡献率
[vector_first,lamda,rate]=pcacov(relation)
%计算累积贡献率
contribution=cumsum(rate)
%构造与vector_first同维数的元素为±1的矩阵
f=repmat(sign(sum(vector_first)),size(vector_first,1),1);
%修改特征向量的正负号，使得每个特征向量的分量和为正
vector_second=vector_first.*f
%输出修改的特征向量至excel文档
xlswrite('book_PAC',vector_second,'sheet1')
%main_num为选取的主成分的个数
main_num=3;
%计算各个主成分的得分
score_PC=data*vector_second(:,1:main_num)
%输出各个主成分的得分至excel文档
xlswrite('book_PAC',score_PC,'sheet2');
%计算综合得分
final_score=score_PC*rate(1:main_num)/100
%输出综合得分至excel文档
xlswrite('book_PAC',final_score,'sheet3');
%把得分从高到低的排列
[score_t,rank]=sort(final_score,'descend');
score_t=score_t', rank=rank'
%输出综合得分至excel文档
xlswrite('book_PAC',rank','sheet4');
