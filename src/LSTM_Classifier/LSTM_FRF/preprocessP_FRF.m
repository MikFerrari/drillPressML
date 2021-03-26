%Funzione per eliminare la colonna del tempo e le tre accelerazioni
%relative alla base, restituendo una matrice. 
function a=preprocessP_FRF(TT)
T=timetable2table(TT);
T(:,1)=[];

T(16161:end,:)=[];
a=table2array(T);
