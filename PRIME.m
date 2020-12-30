%% Práctica PRIME
% Autores: Alfredo Sánchez Sánchez y Manuel Mora de amarillas.
%%
% El proyecto consiste en realizar un modelado de la simulación de la transmisión de tramas de Carga (Payload) según el estándar de PRIME,  ITU-T G.9904. No se tendrá en cuenta la parte de la trama destinada a la transmisión del preámbulo (Preamble), Encabezado (Header) ni del CRC. 
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
BERDBPSK_Total = [];
BERDQPSK_Total = [];
BERD8PSK_Total = [];

for i = 1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionOFDM(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDM(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDM(8, Nf, NFFT, Nofdm);
    % Demodulacion sin ruido
    BERDBPSK=CalcularError(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
    BERDQPSK=CalcularError(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
    BERD8PSK=CalcularError(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
    BERDBPSK_Total = [BERDBPSK_Total BERDBPSK];
    BERDQPSK_Total = [BERDQPSK_Total BERDQPSK];
    BERD8PSK_Total = [BERD8PSK_Total BERD8PSK];
        
end
BERDBPSK_Total = sum(BERDBPSK_Total)
BERDQPSK_Total = sum(BERDQPSK_Total)
BERD8PSK_Total = sum(BERD8PSK_Total)

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
BERDBPSK_Total_Scrambler = [];
BERDQPSK_Total_Scrambler = [];
BERD8PSK_Total_Scrambler = [];
SNR_vector = 0:20;
for i = 1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    % Demodulacion con Scrambler
    BERDBPSKScrambler=CalcularErrorScrambler(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
    BERDQPSKScrambler=CalcularErrorScrambler(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
    BERD8PSKScrambler=CalcularErrorScrambler(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
    BERDBPSK_Total_Scrambler = [BERDBPSK_Total_Scrambler BERDBPSKScrambler];
    BERDQPSK_Total_Scrambler = [BERDQPSK_Total_Scrambler BERDQPSKScrambler];
    BERD8PSK_Total_Scrambler = [BERD8PSK_Total_Scrambler BERD8PSKScrambler];
end
BERDBPSK_Total_Scrambler = sum(BERDBPSK_Total_Scrambler)
BERDQPSK_Total_Scrambler = sum(BERDQPSK_Total_Scrambler)
BERD8PSK_Total_Scrambler = sum(BERD8PSK_Total_Scrambler)
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
for i = 1:N_tramas
    % Inicialización de vectores:
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
clear all;
%% Apartado 2: Implementación de todos los modos de comunicación de PRIME en el caso de canal sin distorsión y sin FEC.
% Así como en las implementaciones anteriores se ha supuesto un canal
% invariante en frecuencia, en este apartado se asumirá que el canal cambia
% con la frecuencia y que se producen retardos.
%% Apartado 2.1: Señal inyectada

%% Apartado 2.2: Representación gráfica del canal
Fs    =	 25000;  % Frecuencia de muestreo
NFFT = 512;
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
f = linspace(-Fs/2, Fs/2, NFFT);
H = fft(h,NFFT);
figure;
plot(f, 20*log(abs(fftshift(H))));
title('Transformada de Fourier discreta de la respuesta del canal h(n)')
xlabel('f(Hz)')
ylabel('Amplitud (dB)')
%% 
% El canal, como se puede apreciar actua como un filtro que atenua las
% bandas laterales y amplifica las bandas de los extremos.
%% Apartado 2.3: Curvas BER vs SNR teóricas y simuladas, añadiendo el efecto del canal sin prefijo cíclico ni ecualizador.
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = 0:20;
for i=1:N_tramas
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));

    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    % Se añase ruido:    
     BERDBPSK=CalcularErrorRuidoCanal(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector, h);
     BERDQPSK=CalcularErrorRuidoCanal(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector, h);
     BERD8PSK=CalcularErrorRuidoCanal(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector, h);
     BERDBPSKRuido(i,:) = BERDBPSK;
     BERDQPSKRuido(i,:) = BERDQPSK;
     BERD8PSKRuido(i,:) = BERD8PSK;
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

semilogy(SNR_vector, BERDBPSKRuido_avg, '-o');  hold on
semilogy(SNR_vector, theoryBerDBPSK,     '-kx');  
semilogy(SNR_vector, BERDQPSKRuido_avg, '-o');  
semilogy(SNR_vector, theoryBerDQPSK,     '-kx');  
semilogy(SNR_vector, BERD8PSKRuido_avg, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK,     '-kx'); 

legend('Simulado DBPSK','Teórico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC con canal sin prefijo cíclico')
title('BER vs SNR  sin FEC con canal sin prefijo cíclico ni ecualizador')
%%
% Como se podía esperar, cuando se introducen interferencias y retardos en
% el canal, los errores aumentan. Es curioso que a partir de un umbral de
% SNR, por mucho que se aumente el porcentaje de errores, se queda
% estancado ahí.
%%
% Dependiendo del tipo de modulación, el umbral varía, para DQPSK, el
% umbral se encuentra en aproximadamente 19 dB y el BER se estanca en
% 0.03745 y no se consigue una BER menor a 0.9% a partir de ese umbral. Para DQPSK, ocurre lo mismo, se empieza a estancar el BER en 19 dB
% con un BER de 0.01108 aproximadamente y no se consigue una BER menor a 2 % a partir de dicho umbral. Para D8PSK, ocurre lo mismo, se empieza a estancar el BER en 19 dB
% con un BER de 0.007068 aproximadamente y no se consigue una BER menor a 5 % a partir de dicho umbral.
%%
% El valor de SNR coincide en todas las modulaciones, el error obtenido
% varia debido a la separación entre símbolos de cada una.

%% Apartado 2.4: Curvas BER vs SNR Teórica con canal, prefijo cíclico y ecualizador
% En este introduciremos el prefijo cíclicoy, en el receptor, depués del
% demodulador un ecualizador. Se empleará como piloto el primer símbolo
% OFDM, se asumirá que el receptor conoce las amplitudes complejas de las
% portadoras del primer símbolo OFDM antes de inyectar la señal en línea.
% Con estos añadidos, se calculará y se representará las nuevas curvas de
for i=1:N_tramas
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));

    [txbitsDBPSK,xDBPSK, pilotoDBPSK] = ModulacionOFDMEcualizacion(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK, pilotoDQPSK] = ModulacionOFDMEcualizacion(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK, pilotoD8PSK] = ModulacionOFDMEcualizacion(8, Nf, NFFT, Nofdm);
    % Demodulacion con Ecualizador Zero Forcing    
     BERDBPSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector, h, pilotoDBPSK);
     BERDQPSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector, h, pilotoDQPSK);
     BERD8PSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector, h, pilotoD8PSK);
     BERDBPSKRuido_Ecualizador(i,:) = BERDBPSK_Ecualizador;
     BERDQPSKRuido_Ecualizador(i,:) = BERDQPSK_Ecualizador;
     BERD8PSKRuido_Ecualizador(i,:) = BERD8PSK_Ecualizador;
end
BERDBPSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));

