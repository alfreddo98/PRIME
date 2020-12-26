function BER = CalcularErrorRuidoCanal(signal, Nf, NFFT, M ,Nofdm, tx_bits, ruido, canal)
    for i=1:length(ruido)
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
        % Efecto del canal:
        y_conv = conv(y, canal);
        y = y_conv(1:length(y));
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
        errores = sum(bitxor(tx_bits(:), rx_bits(:)));
        BER(i) = errores / (Nf*Nofdm*log2(M));
    end
end