%Funzione per eliminare la colonna del tempo e le tre accelerazioni
%relative alla base, restituendo una matrice. 
function a=preprocessN_FRF(TT)
T=timetable2table(TT);
T(:,1)=[];

a=table2array(T);
