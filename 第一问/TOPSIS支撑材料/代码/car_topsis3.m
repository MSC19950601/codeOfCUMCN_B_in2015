%%
%计算24小时各时间北京市的供求匹配程度
%%
ccc=struct('matrix','num');
ttt=1:24;
c_value=zeros(1,24);
for i=1:24
%a1-hoe，难易程度
a1=B_hoe(i).matrix;
%a2-time，时间
a2=B_time(i).matrix;
%a3-car，车数量
a3=B_car(i).matrix;
%a4-need，需求量
a4=B_need(i).matrix;
%a5-price，打车价格
a5=B_price(i).matrix;

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
ccc(i).matrix=dff./(dzz+dff);
c_value(i)=sum(sum(ccc(i).matrix));
end
plot(ttt,c_value,'b-')
xlabel('时间（小时）');
ylabel('整体匹配程度');

