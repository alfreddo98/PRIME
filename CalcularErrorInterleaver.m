function BER = CalcularErrorInterleaver(signal, Nf, NFFT, M ,Nofdm, tx_bits, canal)
        % Efecto del canal:
        y_conv = conv(signal, canal);
        y = y_conv(1:length(signal));
        y = reshape(y,[NFFT+48, Nofdm]);
        % Eliminar prefijo cíclico
        y = y(49:end,:);
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
        % Deshacer el entrelazado
        rx_bits_aleatorios = DeEntrelazado(rx_bits_aleatorios(:), M, Nofdm, Nf);
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
        errores = sum(bitxor(tx_bits(:), rx_bits'));
        BER = errores / (Nf*Nofdm*log2(M));    
end