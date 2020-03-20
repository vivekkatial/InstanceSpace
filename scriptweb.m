function scriptweb(container,rootdir)
% -------------------------------------------------------------------------
% webscript.m
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

disp('=========================================================================');
disp('-> Writing the data for the web interfase.');
% -------------------------------------------------------------------------
writetable(array2table(parula(256), ...
           'VariableNames', {'R','G','B'}), ...
           [rootdir 'color_table.csv']);
writeArray2CSV(colorscale(container.data.Xraw(:,container.featsel.idx)), ...
               container.data.featlabels, ...
               container.data.instlabels, ...
               [rootdir 'feature_raw_color.csv']);
writeArray2CSV(colorscale(container.data.Yraw), ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_raw_single_color.csv']);
writeArray2CSV(colorscale(container.data.X), ...
               container.data.featlabels, ...
               container.data.instlabels, ...
               [rootdir 'feature_process_color.csv']);
writeArray2CSV(colorscale(container.data.Y), ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_process_single_color.csv']);
writeArray2CSV(colorscaleg(container.data.Yraw), ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_raw_color.csv']);
writeArray2CSV(colorscaleg(container.data.Y), ...
               container.data.algolabels, ...
               container.data.instlabels, ...
               [rootdir 'algorithm_process_color.csv']);
writeArray2CSV(colorscaleg(container.data.numGoodAlgos),  ...
               {'NumGoodAlgos'}, ...
               container.data.instlabels, ...
               [rootdir 'good_algos_color.csv']);