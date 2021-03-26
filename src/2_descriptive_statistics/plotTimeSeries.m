function [] = plotTimeSeries(vars,colors,titles,selection,acc,filtFlag,plotsPath)
    
    % Plot Force
    if isempty(acc)
        figure('Name',selection,'NumberTitle','off','Visible','off')
        set(gcf, 'DefaultAxesFontSize', 16)
        t = tiledlayout(5,1);
        
        if strcmp(filtFlag,'filt')
            title(t,strcat(selection," [filtered]"), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'unfilt')
            title(t,strcat(selection," [unfiltered]"), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'downsmpl')
            title(t,strcat(selection," [downsampled]"), ...
                  'interpreter','none','FontSize',20)
        end
    
        for i = 1:size(titles,2)
            nexttile
            plot(vars{i}.time,vars{i}.force,'Color',colors{i});
            title(titles{i});
            ylabel('force [kN]')
%             ylim([-5 20])
%             set(gca,'YTick',-5:5:20)
        end

        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        savefig(strcat(plotsPath,'\',selection,"_[",filtFlag,']_plot.fig'))
        close
        
    % Plot Accelerations
    else
        figure('Name',strcat(selection," [",acc,']'), ...
               'NumberTitle','off','Visible','off')
        set(gcf, 'DefaultAxesFontSize', 16)   
        t = tiledlayout(5,1);

        if strcmp(filtFlag,'unfilt')
            title(t,strcat(selection," [",acc,', unfiltered]'), ...
                  'interpreter','none','FontSize',20)
        elseif strcmp(filtFlag,'downsmpl')
            title(t,strcat(selection," [",acc,', downsampled]'), ...
                  'interpreter','none','FontSize',20)
        end
        
        for i = 1:size(titles,2)
            nexttile
            plot(vars{i}.time,vars{i}.(acc),'Color',colors{i});
            title(titles{i});
            ylabel(strcat(acc," ",'[g]'),'interpreter','none')
            ylim([-1 1])
            set(gca,'YTick',-1:0.4:1)
        end
        
        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        savefig(strcat(plotsPath,'\',selection,"_[",acc,'_',filtFlag,']_plot.fig'))
        close

    end

end

