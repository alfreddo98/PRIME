%% Pr�ctica PRIME
% Autores: Alfredo S�nchez S�nchez y Manuel Mora de amarillas.
%%
% El proyecto consiste en realizar un modelado de la simulaci�n de la transmisi�n de tramas de Carga (Payload) seg�n el est�ndar de PRIME,  ITU-T G.9904. No se tendr� en cuenta la parte de la trama destinada a la transmisi�n del pre�mbulo (Preamble), Encabezado (Header) ni del CRC. 
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
Fs    =	 25600;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 4;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
% El n�mero de bits totales ser�: N_bits_totales =
% Nf*Nofdm*log2(M)*N_tramas, donde M ser� 2, 4, 8 dependiendo del tipo de
% modulaci�n.
%% Apartado 1.2.1: Demostrar que en ausencia de ruido sin FEC, sin prefijo c�clico y sin aleatorizaci�n, no se gener� errores.
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 256000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 10;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
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
% introduce ning�n tipo de distorsi�n ni ruido en ning�n punto entre la
% se�al transmitida y la recibida. Todos los bloques simulados funcionan
% correctamente y por tanto, no a�aden ning�n error, pu�s los bloques en s�
% no a�aden error. 
%% Apartado 1.2.2: Demostrar que en ausencia de ruido sin FEC, sin prefijo c�clico y con aleatorizaci�n, no se gener� errores.
% En este apartado, se a�adir� la parte de Aleatorizaci�n y
% Dealeatorizaci�n, con una funci�n Scrambler.

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
% Como ocurre en el apartado anterior, el BER es 0, pu�s
% como en el caso anterior, no se introduc�a ning�n error, en este caso y
% solo al a�adir la aleatorizaci�n que tampoco introduce ni distorsi�n, ni
% errores, ni ruido, al compararar los bits transmitidos y los recibidos, el BER sale 0. 
%% Apartado 1.2.3: Curvas BER vs SNR te�ricas y simuladas, estas ultimas empleando secuencias de bits seudoaleatorias.
% En este apartado, para ver como responde el sistema a interferencia de
% ruido blanco, se a�ade dicho ruido a la se�al antes de ser introducida en
% el receptor. Se representar� la final el error obtenido para distintos
% valores de SNR.
for i = 1:N_tramas
    % Inicializaci�n de vectores:
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));
    % Se a�ase ruido:    
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

