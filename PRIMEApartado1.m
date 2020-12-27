%% Práctica PRIME
% Autores: Alfredo Sánchez Sánchez y Manuel Mora de amarillas.
%%
%*BOLD TEXT* El proyecto consiste en realizar un modelado de la simulación de la transmisión de tramas de Carga (Payload) según el estándar de PRIME,  ITU-T G.9904. No se tendrá en cuenta la parte de la trama destinada a la transmisión del preámbulo (Preamble), Encabezado (Header) ni del CRC. 
%% Apartado 1: Implementación de todos los modos de comunicación de PRIME en el caso de canal sin distorsión y sin FEC 
%% Apartado 1.1: Elección de parámetros de simulación
% Los bits a transmitir, deben ser superiores a 10^4 o 10000 pues queremos
% una simulación fiable de BER de 10^-4. En nuestro caso, hemos
% seleccionado como límite 20000, que es un valor fiable para todos los
% tipos de modulación, especialmente paa la modulación de 2, que es la que
% enviaría un menor número de bits. El número de tramas que enviaremos será
% 4, sabiendo que con DBPSK el número de símbolos a transmitir es el doble
% que en DQPSK y este es el doble que con D8PSK.
% El motivo por el que queremos enviar un número elevados de bits es que
% queremos hacer que la simulación, se asemeje más a los cálculos teóricos,
% pués cuantos más bits se envíen, el factor aleatorio va desapareciendo.
%%
% El número de símbolos de OFDM por trama será 63, que es el máximo que
% permite el standard PRIME en sus especificaciones para que la transmisión
% sea lo más rápida posible.
%%
% Para terminar, el número de portadoras por simbolo OFDM será de 96, este
% dato es el que viene dado por el standard y significa que por cada
% símbolo OFDM van 96 símbolos modulados en DBPSK, DQPSK o D8PSK.
clear; close all, format compact
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % Número de símbolos OFDM por trama
% El número de bits totales será: N_bits_totales =
% Nf*Nofdm*log2(M)*N_tramas, donde M será 2, 4, 8 dependiendo del tipo de
% modulación.
%% Apartado 1.2.1: Demostrar que en ausencia de ruido sin FEC, sin prefijo cíclico y sin aleatorización, no se generá errores.
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % Número de símbolos OFDM por trama
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
% introduce ningún tipo de distorsión ni ruido en ningún punto entre la
% señal transmitida y la recibida. Todos los bloques simulados funcionan
% correctamente y por tanto, no añaden ningún error, pués los bloques en sí
% no añaden error. 
%% Apartado 1.2.2: Demostrar que en ausencia de ruido sin FEC, sin prefijo cíclico y con aleatorización, no se generá errores.
% En este apartado, se añadirá la parte de Aleatorización y
% Dealeatorización, con una función Scrambler.
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
% Como ocurre en el apartado anterior, el BER es 0, pués
% como en el caso anterior, no se introducía ningún error, en este caso y
% solo al añadir la aleatorización que tampoco introduce ni distorsión, ni
% errores, ni ruido, al compararar los bits transmitidos y los recibidos, el BER sale 0. 