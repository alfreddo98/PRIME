function [Y,piloto_fase] = OFDM_Demodulador(signal,NFFT,Nofdm)
% Función: Función que realiza de demodulación OFDM inversa, haciendo la
% FFT en vez de la IFFT.
% Input: signal= La señal modulada que se recibé del receptor. NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: Y= Señal demodulada en OFDM sin los pilotos. piloto_fase= Pilotos
% que se introdujeron en el modulador y que se devuelven para la
% demodulacion DMPSK.
    y = reshape(signal, [NFFT, Nofdm]);
    Y = fft(y,NFFT);
    piloto_fase = angle((Y(87,:)));
    Y = Y(88:183,:);
end

