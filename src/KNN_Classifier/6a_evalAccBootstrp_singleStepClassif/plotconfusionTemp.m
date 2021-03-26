function out1 = plotconfusion(varargin)
%PLOTCONFUSION Plot classification confusion matrix.
%
% plotconfusion(targets,outputs) plots a confusion matrix, using target
% (true) and output (predicted) labels. Specify the labels as categorical
% vectors, or in 1-of-N (one-hot) form.
%
% PLOTCONFUSION is not recommended for categorical labels. Use
% CONFUSIONCHART instead.
%                                    
% If the labels are categorical vectors, then each element of the vectors
% corresponds to a single class label. Both vectors must be of length M,
% where M is the number of observations.
%
% If the categorical vectors define underlying classes, then all the
% underlying classes are displayed in the plot, even if there are no
% observations of some of the underlying classes. If the vectors are
% ordinal categorical vectors, then they must both define the same
% underlying categories, in the same order.
%
% If the labels are given in 1-of-N (one-hot) form, then each array must be
% of size N-by-M, where N is the number of classes and M is the number of
% observations. The targets are ground-truth labels: in each column, a
% single element is 1 to indicate the correct class, and all other elements
% are 0. The output labels can either be in 1-of-N form, or may instead be
% probabilities where each column sums to 1.
%
% plotconfusion(targets1,outputs1,'name1',targets2,outputs2,'name2',...)
% plots multiple confusion matrices in one figure, and prefixes the
% character vectors specified by the 'name' arguments to the titles of the
% appropriate plots. All confusion matrices must have the same number of
% classes.
% 
% Example 1:
% Train a convolutional neural network on some synthetic images of
% handwritten digits. Then use the network to predict the class of a set of
% test images, and plot the confusion between the true and predicted
% classes of the test data.
% 
%   [XTrain, YTrain] = digitTrain4DArrayData;
%  
%   layers = [ ...
%             imageInputLayer([28 28 1])
%             convolution2dLayer(5,20)
%             reluLayer()
%             maxPooling2dLayer(2,'Stride',2)
%             fullyConnectedLayer(10)
%             softmaxLayer()
%             classificationLayer()];
%   options = trainingOptions('sgdm');
%   net = trainNetwork(XTrain, YTrain, layers, options);
%  
%   [XTest, YTest] = digitTest4DArrayData;
%  
%   YPred = classify(net, XTest);
% 
%   plotconfusion(YTest, YPred);
%
% Example 2:
% Train a pattern recognition network and plot its accuracy.
%
%   [x,t] = <a href="matlab:doc simpleclass_dataset">simpleclass_dataset</a>;
%   net = <a href="matlab:doc patternnet">patternnet</a>(10);
%   net = <a href="matlab:doc train">train</a>(net,x,t);
%   y = net(x);
%   <a href="matlab:doc plotconfusion">plotconfusion</a>(t,y)
%
% See also confusionchart, confusion, plotroc, ploterrhist,
% plotregression.

% Copyright 2007-2019 The MathWorks, Inc.

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Transfer Functions.

if nargin > 0
    [varargin{:}] = convertStringsToChars(varargin{:});
end

persistent INFO;
if isempty(INFO), INFO = get_info; end
if nargin == 0
    fig = nnplots.find_training_plot(mfilename);
    if nargout > 0
        out1 = fig;
    elseif ~isempty(fig)
        figure(fig);
    end
    return;