legend('Simulado DBPSK','Te�rico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC')
 %%
 % El sistema PRIME implementado hasta este momento tiene un comportamiento
 % frente al ruido parecido al de la pr�ctica 4 de OFDM, pues no se ha
 % a�adido ning�n bloque de correci�n de errores.
 %%
 % Al representar las curvas de BER te�ricas frente a las curvas de BER
 % simuladas, se observa como ambas son pr�cticamente id�nticas (menos en
 % el caso de D8PSK que la pr�ctica sale algo desplezada. Este es el
 % resultado esperado, pues en ausencia de FEC, el error cometido para un
 % determinado ruido blanco es igual con PRIME a una modulaci�n OFDM normal
 % y corriente.
 
 %%
 % Como ya se ha observado en otras pr�cticas, para un valor de BER se
 % necesita mayor SNR para las modulaciones que utilizan mayor n�mero de
 % s�mbolos (D8PSK), pues la separaci�n entre ellos es menor. Para la
 % modulaci�n DBPSK tanto la te�rica como la pr�ctica alcanzan un BER de
 % 10^-4 para una SNR=10dB aproximadamente. Con la modulaci�n DQPSK se
 % alcanza en los 14dB (el 5 dB m�s pr�cticamente). Para D8PSK se aumenta la
 % SNR se necesitan aproximadamente 20dB para alcanzarlos (el aumento es
 % pr�cticamente el mismo que el aumento anterior)
clear all;
%% Apartado 2: Implementaci�n de todos los modos de comunicaci�n de PRIME en el caso de canal sin distorsi�n y sin FEC.
% As� como en las implementaciones anteriores se ha supuesto un canal
% invariante en frecuencia, en este apartado se asumir� que el canal cambia
% con la frecuencia y que se producen retardos.
%% Apartado 2.1: Se�al inyectada

%% Apartado 2.2: Representaci�n gr�fica del canal
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
%% Apartado 2.3: Curvas BER vs SNR te�ricas y simuladas, a�adiendo el efecto del canal sin prefijo c�clico ni ecualizador.
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
SNR_vector = 0:20;
for i=1:N_tramas
    BER_DBPSK=zeros(N_tramas,length(SNR_vector));
    BER_DQPSK=zeros(N_tramas,length(SNR_vector));
    BER_D8PSK=zeros(N_tramas,length(SNR_vector));

    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    % Se a�ase ruido:    
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

legend('Simulado DBPSK','Te�rico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC con canal sin prefijo c�clico')
title('BER vs SNR  sin FEC con canal sin prefijo c�clico ni ecualizador')
%%
% Como se pod�a esperar, cuando se introducen interferencias y retardos en
% el canal, los errores aumentan. Es curioso que a partir de un umbral de
% SNR, por mucho que se aumente el porcentaje de errores, se queda
% estancado ah�.
%%
% Dependiendo del tipo de modulaci�n, el umbral var�a, para DQPSK, el
% umbral se encuentra en aproximadamente 19 dB y el BER se estanca en
% 0.03745 y no se consigue una BER menor a 0.9% a partir de ese umbral. Para DQPSK, ocurre lo mismo, se empieza a estancar el BER en 19 dB
% con un BER de 0.01108 aproximadamente y no se consigue una BER menor a 2 % a partir de dicho umbral. Para D8PSK, ocurre lo mismo, se empieza a estancar el BER en 19 dB
% con un BER de 0.007068 aproximadamente y no se consigue una BER menor a 5 % a partir de dicho umbral.
%%
% El valor de SNR coincide en todas las modulaciones, el error obtenido
% varia debido a la separaci�n entre s�mbolos de cada una.

%% Apartado 2.4: Curvas BER vs SNR Te�rica con canal, prefijo c�clico y ecualizador
% En este introduciremos el prefijo c�clicoy, en el receptor, depu�s del
% demodulador un ecualizador. Se emplear� como piloto el primer s�mbolo
% OFDM, se asumir� que el receptor conoce las amplitudes complejas de las
% portadoras del primer s�mbolo OFDM antes de inyectar la se�al en l�nea.
% Con estos a�adidos, se calcular� y se representar� las nuevas curvas de
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
title('BER vs SNR  sin FEC con canal con prefijo c�clico y con ecualizador')
figure

semilogy(SNR_vector, BERDBPSKRuido_avg_Ecualizador, '-o');  hold on
semilogy(SNR_vector, theoryBerDBPSK);  
semilogy(SNR_vector, BERDQPSKRuido_avg_Ecualizador, '-o');  
semilogy(SNR_vector, theoryBerDQPSK);  
semilogy(SNR_vector, BERD8PSKRuido_avg_Ecualizador, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK); 

legend('Simulado DBPSK','Te�rico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('BER vs SNR  sin FEC con canal con prefijo c�clico y con ecualizador')


%%
% Se muestra el resultado de introducir el ecualizador en recepci�n. Se
% muestran dos figuras, una figura muestra las curvas de error BER en funci�n de la SNR de las se�ales recibidas con y sin ecualizador. La siguiente figura, muestra las curvas creadas con ecualizador junto
% con las te�ricas sin distorsi�n de canal. Se observa en las figuras, como
% el error de fondo que limitaba todas las se�ales con un BER muy grande,
% el ecualizador lo soluciona. Se observa que tal y como se esperaba la
% curva te�rica es parecida a la de con ecualizador, pero las curvas se
% desplezan un poco a la derecha. Esto se debe a que el ecualizador es
% Zero-Forcing y como vimos hace que se aumente el SNR y por tanto los
% errores. Para DBPSK, encontramos que para un BER de 10^-4 hay una diferencia de SNR de 7 dB con respecto a la te�rica. Para DQPSK, con un BER de 10^-4 hay una direncia aproximada de unos 6 dB. Por �ltimo, para un BER de 10^-4, tenemos una diferenca de SNR de casi 8 dB. 
clear all;
%% Apartado 3: Implementaci�n de todos los modos de comunicaci�n de PRIME con FEC 
% Partiendo del sistema ya definido con su c�digo para la obtenci�n de
% curvas de BER frente a SNR, incluyendo canal real, incluir las t�cnicas de correcci�n de errores, FEC, definidas en el est�ndar.
% Para implementar FEC es necesario modificar los valores de algunos par�metros de simulaci�n. Se debe justificar la modificaci�n, teniendo en cuenta que las tramas payload deben construirse de acuerdo al est�ndar PRIME, que se establece una diferencia entre bits de informaci�n, o antes de codificar, y bits codificados, la existencia de bits de vaciado (flushing), etc.
%% Apartado 3.1:  Modificaci�n de par�metros.
%%
% Cuando aplicamos FEC, se sabe que el codificador es el standard usado por
% PRIME seg�n se especifica en dicho standard. Se duplican los bits de
% entrada y por tanto los paquetes necesarios para enviar la cadena. El
% codificador que usa PRIME, usa 7 registros que para para la entrada de
% cada paquete se deben reiniciar a cero. Para reiniciar los registros a
% cero, se a�aden 8 bits de valor 0 al inicio de la cadena, estos bits se
% conocen como flushing. 
%% 
% Para poder computar la variaci�n de paquetes transmitidos con FEC, se han
% creado dos funciones para calcularlo, se muestran los paquetes necesarios
% para enviar una cadena de 80000 bits en todos los formatos de modulaci�n
% aceptados por prime con y sin FEC. Se puede ver que no en todos los caso
% con FEC es el doble exactamente de paquetes a sin FEC, ya que el n�mero
% de bits no es redondo para rellenar todos paquetes, por lo que el �ltimo
% paquete se rellena con ceros al final. Se puede ver tambi�n como aumentan
% los paquetes enviados enviados a casi el doble con FEC que sin FEC.
clear; close all, format compact
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
numPaquetesDBPSKFEC = calcularNumeroPaquetesFEC(80000, 2, Nofdm, Nf)
numPaquetesDBPSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 2, Nofdm, Nf)

numPaquetesDQPSKFEC = calcularNumeroPaquetesFEC(80000, 4, Nofdm, Nf)
numPaquetesDQPSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 4, Nofdm, Nf)

