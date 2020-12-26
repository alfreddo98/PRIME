%% Apartado 4
%% Sin prefijo cíclico

h=[-0.1,0.3,-0.5,0.7,-0.9,0.7,-0.5,0.3,-0.1];
H = fft(h,length(h));
figure;
plot(abs(fftshift(H)));
title('Transformada de Fourier discreta de la respuesta del canal, H(k)')
xlabel('k')
ylabel('Amplitud o valor')
%% Incluir el canal en el ejercicio anterior:
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
%% Incluir prefijo cíclico:
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

    [txbitsDBPSK,xDBPSK] = ModulacionOFDMConPrefijoCiclico(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK] = ModulacionOFDMConPrefijoCiclico(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK] = ModulacionOFDMConPrefijoCiclico(8, Nf, NFFT, Nofdm);
    %% Demodulacion con Scrambler
    % Se añase ruido:    
     BERDBPSK=CalcularErrorRuidoCanalPrefijoCiclico(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector, h);
     BERDQPSK=CalcularErrorRuidoCanalPrefijoCiclico(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector, h);
     BERD8PSK=CalcularErrorRuidoCanalPrefijoCiclico(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector, h);
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
%}

%% Incluir Ecualizador:
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

    [txbitsDBPSK,xDBPSK, pilotoDBPSK] = ModulacionOFDMEcualizacion(2, Nf, NFFT, Nofdm);
    [txbitsDQPSK,xDQPSK, pilotoDQPSK] = ModulacionOFDMEcualizacion(4, Nf, NFFT, Nofdm);
    [txbitsD8PSK,xD8PSK, pilotoD8PSK] = ModulacionOFDMEcualizacion(8, Nf, NFFT, Nofdm);
    %% Demodulacion con Ecualizador Zero Forcing
    % Se añase ruido:    
     BERDBPSK=CalcularErrorRuidoCanalEcualizado(xDBPSK, Nf, NFFT, 2 ,Nofdm, txbitsDBPSK, SNR_vector, h, pilotoDBPSK);
     BERDQPSK=CalcularErrorRuidoCanalEcualizado(xDQPSK, Nf, NFFT, 4 ,Nofdm, txbitsDQPSK, SNR_vector, h, pilotoDQPSK);
     BERD8PSK=CalcularErrorRuidoCanalEcualizado(xD8PSK, Nf, NFFT, 8 ,Nofdm, txbitsD8PSK, SNR_vector, h, pilotoD8PSK);
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