%% skrypt zapisuje dane z out do formatu wav

inputdir = "./Acoustic/";
wavdir = "./wav/";
Fs = 25e+3;

files = dir(inputdir + "*.mat")';

for f = files
    
    load(inputdir + f.name) 
    
    audiowrite(wavdir + erase(f.name, ".mat") + ".wav", ts.Data, Fs);
    
end