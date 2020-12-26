function [signal] = addPrefijoCiclico(x)
    prefijo_ciclico = x(end-47:end,:);
    signal = [prefijo_ciclico;x];
    signal = signal(:)';
end

