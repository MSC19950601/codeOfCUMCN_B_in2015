%%
%����24Сʱ��ʱ�䱱���еĹ���ƥ��̶�
%%
ccc=struct('matrix','num');
ttt=1:24;
c_value=zeros(1,24);
for i=1:24
%a1-hoe�����׳̶�
a1=B_hoe(i).matrix;
%a2-time��ʱ��
a2=B_time(i).matrix;
%a3-car��������
a3=B_car(i).matrix;
%a4-need��������
a4=B_need(i).matrix;
%a5-price���򳵼۸�
a5=B_price(i).matrix;

%��һ������----------------------------------------------------------------

%�������׶�
a1=a1./sum(sum(a1.^2));
%����ʱ��Ϊ0�ĵ���������ʱ��Ϊ1000��Ȼ��ʱ��ԽСԽ�ã��������һ
a2(find(a2==0))=1000;
a2=1./a2;
a2=a2./sum(sum(a2.^2));
%����������ֵ����Դ������ʵ��ı�ָ����Ȼ�����һ
a6=a3-a4;
a6(find(a6>0))=a6(find(a6>0)).^1;
a6(find(a6<0))=a6(find(a6<0)).^2;
a6(find(a6==0))=50;
a6=1./a6;
a6=a6./sum(sum(a6.^2));
%�۸�Ϊ0�ĵط���Ϊ1000�������һ
a5(find(a5==0))=1000;
a5=1./a5;
a5=a5./sum(sum(a5.^2));

%�����ָ��������Сֵ---------------------------------------------------
a1max=max(max(a1));
a2max=max(max(a2));
a6max=max(max(a6));
a5max=max(max(a5));

a1min=min(min(a1));
a2min=min(min(a2));
a5min=min(min(a5));
a6min=min(min(a6));

%�������š����Ӿ���--------------------------------------------------------
dzz=sqrt((a1-a1max).^2+(a2-a2max).^2+(a5-a5max).^2+(a6-a6max).^2);
dff=sqrt((a1-a1min).^2+(a2-a2min).^2+(a5-a5min).^2+(a6-a6min).^2);
%�����ŷ����Ľӽ��̶�------------------------------------------------------
ccc(i).matrix=dff./(dzz+dff);
c_value(i)=sum(sum(ccc(i).matrix));
end
plot(ttt,c_value,'b-')
xlabel('ʱ�䣨Сʱ��');
ylabel('����ƥ��̶�');

