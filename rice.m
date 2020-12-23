function [rf]=rice(x, prop)
% Oblicza czestotliwosc Rice dla sygnalu probkowanego ze stala 
% czestotliwoscia probkowania
% x - sygnal
% 1/Fs - odstep probkowania
% ds - pochdna z sygnalu

[dx]=differentiate_function(x, 1/prop.Fs);

% Wyliczenie czestotliwosci Rice'a
rf = ( std(dx) / std(x) ) / ( 2 * pi );

end

function[v]=differentiate_function(y,dt)
%
ddt=12.*dt;
%
n=length(y);
%
v(1)=( -y(3)+4.*y(2)-3.*y(1) )/(2.*dt);
v(2)=( -y(4)+4.*y(3)-3.*y(2) )/(2.*dt);
v(3:(n-2))=(-y(5:n)+8*y(4:(n-1))-8*y(2:(n-3))+y(1:(n-4)))/ddt;
v(n-1)=( +y(n-1)-y(n-3) )/(2.*dt);
v(n)  =( +y(n-1)-y(n-2) )/dt;

end