for i=1:N_tramas
      BERDBPSKRuido_avg_Ecualizador = BERDBPSKRuido_avg_Ecualizador + BERDBPSKRuido_Ecualizador(i,:);
      BERDQPSKRuido_avg_Ecualizador = BERDQPSKRuido_avg_Ecualizador + BERDQPSKRuido_Ecualizador(i,:);
      BERD8PSKRuido_avg_Ecualizador = BERD8PSKRuido_avg_Ecualizador + BERD8PSKRuido_Ecualizador(i,:);
end
BERDBPSKRuido_avg_Ecualizador = BERDBPSKRuido_avg_Ecualizador./N_tramas;
BERDQPSKRuido_avg_Ecualizador = BERDQPSKRuido_avg_Ecualizador./N_tramas;
BERD8PSKRuido_avg_Ecualizador = BERD8PSKRuido_avg_Ecualizador./N_tramas;
figure

semilogy(SNR_vector, BERDBPSKRuido_avg, '-*');  hold on
semilogy(SNR_vector, BERDBPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, BERDQPSKRuido_avg, '-*');  
semilogy(SNR_vector, BERDQPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, BERD8PSKRuido_avg, '-*'); 
semilogy(SNR_vector, BERD8PSKRuido_avg_Ecualizador, '-o'); 

