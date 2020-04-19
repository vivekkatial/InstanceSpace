function scriptcsv(container,rootdir)
% -------------------------------------------------------------------------
% csvscript.m
% -------------------------------------------------------------------------
%
% By: Mario Andres Munoz Acosta
%     School of Mathematics and Statistics
%     The University of Melbourne
%     Australia
%     2020
%
% -------------------------------------------------------------------------

scriptfcn;

nalgos = size(container.data.Y,2);
disp('=========================================================================');
disp('-> Writing the data on CSV files for posterior analysis.');
% -------------------------------------------------------------------------
for i=1:nalgos
    if isfield(container.trace.best{i},'polygon') && ~isempty(container.trace.best{i}.polygon)
        writeArray2CSV(container.trace.best{i}.polygon.Vertices, ...
                       {'z_1','z_2'},...
                       makeBndLabels(container.trace.best{i}.polygon.Vertices),...
                       [rootdir 'footprint_' container.data.algolabels{i} '_best.csv']);
    end
    if isfield(container.trace.good{i},'polygon') && ~isempty(container.trace.good{i}.polygon)
        writeArray2CSV(container.trace.good{i}.polygon.Vertices, ...
                       {'z_1','z_2'},...
                       makeBndLabels(container.trace.good{i}.polygon.Vertices),...
                       [rootdir 'footprint_' container.data.algolabels{i} '_good.csv']);
    end
    if isfield(container.trace.bad{i},'polygon') && ~isempty(container.trace.bad{i}.polygon)
        writeArray2CSV(container.trace.bad{i}.polygon.Vertices, ...
                       {'z_1','z_2'},...
                       makeBndLabels(container.trace.bad{i}.polygon.Vertices),...
                       [rootdir 'footprint_' container.data.algolabels{i} '_bad.csv']);
    end
end

writeArray2CSV(container.pilot.Z, {'z_1','z_2'}, ...
               container.data.instlabels, ...
               [rootdir 'coordinates.csv']);
if isfield(container,'cloist')
    writeArray2CSV(container.cloist.Zedge, {'z_1','z_2'}, ...
                   makeBndLabels(container.cloist.Zedge), ...
                   [rootdir 'bounds.csv']);
    writeArray2CSV(container.cloist.Zecorr, {'z_1','z_2'}, ...
                   makeBndLabels(container.cloist.Zecorr), ...
                   [rootdir 'bounds_prunned.csv']);
end
writeArray2CSV(container.data.Xraw(:, container.featsel.idx), ...
               container.data.featlabels, ...
               container.data.instlabels, ...
               [rootdir 'feature_raw.csv']);
writeArray2CSV(container.data.X, ...
               container.data.featlabels, ...
               container.data.instlabels, ...
               [rootdir 'feature_process.csv']);
writeArray2CSV(container.data.Yraw, ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_raw.csv']);
writeArray2CSV(container.data.Y, ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_process.csv']);
writeArray2CSV(container.data.Ybin, ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_bin.csv']);
writeArray2CSV(container.data.numGoodAlgos, {'NumGoodAlgos'}, ...
               container.data.instlabels, ...
               [rootdir 'good_algos.csv']);
writeArray2CSV(container.data.beta, {'IsBetaEasy'}, ...
               container.data.instlabels, ...
               [rootdir 'beta_easy.csv']);
writeArray2CSV(container.data.P, {'Best_Algorithm'}, ...
               container.data.instlabels, ...
               [rootdir 'portfolio.csv']);
writeArray2CSV(container.pythia.Yhat, ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_svm.csv']);
writeArray2CSV(container.pythia.selection0, ...
               {'Best_Algorithm'}, ...
               container.data.instlabels, ...
               [rootdir 'portfolio_svm.csv']);
writeCell2CSV(container.trace.summary(2:end,[3 5 6 8 10 11]), ...
              container.trace.summary(1,[3 5 6 8 10 11]),...
              container.trace.summary(2:end,1),...
              [rootdir 'footprint_performance.csv']);
if isfield(container.pilot,'summary')
    writeCell2CSV(container.pilot.summary(2:end,2:end), ...
                  container.pilot.summary(1,2:end),...
                  container.pilot.summary(2:end,1), ...
                  [rootdir 'projection_matrix.csv']);
end
writeCell2CSV(container.pythia.summary(2:end,2:end), ...
              container.pythia.summary(1,2:end), ...
              container.pythia.summary(2:end,1), ...
              [rootdir 'svm_table.csv']);