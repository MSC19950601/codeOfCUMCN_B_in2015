%求和函数------------------------------------------------------------------
for i=1:24
average_people{i}=zeros(10);
average_demand{i}=zeros(10);
average_car{i}=zeros(10);
end
for i=1:10
    FileName = ['D:\Desktop\政策2实施后\result' num2str(i) '.mat'];
    load (FileName);
    for j=1:24
        average_people{j}=average_people{j}+result{1,j}.people;
        average_demand{j}=average_demand{j}+result{1,j}.demand;
        average_car{j}=average_car{j}+result{1,j}.car;
    end
end
for j=1:24
    average_people{j}=average_people{j}/10;
    average_demand{j}=average_demand{j}/10;
    average_car{j}=average_car{j}/10;
    average_gongqiu{j}=sqrt((average_car{j}-average_demand{j}).^2);
end

haha.average_people=average_people;
haha.average_demand=average_demand;
haha.average_car=average_car;
haha.average_gongqiu=average_gongqiu;

for i=1:24
    xlswrite(strcat('D:\Desktop\政策2实施后\time',num2str(i),'_average_gongqiu'),haha.average_gongqiu{i});
%     xlswrite(strcat('D:\Desktop\政策实施前\time',num2str(i),'_average_car'),haha.average_car{i});
end