legend('Simulado DBPSK Sin Ecualizador','Simulado DBPSK Con Ecualizador', 'Simulado DQPSK Sin Ecualizador', 'Simulado DQPSK Con Ecualizador', 'Simulado D8PSK Sin Ecualizador', 'Simulado D8PSK Con Ecualizador')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('BER vs SNR  sin FEC con canal con prefijo cíclico y con ecualizador')
figure

semilogy(SNR_vector, BERDBPSKRuido_avg_Ecualizador, '-o');  hold on
semilogy(SNR_vector, theoryBerDBPSK);  
semilogy(SNR_vector, BERDQPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, theoryBerDQPSK);  
semilogy(SNR_vector, BERD8PSKRuido_avg_Ecualizador, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK); 

legend('Simulado DBPSK','Teórico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('BER vs SNR  sin FEC con canal con prefijo cíclico y con ecualizador')


%%
% Se muestra el resultado de introducir el ecualizador en recepción. Se
% muestran dos figuras, una figura muestra las curvas de error BER en función de la SNR de las señales recibidas con y sin ecualizador. La siguiente figura, muestra las curvas creadas con ecualizador junto
% con las teóricas sin distorsión de canal. Se observa en las figuras, como
% el error de fondo que limitaba todas las señales con un BER muy grande,
% el ecualizador lo soluciona. Se observa que tal y como se esperaba la
% curva teórica es parecida a la de con ecualizador, pero las curvas se
% desplezan un poco a la derecha. Esto se debe a que el ecualizador es
% Zero-Forcing y como vimos hace que se aumente el SNR y por tanto los
% errores. Para DBPSK, encontramos que para un BER de 10^-4 hay una diferencia de SNR de 7 dB con respecto a la teórica. Para DQPSK, con un BER de 10^-4 hay una direncia aproximada de unos 6 dB. Por último, para un BER de 10^-4, tenemos una diferenca de SNR de casi 8 dB. 
clear all;
%% Apartado 3: Implementación de todos los modos de comunicación de PRIME con FEC 
% Partiendo del sistema ya definido con su código para la obtención de
% curvas de BER frente a SNR, incluyendo canal real, incluir las técnicas de corrección de errores, FEC, definidas en el estándar.
% Para implementar FEC es necesario modificar los valores de algunos parámetros de simulación. Se debe justificar la modificación, teniendo en cuenta que las tramas payload deben construirse de acuerdo al estándar PRIME, que se establece una diferencia entre bits de información, o antes de codificar, y bits codificados, la existencia de bits de vaciado (flushing), etc.
%% Apartado 3.1:  Modificación de parámetros.
%%
% Cuando aplicamos FEC, se sabe que el codificador es el standard usado por
% PRIME según se especifica en dicho standard. Se duplican los bits de
% entrada y por tanto los paquetes necesarios para enviar la cadena. El
% codificador que usa PRIME, usa 7 registros que para para la entrada de
% cada paquete se deben reiniciar a cero. Para reiniciar los registros a
% cero, se añaden 8 bits de valor 0 al inicio de la cadena, estos bits se
% conocen como flushing. 
%% 
% Para poder computar la variación de paquetes transmitidos con FEC, se han
% creado dos funciones para calcularlo, se muestran los paquetes necesarios
% para enviar una cadena de 80000 bits en todos los formatos de modulación
% aceptados por prime con y sin FEC. Se puede ver que no en todos los caso
% con FEC es el doble exactamente de paquetes a sin FEC, ya que el número
% de bits no es redondo para rellenar todos paquetes, por lo que el último
% paquete se rellena con ceros al final. Se puede ver también como aumentan
% los paquetes enviados enviados a casi el doble con FEC que sin FEC.
clear; close all, format compact
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
Nofdm = 63; % Número de símbolos OFDM por trama
numPaquetesDBPSKFEC = calcularNumeroPaquetesFEC(80000, 2, Nofdm, Nf)
numPaquetesDBPSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 2, Nofdm, Nf)

