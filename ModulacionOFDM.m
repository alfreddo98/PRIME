function [tx_bits, signal] = ModulacionOFDM(M, Nf, NFFT, Nofdm)
    % Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
    tx_bits = vec2mat(tx_bits, Nf*log2(M));
    tx_bits = tx_bits';
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
    % Modulación:
    mod_DMPSK = DMPSK_Modulador(tx_bits, M, piloto_fase);
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
end