end
in1 = varargin{1};
if ischar(in1)
    switch in1
        case 'info',
            out1 = INFO;
        case 'data_suitable'
            data = varargin{2};
            out1 = nnet.train.isNotParallelData(data);
        case 'suitable'
            [args,param] = nnparam.extract_param(varargin,INFO.defaultParam);
            [net,tr,signals] = deal(args{2:end});
            update_args = standard_args(net,tr,signals);
            unsuitable = unsuitable_to_plot(param,update_args{:});
            if nargout > 0
                out1 = unsuitable;
            elseif ~isempty(unsuitable)
                for i=1:length(unsuitable)
                    disp(unsuitable{i});
                end
            end
        case 'training_suitable'
            [net,tr,signals,param] = deal(varargin{2:end});
            update_args = training_args(net,tr,signals,param);
            unsuitable = unsuitable_to_plot(param,update_args{:});
            if nargout > 0
                out1 = unsuitable;
            elseif ~isempty(unsuitable)
                for i=1:length(unsuitable)
                    disp(unsuitable{i});
                end
            end
        case 'training'
            [net,tr,signals,param] = deal(varargin{2:end});
            update_args = training_args(net,tr,signals);
            fig = nnplots.find_training_plot(mfilename);
            if isempty(fig)
                fig = figure('Visible','off','Tag',['TRAINING_' upper(mfilename)]);
                plotData = setup_figure(fig,INFO,true);
            else
                plotData = get(fig,'UserData');
            end
            set_busy(fig);
            unsuitable = unsuitable_to_plot(param,update_args{:});
            if isempty(unsuitable)
                set(0,'CurrentFigure',fig);
                plotData = update_plot(param,fig,plotData,update_args{:});
                update_training_title(fig,INFO,tr)
                nnplots.enable_plot(plotData);
            else
                nnplots.disable_plot(plotData,unsuitable);
            end
            fig = unset_busy(fig,plotData);
            if nargout > 0, out1 = fig; end
        case 'close_request'
            fig = nnplots.find_training_plot(mfilename);
            if ~isempty(fig),close_request(fig); end
        case 'check_param'
            out1 = ''; % TODO
        otherwise,
            try
                out1 = eval(['INFO.' in1]);
            catch me, nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
            end
    end
else
    [args,param] = nnparam.extract_param(varargin,INFO.defaultParam);
    update_args = standard_args(args{:});
    if ischar(update_args)
        nnerr.throw(update_args);
    end
    [plotData,fig] = setup_figure([],INFO,false);
    unsuitable = unsuitable_to_plot(param,update_args{:});
    if isempty(unsuitable)
        plotData = update_plot(param,fig,plotData,update_args{:});
        nnplots.enable_plot(plotData);
    else
        nnplots.disable_plot(plotData,unsuitable);
    end
    set(fig,'Visible','on');
    drawnow;
    if nargout > 0, out1 = fig; end
end
end

function set_busy(fig)
set(fig,'UserData','BUSY');
end

function close_request(fig)
ud = get(fig,'UserData');
if ischar(ud)
    set(fig,'UserData','CLOSE');
else
    delete(fig);
end
drawnow;
end

function fig = unset_busy(fig,plotData)
ud = get(fig,'UserData');
if ischar(ud) && strcmp(ud,'CLOSE')
    delete(fig);
    fig = [];
else
    set(fig,'UserData',plotData);
end
drawnow;
end

function tag = new_tag
tagnum = 1;
while true
    tag = [upper(mfilename) num2str(tagnum)];
    fig = nnplots.find_plot(tag);
    if isempty(fig), return; end
    tagnum = tagnum+1;
end
end

function [plotData,fig] = setup_figure(fig,info,isTraining)
PTFS = nnplots.title_font_size;
if isempty(fig)
    fig = get(0,'CurrentFigure');
    if isempty(fig) || strcmp(get(fig,'NextPlot'),'new')
        if isTraining
            tag = ['TRAINING_' upper(mfilename)];
        else
            tag = new_tag;
        end
        fig = figure('Visible','off','Tag',tag);
        if isTraining
            set(fig,'CloseRequestFcn',[mfilename '(''close_request'')']);
        end
    else
        clf(fig);
        set(fig,'Tag','');
        set(fig,'Tag',new_tag);
    end
end
set(0,'CurrentFigure',fig);
ws = warning('off','MATLAB:Figure:SetPosition');
plotData = setup_plot(fig);
warning(ws);
if isTraining
    set(fig,'NextPlot','new');
    update_training_title(fig,info,[]);
else
    set(fig,'NextPlot','replace');
    set(fig,'Name',[info.name ' (' mfilename ')']);
end
set(fig,'NumberTitle','off','ToolBar','none');
plotData.CONTROL.text = uicontrol('Parent',fig,'Style','text',...
    'Units','normalized','Position',[0 0 1 1],'FontSize',PTFS,...
    'FontWeight','bold','ForegroundColor',[0.7 0 0]);