numPaquetesDQPSKFEC = calcularNumeroPaquetesFEC(80000, 4, Nofdm, Nf)
numPaquetesDQPSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 4, Nofdm, Nf)

numPaquetesD8PSKFEC = calcularNumeroPaquetesFEC(80000, 8, Nofdm, Nf)
numPaquetesD8PSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 8, Nofdm, Nf)
%% Apartado 3.2.1: Cadena con entrelazado en ausencia de ruido.
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = 0:20;

BERDBPSK_Entrelazado_Total = [];
BERDQPSK_Entrelazado_Total = [];
BERD8PSK_Entrelazado_Total = [];
BERDBPSK_FEC_Total = [];
BERDQPSK_FEC_Total = [];
BERD8PSK_FEC_Total = [];

BER_DBPSK_conFEC=zeros(N_tramas,length(SNR_vector));
BER_DQPSK_conFEC=zeros(N_tramas,length(SNR_vector));
BER_D8PSK_conFEC=zeros(N_tramas,length(SNR_vector));

BER_DBPSK_sinFEC=zeros(N_tramas,length(SNR_vector));
BER_DQPSK_sinFEC=zeros(N_tramas,length(SNR_vector));
BER_D8PSK_sinFEC=zeros(N_tramas,length(SNR_vector));
for iter=1:N_tramas
    [txbitsDBPSK,xDBPSK] = ModulacionInterleaver(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionInterleaver(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionInterleaver(8, Nf, NFFT, Nofdm);
    % Demodulacion con Interleaver
    h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
    BERDBPSK_Entrelazado=CalcularErrorInterleaver(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
    BERDQPSK_Entrelazado=CalcularErrorInterleaver(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
    BERD8PSK_Entrelazado=CalcularErrorInterleaver(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
    BERDBPSK_Entrelazado_Total = [BERDBPSK_Entrelazado_Total BERDBPSK_Entrelazado];
    BERDQPSK_Entrelazado_Total = [BERDQPSK_Entrelazado_Total BERDQPSK_Entrelazado];
    BERD8PSK_Entrelazado_Total = [BERD8PSK_Entrelazado_Total BERD8PSK_Entrelazado];    
% No hay errores al añadir el entrelazado
end
BERDBPSK_Entrelazado_Total = sum(BERDBPSK_Entrelazado_Total)
BERDQPSK_Entrelazado_Total = sum(BERDQPSK_Entrelazado_Total)
BERD8PSK_Entrelazado_Total = sum(BERD8PSK_Entrelazado_Total)

%% 
% Tal y como se esperaba, en ausencia de ruido y unicamente añadiendo el
% entrelazado y desentrelazado, no se producen errores y por tanto, al
% igual que el apartado 1, podemos decir que se ha añadido correctamente
% los bloques de entrelazado y desentralazado.
%% Apartado 3.2.2: Cadena con entrelazado y FEC en ausencia de ruido.
%Añadimos la codificación
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = 0:20;
for i=1:N_tramas
    lg = 7;
    enrejado = poly2trellis([lg],[171,133]);
    [txbitsDBPSK,xDBPSK] = ModulacionConvolutionalEncoder(2, Nf, NFFT, Nofdm, enrejado);
    [txbitsDQPSK,xDQPSK] = ModulacionConvolutionalEncoder(4, Nf, NFFT, Nofdm, enrejado);
    [txbitsD8PSK,xD8PSK] = ModulacionConvolutionalEncoder(8, Nf, NFFT, Nofdm, enrejado);
    % Demodulacion con Convolutional Encoder
    BERDBPSK_FEC=CalcularErrorConvolutionalEncoder(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, enrejado);
    BERDQPSK_FEC=CalcularErrorConvolutionalEncoder(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, enrejado);
    BERD8PSK_FEC=CalcularErrorConvolutionalEncoder(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, enrejado);
    BERDBPSK_FEC_Total = [BERDBPSK_FEC_Total BERDBPSK_FEC];
    BERDQPSK_FEC_Total = [BERDQPSK_FEC_Total BERDQPSK_FEC];
    BERD8PSK_FEC_Total = [BERD8PSK_FEC_Total BERD8PSK_FEC];
end
BERDBPSK_FEC_Total = sum(BERDBPSK_FEC_Total)
BERDQPSK_FEC_Total = sum(BERDQPSK_FEC_Total)
BERD8PSK_FEC_Total = sum(BERD8PSK_FEC_Total)

%% 
% Tal y como se esperaba, en ausencia de ruido y unicamente añadiendo el
% entrelazado y desentrelazado, no se producen errores y por tanto, al
% igual que el apartado 1, podemos decir que se ha añadido correctamente
% los bloques de entrelazado y desentralazado y de convolutional encoder.
%% Apartado 3.2.3: Curvas BER vs SNR
% Primero representaremos las curvas de BER vs SNR sin FEC y sin canal frente a las propias curvas con FEC sin canal:
for i=1:N_tramas
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));
    BER_DBPSK_FEC=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK_FEC=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK_FEC=zeros(N_tramas,length(SNR_vector));

    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    
    % Se añase ruido:    
    BERDBPSK=CalcularErrorRuido(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector);
    BERDQPSK=CalcularErrorRuido(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector);
    BERD8PSK=CalcularErrorRuido(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector);
    BERDBPSKRuido(i,:) = BERDBPSK;
    BERDQPSKRuido(i,:) = BERDQPSK;
    BERD8PSKRuido(i,:) = BERD8PSK;
    
    % Ahora con FEC:
    lg = 7;
    enrejado = poly2trellis([lg],[171,133]);
    [txbitsDBPSK_FEC,xDBPSK_FEC] = ModulacionConvolutionalEncoder(2, Nf, NFFT, Nofdm, enrejado);
    [txbitsDQPSK_FEC,xDQPSK_FEC] = ModulacionConvolutionalEncoder(4, Nf, NFFT, Nofdm, enrejado);
    [txbitsD8PSK_FEC,xD8PSK_FEC] = ModulacionConvolutionalEncoder(8, Nf, NFFT, Nofdm, enrejado);
    BERDBPSK_FEC=CalcularErrorConvolutionalEncoderRuido(xDBPSK_FEC, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK_FEC, enrejado, SNR_vector);
    BERDQPSK_FEC=CalcularErrorConvolutionalEncoderRuido(xDQPSK_FEC, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK_FEC, enrejado, SNR_vector);
    BERD8PSK_FEC=CalcularErrorConvolutionalEncoderRuido(xD8PSK_FEC, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK_FEC, enrejado, SNR_vector);    
    BERDBPSKRuido_FEC(i,:) = BERDBPSK_FEC;
    BERDQPSKRuido_FEC(i,:) = BERDQPSK_FEC;
    BERD8PSKRuido_FEC(i,:) = BERD8PSK_FEC;    
end  
BERDBPSKRuido_avg = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg = zeros(1,length(SNR_vector));
BERDBPSKRuido_avg_FEC = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg_FEC = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg_FEC = zeros(1,length(SNR_vector));
for i=1:N_tramas
      BERDBPSKRuido_avg = BERDBPSKRuido_avg + BERDBPSKRuido(i,:);
      BERDQPSKRuido_avg = BERDQPSKRuido_avg + BERDQPSKRuido(i,:);
      BERD8PSKRuido_avg = BERD8PSKRuido_avg + BERD8PSKRuido(i,:);
      BERDBPSKRuido_avg_FEC = BERDBPSKRuido_avg_FEC + BERDBPSKRuido_FEC(i,:);
      BERDQPSKRuido_avg_FEC = BERDQPSKRuido_avg_FEC + BERDQPSKRuido_FEC(i,:);
      BERD8PSKRuido_avg_FEC = BERD8PSKRuido_avg_FEC + BERD8PSKRuido_FEC(i,:);
end
BERDBPSKRuido_avg = BERDBPSKRuido_avg./N_tramas;
BERDQPSKRuido_avg = BERDQPSKRuido_avg./N_tramas;
BERD8PSKRuido_avg = BERD8PSKRuido_avg./N_tramas;

BERDBPSKRuido_avg_FEC = BERDBPSKRuido_avg_FEC./N_tramas;
BERDQPSKRuido_avg_FEC = BERDQPSKRuido_avg_FEC./N_tramas;
BERD8PSKRuido_avg_FEC = BERD8PSKRuido_avg_FEC./N_tramas;
figure
semilogy(SNR_vector, BERDBPSKRuido_avg, '-o');  hold on
semilogy(SNR_vector, BERDBPSKRuido_avg_FEC,     '-x');  
semilogy(SNR_vector, BERDQPSKRuido_avg, '-o');  
semilogy(SNR_vector, BERDQPSKRuido_avg_FEC,     '-x');  
semilogy(SNR_vector, BERD8PSKRuido_avg, '-o'); 
semilogy(SNR_vector, BERD8PSKRuido_avg_FEC,     '-x'); 

legend('DBPSK sin FEC','DBPSK con FEC', 'DQPSK sin FEC', 'DQPSK con FEC', 'D8PSK sin FEC', 'D8PSK con FEC')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM sin FEC vs con FEC')
%%
% Se muestra una representación de BER vs SNR con y sin FEC cuando no se
% añade el canal, ni prefijo cíclico, ni ecualización. Como se puede
% apreciar, el rendimiento es peor cuando se introduce FEC que cuando se
% introduce FEC, esto se puede deber a que la codicodificación de un bit
% está influenciada por las anteriores, por lo que el error se arrastra.
% Para condiciones con SNR mayor a un cierto umbral, el SNR necesario para
% un BER disminuye rápidamente. El umbral para cada modulación es: a partir
% de 2dB para DBPSK, a partir de 4 dB para DQPSK y a partir de 8 dB para
% D8PSK.
%%
% Podemos decir que con FEC se mandan más bits para un número fijo de bits
% de información, estos bits permiten corregir errores al decodificar, por
% lo que necesita menor SNR y la potencia para transmitir información va a
% ser mayor. Por otro lado, se reduce la velocidad de transmisión y se
% aumenta considerablemente la complejidad.
%% Canal con ecualización:
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
for i=1:N_tramas
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));

    [txbitsDBPSK,xDBPSK, pilotoDBPSK] = ModulacionOFDMEcualizacion(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK, pilotoDQPSK] = ModulacionOFDMEcualizacion(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK, pilotoD8PSK] = ModulacionOFDMEcualizacion(8, Nf, NFFT, Nofdm);
    % Demodulacion con Ecualizador Zero Forcing    
     BERDBPSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector, h, pilotoDBPSK);
     BERDQPSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector, h, pilotoDQPSK);
     BERD8PSK_Ecualizador=CalcularErrorRuidoCanalEcualizado(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector, h, pilotoD8PSK);
     BERDBPSKRuido_Ecualizador(i,:) = BERDBPSK_Ecualizador;
     BERDQPSKRuido_Ecualizador(i,:) = BERDQPSK_Ecualizador;
     BERD8PSKRuido_Ecualizador(i,:) = BERD8PSK_Ecualizador;
