%% Apartado 5
%% Modificación de parámetros de simulación
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 5;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = -10:2:50;
SNR_vector = -5:2:15;
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
    BERDBPSK=CalcularErrorInterleaver(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, h)
    BERDQPSK=CalcularErrorInterleaver(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, h)
    BERD8PSK=CalcularErrorInterleaver(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, h)
    % No hay errores al añadir el entrelazado
end
%% Añadimos la codificación
clear; close all, format compact
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 5;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = -10:2:50;
for i=1:N_tramas
    lg = 7;
    enrejado = poly2trellis([lg],[171,133]);
    [txbitsDBPSK,xDBPSK] = ModulacionConvolutionalEncoder(2, Nf, NFFT, Nofdm, enrejado);
    [txbitsDQPSK,xDQPSK] = ModulacionConvolutionalEncoder(4, Nf, NFFT, Nofdm, enrejado);
    [txbitsD8PSK,xD8PSK] = ModulacionConvolutionalEncoder(8, Nf, NFFT, Nofdm, enrejado);
    %% Demodulacion con Convolutional Encoder
    h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
    BERDBPSK=CalcularErrorConvolutionalEncoder(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, h, enrejado)
    BERDQPSK=CalcularErrorConvolutionalEncoder(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, h, enrejado)
    BERD8PSK=CalcularErrorConvolutionalEncoder(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, h, enrejado)    
end
%% Sin ecualizar ni prefijo cíclico ni canal:
%% Añadimos el ruido, primero las curvas sin FEC:
clear; close all, format compact
h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 5;
Nofdm = 63; % Número de símbolos OFDM por trama
SNR_vector = -10:2:50;
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
   
     % Con FEC:
    lg = 7;
    enrejado = poly2trellis([lg],[171,133]);
    [txbitsDBPSK_FEC,xDBPSK_FEC] = ModulacionConvolutionalEncoder(2, Nf, NFFT, Nofdm, enrejado);
    [txbitsDQPSK_FEC,xDQPSK_FEC] = ModulacionConvolutionalEncoder(4, Nf, NFFT, Nofdm, enrejado);
    [txbitsD8PSK_FEC,xD8PSK_FEC] = ModulacionConvolutionalEncoder(8, Nf, NFFT, Nofdm, enrejado);
    BERDBPSK_FEC=CalcularErrorConvolutionalEncoderRuido(xDBPSK_FEC, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK_FEC, enrejado, SNR_vector, h);
    BERDQPSK_FEC=CalcularErrorConvolutionalEncoderRuido(xDQPSK_FEC, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK_FEC, enrejado, SNR_vector, h);
    BERD8PSK_FEC=CalcularErrorConvolutionalEncoderRuido(xD8PSK_FEC, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK_FEC, enrejado, SNR_vector, h);    
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

theoryBerDBPSK = DBPSK_BER(SNR_vector);
theoryBerDQPSK = DQPSK_BER(SNR_vector);
theoryBerD8PSK = D8PSK_BER(SNR_vector);

theoryBerDBPSK(find(theoryBerDBPSK<1e-5)) = NaN;
theoryBerDQPSK(find(theoryBerDQPSK<1e-5)) = NaN;
theoryBerD8PSK(find(theoryBerD8PSK<1e-5)) = NaN;

figure
subplot(2,1,1);
semilogy(SNR_vector, BERDBPSKRuido_avg, '-o');  hold on
semilogy(SNR_vector, theoryBerDBPSK,     '-kx');  
semilogy(SNR_vector, BERDQPSKRuido_avg, '-o');  
semilogy(SNR_vector, theoryBerDQPSK,     '-kx');  
semilogy(SNR_vector, BERD8PSKRuido_avg, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK,     '-kx'); 

legend('Simulado DBPSK','Teórico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC')
subplot(2,1,2);
semilogy(SNR_vector, BERDBPSKRuido_avg_FEC, '-o');  hold on
semilogy(SNR_vector, theoryBerDBPSK,     '-kx');  
semilogy(SNR_vector, BERDQPSKRuido_avg_FEC, '-o');  
semilogy(SNR_vector, theoryBerDQPSK,     '-kx');  
semilogy(SNR_vector, BERD8PSKRuido_avg_FEC, '-o'); 
semilogy(SNR_vector, theoryBerD8PSK,     '-kx'); 

legend('Simulado DBPSK','Teórico DBPSK', 'Simulado DQPSK', 'Teorico DQPSK', 'Simulado D8PSK', 'Teorico D8PSK')
xlabel('SNR (dB)');  ylabel('BER de DMPSK')
grid on
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK con FEC')