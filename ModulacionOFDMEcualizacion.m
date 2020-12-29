function [tx_bits, signal, piloto_ecualizador] = ModulacionOFDMEcualizacion(M, Nf, NFFT, Nofdm)
% Función: Función que crea un vector a transmitir dados una serie de
% parámetros y que devuelve el vector que se va a transmitir y su
% modulación OFDM que finalmente se transmitirá. Se añade además después de
% crear el vector de bits que transmitimos, una parte en la que se
% aleatoriza ese vector. Se le añadirá una parte en la que se añade el
% prefijo cíclico y además se devuelve la señal que se usará a la hora de
% comparar para ecualizar.
% Input: M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96, NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: tx_bits= Bits que se transmiten, se usarán para posteriormente
% compararlos con los bits recibidos y calcular los errores. Signal=
% La señal modulada que se enviará al receptor. piloto_ecualizador= Piloto
% que se usará para el ecualizador Zero-Forcing.
% Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
% Aleatorización del vector de bits a transmitir.
    tx_bits_aleatorios = Scrambler(tx_bits');
    tx_bits_aleatorios = double(vec2mat(tx_bits_aleatorios', Nf*log2(M)));
    tx_bits_aleatorios = tx_bits_aleatorios';
% Obtenemos los pilotos:
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
% Modulación DMPSK:
    mod_DMPSK = DMPSK_Modulador(tx_bits_aleatorios, M, piloto_fase);
% Modulación OFDM:
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
    piloto_ecualizador = signal(:,1);
% Se añade el prefijo cíclico y se devuelve como un vector.
    signal = addPrefijoCiclico(signal);
end

