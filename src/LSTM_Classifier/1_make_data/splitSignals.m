%Funzione che si occupa di dividere i segnali in report della medesima
%lunghezza (targetLength). Da notare che i segnali non vengono
%semplicemente troncati a tale lunghezza, bensì da ciascun segnale vengono
%estrapolati quanti più record possibili di lunghezza targeLength e la
%rimanenza viene eliminata. 
%Ad esempio: se alla funzione viene passata un
%segnale con 6500 righe e si imposta un targetLength di 2000, verranno 
%creati tre segnali di 2000 righe ciascuno e le restanti 500 righe verranno
%eliminate. 

%Questa funzione è quindi utile per avere report tutti della stessa
%lunghezza e permette di non considerare eventuali segnali che vengono
%passati di lunghezza inferiore a targetLength.

%Il processo seguito da questa funzione è piuttosto articolato, per la
%comprensione può essere utile utilizzare lo schema presentato nel file
%"splitSignals_details.pdf". 

function [Xout,Yout]=splitSignals(Xin,Yin,fs)
targetLength = fs;
Xout={};
Yout={};
M=[];
MM=[];
  

for idx=1:numel(Xin)
    XX=Xin{idx};
    YY=Yin(idx);
    
    %Calcolo il numero di report che si possono estrarre
    numSigs = floor(length(XX(:,1))/targetLength); 
    
    %Se il numero di report è 0 (cioè se targetLength > della lunghezza del
    %segnale passato) il segnale viene ignorato. 
    if numSigs == 0
         continue;
    end
    
    % Elimino le righe in eccesso, mantenendo ancora i report uniti
    XX = XX(1:numSigs*targetLength,:);
    
    %Procedo con la suddivisione dei report (per tutti gli assi) che
    %verranno salvati in celle successive di un cell array    
    
    % N.B. La funzione reshape prende un vettore colonna e lo suddivide in
    % numSigs parti di lunghezza targetLength che vengono affiancate in
    % colonne.
    for i=1:size(XX,2) %per ciascun asse
        x=XX(:,i); %prendo l'accelerazione della singola asse
        M = [M reshape(x,targetLength,numSigs)];
    end
    
    %Ottengo quindi la matrice M che presenta numSigs*numAssi colonne.
    %Ad esempio: usando tre assi e con numSigs=2, le colonne di M saranno
    %in un ordine del tipo: ax1,ax2,ay1,ay2,az1,az2.
    
    %Dalla matrice M devo estrarre ad esempio ax1,ay1,az1, che verranno
    %salvati temporaneamente nella matrice MM, il cui contenuto sarà
    %salvato iterativamente all'interno delle celle di Xout.
    for i=1:numSigs
        for j=i:numSigs:(numSigs*size(XX,2))
            MM=[MM M(:,j)];
        end
        Xout=[Xout; {MM}];
        MM=[];
    end
    M=[];
    
    % Avendo elaborato in questo modo le matrici X devo replicare le
    % etichette per ogni report realizzato, per questo devo utilzizare la
    % funzione repmat.
    YY = repmat(YY,[numSigs,1]); 
    Yout = [Yout; cellstr(YY)];   
end

%Rendo il vettore delle etichette categorical. 
Yout=categorical(Yout);
end