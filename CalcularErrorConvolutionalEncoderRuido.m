function BER = CalcularErrorConvolutionalEncoderRuido(signal, Nf, NFFT, M ,Nofdm, tx_bits, enrejado, ruido, canal)
    for i=1:length(ruido)
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
        % Efecto del canal:        
        y = reshape(y,[NFFT+48, Nofdm]);
        % Eliminar prefijo cíclico
        y = y(49:end,:);
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
        % Deshacer el entrelazado
        rx_bits_aleatorios = DeEntrelazado(rx_bits_aleatorios(:), M, Nofdm, Nf);
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
        % Decodificador
        rx_bits = vitdec(rx_bits,enrejado,5*7,'trunc','hard');
        errores = sum(bitxor(tx_bits(:), rx_bits'));
        BER(i) = errores / (Nf*Nofdm*log2(M));
    end
end