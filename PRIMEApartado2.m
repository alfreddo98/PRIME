clear all;
%% Apartado 3: Implementaci�n de todos los modos de comunicaci�n de PRIME en el caso de canal sin distorsi�n y sin FEC.
% As� como en las implementaciones anteriores se ha supuesto un canal
% invariante en frecuencia, en este apartado se asumir� que el canal cambia
% con la frecuencia y que se producen retardos.
%% Apartado 3.1: Se�al inyectada

%% Apartado 3.2: Representaci�n gr�fica del canal
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
%% Apartado 3.3: Curvas BER vs SNR te�ricas y simuladas, a�adiendo el efecto del canal sin prefijo c�clico ni ecualizador.
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
    %% Demodulacion con Scrambler
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