clear; close all, format compact
%% Apartado 3
%% Modulación sin ruido
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
clear; close all, format compact
%% Modulación con Scrambler
NFFT  =	512;  % Tamaño de la FFT
Fs    =	 250000;  % Frecuencia de muestreo
df    =  Fs/NFFT ;  % Separación entre portadoras
Nf    =	96;  % Numero de portadoras con datos (+1 por el piloto)
N_tramas = 1;
Nofdm = 63; % Número de símbolos OFDM por trama
[txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
[txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
[txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
%% Demodulacion con Scrambler
BERDBPSKScrambler=CalcularErrorScrambler(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK);
BERDQPSKScrambler=CalcularErrorScrambler(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK);
BERD8PSKScrambler=CalcularErrorScrambler(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK);
%% Incluimos error
clear; close all, format compact

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

    [txbitsDBPSK,xDBPSK] = ModulacionOFDMScrambler(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMScrambler(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMScrambler(8, Nf, NFFT, Nofdm);
    %% Demodulacion con Scrambler
    % Se añase ruido:    
     BERDBPSK=CalcularErrorRuido(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector);
     BERDQPSK=CalcularErrorRuido(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector);
     BERD8PSK=CalcularErrorRuido(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector);
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
title('Resultados del sistema OFDM de DBPSK DQPSK y D8PSK sin FEC')
  
