function [txbits_aleatorizados] = Scrambler(tx_bits)
%%
% Vector de aleatorizaci�n que vamos a usar que viene especificado en la
% documentaci�n prime.
     pref = [0 0 0 0 1 1 1 0 1 1 1 1 0 0 1 0 1 1, ...
        0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0, ...
        1 1 0 0 0 1 0 1 1 1 0 1 0 1 1 0 1 1 0, ...
        0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 1 1, ...
        0 0 1 1 1 1 0 1 1 0 1 0 0 0 0 1 0 1 0, ...
        1 0 1 1 1 1 1 0 1 0 0 1 0 1 0 0 0 1 1, ...
        0 1 1 1 0 0 0 1 1 1 1 1 1 1];

    cadena=[];
    %%
    % Si los bits que enviamos son menos que los del vector de aleatorizaci�n:
    if length(tx_bits) < length(pref)
        cadena = [cadena pref(1:length(tx_bits))];
    else
        %%
        % En el caso de que los bits que transmitimos son mayores que los del
        % vector de aleatorizaci�n:
        while length(cadena) < length(tx_bits) - length(pref)
            cadena = [cadena pref];
        end
        cadena = [cadena pref(1:length(tx_bits)-length(cadena))];
    end
    %%
    % Hacemos el xor de los bits que transmitimos con los de la cadena de
    % ayuda en la que est� el vector de aleatorizacion.
     txbits_aleatorizados = xor(tx_bits, cadena);
end