set(fig,'UserData',plotData);
end

function update_training_title(fig,info,tr)
if isempty(tr)
    epochs = '0';
    stop = '';
else
    epochs = num2str(tr.num_epochs);
    if isempty(tr.stop)
        stop = '';
    else
        stop = [', ' tr.stop];
    end
end
set(fig,'Name',['Neural Network Training ' ...
    info.name ' (' mfilename '), Epoch ' epochs stop]);
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
info = nnfcnPlot(mfilename,'Confusion',7.0,[]);
end

function args = training_args(net,tr,data)
yall  = nncalc.y(net,data.X,data.Xi,data.Ai);
y = {yall};
t = {gmultiply(data.train.mask,data.T)};
names = {'Training'};
if ~isempty(data.val.enabled)
    y = [y {yall}];
    t = [t {gmultiply(data.val.mask,data.T)}];
    names = [names {'Validation'}];
end
if ~isempty(data.test.enabled)
    y = [y {yall}];
    t = [t {gmultiply(data.test.mask,data.T)}];
    names = [names {'Test'}];
end
if length(t) >= 2
    t = [t {data.T}];
    y = [y {yall}];
    names = [names {'All'}];
end
args = {t y names};
end

function args = standard_args(varargin)
if nargin < 2
    args = 'Not enough input arguments.';
elseif (nargin > 2) && (rem(nargin,3) ~= 0)
    args = 'Incorrect number of input arguments.';
elseif nargin == 2
    % (t,y)
    
    % Turn the input arguments into 1-of-N (one-hot) arrays. The inputs
    % might be categoricals, or one-of-N arrays or cell arrays, or some
    % other invalid type, so we do the following:
    % - For categorical, do the conversion ourselves, and throw any errors
    % on bad input.
    % - For anything else, pass the arguments straight back out and let
    % existing error handling deal with them.
    [trueOneOfN, predictedOneofN, classLabels] = iConvertToOneHot(varargin{:});

    % Make sure output arguments are cell arrays, so that handling between
    % the 1-signal and multiple-signal case is consistent.
    t = { nntype.data('format',trueOneOfN) };
    y = { nntype.data('format',predictedOneofN) };
    classLabels = {classLabels};
    names = {''};
    
    args = {t y names classLabels};
else
    % (t1,y1,name1,...)
    count = nargin/3;
    t = cell(1,count);
    y = cell(1,count);
    names = cell(1,count);
    for i=1:count
        % Turn each pair of {trueLabels, predLabels} into 1-hot arrays. As
        % noted above, we only handle conversion and errors for the
        % categorical case - anything else is passed straight back out.
        [trueOneOfN, predictedOneofN, classLabels{i}] = iConvertToOneHot(varargin{i*3-2}, varargin{i*3-1});
        
        t{i} = nntype.data('format',trueOneOfN);
        y{i} = nntype.data('format',predictedOneofN);
        names{i} = varargin{i*3};
    end
    args = {t y names classLabels};
end
end

function plotData = setup_plot(fig)
plotData.numSignals = 0;
end

function fail = unsuitable_to_plot(param,t,y,names,labels)
fail = '';
end

function plotData = update_plot(param,fig,plotData,tt,yy,names,columnLabels)

% Need to guard against the case this was called without the columnLabels
% argument.
ComputeLabels = (nargin == 6);

numSignals = length(names);

