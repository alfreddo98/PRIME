function [tx_bits, signal] = ModulacionOFDM(M, Nf, NFFT, Nofdm)
% Función: Función que crea un vector a transmitir dados una serie de
% parámetros y que devuelve el vector que se va a transmitir y su
% modulación OFDM que finalmente se transmitirá.
% Input: M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96, NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: tx_bits= Bits que se transmiten, se usarán para posteriormente
% compararlos con los bits recibidos y calcular los errores. Signal=
% La señal modulada que se enviará al receptor.
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
    tx_bits = vec2mat(tx_bits, Nf*log2(M));
    tx_bits = tx_bits';
% Obtenemos los pilotos:
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
% Modulación DMPSK:
    mod_DMPSK = DMPSK_Modulador(tx_bits, M, piloto_fase);
    size(mod_DMPSK)
% Modulación OFDM:
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
% Se devuelve como un vector:
    signal = signal(:)';
end

