close all;
clear all;
clc
%对于补贴力度的灵敏度分析----------------------------------------------------
for goji=1:100
    %元胞自动机求解打车问题-----------------------------------------------------
    %初始化--------------------------------------------------------------------
    result=cell(1,24);                              %存储结果的结构体
    A=zeros(10);            %A为人口分布矩阵，人口单位为万人
    A(5,:)=37;  A(:,5)=37;
    A(6,:)=37;  A(:,6)=37;
    A(4,:)=21;  A(:,4)=21;
    A(7,:)=21;  A(:,7)=21;
    A(3,:)=14;  A(:,3)=14;
    A(8,:)=14;  A(:,8)=14;
    A(2,:)=13;  A(:,2)=13;
    A(9,:)=13;  A(:,9)=13;
    A(1,:)=12;  A(:,1)=12;
    A(10,:)=12;  A(:,10)=12;
    B=zeros(10);            %B为出租车分布矩阵，出租车数目单位为万辆
    B(5:6,5:6)=1.725;
    demand=zeros(10);       %需求量的矩阵
    go=0;                   %车可能前往的地方标志
    scale=0.005;             %暂且设置1%的人打车，其实这儿究竟取多少值得斟酌
    cc=0.25+goji*0.001;   %距离与人数项权值
    aa=(1-cc)/2;
    bb=aa;
    for o=1:24
        %随机设置有多少地有人可能打车------------------------------------------------
        need=fix(rand(1)*100); %need是有多少个地点有人打车
        if need==0
            need=1;
        end
        
        car=cell(10,10);
        for i=1:10
            for j=1:10
                car{i,j}.distance=zeros(1,need);%各点出租车与各需求点的距离
                car{i,j}.car_want=zeros(2,1);
                car{i,j}.gailv=zeros(1,need);
            end
        end
        bar=zeros(1,need);                     %轮盘赌计量表
        %寻找need个地点的位置-------------------------------------------------------
        need_point=fix(rand(2,need)*10);            %人出发点
        [a,b,~]=find(need_point==0);
        long=length(a);
        for i=1:long
            need_point(a(i),b(i))=1;
        end
        for i=1:need
            demand(need_point(1,i),need_point(2,i))=demand(need_point(1,i),need_point(2,i))+A(need_point(1,i),need_point(2,i))*scale;
        end
        [pop,haha,~]=find(demand~=0);
        need=length(pop);
        clear need_point;
        need_point(1,:)=pop';
        need_point(2,:)=haha';
        %任意选取need个人想去的地方-------------------------------------------------
        people_want=fix(rand(2,need)*10);           %目的地（行列与出发点一一对应）
        [a,b,~]=find(people_want==0);
        long=length(a);
        for i=1:long
            people_want(a(i),b(i))=1;
        end
        for i=1:need                                 %避免出发点与目的地是同一地方
            while (people_want(1,i)==need_point(1,i))&&(people_want(2,i)==need_point(2,i))
                people_want(:,i)=fix(rand(2,1)*10);
                if people_want(1,i)==0
                    people_want(1,i)=1;
                end
                if people_want(2,i)==0
                    people_want(2,i)=1;
                end
            end
        end
        
        %车计算与自己所在位置与人的出发点的距离与人的出发点与目的地的距离和------------
        for i=1:10
            for j=1:10
                for ii=1:need
                    car{i,j}.distance(ii)=sqrt((need_point(1,ii)-i)^2+(need_point(2,ii)-j)^2)+sqrt((people_want(1,ii)-need_point(1,ii))^2+(people_want(2,ii)-need_point(2,ii))^2);
                    car{i,j}.distance_gailv(ii)=1/car{i,j}.distance(ii);
                    car{i,j}.people_gailv(ii)=A(people_want(1,ii),people_want(2,ii));
                    car{i,j}.leave_gailv(ii)=sqrt((need_point(1,ii)-i)^2+(need_point(2,ii)-j)^2);
                end
                distance_all=sum(car{i,j}.distance_gailv);
                people_all=sum(car{i,j}.people_gailv);
                leave_all=sum(car{i,j}.leave_gailv);
                car{i,j}.gailv=aa*(car{i,j}.distance_gailv/distance_all)+bb*(car{i,j}.people_gailv/people_all)+cc*(car{i,j}.leave_gailv/leave_all);
            end
        end
        %车以轮盘赌法选取地点接客---------------------------------------------------
        for i=1:10
            for j=1:10
                for ii=1:need
                    bar(ii)=sum(car{i,j}.gailv(1:ii));
                end
                index=rand(1);
                if index<=bar(1)
                    go=1;
                end
                for ii=2:need
                    if index>bar(ii-1)&&index<=bar(ii)
                        go=ii;
                    end
                end
                car{i,j}.car_want=need_point(:,go);
            end
        end
        
        %车到乘车地-----------------------------------------------------------------
        for i=1:10
            for j=1:10
                destination_index=car{i,j}.car_want;
                if demand(destination_index(1),destination_index(2))<B(i,j)
                    B(i,j)=B(i,j)-demand(destination_index(1),destination_index(2));
                    B(destination_index(1),destination_index(2))=B(destination_index(1),destination_index(2))+demand(destination_index(1),destination_index(2));%当地车增加
                elseif demand(destination_index(1),destination_index(2))>=B(i,j)
                    B(destination_index(1),destination_index(2))=B(destination_index(1),destination_index(2))+B(i,j);
                    B(i,j)=0;
                end
            end
        end
        %车开到乘车地把人带到目的地--------------------------------------------------
        for i=1:need
            index1=need_point(1,i);
            index2=need_point(2,i);
            index3=people_want(1,i);
            index4=people_want(2,i);
            if demand(index1,index2)>B(index1,index2)
                demand(index1,index2)=demand(index1,index2)-B(index1,index2);
                A(index1,index2)=A(index1,index2)-B(index1,index2);
                A(index3,index4)=A(index3,index4)+B(index1,index2);
                B(index3,index4)=B(index3,index4)+B(index1,index2);
                B(index1,index2)=0;
            elseif demand(index1,index2)<=B(index1,index2)
                B(index1,index2)=B(index1,index2)-demand(index1,index2);
                A(index1,index2)=A(index1,index2)-demand(index1,index2);
                A(index3,index4)=A(index3,index4)+demand(index1,index2);
                B(index3,index4)=B(index3,index4)+demand(index1,index2);
                demand(index1,index2)=0;
            end
        end
        if sum(sum(B))~=6.9
            the_number=10;
            difang=fix(rand(2,the_number)*10);
            [a,b,~]=find(difang==0);
            long=length(a);
            for i=1:long
                difang(a(i),b(i))=1;
            end
            for  i=1:the_number
                B(difang(1,i),difang(2,i))=B(difang(1,i),difang(2,i))+(6.9-sum(sum(B)))/the_number;
            end
        end
        %存数据，进行下一次迭代-----------------------------------------------------
        result{o}.people=A;
        result{o}.demand=demand;
        result{o}.car=B;
        result{o}.cha=result{o}.car-result{o}.demand;
    end
    ee=reshape(result{24}.cha,1,100);
    pp=mean(ee);
    cha=var(ee);
    fangcha(goji)=cha;
    average(goji)=pp;
    disp(100-goji)
end
save fangcha fangcha
save average average