t = tt{1}; if iscell(t), t = cell2mat(t); end
[numClassesShown,numSamples] = size(t);
numClassesShown = max(numClassesShown,2);
numColumns = numClassesShown+1;
% Rebuild figure
if (plotData.numSignals ~= numSignals) || (plotData.numClasses ~= numClassesShown)
    plotData.numSignals = numSignals;
    plotData.numClasses = numClassesShown;
    plotData.axes = zeros(1,numSignals);
    titleStyle = {'fontweight','bold','fontsize',nnplots.title_font_size;};
    plotcols = ceil(sqrt(numSignals));
    plotrows = ceil(numSignals/plotcols);
    set(fig,'NextPlot','replace')
    for plotrow=1:plotrows
        for plotcol=1:plotcols
            i = (plotrow-1)*plotcols+plotcol;
            if (i<=numSignals)
                a = subplot(plotrows,plotcols,i);
                set(a,'YDir','reverse','TickLength',[0 0],'Box','on')
                set(a,'DataAspectRatio',[1 1 1])
                hold on
                mn = 0.5;
                mx = numColumns+0.5;
                
                % Get the axes tick labels. If they weren't provided as an
                % argument to update_plot, calculate them here; otherwise,
                % use the right labels for this signal.
                if( ComputeLabels )
                    axesTickLabels = iComputeNumericalClassLabels(t, numClassesShown);
                else
                    % Get the existing labels from the input arguments.
                    axesTickLabels = columnLabels{i};
                end
                
                % Append an extra blank label to the end, for the
                % summary column.
                axesTickLabels = iEnsureLabelsAreCorrectLength(axesTickLabels, numClassesShown);
                axesTickLabels = iAppendLabelForSummary(axesTickLabels);              
                
                set(a,'XLim',[mn mx],'XTick',1:(numColumns+1));
                set(a,'YLim',[mn mx],'YTick',1:(numColumns+1));
                set(a,'XTickLabel',axesTickLabels);
                set(a,'YTickLabel',axesTickLabels);
                       
                xtickangle(45);  
                
                axisdata.number = zeros(numColumns,numColumns);
                axisdata.percent = zeros(numColumns,numColumns);
                for j=1:numColumns
                    for k=1:numColumns
                        if (j==numColumns) && (k==numColumns)
                            % Bottom right summary
                            c = [217 217 217]/255;
                            topcolor = [34 172 60]/255;
                            bottomcolor = [226 61 45]/255;
                            topbold = 'bold';
                            bottombold = 'bold';
                        elseif (j==k)
                            % Diagonal
                            c = [188 230 196]/255;
                            topcolor = [0 0 0];
                            bottomcolor = [0 0 0];
                            topbold = 'bold';
                            bottombold = 'normal';
                        elseif (j<numColumns) && (k<numColumns)
                            % Off-diagonal
                            c = [249 196 192]/255;
                            topcolor = [0 0 0];
                            bottomcolor = [0 0 0];
                            topbold = 'bold';
                            bottombold = 'normal';
                        elseif (j<numColumns)
                            % Column summary (cells at bottom)
                            c = [240 240 240]/255;
                            topcolor = [34 172 60]/255;
                            bottomcolor = [226 61 45]/255;
                            topbold = 'normal';
                            bottombold = 'normal';
                        else
                            % Row summary (cells at right)
                            c = [240 240 240]/255;
                            topcolor = [34 172 60]/255;
                            bottomcolor = [226 61 45]/255;
                            topbold = 'normal';
                            bottombold = 'normal';
                        end
                        fill([0 1 1 0]-0.5+j,[0 0 1 1]-0.5+k,c);
                        axisdata.number(j,k) = text(j,k,'', ...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','bottom',...
                            'FontWeight',topbold,...
                            'Color',topcolor); %,...
                        %'FontSize',8);
                        axisdata.percent(j,k) = text(j,k,'', ...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','top',...
                            'FontWeight',bottombold,...
                            'Color',bottomcolor); %,...
                        %'FontSize',8);
                    end
                end
                plot([0 0]+numColumns-0.5,[mn mx],'LineWidth',2,'Color',[0 0 0]+0.25);
                plot([mn mx],[0 0]+numColumns-0.5,'LineWidth',2,'Color',[0 0 0]+0.25);
                xlabel('Classe effettiva',titleStyle{:});
                ylabel('Classe predetta',titleStyle{:});
                title([names{i} ' Confusion Matrix'],titleStyle{:});
                set(a,'UserData',axisdata);
                plotData.axes(i) = a;
            end
        end
    end
    if(~strcmp(fig.WindowStyle, 'docked'))
        screenSize = get(0,'ScreenSize');
        screenSize = screenSize(3:4);
        if numSignals == 1
            windowSize = [600 600];
        else
            windowSize = 700 * [1 (plotrows/plotcols)];
        end
        pos = [(screenSize-windowSize)/2 windowSize];
        set(fig,'Position',pos);
    end
