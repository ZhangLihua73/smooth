
clc
clear

pathname='C:\Users\Administrator\Desktop\ZLH\batch\data\';
%初始量：流体密度，流体动力粘度, 小球密度，小球直径，起始高度（y-d/2），角度，角速度, 域
load([pathname,'original.mat']);
% %特征量：流体密度(ML^-3)，小球直径(L)，重力加速度(LT^-2)
% M_c=%density of fluid(ML^-3)
% L_c=0.003;%diameter of sphere(L)
% T_c=9.81;%acceleration of gravity(LT^-2)
%无量纲化后：流体动力粘度（雷诺数）, 小球密度，起始高度（y-d/2），角度，角速度, 域， 最大时间步
a=1.;
b=9.06;
%初始量：流体密度，流体动力粘度, 小球密度，小球直径，起始高度（y-d/2），角度，角速度, 域
%无量纲化后：流体动力粘度（雷诺数）, 小球密度，起始高度（y-d/2），最大时间步, Re, St
parameter=zeros(length(original(:,1))*length(original(:,1))*length(original(:,1)),6);
miu=zeros(length(parameter(:,1)),1);%无量纲化粘度
rho=zeros(length(parameter(:,1)),1);%无量纲化密度
DT=zeros(length(parameter(:,1)),1);%最大时间步控制
h=zeros(length(parameter(:,1)),1);%起始高度
% 使用三重循环将数组组合成125组数据
index = 1;
for i = 1:length(original(:,2))
    for j = 1:length(original(:,3))
        for k = 1:length(original(:,5))
            miu(index,:)=[original(i,2)];%无量纲化动力粘度
            rho(index, :)=[original(j,3)];%无量纲化密度
            h(index, :)=[original(k,5)];%起始高度
            index = index + 1;
        end
    end
end
%无量纲化后：流体动力粘度（雷诺数）, 小球密度，起始高度（y-d/2），最大时间步, Re, St
for i = 1:length(parameter(:,1))
    parameter(i,1)=miu(i,1);
    parameter(i,2)=rho(i,1);
    parameter(i,3)=h(i,1);
end


          
for i=1:length(miu)
    % 定义一元二次方程系数
    D = 1;%input('请输入小球直径：');
    rho_s = parameter(i,2);%input('请输入小球密度：');
    rho_f = 1;%input('请输入流体密度：');
    mu = parameter(i,1);%input('请输入流体动力粘度：');
    c=-sqrt(abs(9.06*9.06*D*D*D*rho_f*rho_f*(rho_s/rho_f-1)*9.81/18/mu/mu));
    % 计算判别式
    delta = b^2 - 4*a*c;
    % 根据判别式的不同情况求解
    if delta > 0
        x1 = (-b + sqrt(delta)) / (2*a);
        x2 = (-b - sqrt(delta)) / (2*a);
        %fprintf('方程有两个实数根：x1 = %f，x2 = %f\n', x1, x2);
        Re = x1*x1;
        if Re > 5000
            Re=sqrt(4*D*D*D*rho_f*rho_f*(rho_s/rho_f-1)*9.81/mu/mu/3./0.44);
        end
        %fprintf('参考雷诺数为：Re = %f\n',Re );
        St = x1*x1*mu*D*rho_s/D/rho_f/9/mu;
        %fprintf('Stokes数为：St = %f\n', St);
        Uc = x1*x1*mu/D/rho_f; 
        DT(i,1)=1./Uc;
        %fprintf('球体在无限介质中的沉降速度：Uc = %f\n',Uc);
        nu = D*x1*x1*mu/D/rho_f/x1/x1;
        %fprintf('流体的无量纲化动力粘度：nu = %f\n', nu);
        parameter(i,4)=DT(i,1);
        parameter(i,5)=Re;
        parameter(i,6)=St;
    else
        fprintf('方程无实数根或方程有一个实数根\n');
    end
end
save ([pathname,'parameter_all.mat'],'parameter')


% for i = 1:2
%     for j=1:length(Abraham(:,1))
%         parameter(j,i)=Abraham(j,i);
%     end
% end
% 
% 
% for i=1:length(Abraham(:,1))
%     % 定义一元二次方程系数
%     D = 1;%input('请输入小球直径：');
%     rho_s = Abraham(i,1);%input('请输入小球密度：');
%     rho_f = 1;%input('请输入流体密度：');
%     mu = Abraham(i,2);%input('请输入流体动力粘度：');
%     c=-sqrt(abs(9.06*9.06*D*D*D*rho_f*rho_f*(rho_s/rho_f-1)*9.81/18/mu/mu));
%     % 计算判别式
%     delta = b^2 - 4*a*c;
%     % 根据判别式的不同情况求解
%     if delta > 0
%         x1 = (-b + sqrt(delta)) / (2*a);
%         x2 = (-b - sqrt(delta)) / (2*a);
%         %fprintf('方程有两个实数根：x1 = %f，x2 = %f\n', x1, x2);
%         Re = x1*x1;
%         if Re > 5000
%             Re=sqrt(4*D*D*D*rho_f*rho_f*(rho_s/rho_f-1)*9.81/mu/mu/3./0.44);
%         end
%         %fprintf('参考雷诺数为：Re = %f\n',Re );
%         St = x1*x1*mu*D*rho_s/D/rho_f/9/mu;
%         %fprintf('Stokes数为：St = %f\n', St);
%         Uc = x1*x1*mu/D/rho_f; 
%         DT(i,1)=1./Uc;
%         %fprintf('球体在无限介质中的沉降速度：Uc = %f\n',Uc);
%         nu = D*x1*x1*mu/D/rho_f/x1/x1;
%         %fprintf('流体的无量纲化动力粘度：nu = %f\n', nu);
%         parameter(i,4)=DT(i,1);
%         parameter(i,5)=Re;
%         parameter(i,6)=St;
%     else
%         fprintf('方程无实数根或方程有一个实数根\n');
%     end
% end
