close all;
clear all;
clc
%���ڲ������ȵ������ȷ���----------------------------------------------------
for goji=1:100
    %Ԫ���Զ�����������-----------------------------------------------------
    %��ʼ��--------------------------------------------------------------------
    result=cell(1,24);                              %�洢����Ľṹ��
    A=zeros(10);            %AΪ�˿ڷֲ������˿ڵ�λΪ����
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
    B=zeros(10);            %BΪ���⳵�ֲ����󣬳��⳵��Ŀ��λΪ����
    B(5:6,5:6)=1.725;
    demand=zeros(10);       %�������ľ���
    go=0;                   %������ǰ���ĵط���־
    scale=0.005;             %��������1%���˴򳵣���ʵ�������ȡ����ֵ������
    cc=0.25+goji*0.001;   %������������Ȩֵ
    aa=(1-cc)/2;
    bb=aa;
    for o=1:24
        %��������ж��ٵ����˿��ܴ�------------------------------------------------
        need=fix(rand(1)*100); %need���ж��ٸ��ص����˴�
        if need==0
            need=1;
        end
        
        car=cell(10,10);
        for i=1:10
            for j=1:10
                car{i,j}.distance=zeros(1,need);%������⳵��������ľ���
                car{i,j}.car_want=zeros(2,1);
                car{i,j}.gailv=zeros(1,need);
            end
        end
        bar=zeros(1,need);                     %���̶ļ�����
        %Ѱ��need���ص��λ��-------------------------------------------------------
        need_point=fix(rand(2,need)*10);            %�˳�����
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
        %����ѡȡneed������ȥ�ĵط�-------------------------------------------------
        people_want=fix(rand(2,need)*10);           %Ŀ�ĵأ������������һһ��Ӧ��
        [a,b,~]=find(people_want==0);
        long=length(a);
        for i=1:long
            people_want(a(i),b(i))=1;
        end
        for i=1:need                                 %�����������Ŀ�ĵ���ͬһ�ط�
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
        
        %���������Լ�����λ�����˵ĳ�����ľ������˵ĳ�������Ŀ�ĵصľ����------------
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
        %�������̶ķ�ѡȡ�ص�ӿ�---------------------------------------------------
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
        
        %�����˳���-----------------------------------------------------------------
        for i=1:10
            for j=1:10
                destination_index=car{i,j}.car_want;
                if demand(destination_index(1),destination_index(2))<B(i,j)
                    B(i,j)=B(i,j)-demand(destination_index(1),destination_index(2));
                    B(destination_index(1),destination_index(2))=B(destination_index(1),destination_index(2))+demand(destination_index(1),destination_index(2));%���س�����
                elseif demand(destination_index(1),destination_index(2))>=B(i,j)
                    B(destination_index(1),destination_index(2))=B(destination_index(1),destination_index(2))+B(i,j);
                    B(i,j)=0;
                end
            end
        end
        %�������˳��ذ��˴���Ŀ�ĵ�--------------------------------------------------
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
        %�����ݣ�������һ�ε���-----------------------------------------------------
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






