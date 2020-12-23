%% Opis
%  Ten skrypt kolejno ładuje pliki z nagraniami z podanego folderu, tworzy
%  dla nich zmienną table przechowującą wyliczone parametry (zależne
%  i niezależne od czasu), filtruje i wstępnie przetwarza dane, wylicza
%  wartości wskaźników i zapisuje je w strukturze a następnie, zapisuje
%  strukturę w formacie mat.

% dane są przechowywane w tablicy 'Y'
% clear all

%% Konfiguracja

verbose = true; % obszerne informacje
regen_intermediate = false; % wygeneruj pliki pośrednie

inputdir = "./Raw_P/";
savedir = "./out/";

filtered_suffix = "_filtered";

% Stałe
acousticRange = [20 20e+3]; % Hz
Fs_rec = 250e+3; % Hz, częstotliwość próbkowania nagrania
Fs = 25e+3; % Hz, docelowa częstotliwość próbkowania do obliczeń

% Parametry okna
winsize = 2048;
overlap = 0.5;

% Obliczane parametry
stats = {
    % {@uchwyt funkcji, nazwa kolumny tablicy, nazwa opisowa na wykres}
    {@signal_entropy, 'ent',      'entropia sygnału' };          ...
    {@beta_a,         'beta_a',   'parametr a rozkładu beta' };  ...
    {@beta_b,         'beta_b',   'parametr b rozkładu beta' };  ...
    {@kurt,           'kurt',     'kurtoza' };                   ...
    {@rice,           'rice',     'częstotliwość charakterystyczna Ricea'} ....
    };

%% Do dzieła
if verbose
    fprintf("Szerokość okna: %d ms.\n", round(winsize/Fs*1000));
end
    
files = dir(inputdir + "*.txt");
for f = files'
    % preprocessing
    if ~isfile(inputdir + f.name + filtered_suffix + ".mat") ...
            || regen_intermediate
        
        x_raw = load(inputdir + f.name);
        if verbose
            fprintf("Załadowano plik %s \n", inputdir + f.name);
        end
        
        % filtrowanie
        if verbose
            fprintf("Filtrowanie idealne pasmo %d-%d Hz + decymacja" + ...
                "n=%d...", acousticRange(1), acousticRange(2), Fs_rec/Fs);
        end
        x_raw_t = 0 : 1/Fs_rec : (length(x_raw)-1)/Fs_rec;
        x_raw_ts = timeseries(x_raw, x_raw_t);
        x_raw_ts = x_raw_ts.idealfilter(acousticRange, 'pass');
        x = downsample(x_raw_ts.Data, Fs_rec/Fs);
        if verbose
            fprintf(" ok.\n");
        end
        
        save(inputdir + f.name + filtered_suffix + ".mat", 'x')
        if verbose
            fprintf("Zapisano plik pośredni.\n");
        end
    else
        load(inputdir + f.name + filtered_suffix + ".mat");
        if verbose
            fprintf("Załadowano plik pośredni.\n");
        end
    end
    
    % obl. wskaźników
    Y = table();
    Y.Properties.UserData = struct( ...
        'Fs',   Fs, ...
        'winsize', winsize, ...
        'overlap', overlap, ...
        'restlen', NaN, ...
        'xmin', min(x), ...
        'xmax', max(x), ...
        'xlen', length(x) ...
        );
    
    [Xw, rest] = buffer(x, winsize, winsize*overlap);
    [~, nwin] = size(Xw);
    Y.Properties.UserData.restlen = length(rest); % TODO: sure needed?
    prop = Y.Properties.UserData;
    Y.n = round(linspace((0.5-overlap)*winsize, ...
               ((nwin-1)*(1-overlap)+0.5-overlap)*winsize, nwin))';
    Y.t = Y.n / Fs;
    tic
    for i = 1:length(stats)
        Y.(stats{i}{2}) = zeros(nwin, 1);
        for j = 1:nwin
            Y.(stats{i}{2})(j) = stats{i}{1}(Xw(:, j), prop);
        end
    end
    toc
    desc = {'numer próbki', 'czas'};
    for s = 1:length(stats)
        desc{end+1} = stats{s}{3};
    end
    Y.Properties.VariableDescriptions = desc;
    
    % zapis
    savepath = savedir + erase(f.name, ".txt");
    save(savepath, 'Y');
    if verbose
        fprintf("Zapisano plik wyjściowy jako %s\n", savepath);
    end
end