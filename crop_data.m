%% Skrypt ułatwiający usuwanie zbędnych danych zarejestrowanych po zakończeniu spawania

clear all;

savedir = "./Raw_P/";
inputdir = "./Raw_P/";
filtered_suffix = "_filtered";

files = dir(inputdir  + "*" + filtered_suffix + ".mat");

for f = files'
    
    load(inputdir + f.name);
    figure(1);
    stackedplot(x);
    title("\verbatim{" + f.name + "}");
    
    ind = input("podaj pierwszą złą próbkę lub 0 aby kontynuować: ");
    
    if ind
        x = x(1:ind);
        save(inputdir + f.name, 'x')
    end
    
end