end

% Fill axes
for i=1:numSignals
    a = plotData.axes(i);
    set(fig,'CurrentAxes',a);
    axisdata = get(a,'UserData');
    y = yy{i}; if iscell(y), y = cell2mat(y); end
    t = tt{i}; if iscell(t), t = cell2mat(t); end
    known = find(~isnan(sum(t,1)));
    y = y(:,known);
    t = t(:,known);
    numSamples = size(t,2);
    [c,cm] = confusion(t,y);
    numClassesInThisSignal = length(cm);
    iValidateNumberOfClassesToPlot(numClassesInThisSignal, numClassesShown, names{i});
    for j=1:numColumns
        for k=1:numColumns
            if (j==numColumns) && (k==numColumns)
                correct = sum(diag(cm));
                perc = correct/numSamples;
                top = percent_string(perc);
                bottom = percent_string(1-perc);
            elseif (j==k)
                num = cm(j,k);
                top = num2str(num);
                perc = num/numSamples;
                bottom = percent_string(perc);
            elseif (j<numColumns) && (k<numColumns)
                num = cm(j,k);
                top = num2str(num);
                perc = num/numSamples;
                bottom = percent_string(perc);
            elseif (j<numColumns)
                correct = cm(j,j);
                total = sum(cm(j,:));
                perc = correct/total;
                top = percent_string(perc);
                bottom = percent_string(1-perc);
            else
                correct = cm(k,k);
                total = sum(cm(:,k));
                perc = correct/total;
                top = percent_string(perc);
                bottom = percent_string(1-perc);
            end
            set(axisdata.number(j,k),'String',top);
            set(axisdata.percent(j,k),'String',bottom);
        end
    end
end
end

function ps = percent_string(p)
if (p==1)
    ps = '100%';
else
    ps = [sprintf('%2.1f',p*100) '%'];
end
end

function iValidateNumberOfClassesToPlot(numClassesInThisSignal, numClassesShown, signalName)
% The axes are drawn with a number of classes set by the number of labels
% in the first signal. There are 2 problems when there's multiple signals being plotted:
% - If there are more classes in the first signal than in this signal, a
% loop over all those classes will cause an index-out-of-range error.
% - If there are fewer classes in the first signal than in this signal,
% then the extra classes in this signal will be ignored, without warning.

if( numClassesShown > numClassesInThisSignal )
   error(message('nnet:confusion:TooFewClasses'));
end

if( numClassesShown < numClassesInThisSignal )
   warning(message('nnet:confusion:TooManyClasses'));
end

end

function [trueArray, predArray, classLabels] = iConvertToOneHot(trueLabels, predLabels)
% This returns a one-hot array, when given an input of a suitable type. To
% ensure we have consistent error handling with the existing code, we take
% the following approach: 
% - Pass anything that isn't a categorical straight
% back out with no validation, and rely on existing error handling. 
% - If it's a categorical, do error checking ourselves.

if( iscategorical(trueLabels) || iscategorical(predLabels) )
    % Convert categoricals to one-hot, and handle any errors.
    
    try
        [trueArray, predArray, classLabels] = iConvertCategoricalInputToOneHot(trueLabels, predLabels);
    catch err
        throwAsCaller(err);
    end
else
    % Pass anything else straight through.
    trueArray = trueLabels;
    predArray = predLabels;
    
    % Return the labels as a cellstr.
    numClasses = size(trueLabels, 1);
    classLabels = iComputeNumericalClassLabels(trueLabels, numClasses);
end

end

function [trueArray, predArray, classLabels] = iConvertCategoricalInputToOneHot(trueLabels, predLabels)
% Given at least one categorical input, validates input then converts to
% one-hot form.

% Throw errors if input is invalid for conversion to one-of-N.
iValidateCategoricalLabels(trueLabels, predLabels);

[trueLabels, predLabels] = iRemoveMissingData(trueLabels(:), predLabels(:));

