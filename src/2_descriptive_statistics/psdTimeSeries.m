function [] = psdTimeSeries(vars,colors,titles, ...
                            selection,acc,fs,filtFlag,plotsPath)

    % PSD
    figure('Name',selection,'NumberTitle','off','Visible','off')
    set(gcf, 'DefaultAxesFontSize', 16)
    t = tiledlayout(5,1);
            
    if strcmp(filtFlag,'filt')
        title(t,strcat("PSD: ",selection," [",acc,', filtered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'unfilt')
        title(t,strcat("PSD: ",selection," [",acc,', unfiltered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'downsmpl')
        title(t,strcat("PSD: ",selection," [",acc,', downsampled]'), ...
              'interpreter','none','FontSize',20)
    end
    
    % PSD parameters
    frequencyLimits = [0 55]; % Hz
    frequencyResolution = 0.2;

    psds = [];
    freqs = [];
    for i = 1:size(titles,2)
        
        nexttile
        signal = vars{i}.(acc);
        [p,f] = pspectrum(signal,fs, ...
                          'FrequencyLimits',frequencyLimits, ...
                          'FrequencyResolution',frequencyResolution);
        
%         fmindist = 2;                       % Minimum distance in Hz
%         N = 2*(length(f)-1);                % Number of FFT points
%         minpkdist = floor(fmindist/(fs/N)); % Minimum number of frequency bins
% 
%         [pks,locs] = findpeaks(p,'npeaks',20,'minpeakdistance',minpkdist, ...
%                                'minpeakprominence', 0.00001);
%         fpks = f(locs);
        
        psds = [psds p];
        freqs = [freqs f];

        plot(f,db(p),'Color',colors{i})
        grid on
%         hold on
%         plot(fpks,db(pks),'k*','MarkerSize',5)
%         hold off
        title(titles{i});
        xlim([0 ceil(f(end))])
        ylabel('P/f [dB/Hz]','interpreter','none')
        xlabel('frequency [Hz]')
        
    end
    
    set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
    savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_psd.fig'))
    close
    
    
    % PSD - mean(PSD)
    figure('Name',selection,'NumberTitle','off','Visible','off')
    set(gcf, 'DefaultAxesFontSize', 16)
    t = tiledlayout(5,1);
            
    if strcmp(filtFlag,'filt')
        title(t,strcat("PSD - mean(PSD): ",selection," [",acc,', filtered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'unfilt')
        title(t,strcat("PSD - mean(PSD): ",selection," [",acc,', unfiltered]'), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'downsmpl')
        title(t,strcat("PSD - mean(PSD): ",selection," [",acc,', downsampled]'), ...
              'interpreter','none','FontSize',20)
    end

    mean_psds = mean(psds);
    for i = 1:size(titles,2)
        nexttile
        plot(freqs(:,i),db(psds(:,i)-mean_psds(i)),'Color',colors{i})
        grid on
        title(titles{i});
        xlim([0 ceil(f(end))])
        ylabel('P/f [dB/Hz]','interpreter','none')
        xlabel('frequency [Hz]')   
    end
    
    set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
    savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_psdMinusMean.fig'))
    close
    
end