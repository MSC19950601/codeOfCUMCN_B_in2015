%ʱ��ƽ������----------------------------------------------------------------------
B=zeros(10);
for i=1:24
A=xlsread(['D:\Desktop\����2ʵʩ��\time',num2str(i),'_average_gongqiu.xls']);
B=B+A;
end
B=B/24;
xlswrite(strcat('D:\Desktop\����2ʵʩ��\average_gongqiu'),B);
