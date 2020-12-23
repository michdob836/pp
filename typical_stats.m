load('./out/brak_k_01_4.mat')

typ = struct();

np = length(Y.Properties.VariableNames);

for i = 3:np
        typ.mean.(Y.Properties.VariableNames{i}) ...
            = mean( Y.(Y.Properties.VariableNames{i}) );
        typ.std.(Y.Properties.VariableNames{i}) ...
            = std( Y.(Y.Properties.VariableNames{i}) );
        typ.median.(Y.Properties.VariableNames{i}) ...
            = median( Y.(Y.Properties.VariableNames{i}) );
end 

save('./typical_stats.mat', 'typ');