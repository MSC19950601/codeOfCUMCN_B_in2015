clc
clear all
close all
% ���е��ۺϵ÷�
% y=[-0.2803 -0.0986 -0.1402 1.4435	0.7193 -0.2098 0.0023];
y=[-0.951 -0.529 0.007 -0.123 -0.967 -0.122 -0.967];
% ÿ�����е����˳��⳵ӵ����
x1=[24.34626301 23.41638608 18.65102975 34.62638907 29.65862763 23.28010684 26.90366008];
% ÿ�����е����������
x2=[0.7170 0.6925 0.6540 0.5740 0.7379 0.7000 0.6788];
n=length(x1);
% �����ݽ��б�׼������
x1=zscore(x1);
x2=zscore(x2);
y=zscore(y);
% ����ϵ��
X=[ones(n,1),x1',x2'];
% �ع�
[b,bint,r,rint,sate]=regress(y',X)
% ����������������̨
b,bint,r,rint,sate
% ��������
xlswrite('book_linear_regression',b,'sheet1');
xlswrite('book_linear_regression',bint,'sheet2');
xlswrite('book_linear_regression',r,'sheet3');
xlswrite('book_linear_regression',rint,'sheet4');
xlswrite('book_linear_regression',sate,'sheet5');
% �в��������ͼ����
rcoplot(r,rint)