function y = signal_entropy(x, prop)
    y = pentropy(x, prop.Fs, "Instantaneous", false);
%     y = approximateEntropy(x, "Radius", xres);
end
