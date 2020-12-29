function [signal] = addPrefijoCiclico(x)
% Funci�n: Funci�n que se utiliza para a�adir el prefijo c�clico al vector
% entrante. Se coje el final del vector (48 �ltimas muestras seg�n indica
% el standard) y se pone al principio de la se�al, finalmente se devuelbe
% la se�al como un vector.
% Input: x= Vector al que se a�adir� el prefijo c�clico.
% Output: signal= Vector con el prefijo c�clico a�adido.
    prefijo_ciclico = x(end-47:end,:);
    signal = [prefijo_ciclico;x];
    signal = signal(:)';
end

