clear all
close all
M=medie_forze();
v1=560;
v2=780;
v3=1200;
v4=1900;
v5=3000;
F1=M(1);
F2=M(2);
F3=M(3);
F4=M(4);
F5=M(5);
p1=[v1 F1];
p2=[v2 F2];
p3=[v3 F3];
p4=[v4 F4];
p5=[v5 F5];
x=[p1(1) p2(1) p3(1) p4(1) p5(1)];
y=[p1(2) p2(2) p3(2) p4(2) p5(2)];
figure
set(0,'defaultAxesFontSize',12)
plot(x,y,'.','MarkerSize',40)
xlim([560 3000])
ylim([70 110])
pbaspect([2 1 1])
xlabel('Velocità [RPM]')
ylabel('Forza [N]')
hold onva 
grid on
c=polyfit(x,y,3);
z=linspace(0,3100,100);
p=polyval(c,z);
%plot(z,p,'k','LineWidth',2)
%legend('dati','regressione')
p=polyval(c,x);
Rsq1=1 - sum((y - p).^2)/sum((y - mean(y)).^2);
title(['Forza media al variare della velocità'])
exportgraphics(gcf,'forza_media.pdf')
