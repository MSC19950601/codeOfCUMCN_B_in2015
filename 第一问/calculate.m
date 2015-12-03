%����������ݶ�̬ͼ
%���ݽӿ�------------------------------------------------------------------
coordinate=A;%��γ���µ�����
%�����ݱ���Ϊ��׼����-------------------------------------------------------
for i=1:24
    lengths(i)=size(A{1,i},2);
end
for i=1:24
    for j=1:lengths(i)
    B(i).coordinate(j,:)=coordinate{1,i}{1,j};
    end
end
%�޳���������--------------------------------------------------------------
for i=1:24
    index1=find(B(i).coordinate(:,1)<116.26|B(i).coordinate(:,1)>116.50);
    B(i).coordinate(index1,:)=[];
    index2=find(B(i).coordinate(:,2)<39.83|B(i).coordinate(:,2)>40);
    B(i).coordinate(index2,:)=[];
end
%��ʾ��Χ------------------------------------------------------------------
xmin=111*116.26.*cos(40*pi/180);
xmax=111*116.50.*cos(39.83*pi/180);
ymin=111*39.83;
ymax=111*40;
step_x=(xmax-xmin)/10;
step_y=(ymax-ymin)/10;
%����任------------------------------------------------------------------
for i=1:24
    B(i).coordinates(:,1)=111*(B(i).coordinate(:,1)).*cos(B(i).coordinate(:,2)*pi/180);%������
    B(i).coordinates(:,2)=111*B(i).coordinate(:,2);   %������
    B(i).coordinates(:,3)=B(i).coordinate(:,3);
    better_value(i)=max(B(i).coordinates(:,3));
    %����Ϊ��γ������ϵ����Ϊŷ���������ϵ
end
max_value=max(better_value);
%������������ԭ��-----------------------------------------------------------
for i=1:24
    B(i).coordinates(:,1)=B(i).coordinates(:,1)-xmin;%������
    B(i).coordinates(:,2)=B(i).coordinates(:,2)-ymin;   %������
end
%��ͼ----------------------------------------------------------------------
% figure(1)
% for i=1:24
%     scatter(B(i).coordinates(:,1),B(i).coordinates(:,2))
%     axis([0 xmax-xmin 0 ymax-ymin]) ;
%     drawnow
%     pause(1);
% end
%�ֻ�����------------------------------------------------------------------
for k=1:24
    for i=1:10
        for j=1:10
            point=find((B(k).coordinates(:,1)>((i-1)*step_x))&(B(k).coordinates(:,1)<=(i*step_x))&(B(k).coordinates(:,2)>((j-1)*step_y))&(B(k).coordinates(:,2)<=(j*step_y)));
            B(k).matrix(i,j)=sum(B(k).coordinates(point,3));
        end
    end
end
q=1:10; p=1:10;
[Q,P]=meshgrid(q,p);
figure(2)
for e=1:24
    h=bar3(B(e).matrix)
    for i = 1:length(h)
        zdata = ones(6*length(h),4);
        k = 1;
        for j = 0:6:(6*length(h)-6)
            zdata(j+1:j+6,:) =B(e).matrix(k,i);
            k = k+1;
        end
        set(h(i),'Cdata',zdata)
    end
    title('����������������24Сʱ�ı仯')
    axis([1 10 1 10 0 max_value])
     axis off
    view(240,45);
    colormap cool
    colorbar
    caxis([0 max_value])
    drawnow
    pause(1)
end
save result B
        


