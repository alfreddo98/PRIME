function [piloto_fase , Y] = Ecualizador(y, NFFT, Nofdm, freq)
% Funci�n: Funci�n que se utiliza para ecualizar, se divide el vector que
% se recibe con el que deber�a ser para saber cu�l es la respuesta del
% canal y poder contrarrestarla despu�s.
% Input: y= Se�al sin prefijo c�clico para ecualizarla .NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n. freq= Piloto que se usar� para el ecualizador Zero-Forcing.
% Output: Y= Se�al demodulada en OFDM sin los pilotos y ecualizada. piloto_fase= Pilotos
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

