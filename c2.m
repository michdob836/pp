%% Aby obejrzeć wynik należy załadować dwuklikiem plik mat z katalogu 'out'  a następnie uruchomić w konsoli 'c2(Y)'

function c2(Y)
k = 2; %współczynnik rozszerzenia odchylena standardowego do rysowania granic

load('./typical_stats.mat')
varn = Y.Properties.VariableNames;

np = length(varn) - 2;

fig = figure(1);
fig.Name = Y.Properties.Description;
tl = tiledlayout(np, 1);
tl.TileSpacing = 'compact';
tl.Padding = 'compact';

for i = 3:np+2
    nexttile
    plot(Y.t, Y.(varn{i}));
    ylabel(varn{i});
    rl = refline(0, typ.mean.(varn{i}));
    rl.Color = 'g';
    rl = refline(0, typ.mean.(varn{i}) + k * typ.std.(varn{i}));
    rl.Color = 'r';
    rl = refline(0, typ.mean.(varn{i}) - k * typ.std.(varn{i}));
    rl.Color = 'r';
end

end