% We need to know the total number of categories, as there may be some in
% trueLabels not in predLabels and vice versa. We have already validated
% that this concatenation is valid (e.g. the categoricals are not ordinals
% with different underlying categories).
combinedCategorical = [trueLabels(:); predLabels(:)];
classLabels = categories(combinedCategorical);
numTrueLabels = length(trueLabels);

% Convert the combined array to one-of-N.
combinedOneOfN = nnet.internal.data.convertCategoricalToOneOfN(combinedCategorical);

% Now, split the combined one-of-N array back into the 2 separate true and
% predicted arrays.
trueArray = combinedOneOfN(:, 1:numTrueLabels);
predArray = combinedOneOfN(:, numTrueLabels+1:end);

end

function iValidateCategoricalLabels(trueLabels, predLabels)
% Check that the provided categoricals are suitable for conversion to
% one-hot form.

% Check we don't have only one categorical input.
if( ~iscategorical(trueLabels) || ~iscategorical(predLabels) )
    error(message('nnet:confusion:MixingCategoricalInput'));
end

Attributes = {'nonempty', 'vector'};
validateattributes(trueLabels, {'categorical'}, Attributes, 'plotconfusion', 'targets');
validateattributes(predLabels, {'categorical'}, Attributes, 'plotconfusion', 'outputs');

% Make sure trueLabels and predLabels are the same size.
if( any(size(trueLabels) ~= size(predLabels)) )
    error(message('nnet:confusion:MismatchedCategoricalSize',...
        size(trueLabels, 1), size(trueLabels, 2),...
        size(predLabels, 1), size(predLabels, 2)));
end

% Make sure trueLabels and predLabels have the same type of ordinality,
% otherwise attempting to concatenate them will fail.
if( isordinal(trueLabels) ~=  isordinal(predLabels))
    error(message('nnet:confusion:MismatchedCategoricalOrdinality'));
end

% Make sure that, if both labels are ordinal, they have the same ordered
% categories, otherwise attempting to concatenate them will fail.
if( isordinal(trueLabels) && isordinal(predLabels))
    iValidateBothOrdinalCategoricalsHaveSameCategories(trueLabels, predLabels);
end

end

function [trueLabels, predLabels] = iRemoveMissingData(trueLabels, predLabels)
% If either of the categoricals has missing data, strip that observation
% out of both true and predicted labels.

% Find indices of <undefined> data, as a logical array. If the same
% observation is missing in both arrays, make sure that's only logical 1,
% not 2.
isMissingInEitherLabels = min(1, ismissing(trueLabels) + ismissing(predLabels));

trueLabels = trueLabels(~isMissingInEitherLabels);
predLabels = predLabels(~isMissingInEitherLabels);

end

function iValidateBothOrdinalCategoricalsHaveSameCategories(trueLabels, predLabels)
% If both input labels are ordinal categoricals, they have to have the same
% categories (including order). Otherwise, when they're concatenated to
% convert to one-of-N form, an error will be thrown. We instead want to
% throw our own, more helpful error here.

if( ~isequal(categories(trueLabels), categories(predLabels)) )
   error(message('nnet:confusion:OrdinalCategoriesDiffer'));
end

end

function labels = iComputeNumericalClassLabels(t, numClasses)

numClasses = max(numClasses, 2);

labels = cell(1,numClasses);
if size(t,1) == 1
    base = 0;
else
    base = 1;
end

for j=1:numClasses, labels{j} = num2str(base+j-1); end

% Return a row vector, so we're consistent with the shape of the labels for
% categorical arrays.
labels = labels';

end

function axesTickLabels = iEnsureLabelsAreCorrectLength(labels, numClassesToUse)
% There may be more labels than there are classes. This is because, if
% there are multiple plots, they'll all show a number of classes equal to the
% number of classes in the first plot. This may mean the class labels
% have to be truncated; only keep as many class labels as there are classes
% in the first dataset.

numClassesToUse = min(numClassesToUse, length(labels));

axesTickLabels = labels(1:numClassesToUse);

end

function axesTickLabels = iAppendLabelForSummary(labels)
% Append an empty string, used to label the summaries.

axesTickLabels = labels;
axesTickLabels{end+1} = '';

end