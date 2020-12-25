function [Y,piloto_fase] = OFDM_Demodulador(signal,NFFT,Nofdm)
    y = reshape(signal, [NFFT, Nofdm]);
    Y = fft(y,NFFT);
    piloto_fase = angle((Y(87,:)));
    Y = Y(88:183,:);
end

