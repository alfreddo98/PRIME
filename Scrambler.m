function [txbits_aleatorizados] = Scrambler(tx_bits)
% Función: Función que convierte el vector de bits que entra, en un vector
% aleatorizado aplicando un xor entre los bits y un vector estipulado en el
% standard.
% Input: Vector de bits que se desea aleatorizar o dealeatorizar.
% Output: Vector de bits dealeatorizado o aleatorizado, según lo que
% corresponda.

% Vector de aleatorización que vamos a usar que viene especificado en la
% documentación prime.
     pref = [0 0 0 0 1 1 1 0 1 1 1 1 0 0 1 0 1 1, ...
        0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0, ...
        1 1 0 0 0 1 0 1 1 1 0 1 0 1 1 0 1 1 0, ...
        0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 1 1, ...
        0 0 1 1 1 1 0 1 1 0 1 0 0 0 0 1 0 1 0, ...
        1 0 1 1 1 1 1 0 1 0 0 1 0 1 0 0 0 1 1, ...
        0 1 1 1 0 0 0 1 1 1 1 1 1 1];

    cadena=[];
    %%
    % Si los bits que enviamos son menos que los del vector de aleatorización:
    if length(tx_bits) < length(pref)
        cadena = [cadena pref(1:length(tx_bits))];
    else
        %%
        % En el caso de que los bits que transmitimos son mayores que los del
        % vector de aleatorización:
        while length(cadena) < length(tx_bits) - length(pref)
            cadena = [cadena pref];
        end
        cadena = [cadena pref(1:length(tx_bits)-length(cadena))];
    end
    %%
    % Hacemos el xor de los bits que transmitimos con los de la cadena de
    % ayuda en la que está el vector de aleatorizacion.
     txbits_aleatorizados = xor(tx_bits, cadena);
end

