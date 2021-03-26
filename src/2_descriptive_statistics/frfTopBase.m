function [] = frfTopBase(vars,titles, ...
                         selection,accs,fs,filtFlag,plotsPath)

    figure('Name',selection,'NumberTitle','off','Visible','off')
    set(gcf, 'DefaultAxesFontSize', 16)
    t = tiledlayout(5,2);
            
    if strcmp(filtFlag,'filt')
        title(t,strcat("FRF top-base: ",selection," [filtered]"), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'unfilt')
        title(t,strcat("FRF top-base: ",selection," [unfiltered]"), ...
              'interpreter','none','FontSize',20)
    elseif strcmp(filtFlag,'downsmpl')
        title(t,strcat("FRF top-base: ",selection," [downsampled]"), ...
              'interpreter','none','FontSize',20)
    end
    
    for i = 1:size(titles,2)
        nexttile
        for j = 1:(size(vars{i},2)-1)/2
            window = hann(floor(length(vars{i}.(accs{j}))/5));
            noverlap = floor(length(window)/2);
            [frf,f] = modalfrf(vars{i}.(accs{j}),vars{i}.(accs{j+3}),fs,window,noverlap);
            idx = f<55;
            f_sel = f(idx);
            plot(f_sel,db(abs(frf(idx))))
            hold on
        end
        hold off
        grid on
        legend('x-axis','y-axis','z-axis','Location','eastoutside')
        title([titles{i},"FRF"]);
        xlim([0 ceil(f_sel(end))])
        xlabel('frequency [Hz]')
        ylabel('magnitude [dB]')
        
        nexttile
        for j = 1:(size(vars{i},2)-1)/2
            window = hann(floor(length(vars{i}.(accs{j}))/10));
            noverlap = floor(length(window)/5);
            [~,f,coh] = modalfrf(vars{i}.(accs{j}),vars{i}.(accs{j+3}),fs,window,noverlap);
            idx = f<55;
            f_sel = f(idx);
            plot(f_sel,coh(idx))
            hold on
        end
        hold off
        grid on
        legend('x-axis','y-axis','z-axis','Location','eastoutside')
        title([titles{i},"Coherence"]);
        xlim([0 ceil(f_sel(end))])
        xlabel('frequency [Hz]')
        ylabel('')
    end
    
    set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
    savefig(strcat(plotsPath,'\',selection,"_[",filtFlag,']_frfTopBase.fig'))
    close
        
end