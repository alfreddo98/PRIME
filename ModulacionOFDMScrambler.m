function [tx_bits, signal] = ModulacionOFDMScrambler(M, Nf, NFFT, Nofdm)
    % Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
    size(tx_bits')
    tx_bits_aleatorios = Scrambler(tx_bits');
    class(tx_bits_aleatorios)
    tx_bits_aleatorios = double(vec2mat(tx_bits_aleatorios', Nf*log2(M)));
    tx_bits_aleatorios = tx_bits_aleatorios';
    class(tx_bits_aleatorios)
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
    % Modulación:
    mod_DMPSK = DMPSK_Modulador(tx_bits_aleatorios, M, piloto_fase);
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
end