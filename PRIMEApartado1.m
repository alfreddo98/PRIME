%% Pr�ctica PRIME
% Autores: Alfredo S�nchez S�nchez y Manuel Mora de amarillas.
%%
%*BOLD TEXT* El proyecto consiste en realizar un modelado de la simulaci�n de la transmisi�n de tramas de Carga (Payload) seg�n el est�ndar de PRIME,  ITU-T G.9904. No se tendr� en cuenta la parte de la trama destinada a la transmisi�n del pre�mbulo (Preamble), Encabezado (Header) ni del CRC. 
%% Apartado 1: Implementaci�n de todos los modos de comunicaci�n de PRIME en el caso de canal sin distorsi�n y sin FEC 
%% Apartado 1.1: Elecci�n de par�metros de simulaci�n
% Los bits a transmitir, deben ser superiores a 10^4 o 10000 pues queremos
% una simulaci�n fiable de BER de 10^-4. En nuestro caso, hemos
% seleccionado como l�mite 20000, que es un valor fiable para todos los
% tipos de modulaci�n, especialmente paa la modulaci�n de 2, que es la que
% enviar�a un menor n�mero de bits. El n�mero de tramas que enviaremos ser�
% 4, sabiendo que con DBPSK el n�mero de s�mbolos a transmitir es el doble
% que en DQPSK y este es el doble que con D8PSK.
% El motivo por el que queremos enviar un n�mero elevados de bits es que
% queremos hacer que la simulaci�n, se asemeje m�s a los c�lculos te�ricos,
% pu�s cuantos m�s bits se env�en, el factor aleatorio va desapareciendo.
%%
% El n�mero de s�mbolos de OFDM por trama ser� 63, que es el m�ximo que
% permite el standard PRIME en sus especificaciones para que la transmisi�n
% sea lo m�s r�pida posible.
%%
% Para terminar, el n�mero de portadoras por simbolo OFDM ser� de 96, este
% dato es el que viene dado por el standard y significa que por cada
% s�mbolo OFDM van 96 s�mbolos modulados en DBPSK, DQPSK o D8PSK.
clear; close all, format compact
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
% El n�mero de bits totales ser�: N_bits_totales =
% Nf*Nofdm*log2(M)*N_tramas, donde M ser� 2, 4, 8 dependiendo del tipo de
% modulaci�n.
%% Apartado 1.2.1: Demostrar que en ausencia de ruido sin FEC, sin prefijo c�clico y sin aleatorizaci�n, no se gener� errores.
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
for i = 1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionOFDM(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDM(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDM(8, Nf, NFFT, Nofdm);
    %% Demodulacion sin ruido
    BERDBPSK=CalcularError(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK)
    BERDQPSK=CalcularError(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK)
    BERD8PSK=CalcularError(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK)
end
%%
% Efectivamente, anteriormente se muestra que el error es nulo y tiene todo el sentido, puesto que no se
% introduce ning�n tipo de distorsi�n ni ruido en ning�n punto entre la
% se�al transmitida y la recibida. Todos los bloques simulados funcionan
% correctamente y por tanto, no a�aden ning�n error, pu�s los bloques en s�
% no a�aden error. 
%% Apartado 1.2.2: Demostrar que en ausencia de ruido sin FEC, sin prefijo c�clico y con aleatorizaci�n, no se gener� errores.
% En este apartado, se a�adir� la parte de Aleatorizaci�n y
% Dealeatorizaci�n, con una funci�n Scrambler.
for i = 1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    %% Demodulacion con Scrambler
    BERDBPSKScrambler=CalcularErrorScrambler(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
    BERDQPSKScrambler=CalcularErrorScrambler(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
    BERD8PSKScrambler=CalcularErrorScrambler(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
end
%%
% Como ocurre en el apartado anterior, el BER es 0, pu�s
% como en el caso anterior, no se introduc�a ning�n error, en este caso y
% solo al a�adir la aleatorizaci�n que tampoco introduce ni distorsi�n, ni
% errores, ni ruido, al compararar los bits transmitidos y los recibidos, el BER sale 0. 