end
BERDBPSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg_Ecualizador = zeros(1,length(SNR_vector));

for i=1:N_tramas
      BERDBPSKRuido_avg_Ecualizador = BERDBPSKRuido_avg_Ecualizador + BERDBPSKRuido_Ecualizador(i,:);
      BERDQPSKRuido_avg_Ecualizador = BERDQPSKRuido_avg_Ecualizador + BERDQPSKRuido_Ecualizador(i,:);
      BERD8PSKRuido_avg_Ecualizador = BERD8PSKRuido_avg_Ecualizador + BERD8PSKRuido_Ecualizador(i,:);
end
BERDBPSKRuido_avg_Ecualizador = BERDBPSKRuido_avg_Ecualizador./N_tramas;
BERDQPSKRuido_avg_Ecualizador = BERDQPSKRuido_avg_Ecualizador./N_tramas;
BERD8PSKRuido_avg_Ecualizador = BERD8PSKRuido_avg_Ecualizador./N_tramas;
for i=1:N_tramas
    BER_DBPSK_FEC=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK_FEC=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK_FEC=zeros(N_tramas,length(SNR_vector));

    lg = 7;
    enrejado = poly2trellis([lg],[171,133]);
    [txbitsDBPSK_FEC,xDBPSK_FEC,piloto_ecualizadorDBPSK] = ModulacionConvolutionalEncoderPC(2, Nf, NFFT, Nofdm, enrejado);
    [txbitsDQPSK_FEC,xDQPSK_FEC,piloto_ecualizadorDQPSK] = ModulacionConvolutionalEncoderPC(4, Nf, NFFT, Nofdm, enrejado);
    [txbitsD8PSK_FEC,xD8PSK_FEC,piloto_ecualizadorD8PSK] = ModulacionConvolutionalEncoderPC(8, Nf, NFFT, Nofdm, enrejado);
    BERDBPSK_FEC=CalcularErrorConvolutionalEncoderRuidoCanal(xDBPSK_FEC, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK_FEC, enrejado, SNR_vector, h, piloto_ecualizadorDBPSK);
    BERDQPSK_FEC=CalcularErrorConvolutionalEncoderRuidoCanal(xDQPSK_FEC, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK_FEC, enrejado, SNR_vector, h, piloto_ecualizadorDQPSK);
    BERD8PSK_FEC=CalcularErrorConvolutionalEncoderRuidoCanal(xD8PSK_FEC, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK_FEC, enrejado, SNR_vector, h, piloto_ecualizadorD8PSK);    
    BERDBPSKRuido_FEC(i,:) = BERDBPSK_FEC;
    BERDQPSKRuido_FEC(i,:) = BERDQPSK_FEC;
    BERD8PSKRuido_FEC(i,:) = BERD8PSK_FEC; 
