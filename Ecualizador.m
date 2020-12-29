function [piloto_fase , Y] = Ecualizador(y, NFFT, Nofdm, freq)
% Función: Función que se utiliza para ecualizar, se divide el vector que
% se recibe con el que debería ser para saber cuál es la respuesta del
% canal y poder contrarrestarla después.
% Input: y= Señal sin prefijo cíclico para ecualizarla .NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también. freq= Piloto que se usará para el ecualizador Zero-Forcing.
% Output: Y= Señal demodulada en OFDM sin los pilotos y ecualizada. piloto_fase= Pilotos
% que se introdujeron en el modulador y que se devuelven para la
% demodulacion DMPSK.
     Y = fft(y,NFFT);
     pref = [0 0 0 0 1 1 1 0 1 1 1 1 0 0 1 0 1 1, ...
        0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0, ...
        1 1 0 0 0 1 0 1 1 1 0 1 0 1 1 0 1 1 0, ...
        0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 1 1, ...
        0 0 1 1 1 1 0 1 1 0 1 0 0 0 0 1 0 1 0, ...
        1 0 1 1 1 1 1 0 1 0 0 1 0 1 0 0 0 1 1, ...
        0 1 1 1 0 0 0 1 1 1 1 1 1 1];
    Respuesta_canal = Y(:,1)./freq;

    for i=1:Nofdm
        Y_ecualizada(:,i) = Y(:,i)./Respuesta_canal;
    end
    piloto_fase = angle(Y_ecualizada(87,:));
    Y = Y_ecualizada(88:183,:);    
end

