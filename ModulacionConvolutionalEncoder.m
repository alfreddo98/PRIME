function [tx_bits, signal, piloto_ecualizador] = ModulacionConvolutionalEncoder(M, Nf, NFFT, Nofdm, enrejado)
    % Hay que modicar los bits que se envían a la mitad:
    % Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf/2;
    tx_bits = round(rand(tx_bits,1));
    tx_bits(end-8+1:end) = 0;
    % Codificamos
    tx_bits_codificados = convenc(tx_bits, enrejado);
    % Scrambler
    tx_bits_aleatorios = Scrambler(tx_bits_codificados');
    tx_bits_aleatorios = double(vec2mat(tx_bits_aleatorios', Nf*log2(M)));
    tx_bits_aleatorios = tx_bits_aleatorios';
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
    % Entrelazado
    tx_bits_aleatorios = Entrelazar(tx_bits_aleatorios, M, Nofdm, Nf);
    % Modulación:
    mod_DMPSK = DMPSK_Modulador(tx_bits_aleatorios, M, piloto_fase);
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
    piloto_ecualizador = signal(:,1);
    signal = addPrefijoCiclico(signal);
    size(signal)

end
