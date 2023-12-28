clc
clear
%%%%%%%划分下落回弹
test_l=14;
pathname='F:\ZLH\Basilisk\share\vertical\cell2\14bounce\';
mydata=load('F:\ZLH\Basilisk\share\vertical\cell2\14bounce\level-turn.dat');
data_para=zeros(5,1);%impact-end(length(impact)),bounce-start,bounce-peak,length(impact),length(bounce)
bounce_start1=1524;%%%%%%%%%%%%%
bounce_start2=3513;%%%%%%%%%%%%%
data_para(1,1)=bounce_start1-1;
data_para(2,1)=bounce_start1;
data_para(4,1)=data_para(1,1);
for i=bounce_start1:bounce_start2-1
    if(mydata(i,8)<0.&&mydata(i-1,8)>0.)
        data_para(3,1)=i-1;
    end
end
data_para(5,1)=data_para(3,1)-data_para(2,1)+1;
impact=zeros(data_para(4,1),length(mydata(1,:)));
bounce1=zeros(data_para(5,1),length(mydata(1,:)));
%%%%%%%数据填充
for j=1:length(mydata(1,:))
    for i=1:length(impact(:,1))
        impact(i,j)=mydata(i,j);
    end
    for i=1:length(bounce1(:,1))
        bounce1(i,j)=mydata(data_para(1,1)+i,j);
    end
end
%%%%%%%
pathname='F:\ZLH\Basilisk\share\vertical\cell2\14bounce\';
mydata=load('F:\ZLH\Basilisk\share\vertical\cell2\14bounce\level-turn.dat');
d=0.003;
impact_start=0;
impact_end=data_para(1,1);
bounce1_start=0;
bounce1_end=0;
parameter=zeros(6,1);
%根据加速度正负交替选取润滑力作用范围
%impact加速度选取
for i=2:length(impact(:,1))%润滑力不会从一开始主导
    if(impact(i,11)>0.&&impact(i,8)<0.)
        impact_end=i;
        if(i>impact_end)
            impact_end=i;
        end
    end
    if(impact(i,11)>0.&&impact(i-1,11)<0.&&impact(i,8)<0.)
        impact_start=i;
    end
    impact_length=impact_end-impact_start+1;
end
%回弹-根据球回弹到最高点选取数据
inf=2.*impact(length(impact(:,11)),11);
gra=-8.63406;
bounce1_start=1;
bounce1_end=length(bounce1(:,1));
for i=2:length(bounce1(:,1))-1
    if(abs(bounce1(i,11))>inf)
        if(bounce1_start<i)
            bounce1_start=i+1;
        end
    end
%     if((bounce1(i,11)<10*gra)&&(bounce1(i+1,11)>10*gra))
%         bounce1_end=i;
%     end
    
end
bounce1_start=bounce1_start+1;;
bounce1_length=bounce1_end-bounce1_start+1;


parameter(1,1)=impact_start;
parameter(2,1)=impact_end;
parameter(3,1)=impact_length;
parameter(4,1)=bounce1_start;
parameter(5,1)=bounce1_end;
parameter(6,1)=bounce1_length;
impact_data=zeros(impact_length,7);
bounce1_data=zeros(bounce1_length,7);
%%%%%%%%%%%%
%下落-加速度正负交替选取
for i=1:length(impact_data(:,1))
    impact_data(i,1)=impact(i+impact_start-1,2);%t(s)
    impact_data(i,2)=impact(i+impact_start-1,8);%v(m/s)
    impact_data(i,3)=impact(i+impact_start-1,5)-d/2.;%h(m)
    impact_data(i,4)=impact(i+impact_start-1,11);%a(m/s^2)
    impact_data(i,5)=impact(i+impact_start-1,5);%y(m)
    impact_data(i,6)=impact(i+impact_start-1,1);%i
    impact_data(i,7)=impact(i+impact_start-1,16);%maxlevel
end
%回弹-距离壁面一个直径选取
for i=1:length(bounce1_data(:,1))
    bounce1_data(i,1)=bounce1(i+bounce1_start-1,2);%t(s)
    bounce1_data(i,2)=bounce1(i+bounce1_start-1,8);%v(m/s)
    bounce1_data(i,3)=bounce1(i+bounce1_start-1,5)-d/2.;%h(m)
    bounce1_data(i,4)=bounce1(i+bounce1_start-1,11);%a(m/s^2)
    bounce1_data(i,5)=bounce1(i+bounce1_start-1,5);%y(m)
    bounce1_data(i,6)=bounce1(i+bounce1_start-1,1);%i
    bounce1_data(i,7)=bounce1(i+bounce1_start-1,16);%maxlevel
