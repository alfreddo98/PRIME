function BER = CalcularErrorRuidoCanalEcualizado(signal, Nf, NFFT, M ,Nofdm, tx_bits, ruido, canal, piloto)
    freq = fft(piloto, NFFT);
    for i=1:length(ruido)
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
        % Efecto del canal:
        y_conv = conv(y, canal);
        y = y_conv(1:length(y));
        y = reshape(y,[NFFT+48, Nofdm]);
        % Eliminar prefijo cíclico
        y = y(49:end,:);
        % Ecualizamos
        [pilotos_angulos , Y] = Ecualizador(y, NFFT, Nofdm, freq);
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
        errores = sum(bitxor(tx_bits(:), rx_bits(:)));
        BER(i) = errores / (Nf*Nofdm*log2(M));
    end
end
