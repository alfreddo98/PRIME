function [tx_bits, signal] = ModulacionConvolutionalEncoder(M, Nf, NFFT, Nofdm, enrejado)
% Función: Función que crea un vector a transmitir dados una serie de
% parámetros y que devuelve el vector que se va a transmitir y su
% modulación OFDM que finalmente se transmitirá. Se añade además después de
% crear el vector de bits que transmitimos, una parte en la que se
% aleatoriza ese vector, una parte en la que se realiza el entrelazado y un codificador convolucional que además cambiará el número de bits transmitidos.
% Input: M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96, NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% enrejado= resultado de la función polytrellis que funciona como registro
% de desplazamiento.
% Output: tx_bits= Bits que se transmiten, se usarán para posteriormente
% compararlos con los bits recibidos y calcular los errores. Signal= Bits que vamos a transmitir.
% Hay que modicar los bits que se envían a la mitad:
% Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf/2;
    tx_bits = round(rand(tx_bits,1));
    tx_bits(end-8+1:end) = 0;
% Codificación
    tx_bits_codificados = convenc(tx_bits, enrejado);
% Aleatorización del vector de bits a transmitir.
    tx_bits_aleatorios = Scrambler(tx_bits_codificados');
    tx_bits_aleatorios = double(vec2mat(tx_bits_aleatorios', Nf*log2(M)));
    tx_bits_aleatorios = tx_bits_aleatorios';
% Obtenemos los pilotos:
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
% Entrelazado
    tx_bits_aleatorios = Entrelazar(tx_bits_aleatorios, M, Nofdm, Nf);
% Modulación DMPSK:
    mod_DMPSK = DMPSK_Modulador(tx_bits_aleatorios, M, piloto_fase);
% Modulación OFDM:
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
end
