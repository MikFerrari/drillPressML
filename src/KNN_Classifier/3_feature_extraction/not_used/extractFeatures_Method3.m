function output = extractFeatures_Method3(records,fs)
       
    % Frequency upper boundary
    freqThres = 60;     % Hz         

    selectedColumns = 4:6;
    
    % PWELCH ( < freqThres )
    [pwel, f_pwel] = cellfun(@(x) pwelch(x(:,selectedColumns).Variables,[],[],[],fs),records,'UniformOutput',false);
    idx = cell2mat(f_pwel(1)) < freqThres;
    mean_pwel = cell2mat(cellfun(@(x) mean(x(idx,:)),pwel,'UniformOutput',false));
    rms_pwel = cell2mat(cellfun(@(x) rms(x(idx,:)),pwel,'UniformOutput',false));
    std_pwel = cell2mat(cellfun(@(x) std(x(idx,:)),pwel,'UniformOutput',false));
    
    % FFT ( < freqThres )
    f_FFT = [];
    FFT = [];
    for i = 1:length(selectedColumns)
        [f_FFT_i, FFT_i] = cellfun(@(x) onesidedFFT(x(:,selectedColumns(i)).Variables,fs),records,'UniformOutput',false);
        f_FFT = [f_FFT f_FFT_i];
        FFT = [FFT FFT_i];
    end
    idx = cell2mat(f_FFT(1,1)) < freqThres;
    mean_FFT = cell2mat(cellfun(@(x) mean(x(idx)),FFT,'UniformOutput',false));
    
    % MAX
%     maxA = cell2mat(cellfun(@(x) max(x(:,selectedColumns).Variables),records,'UniformOutput',false));

    % STD DEV
    std_dev = cell2mat(cellfun(@(x) std(x(:,selectedColumns).Variables),records,'UniformOutput',false));
    
    % FRF ABS (already filtered)
%     frf_abs = cellfun(@(x) frequencyresponse(x(:,1:end-1).Variables,fs,freqThres,'abs'),records,'UniformOutput',false);
%     mean_frf_abs = cell2mat(cellfun(@(x) mean(x),frf_abs,'UniformOutput',false));
%     
%     % FRF REAL (already filtered)
%     frf_real = cellfun(@(x) frequencyresponse(x(:,1:end-1).Variables,fs,freqThres,'real'),records,'UniformOutput',false);
%     mean_frf_real = cell2mat(cellfun(@(x) mean(x),frf_real,'UniformOutput',false));
%     
%     % FRF IMAG (already filtered)
%     frf_imag = cellfun(@(x) frequencyresponse(x(:,1:end-1).Variables,fs,freqThres,'imag'),records,'UniformOutput',false);
%     mean_frf_imag = cell2mat(cellfun(@(x) mean(x),frf_imag,'UniformOutput',false));
    
%     output = [mean_pwel rms_pwel std_pwel mean_FFT maxA std_dev ...
%               mean_frf_abs mean_frf_real mean_frf_imag];
          
    output = [mean_pwel rms_pwel std_pwel mean_FFT std_dev];

    output = array2table(output);
%     output.Properties.VariableNames = {'meanPsd_ax','meanPd_ay','meanPsd_az', ...
%                                        'rmsPsd_ax','rmsPd_ay','rmsPsd_az', ...
%                                        'stdPsd_ax','stdPsd_ay','stdPsd_az', ...
%                                        'meanFft_ax','meanFft_ay','meanFft_az', ...
%                                        'max_ax_top','max_ay_top','max_az_top', ...
%                                        'std_ax_top','std_ay_top','std_az_top' ...
%                                        'meanFrf_ax','meanFrf_ay','meanFrf_az', ...
%                                        'meanFrf_R_ax','meanFrf_R_ay','meanFrf_R_az', ...
%                                        'meanFrf_I_ax','meanFrf_I_ay','meanFrf_I_az', ...
%                                        };
                                   
    output.Properties.VariableNames = {'meanPsd_ax','meanPd_ay','meanPsd_az', ...
                                       'rmsPsd_ax','rmsPd_ay','rmsPsd_az', ...
                                       'stdPsd_ax','stdPsd_ay','stdPsd_az', ...
                                       'meanFft_ax','meanFft_ay','meanFft_az', ...
                                       'std_ax_top','std_ay_top','std_az_top' ...
                                       };
                                   
    % LABEL
    labels = cell2table(cellfun(@(x) x(1,end).Variables,records,'UniformOutput',false));
    labels.Properties.VariableNames = {'velocity'};
    
    % Add labels column
    output = [output labels];
    
end