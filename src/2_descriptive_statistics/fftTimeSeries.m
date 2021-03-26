function [] = fftTimeSeries(vars,colors,titles, ...
                            selection,acc,fs,filtFlag,plotsPath)

    % FFT
    figure('Name',selection,'NumberTitle','off','Visible','off')
    set(gcf, 'DefaultAxesFontSize', 16)
    t = tiledlayout(5,1);
            
    if strcmp(filtFlag,'filt')
        title(t,strcat("FFT: ",selection," [",acc,', filtered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'unfilt')
        title(t,strcat("FFT: ",selection," [",acc,', unfiltered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'downsmpl')
        title(t,strcat("FFT: ",selection," [",acc,', downsampled]'), ...
              'interpreter','none','FontSize',20)
    end
    
    ffts = [];
    freqs = [];
    for i = 1:size(titles,2)
        
        nexttile
        % Signal windowing with Hanning window to reduce leakage
        signal = vars{i}.(acc).*hann(length(vars{i}.(acc)));
        [f,p] = onesidedFFT(signal,fs);
        idx = f<55;
        
%         fmindist = 2;                       % Minimum distance in Hz
%         N = 2*(length(f)-1);                % Number of FFT points
%         minpkdist = floor(fmindist/(fs/N)); % Minimum number of frequency bins
% 
%         [pks,locs] = findpeaks(p,'npeaks',20,'minpeakdistance',minpkdist, ...
%                                'minpeakprominence', 0.0001);
        f_sel = f(idx);
%         fpks_sel = f(locs);
        
        ffts = [ffts p(idx)'];
        freqs = [freqs f_sel];
        
        plot(f_sel,p(idx),'Color',colors{i})
        grid on
%         hold on
%         plot(fpks_sel,pks,'k*','MarkerSize',5)
%         hold off
        title(titles{i});
        xlim([0 ceil(f_sel(end))])
        ylabel('amplitude [g]')
        xlabel('frequency [Hz]')
        
    end
    
    set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
    savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_fft.fig'))
    close
    
    
    % FFT - mean(FFT)
    figure('Name',selection,'NumberTitle','off','Visible','off')
    set(gcf, 'DefaultAxesFontSize', 16)
    t = tiledlayout(5,1);
            
    if strcmp(filtFlag,'filt')
        title(t,strcat("FFT - mean(FFT): ",selection," [",acc,', filtered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'unfilt')
        title(t,strcat("FFT - mean(FFT): ",selection," [",acc,', unfiltered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'downsmpl')
        title(t,strcat("FFT - mean(FFT): ",selection," [",acc,', downsampled]'), ...
              'interpreter','none','FontSize',20)
    end
    
    mean_ffts = mean(ffts);
    for i = 1:size(titles,2)
        nexttile
        plot(freqs(:,i),ffts(:,i)-mean_ffts(i),'Color',colors{i})
        grid on
        title(titles{i});
        xlim([0 ceil(f_sel(end))])
        ylabel('amplitude [g]')
        xlabel('frequency [Hz]')     
    end
    
    set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
    savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_fftMinusMean.fig'))
    close
    
end