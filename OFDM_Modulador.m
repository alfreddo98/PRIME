function x = OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm)
% Funci�n: Funci�n que calcula la modulaci�n OFDM, es decir, coloc� los
% valores modulados en DMPSK en el lugar indicado en el standard y realiza
% la IFFT.
% Input: mod_DMPSK= vector modulado a partir del vector a transmitir.
% piloto_fase= Vector de pilotos que se colocar� ant�s del vector modulado.
% NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
% Output: x= Resultado de la modulaci�n en una matriz de NFFTxNofdm.
    X = zeros(NFFT, Nofdm);

    X(87,:) = exp(1i*piloto_fase); % piloto
    X(88:183,:) = mod_DMPSK;

    X(331,:)=flipud(conj( X(87,:))); % piloto
    X(332:427,:) = flipud(conj(X(88:183,:)));

    x = ifft(X,NFFT,'symmetric')*NFFT;
end

