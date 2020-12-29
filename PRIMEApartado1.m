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
Fs    =	 25600;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % Número de símbolos OFDM por trama
% El número de bits totales será: N_bits_totales =
% Nf*Nofdm*log2(M)*N_tramas, donde M será 2, 4, 8 dependiendo del tipo de
% modulación.
%% Apartado 1.2.1: Demostrar que en ausencia de ruido sin FEC, sin prefijo cíclico y sin aleatorización, no se generá errores.
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 256000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 10;
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

% Ruido para el apartado 1.2.3:
SNR_vector = 0:20;
for i = 1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    %% Demodulacion con Scrambler
    BERDBPSKScrambler=CalcularErrorScrambler(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
    BERDQPSKScrambler=CalcularErrorScrambler(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
    BERD8PSKScrambler=CalcularErrorScrambler(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
%%
% Como ocurre en el apartado anterior, el BER es 0, pués
% como en el caso anterior, no se introducía ningún error, en este caso y
% solo al añadir la aleatorización que tampoco introduce ni distorsión, ni
% errores, ni ruido, al compararar los bits transmitidos y los recibidos, el BER sale 0. 
%% Apartado 1.2.3: Curvas BER vs SNR teóricas y simuladas, estas ultimas empleando secuencias de bits seudoaleatorias.
% En este apartado, para ver como responde el sistema a interferencia de
% ruido blanco, se añade dicho ruido a la señal antes de ser introducida en
% el receptor. Se representará la final el error obtenido para distintos
% valores de SNR.
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));
    % Se añase ruido:    
    BERDBPSKR=CalcularErrorRuido(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector);
    BERDQPSKR=CalcularErrorRuido(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector);
    BERD8PSKR=CalcularErrorRuido(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector);
    BERDBPSKRuido(i,:) = BERDBPSKR;
    BERDQPSKRuido(i,:) = BERDQPSKR;
    BERD8PSKRuido(i,:) = BERD8PSKR;
end
BERDBPSKRuido_avg = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg = zeros(1,length(SNR_vector));

for i=1:N_tramas
      BERDBPSKRuido_avg = BERDBPSKRuido_avg + BERDBPSKRuido(i,:);
      BERDQPSKRuido_avg = BERDQPSKRuido_avg + BERDQPSKRuido(i,:);
      BERD8PSKRuido_avg = BERD8PSKRuido_avg + BERD8PSKRuido(i,:);
end
BERDBPSKRuido_avg = BERDBPSKRuido_avg./N_tramas;
BERDQPSKRuido_avg = BERDQPSKRuido_avg./N_tramas;
BERD8PSKRuido_avg = BERD8PSKRuido_avg./N_tramas;

theoryBerDBPSK = DBPSK_BER(SNR_vector);
theoryBerDQPSK = DQPSK_BER(SNR_vector);
theoryBerD8PSK = D8PSK_BER(SNR_vector);

theoryBerDBPSK(find(theoryBerDBPSK<1e-5)) = NaN;
theoryBerDQPSK(find(theoryBerDQPSK<1e-5)) = NaN;
theoryBerD8PSK(find(theoryBerD8PSK<1e-5)) = NaN;

figure

semilogy(SNR_vector, BERDBPSKRuido_avg, '-*');  hold on
semilogy(SNR_vector, theoryBerDBPSK);  
semilogy(SNR_vector, BERDQPSKRuido_avg, '-x');  
semilogy(SNR_vector, theoryBerDQPSK);  
semilogy(SNR_vector, BERD8PSKRuido_avg, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK); 

legend('Simulado DBPSK','Teórico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC')
 %%
 % El sistema PRIME implementado hasta este momento tiene un comportamiento
 % frente al ruido parecido al de la práctica 4 de OFDM, pues no se ha
 % añadido ningún bloque de correción de errores.
 %%
 % Al representar las curvas de BER teóricas frente a las curvas de BER
 % simuladas, se observa como ambas son prácticamente idénticas (menos en
 % el caso de D8PSK que la práctica sale algo desplezada. Este es el
 % resultado esperado, pues en ausencia de FEC, el error cometido para un
 % determinado ruido blanco es igual con PRIME a una modulación OFDM normal
 % y corriente.
 
 %%
 % Como ya se ha observado en otras prácticas, para un valor de BER se
 % necesita mayor SNR para las modulaciones que utilizan mayor número de
 % símbolos (D8PSK), pues la separación entre ellos es menor. Para la
 % modulación DBPSK tanto la teórica como la práctica alcanzan un BER de
 % 10^-4 para una SNR=10dB aproximadamente. Con la modulación DQPSK se
 % alcanza en los 14dB (el 5 dB más prácticamente). Para D8PSK se aumenta la
 % SNR se necesitan aproximadamente 20dB para alcanzarlos (el aumento es
 % prácticamente el mismo que el aumento anterior)
