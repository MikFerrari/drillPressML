function output=preprocess(TT,NP,s)
% s=0 se senza FRF
% s=1 se con FRF

%%{
% fs_filter=60; TT = smoothdata(TT,'movmean',seconds(1/fs_filter));
T=timetable2table(TT);
T(:,1)=[]; %tolgo il tempo
if s==0
    if NP=='N'
        T(:,1:3)=[]; 
    elseif NP=='P'
        T(:,1:3)=[];
    end
elseif s==1
    if NP=='N'
        %
    elseif NP=='P'
        %
    end
end
output=table2array(T);
%}
%%
% fs_filter=60;
% filteredTable = smoothdata(TT,'movmean',seconds(1/fs_filter));
%% con Filtro
%{
if s==0
    opt="onlytop";
    output=filtro(TT,opt);
elseif s==1
    opt="allaxes";
    output=filtro(TT,opt);
end
%}
%%
%{
if s==0
    opt="onlytop";
    output=filtro2(TT,opt);
elseif s==1
    opt="allaxes";
    output=filtro2(TT,opt);
end
%}