function [Y,piloto_fase] = OFDM_Demodulador(signal,NFFT,Nofdm)
% Funci�n: Funci�n que realiza de demodulaci�n OFDM inversa, haciendo la
% FFT en vez de la IFFT.
% Input: signal= La se�al modulada que se recib� del receptor. NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
% Output: Y= Se�al demodulada en OFDM sin los pilotos. piloto_fase= Pilotos
% que se introdujeron en el modulador y que se devuelven para la
% demodulacion DMPSK.
    y = reshape(signal, [NFFT, Nofdm]);
    Y = fft(y,NFFT);
    piloto_fase = angle((Y(87,:)));
    Y = Y(88:183,:);
end

