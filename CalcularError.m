function BER = CalcularError(signal, Nf, NFFT, M ,Nofdm, tx_bits)
    [Y,pilotos_angulos] = OFDM_Demodulador(signal,NFFT,Nofdm);
    rx_bits = DMPSK_Demod(Y, M, pilotos_angulos);
    errores = sum(bitxor(tx_bits(:), rx_bits(:)));
    BER = errores / (Nf*Nofdm*log2(M)); 
end

