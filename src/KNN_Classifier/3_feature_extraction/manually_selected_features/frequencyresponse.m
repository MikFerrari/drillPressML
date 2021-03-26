function frf = frequencyresponse(signalTable,fs,fmax,opt)

    signalTable = rmmissing(signalTable);
    w = hamming(fs);
    
    frf_ax = modalfrf(signalTable(:,1),signalTable(:,4),fs,w);
    frf_ay = modalfrf(signalTable(:,2),signalTable(:,5),fs,w);
    frf_az = modalfrf(signalTable(:,3),signalTable(:,6),fs,w);
    
    if strcmp(opt,'abs')
        frf = [abs(frf_ax(1:fmax)),abs(frf_ay(1:fmax)),abs(frf_az(1:fmax))];
    elseif strcmp(opt,'real')
        frf = [real(frf_ax(1:fmax)),real(frf_ay(1:fmax)),real(frf_az(1:fmax))];
    elseif strcmp(opt,'imag')
        frf = [imag(frf_ax(1:fmax)),imag(frf_ay(1:fmax)),imag(frf_az(1:fmax))];
    elseif strcmp(opt,'mediacomplex')
        frf = [meanComplex(frf_ax(1:fmax));meanComplex(frf2(1:fmax));meanComplex(frf3(1:fmax))];
        
    end
    
end
