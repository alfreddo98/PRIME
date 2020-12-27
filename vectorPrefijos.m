function [pref_fase, pref] = vectorPrefijos(Nsimbolos)
% Funci�n: Funci�n que dado el n�mero de s�mbolos que se enviar�n,
% devolver� el vector que se usar� de pilotos, ya dividido en fase y
% m�dulo.
% Input: Nsimbolos= N�mero de s�mbolos que se usar�n, siempre ser� Nofdm.
% Output: pref_fase= Los pilotos ya en fase (�ngulos). pref= Los pilotos en
% m�dulo.
pref = [0 0 0 0 1 1 1 0 1 1 1 1 0 0 1 0 1 1, ...
        0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0, ...
        1 1 0 0 0 1 0 1 1 1 0 1 0 1 1 0 1 1 0, ...
        0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 1 1, ...
        0 0 1 1 1 1 0 1 1 0 1 0 0 0 0 1 0 1 0, ...
        1 0 1 1 1 1 1 0 1 0 0 1 0 1 0 0 0 1 1, ...
        0 1 1 1 0 0 0 1 1 1 1 1 1 1];
pref = pref(1:Nsimbolos);
pref_fase = pref*pi;

end

