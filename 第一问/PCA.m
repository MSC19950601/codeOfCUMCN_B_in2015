clc
clear all
close all
%��������,data.txt��excel�����ݵ��룬��data_PCA_first.xls�ļ���
load data.txt
%���ݱ�׼��
data=zscore(data);
%�������ϵ������
relation=corrcoef(data);
%%�������ϵ������������ɷַ�����vector_first����Ϊ���ɷֵ�ϵ��
%lamdaΪrelation������ֵ��rateΪ�������ɷֵĹ�����
[vector_first,lamda,rate]=pcacov(relation)
%�����ۻ�������
contribution=cumsum(rate)
%������vector_firstͬά����Ԫ��Ϊ��1�ľ���
f=repmat(sign(sum(vector_first)),size(vector_first,1),1);
%�޸����������������ţ�ʹ��ÿ�����������ķ�����Ϊ��
vector_second=vector_first.*f
%����޸ĵ�����������excel�ĵ�
xlswrite('book_PAC',vector_second,'sheet1')
%main_numΪѡȡ�����ɷֵĸ���
main_num=3;
%����������ɷֵĵ÷�
score_PC=data*vector_second(:,1:main_num)
%����������ɷֵĵ÷���excel�ĵ�
xlswrite('book_PAC',score_PC,'sheet2');
%�����ۺϵ÷�
final_score=score_PC*rate(1:main_num)/100
%����ۺϵ÷���excel�ĵ�
xlswrite('book_PAC',final_score,'sheet3');
%�ѵ÷ִӸߵ��͵�����
[score_t,rank]=sort(final_score,'descend');
score_t=score_t', rank=rank'
%����ۺϵ÷���excel�ĵ�
xlswrite('book_PAC',rank','sheet4');