end
BERDBPSKRuido_avg_FEC = zeros(1,length(SNR_vector));
BERDQPSKRuido_avg_FEC = zeros(1,length(SNR_vector));
BERD8PSKRuido_avg_FEC = zeros(1,length(SNR_vector));
for i=1:N_tramas
      BERDBPSKRuido_avg_FEC = BERDBPSKRuido_avg_FEC + BERDBPSKRuido_FEC(i,:);
      BERDQPSKRuido_avg_FEC = BERDQPSKRuido_avg_FEC + BERDQPSKRuido_FEC(i,:);
      BERD8PSKRuido_avg_FEC = BERD8PSKRuido_avg_FEC + BERD8PSKRuido_FEC(i,:);
end
BERDBPSKRuido_avg_FEC = BERDBPSKRuido_avg_FEC./N_tramas;
BERDQPSKRuido_avg_FEC = BERDQPSKRuido_avg_FEC./N_tramas;
BERD8PSKRuido_avg_FEC = BERD8PSKRuido_avg_FEC./N_tramas;

figure

semilogy(SNR_vector, BERDBPSKRuido_avg_FEC, '-*');  hold on
semilogy(SNR_vector, BERDBPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, BERDQPSKRuido_avg_FEC, '-*');  
semilogy(SNR_vector, BERDQPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, BERD8PSKRuido_avg_FEC, '-*'); 
semilogy(SNR_vector, BERD8PSKRuido_avg_Ecualizador, '-o'); 

legend('DBPSK Con FEC','DBPSK Sin FEC', 'DQPSK Con FEC', 'DQPSK Sin FEC', 'D8PSK Con FEC', 'D8PSK Sin FEC')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM con FEC vs sin FEC con canal y ecualizador')
%%
% En este caso y como esperábamos, si comparamos las curvas con canal y
% ecualización con FEC y sin FEC, se puede observar las curvas sin FEC
% tienen mejor respuesta que las curvas sin FEC, los rendimientos ademas
% cambian para cada modulación: Para DBPSK para un BER de 10^-4 hay una
% diferencia de SNR de unos 5 dB, para DQPSK para una BER de 10^-3 hay una
% diferencia de SNR de unos 6 dB (sin FEC se necesita más SNR para llegar a
% 10^-4) para D8PSK para una BER de 10^-2, hay una diferencia de 9 dB (sin
% FEC se necesita mucho más SNR para bajar el BER).