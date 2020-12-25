function BER = CalcularErrorScrambler(signal, Nf, NFFT, M ,Nofdm, tx_bits)
    [Y,pilotos_angulos] = OFDM_Demodulador(signal,NFFT,Nofdm);
    rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
    rx_bits = Scrambler(rx_bits_aleatorios(:)');
    errores = sum(bitxor(tx_bits(:), rx_bits(:)));
    BER = errores / (Nf*Nofdm*log2(M)); 
end
