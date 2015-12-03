clc
clear all
close all
% 城市的综合得分
% y=[-0.2803 -0.0986 -0.1402 1.4435	0.7193 -0.2098 0.0023];
y=[-0.951 -0.529 0.007 -0.123 -0.967 -0.122 -0.967];
% 每个城市的万人出租车拥有量
x1=[24.34626301 23.41638608 18.65102975 34.62638907 29.65862763 23.28010684 26.90366008];
% 每个城市的里程利用率
x2=[0.7170 0.6925 0.6540 0.5740 0.7379 0.7000 0.6788];
n=length(x1);
% 对数据进行标准化处理
x1=zscore(x1);
x2=zscore(x2);
y=zscore(y);
% 设置系数
X=[ones(n,1),x1',x2'];
% 回归
[b,bint,r,rint,sate]=regress(y',X)
% 输出相关数据至命令台
b,bint,r,rint,sate
% 导出数据
xlswrite('book_linear_regression',b,'sheet1');
xlswrite('book_linear_regression',bint,'sheet2');
xlswrite('book_linear_regression',r,'sheet3');
xlswrite('book_linear_regression',rint,'sheet4');
xlswrite('book_linear_regression',sate,'sheet5');
% 残差分析检验图生成
rcoplot(r,rint)