function b = beta_b(x, prop)
    x = x + abs(prop.xmin);
    x = x / (abs(prop.xmax) + abs(prop.xmin));
    y = betafit(x);
    b = y(2);
end