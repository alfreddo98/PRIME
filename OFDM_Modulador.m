function x = OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm)
% Función: Función que calcula la modulación OFDM, es decir, colocá los
% valores modulados en DMPSK en el lugar indicado en el standard y realiza
% la IFFT.
% Input: mod_DMPSK= vector modulado a partir del vector a transmitir.
% piloto_fase= Vector de pilotos que se colocará antés del vector modulado.
% NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: x= Resultado de la modulación en una matriz de NFFTxNofdm.
    X = zeros(NFFT, Nofdm);

    X(87,:) = exp(1i*piloto_fase); % piloto
    X(88:183,:) = mod_DMPSK;

    X(331,:)=flipud(conj( X(87,:))); % piloto
    X(332:427,:) = flipud(conj(X(88:183,:)));

    x = ifft(X,NFFT,'symmetric')*NFFT;
end