end
save ([pathname,'data.mat'],'impact_data','bounce1_data')
result_a=load([pathname,'data.mat']);
figure;
plot(result_a.impact_data(:, 1), result_a.impact_data(:, 4),'r*')
xlabel('时间(s)','FontSize',15,'FontName','Times New Rome');
ylabel('加速度(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('加速度正负交替时截取数据','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);

%%%%%%%%%%下落进行拟合、外推、采样
%maxlevel,test-start,test-end
test_para=zeros(3,1);

for i=2:length(impact_data(:,1))-1
    if(impact_data(i-1,7)==test_l-1&&impact_data(i,7)==test_l)
        test_para(1,1)=impact_data(i,7);
        test_para(2,1)=impact_data(i,6);
        test_para(3,1)=impact_data(length(impact_data(:,1)),6);
    end
end

test=zeros((test_para(3,1)-test_para(2,1)+1),7);
train=zeros((length(impact_data(:,1))-length(test(:,1))),7);
for j=1:7
    for i=1:length(test(:,1))
        test(i,j)=impact_data(i+length(train(:,1)),j);
    end
end
train=zeros((length(impact_data(:,1))-length(test(:,1))),7);
for j=1:7
    for i=1:length(train(:,1))
        train(i,j)=impact_data(i,j);%t(s) v(m/s) h(m) a(m/s^2) y(m) i maxlevel
    end
end

h_sample=2;%%%%%%%%%
samplingpoint=zeros(int32(length(train(:, 1))/h_sample),7);
for i=1:7
    for j=1:length(samplingpoint(:,1))
        samplingpoint(j,i)=train(1+(j-1)*h_sample, i);
    end
end
save ([pathname,'divide_impact.mat'],'test','train','samplingpoint');
divide=load([pathname,'divide_impact.mat']);
figure;
plot(divide.train(:, 1), log(divide.train(:, 4)),'k+',divide.test(:, 1), log(divide.test(:, 4)),'b+',divide.samplingpoint(:, 1), log(divide.samplingpoint(:, 4)),'rs')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('ln(a)(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('fit','extend','sample','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);

%%%%%%%%%%回弹进行拟合、外推、采样
%maxlevel,test-start,test-end
bounce1_test_para=zeros(3,1);
bounce1_test_para(2,1)=bounce1_data(1,6);
bounce1_test_para(3,1)=bounce1_data(1,6);
for i=2:length(bounce1_data(:,1))-1
    if(bounce1_data(i,7)==test_l)
        if(bounce1_test_para(3,1)<bounce1_data(i,6))
            bounce1_test_para(1,1)=bounce1_data(i,7);
            bounce1_test_para(3,1)=bounce1_data(i,6);
        end
    end
end
test=zeros((bounce1_test_para(3,1)-bounce1_test_para(2,1)+1),7);
train=zeros((length(bounce1_data(:,1))-length(test(:,1))),7);
for j=1:7
    for i=1:length(test(:,1))
        test(i,j)=bounce1_data(i,j);
    end
end
train=zeros((length(bounce1_data(:,1))-length(test(:,1))),7);
for j=1:7
    for i=1:length(train(:,1))
        train(i,j)=bounce1_data(i+length(test(:,1)),j);%t(s) v(m/s) h(m) a(m/s^2) y(m) i maxlevel
    end
end

h_sample=10;%%%%%%%%%
samplingpoint=zeros(int32(length(train(:, 1))/h_sample),7);
for i=1:7
    for j=1:length(samplingpoint(:,1))
        samplingpoint(j,i)=train(1+(j-1)*h_sample, i);
    end
end
save ([pathname,'divide_bounce1.mat'],'test','train','samplingpoint');
divide=load([pathname,'divide_bounce1.mat']);
figure;
plot(divide.train(:, 1), log(divide.train(:, 4)),'k+',divide.test(:, 1), log(divide.test(:, 4)),'b+',divide.samplingpoint(:, 1), log(divide.samplingpoint(:, 4)),'rs')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('ln(a)(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('fit','extend','sample','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);
figure;
plot(divide.train(:, 1), divide.train(:, 4),'k+',divide.test(:, 1), divide.test(:, 4),'b+',divide.samplingpoint(:, 1), divide.samplingpoint(:, 4),'rs')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('a(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('fit','extend','sample','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);
figure;
plot(divide.train(:, 1), log(abs(divide.train(:, 4))),'k+',divide.test(:, 1), log(abs(divide.test(:, 4))),'b+',divide.samplingpoint(:, 1), log(abs(divide.samplingpoint(:, 4))),'rs')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('ln(|a|)(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('fit','extend','sample','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);


 
