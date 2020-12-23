function a = beta_a(x, prop)
    x = x + abs(prop.xmin);
    x = x / (abs(prop.xmax) + abs(prop.xmin));
    y = betafit(x);
    a = y(1);
end