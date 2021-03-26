close all
%carico i dati delle forze
load_forces_script

%grafici della forza 1
figure
subplot(2,3,1)
plot(table2array(F11(:,3)))
grid on
title('F11')
subplot(2,3,2)
plot(table2array(F12(:,3)))
grid on
title('F12')
subplot(2,3,3)
plot(table2array(F13(:,3)))
grid on
title('F13')
subplot(2,3,4)
plot(table2array(F14(:,3)))
grid on
title('F14')
subplot(2,3,5)
plot(table2array(F15(:,3)))
grid on
title('F15')

%grafici della forza 2
figure
subplot(2,3,1)
plot(table2array(F21(:,3)))
grid on
title('F21')
subplot(2,3,2)
plot(table2array(F22(:,3)))
grid on
title('F22')
subplot(2,3,3)
plot(table2array(F23(:,3)))
grid on
title('F23')
subplot(2,3,4)
plot(table2array(F24(:,3)))
grid on
title('F24')
subplot(2,3,5)
plot(table2array(F25(:,3)))
grid on
title('F25')

%grafici della forza 3
figure
subplot(2,3,1)
plot(table2array(F31(:,3)))
grid on
title('F31')
subplot(2,3,2)
plot(table2array(F32(:,3)))
grid on
title('F32')
subplot(2,3,3)
plot(table2array(F33(:,3)))
grid on
title('F33')
subplot(2,3,4)
plot(table2array(F34(:,3)))
grid on
title('F34')
subplot(2,3,5)
plot(table2array(F35(:,3)))
grid on
title('F35')

%grafici della forza 4
figure
subplot(2,3,1)
plot(table2array(F41(:,3)))
grid on
title('F41')
subplot(2,3,2)
plot(table2array(F42(:,3)))
grid on
title('F42')
subplot(2,3,3)
plot(table2array(F43(:,3)))
grid on
title('F43')
subplot(2,3,4)
plot(table2array(F44(:,3)))
grid on
title('F44')
subplot(2,3,5)
plot(table2array(F45(:,3)))
grid on
title('F45')

%grafici della forza 5
figure
subplot(2,3,1)
plot(table2array(F51(:,3)))
grid on
title('F51')
subplot(2,3,2)
plot(table2array(F52(:,3)))
grid on
title('F52')
subplot(2,3,3)
plot(table2array(F53(:,3)))
grid on
title('F53')
subplot(2,3,4)
plot(table2array(F54(:,3)))
grid on
title('F54')
subplot(2,3,5)
plot(table2array(F55(:,3)))
grid on
title('F55')


