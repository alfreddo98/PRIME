clear all;
%% Apartado 4: Implementación de todos los modos de comunicación de PRIME con FEC 
% Partiendo del sistema ya definido con su código para la obtención de
% curvas de BER frente a SNR, incluyendo canal real, incluir las técnicas de corrección de errores, FEC, definidas en el estándar.
% Para implementar FEC es necesario modificar los valores de algunos parámetros de simulación. Se debe justificar la modificación, teniendo en cuenta que las tramas payload deben construirse de acuerdo al estándar PRIME, que se establece una diferencia entre bits de información, o antes de codificar, y bits codificados, la existencia de bits de vaciado (flushing), etc.
%% Apartado 4.1:  Modificación de parámetros.
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
%% Apartado 4.2.1: Cadena con entrelazado en ausencia de ruido.
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
    %% Demodulacion con Interleaver
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
%% Apartado 4.2.1: Cadena con entrelazado y FEC en ausencia de ruido.
%% Añadimos la codificación
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
    %% Demodulacion con Convolutional Encoder
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
%% Curvas BER vs SNR
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
%% Añadimos el canal con la ecualización:
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