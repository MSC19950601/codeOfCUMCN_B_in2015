%时间平均计算----------------------------------------------------------------------
B=zeros(10);
for i=1:24
A=xlsread(['D:\Desktop\政策2实施后\time',num2str(i),'_average_gongqiu.xls']);
B=B+A;
end
B=B/24;
xlswrite(strcat('D:\Desktop\政策2实施后\average_gongqiu'),B);
