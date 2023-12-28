clc
clear
r=0.021;
% mydata=load('C:\Users\Administrator\Desktop\ZLH\bounce\data\26-2test\bounce.txt');
%数据进行光滑处理
pathname='C:\Users\Administrator\Desktop\ZLH\bounce\data\ardekani\turn\cell2\';
mydata=load('C:\Users\Administrator\Desktop\ZLH\bounce\data\ardekani\turn\cell2\level-turn.dat');
dataAll=AverageNumber(10, mydata(:, 2), mydata(:,11));
%样本选取
% h_max=0.;
% i_max=0;
% for i=1:length(mydata(:,2))
%     if(mydata(i,4)>h_max)
%         h_max=mydata(i,4);
%         i_max=i;
%     end
% end
h_sample=10;
samplingpoint=zeros(int32(length(mydata(:, 2))/h_sample-1),4);
% for i=1:4
%     for j=1:length(samplingpoint(:,1))
%         samplingpoint(j,1)=dataAll(1+(j-1)*h_sample, 1);
%         samplingpoint(j,4)=dataAll(1+(j-1)*h_sample, 3);
%         samplingpoint(j,2)=mydata(1+(j-1)*h_sample, 5);
%         samplingpoint(j,3)=mydata(1+(j-1)*h_sample, 4)-r;
%     end
% end
for i=1:4
    for j=1:length(samplingpoint(:,1))
        samplingpoint(j,1)=dataAll(1+(j-1)*h_sample, 1);
        samplingpoint(j,4)=dataAll(1+(j-1)*h_sample, 3);
        samplingpoint(j,2)=mydata(1+(j-1)*h_sample, 5);
        samplingpoint(j,3)=mydata(1+(j-1)*h_sample, 4)-r;
    end
end
vh=zeros(length(mydata(:,2)),4);
for i=1:length(mydata(:,2))
    vh(:,1)=dataAll(:, 1);
    vh(:,2)=mydata(:, 5);
    vh(:,3)=mydata(:, 4)-r;
    vh(:,4)=dataAll(:, 3);
end
%dataAll:t,a_o,a_smooth;vh:t,v,h,a
save ([pathname,'smooth10.mat'],'dataAll','vh')
save ([pathname,'sampling.mat'],'samplingpoint')
% mydata=load('C:\Users\Administrator\Desktop\ZLH\bounce\data\26-2test\drop.txt');
% dataAll=AverageNumber( 10, mydata(:, 2), mydata(:,6));
figure;
plot(dataAll(:, 1), dataAll(:, 2),'r*',dataAll(:, 1), dataAll(:, 3),'ks')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('a(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('original data','after smoothing','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);
figure;
plot(samplingpoint(:, 1), samplingpoint(:, 4),'rs',dataAll(:, 1), dataAll(:, 3),'k-')
xlabel('t(s)','FontSize',15,'FontName','Times New Rome');
ylabel('a(m/s^2)','FontSize',15,'FontName','Times New Rome');
legend('sampling point','after smoothing','FontSize',15,'FontName','Times New Rome');
set(gca,'FontName','Times New Rome','FontSize',15);