numPaquetesD8PSKFEC = calcularNumeroPaquetesFEC(80000, 8, Nofdm, Nf)
numPaquetesD8PSKnoFEC = calcularNumeroPaquetesnoFEC(80000, 8, Nofdm, Nf)
%% Apartado 3.2.1: Cadena con entrelazado en ausencia de ruido.
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
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
% No hay errores al a�adir el entrelazado
end
BERDBPSK_Entrelazado_Total = sum(BERDBPSK_Entrelazado_Total)
BERDQPSK_Entrelazado_Total = sum(BERDQPSK_Entrelazado_Total)
BERD8PSK_Entrelazado_Total = sum(BERD8PSK_Entrelazado_Total)

%% 
% Tal y como se esperaba, en ausencia de ruido y unicamente a�adiendo el
% entrelazado y desentrelazado, no se producen errores y por tanto, al
% igual que el apartado 1, podemos decir que se ha a�adido correctamente
% los bloques de entrelazado y desentralazado.
%% Apartado 3.2.2: Cadena con entrelazado y FEC en ausencia de ruido.
%A�adimos la codificaci�n
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
NFFT  =	512;  % Tama�o de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separaci�n entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 20;
Nofdm = 63; % N�mero de s�mbolos OFDM por trama
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
% Tal y como se esperaba, en ausencia de ruido y unicamente a�adiendo el
% entrelazado y desentrelazado, no se producen errores y por tanto, al
% igual que el apartado 1, podemos decir que se ha a�adido correctamente
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
    
    % Se a�ase ruido:    
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
% Se muestra una representaci�n de BER vs SNR con y sin FEC cuando no se
% a�ade el canal, ni prefijo c�clico, ni ecualizaci�n. Como se puede
% apreciar, el rendimiento es peor cuando se introduce FEC que cuando se
% introduce FEC, esto se puede deber a que la codicodificaci�n de un bit
% est� influenciada por las anteriores, por lo que el error se arrastra.
% Para condiciones con SNR mayor a un cierto umbral, el SNR necesario para
% un BER disminuye r�pidamente. El umbral para cada modulaci�n es: a partir
% de 2dB para DBPSK, a partir de 4 dB para DQPSK y a partir de 8 dB para
% D8PSK.
%%
% Podemos decir que con FEC se mandan m�s bits para un n�mero fijo de bits
% de informaci�n, estos bits permiten corregir errores al decodificar, por
% lo que necesita menor SNR y la potencia para transmitir informaci�n va a
% ser mayor. Por otro lado, se reduce la velocidad de transmisi�n y se
% aumenta considerablemente la complejidad.
%% Canal con ecualizaci�n:
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
% En este caso y como esper�bamos, si comparamos las curvas con canal y
% ecualizaci�n con FEC y sin FEC, se puede observar las curvas sin FEC
% tienen mejor respuesta que las curvas sin FEC, los rendimientos ademas
% cambian para cada modulaci�n: Para DBPSK para un BER de 10^-4 hay una
% diferencia de SNR de unos 5 dB, para DQPSK para una BER de 10^-3 hay una
% diferencia de SNR de unos 6 dB (sin FEC se necesita m�s SNR para llegar a
% 10^-4) para D8PSK para una BER de 10^-2, hay una diferencia de 9 dB (sin
% FEC se necesita mucho m�s SNR para bajar el BER).