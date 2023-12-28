%用于计算给定压力数据的平均值，并将数据合并到一个矩阵中

%Narray=[2, 4, 8, 10, 15];

function  [DATAall]=AverageNumber( Narray, time, pressure )
%1、function [DATAall]=AverageNumber(Narray, time, pressure)定义了一个名为AverageNumber的函数。
%该函数接受三个输入参数：分组大小Narray、时间数据time和压力数据pressure。
%函数输出一个名为DATAall的矩阵，该矩阵包含了合并后的所有压力数据以及对应的时间值。
TotalPressure=0;   
PressureAll=[pressure];
%这是初始化变量TotalPressure为0，并将pressure赋值给PressureAll。
for n=1:length(Narray)
 N=Narray(n);
 Pressure=pressure; 
 for i=(1+N):length(pressure)-N
%这里开始循环处理输入参数Narray中每个元素N，将pressure复制一份给Pressure。
%在第二个循环中，从1+N到length(pressure)-N循环，处理除去首尾N个元素的压力数据。
%先进行平均操作
%在第三个循环中，从i-j到i+j取N个数据，将这些压力值求和并赋值给PressureSet。
      for j=1:N
          PressureSet=Pressure (i-j )+Pressure(i+j);%
          TotalPressure=TotalPressure+PressureSet;
      end
%对于每个i，根据PressureSet求平均值，并将平均值赋值给每个i位置上的Pressure。
%将总压力TotalPressure重置为0。
Pressure(i)=1/(2*N)*TotalPressure;
TotalPressure=0;       
 end
%左边界向右取N个做平均，右边界向左取N个做平均
for i1=1:N
    for j1=1:N
        PressureSet=Pressure(i1+j1);
        TotalPressure=TotalPressure+PressureSet;
    end
    Pressure(i1)=1/(N)*TotalPressure;
    TotalPressure=0; 
end
for i2=length(pressure)-N:length(pressure)
    for j2=1:N
        PressureSet=Pressure(i2-j2);
        TotalPressure=TotalPressure+PressureSet;
    end
    Pressure(i2)=1/(N)*TotalPressure;
    TotalPressure=0; 
end
PressureAll=[PressureAll, Pressure];
end
DATAall=[time, PressureAll];
 
 
%  figure(1)
%  c=jet(1.2*length(Narray));
%  
%  for i=2: size(DATAall,2)
%  plot( DATAall(:,1), DATAall(:,i),'color', c(i-1,:),  'linewidth',1)
%  hold on
%  end
%最后的部分是注释掉的MATLAB代码，可以用来在单独的图中绘制压力和时间数据，以便于可视化分析。
end
 
