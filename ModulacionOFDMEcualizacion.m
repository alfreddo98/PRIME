function [tx_bits, signal, piloto_ecualizador] = ModulacionOFDMEcualizacion(M, Nf, NFFT, Nofdm)
% Funci�n: Funci�n que crea un vector a transmitir dados una serie de
% par�metros y que devuelve el vector que se va a transmitir y su
% modulaci�n OFDM que finalmente se transmitir�. Se a�ade adem�s despu�s de
% crear el vector de bits que transmitimos, una parte en la que se
% aleatoriza ese vector. Se le a�adir� una parte en la que se a�ade el
% prefijo c�clico y adem�s se devuelve la se�al que se usar� a la hora de
% comparar para ecualizar.
% Input: M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96, NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
% Output: tx_bits= Bits que se transmiten, se usar�n para posteriormente
% compararlos con los bits recibidos y calcular los errores. Signal=
% La se�al modulada que se enviar� al receptor. piloto_ecualizador= Piloto
% que se usar� para el ecualizador Zero-Forcing.
% Bits que vamos a transmitir:
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
% Aleatorizaci�n del vector de bits a transmitir.
    tx_bits_aleatorios = Scrambler(tx_bits');
    tx_bits_aleatorios = double(vec2mat(tx_bits_aleatorios', Nf*log2(M)));
    tx_bits_aleatorios = tx_bits_aleatorios';
% Obtenemos los pilotos:
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
% Modulaci�n DMPSK:
    mod_DMPSK = DMPSK_Modulador(tx_bits_aleatorios, M, piloto_fase);
% Modulaci�n OFDM:
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
    piloto_ecualizador = signal(:,1);
% Se a�ade el prefijo c�clico y se devuelve como un vector.
    signal = addPrefijoCiclico(signal);
end

