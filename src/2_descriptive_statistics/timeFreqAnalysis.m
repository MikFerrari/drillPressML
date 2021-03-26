function [] = timeFreqAnalysis(vars,colors,titles, ...
                               selection,acc,fs,filtFlag,loadFlag,plotsPath)

    % Plot Force
    if isempty(acc)
        figure('Name',selection,'NumberTitle','off','Visible','off')
        set(gcf, 'DefaultAxesFontSize', 16)
        t = tiledlayout(5,1);

        if strcmp(filtFlag,'filt')
            title(t,strcat("Spectrogram: ",selection," [filtered]"), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'unfilt')
            title(t,strcat("Spectrogram: ",selection," [unfiltered]"), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'downsmpl')
            title(t,strcat("Spectrogram: ",selection," [downsampled]"), ...
                  'interpreter','none','FontSize',20)
        end

        % Spectrogram parameters
        f_min = 0;
        f_max = 55;
        frequencyLimits = [f_min f_max];   % Hz
        leakage = 0.3;
        timeResolution = 1.5;
        overlapPercent = 50;
        
        for i = 1:size(titles,2)

            nexttile
            signal = vars{i}.force;            
            pspectrum(signal,fs, ...
                                   'spectrogram', ...
                                   'FrequencyLimits',frequencyLimits, ...
                                   'Leakage',leakage, ...
                                   'TimeResolution',timeResolution, ...
                                   'OverlapPercent',overlapPercent);
            ax = get(gcf,'CurrentAxes');
            ax.ColorScale = 'log';
            title(titles{i});
            yticks(linspace(f_min,f_max,6));
            xlabel('time [s]')
            ylabel('frequency [Hz]')

        end
        
        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        savefig(strcat(plotsPath,'\',selection,"_[",filtFlag,']_spectrogram.fig'))
        close
    
    % Plot Accelerations
    else
        figure('Name',selection,'NumberTitle','off','Visible','off')
        set(gcf, 'DefaultAxesFontSize', 16)
        t = tiledlayout(5,1);

        if strcmp(filtFlag,'filt')
            title(t,strcat("Spectrogram: ",selection," [",acc,', filtered]'), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'unfilt')
            title(t,strcat("Spectrogram: ",selection," [",acc,', unfiltered]'), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'downsmpl')
            title(t,strcat("Spectrogram: ",selection," [",acc,', downsampled]'), ...
                  'interpreter','none','FontSize',20)
        end
        
        % Spectrogram parameters
        f_min = 0;
        f_max = 55;
        frequencyLimits = [f_min f_max];   % Hz
        leakage = 0.5;
        if strcmp(loadFlag,'load')
            timeResolution = 1.5;             
        elseif strcmp(loadFlag,'noload')
            timeResolution = 3;               
        end
        overlapPercent = 50;

        for i = 1:size(titles,2)

            nexttile
            signal = vars{i}.(acc);            
            pspectrum(signal, fs, ...
                                   'spectrogram', ...
                                   'FrequencyLimits',frequencyLimits, ...
                                   'Leakage',leakage, ...
                                   'TimeResolution',timeResolution, ...
                                   'OverlapPercent',overlapPercent);
            ax = get(gcf,'CurrentAxes');
            ax.ColorScale = 'log';
            title(titles{i});
            yticks(linspace(f_min,f_max,6));
            xlabel('time [s]')
            ylabel('frequency [Hz]')

        end
            
        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_spectrogram.fig'))
        close
        
    end
    
end

