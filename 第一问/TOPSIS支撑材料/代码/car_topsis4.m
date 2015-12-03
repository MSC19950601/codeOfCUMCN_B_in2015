%%
%计算一天北京市的平均供求匹配程度
%%
a1=zeros(10);
a2=zeros(10);
a3=zeros(10);
a4=zeros(10);
a5=zeros(10);
for i=1:24
%a1-hoe，难易程度
a1=B_hoe(i).matrix+a1;
%a2-time，时间
a2=B_time(i).matrix+a2;
%a3-car，车数量
a3=B_car(i).matrix+a3;
%a4-need，需求量
a4=B_need(i).matrix+a4;
%a5-price，打车价格
a5=B_price(i).matrix+a5;
end
a1=1/24*a1;
a2=1/24*a2;
a3=1/24*a3;
a4=1/24*a4;
a5=1/24*a5;

%归一化处理----------------------------------------------------------------

%保留难易度
a1=a1./sum(sum(a1.^2));
%对于时间为0的地区，设置时间为1000，然后时间越小越好，反方向归一
a2(find(a2==0))=1000;
a2=1./a2;
a2=a2./sum(sum(a2.^2));
%对于正负差值区别对待，可适当改变指数，然后反向归一
a6=a3-a4;
a6(find(a6>0))=a6(find(a6>0)).^1;
a6(find(a6<0))=a6(find(a6<0)).^2;
a6(find(a6==0))=50;
a6=1./a6;
a6=a6./sum(sum(a6.^2));
%价格为0的地方改为1000，反向归一
a5(find(a5==0))=1000;
a5=1./a5;
a5=a5./sum(sum(a5.^2));

%计算各指标的最大、最小值---------------------------------------------------
a1max=max(max(a1));
a2max=max(max(a2));
a6max=max(max(a6));
a5max=max(max(a5));

a1min=min(min(a1));
a2min=min(min(a2));
a5min=min(min(a5));
a6min=min(min(a6));

%计算最优、最劣距离--------------------------------------------------------
dzz=sqrt((a1-a1max).^2+(a2-a2max).^2+(a5-a5max).^2+(a6-a6max).^2);
dff=sqrt((a1-a1min).^2+(a2-a2min).^2+(a5-a5min).^2+(a6-a6min).^2);
%与最优方案的接近程度------------------------------------------------------
ccc=dff./(dzz+dff);
    h=bar3(ccc);
    for i = 1:length(h)
        zdata = ones(6*length(h),4);
        k = 1;
        for j = 0:6:(6*length(h)-6)
            zdata(j+1:j+6,:) =ccc(k,i);
            k = k+1;
        end
        set(h(i),'Cdata',zdata)
    end

    axis([1 10 1 10 0 1])
     axis off
    view(240,45);
    colormap cool
    colorbar
    caxis([0 1])




