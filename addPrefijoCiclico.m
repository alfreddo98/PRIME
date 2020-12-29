function [signal] = addPrefijoCiclico(x)
% Función: Función que se utiliza para añadir el prefijo cíclico al vector
% entrante. Se coje el final del vector (48 últimas muestras según indica
% el standard) y se pone al principio de la señal, finalmente se devuelbe
% la señal como un vector.
% Input: x= Vector al que se añadirá el prefijo cíclico.
% Output: signal= Vector con el prefijo cíclico añadido.
    prefijo_ciclico = x(end-47:end,:);
    signal = [prefijo_ciclico;x];
    signal = signal(:)';
end

