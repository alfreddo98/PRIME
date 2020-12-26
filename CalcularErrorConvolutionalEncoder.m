function BER = CalcularErrorConvolutionalEncoder(signal, Nf, NFFT, M ,Nofdm, tx_bits, canal, enrejado)
        % Efecto del canal:
%        y_conv = conv(signal, canal);
%        y = y_conv(1:length(signal));
        y = reshape(signal,[NFFT+48, Nofdm]);
        % Eliminar prefijo cíclico
        y = y(49:end,:);
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
        % Deshacer el entrelazado
        rx_bits_aleatorios = DeEntrelazado(rx_bits_aleatorios(:), M, Nofdm, Nf);
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
        size(rx_bits)
        % Decodificador
        rx_bits = vitdec(rx_bits,enrejado,5*7,'trunc','hard');
        size(rx_bits')
        size(tx_bits)
        errores = sum(bitxor(tx_bits(:), rx_bits'));
        BER = errores / (Nf*Nofdm*log2(M));    
end