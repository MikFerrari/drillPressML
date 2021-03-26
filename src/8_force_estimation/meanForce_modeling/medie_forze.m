function M = medie_forze()
%carico i dati delle forze
load_forces_script

F1 = mean([mean(rmmissing(table2array(F11(:,3)))) mean(rmmissing(table2array(F12(:,3)))) mean(rmmissing(table2array(F13(:,3)))) mean(rmmissing(table2array(F14(:,3)))) mean(rmmissing(table2array(F15(:,3))))]);
F2 = mean([mean(rmmissing(table2array(F21(:,3)))) mean(rmmissing(table2array(F22(:,3)))) mean(rmmissing(table2array(F23(:,3)))) mean(rmmissing(table2array(F24(:,3)))) mean(rmmissing(table2array(F25(:,3))))]);
F3 = mean([mean(rmmissing(table2array(F31(:,3)))) mean(rmmissing(table2array(F32(:,3)))) mean(rmmissing(table2array(F33(:,3)))) mean(rmmissing(table2array(F34(:,3)))) mean(rmmissing(table2array(F35(:,3))))]);
F4 = mean([mean(rmmissing(table2array(F41(:,3)))) mean(rmmissing(table2array(F42(:,3)))) mean(rmmissing(table2array(F43(:,3)))) mean(rmmissing(table2array(F44(:,3)))) mean(rmmissing(table2array(F45(:,3))))]);
F5 = mean([mean(rmmissing(table2array(F51(:,3)))) mean(rmmissing(table2array(F52(:,3)))) mean(rmmissing(table2array(F53(:,3)))) mean(rmmissing(table2array(F54(:,3)))) mean(rmmissing(table2array(F55(:,3))))]);
M = [F1 F2 F3 F4 F5];
end


