%% Aby obejrzeć wynik należy załadować dwuklikiem plik mat z katalogu 'out'
%  a następnie uruchomić w konsoli 'c(Y)'

function c(Y)
    stackedplot(Y, {Y.Properties.VariableNames{3:end}}, 'XVariable', 't')
    
end