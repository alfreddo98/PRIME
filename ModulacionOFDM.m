function [tx_bits, signal] = ModulacionOFDM(M, Nf, NFFT, Nofdm)
% Funci�n: Funci�n que crea un vector a transmitir dados una serie de
% par�metros y que devuelve el vector que se va a transmitir y su
% modulaci�n OFDM que finalmente se transmitir�.
% Input: M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96, NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
% Output: tx_bits= Bits que se transmiten, se usar�n para posteriormente
% compararlos con los bits recibidos y calcular los errores. Signal=
% La se�al modulada que se enviar� al receptor.
    tx_bits = Nofdm*log2(M)*Nf;
    tx_bits = round(rand(tx_bits,1));
    tx_bits = vec2mat(tx_bits, Nf*log2(M));
    tx_bits = tx_bits';
% Obtenemos los pilotos:
    [piloto_fase, piloto_mod]=vectorPrefijos(Nofdm);
% Modulaci�n DMPSK:
    mod_DMPSK = DMPSK_Modulador(tx_bits, M, piloto_fase);
    size(mod_DMPSK)
% Modulaci�n OFDM:
    signal=OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm);
% Se devuelve como un vector:
    signal = signal(:)';
end

