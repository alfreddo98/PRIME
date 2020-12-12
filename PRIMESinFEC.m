clear; close all, format compact
%% 
% Seleccion:
N_tramas = 20;
NFFT  =	512;  % Tama�o de la FFT
df    =   200 ;  % Separaci�n entre portadoras
Fs    =	 NFFT*df;  % Frecuencia de muestreo
Nf    =	96 ;  % Numero de portadoras con datos
M =	8;  % Indicador de modulacion digital de cada portadora
Nofdm  = 127  % N�mero de s�mbolos OFDM
NBitsOfdm = Nf * log2(M)
NBitsTotales_Tramas = Nf * log2(M) * Nofdm * N_tramas
NBitsTotales = Nf * log2(M) * Nofdm
    %%
    % Piloto de la subportadora seg�n el standard:
    pref = [0 0 0 0 1 1 1 0 1 1 1 1 0 0 1 0 1 1, ...
        0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0, ...
        1 1 0 0 0 1 0 1 1 1 0 1 0 1 1 0 1 1 0, ...
        0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 0 1 1 1, ...
        0 0 1 1 1 1 0 1 1 0 1 0 0 0 0 1 0 1 0, ...
        1 0 1 1 1 1 1 0 1 0 0 1 0 1 0 0 0 1 1, ...
        0 1 1 1 0 0 0 1 1 1 1 1 1 1];
    pref_fase = pref*pi;
    pref = BPSKMod(pref);
    txbits = round(rand(1, log2(M)*Nofdm*Nf));
    txbits_aleatorizados= Scrambler(txbits);
    mod = DMPSK_Modulador(txbits_aleatorizados, M, pref_fase, Nofdm, NBitsOfdm);

    %% Modulaci�n OFDM
    % Creamos una matriz para la IFFT, tendr� el numero de FFT (512) filas y
    % numero de simbolos OFDM como columnas, se ir� metiendo el piloto en cada
    % simbolo OFDM.
    matrizFFT = zeros(NFFT, Nofdm);
    % Iniciamos un bucle que recorra el numero de s�mbolos OFDM
    for i=0:Nofdm-1
        Simbolos = mod(i*Nf+1:Nf*i+Nf);
        % Usamos un vector para meter el piloto junto con los simbolos
        % modulados que toquen en simbolo OFDM.
        vector_add = [pref(i+1) Simbolos];
        % A�adimos el vector entre 86 y 182 de la IFFT:
        matrizFFT(87:183, i+1) = vector_add;
        % A�adimos el conjugado, esta vez entre 330 y 426:
        matrizFFT(331:427,i+1) = conj(fliplr(vector_add));
    end
    % Hacemos la ifft de la matriz:
    matrizIFFT = ifft(matrizFFT,NFFT,'symmetric')*NFFT;
    vectorOFDM = matrizIFFT(:);

      %% Proceso inverso: Demodulaci�n
      % Metemos todo en una matriz
    matriz_rx = [];
      for i=0:Nofdm-1
        matriz_rx=[matriz_rx; vectorOFDM(i*NFFT+1:NFFT*i+NFFT)'];    
      end
      matriz_rx= matriz_rx';
      matriz_rx_frec = fft(matriz_rx, NFFT);
      vec_pilotos = matriz_rx_frec(87,:);
      vec_pilotos_angulos=(angle(vec_pilotos));
      matrix_demod = matriz_rx_frec(88:183,:);
      vec_demod = matrix_demod(:)';
      rxbits_aleatorizados=DMPSK_Demod(vec_demod, M,vec_pilotos_angulos, Nofdm, NBitsOfdm, Nf);
      rxbits=Scrambler(rxbits_aleatorizados);
      error = rxbits-txbits;
      errores = NBitsTotales - sum(error==0)
      %%
     % Esta correcto porque no tenemos errores, que es lo que esperabamos al no meterle ruido (es lo ideal).
     %%
     % Ahora vamos a meterle ruido:
     txbits = round(rand(1, log2(M)*Nofdm*Nf));
    txbits_aleatorizados= Scrambler(txbits);
    mod = DMPSK_Modulador(txbits_aleatorizados, M, pref_fase, Nofdm, NBitsOfdm);

    %% Modulaci�n OFDM
    % Creamos una matriz para la IFFT, tendr� el numero de FFT (512) filas y
    % numero de simbolos OFDM como columnas, se ir� metiendo el piloto en cada
    % simbolo OFDM.
    matrizFFT = zeros(NFFT, Nofdm);
    % Iniciamos un bucle que recorra el numero de s�mbolos OFDM
    for i=0:Nofdm-1
        Simbolos = mod(i*Nf+1:Nf*i+Nf);
        % Usamos un vector para meter el piloto junto con los simbolos
        % modulados que toquen en simbolo OFDM.
        vector_add = [pref(i+1) Simbolos];
        % A�adimos el vector entre 86 y 182 de la IFFT:
        matrizFFT(87:183, i+1) = vector_add;
        % A�adimos el conjugado, esta vez entre 330 y 426:
        matrizFFT(331:427,i+1) = conj(fliplr(vector_add));
    end
    % Hacemos la ifft de la matriz:
    matrizIFFT = ifft(matrizFFT,NFFT,'symmetric')*NFFT;
    vectorOFDM = matrizIFFT(:);
    %% RUIDO
    EbN0_dB = 5:2:50;
    suma_error_signal=[];
    signal_noise=[];
    for i= 1:length(EbN0_dB)
       fb = 10*log10( (NFFT/2)/Nf );
       signal_noise =[signal_noise awgn(vectorOFDM, EbN0_dB(i)-fb, 'measured')];
       %suma_error_signal=[suma_error_signal sum(abs(signal_noise(:,i)-vectorOFDM))]
    end
    %suma_error_signal=suma_error_signal/length(vectorOFDM)
    %figure
    %plot(suma_error_signal)

       %% Proceso inverso: Demodulaci�n
      % Metemos todo en una matriz
      vec_error=[];
    for j= 1:length(EbN0_dB)
          matriz_rx = [];    
          for i=0:Nofdm-1
            matriz_rx=[matriz_rx; signal_noise(i*NFFT+1:NFFT*i+NFFT,j)'];    
          end
          matriz_rx= matriz_rx';
          matriz_rx_frec = fft(matriz_rx, NFFT);
          vec_pilotos = matriz_rx_frec(87,:);
          vec_pilotos_angulos=(angle(vec_pilotos));
          matrix_demod = matriz_rx_frec(88:183,:);
          vec_demod = matrix_demod(:)';
          rxbits_aleatorizados=DMPSK_Demod(vec_demod, M,vec_pilotos, Nofdm, NBitsOfdm, Nf);
          rxbits=Scrambler(rxbits_aleatorizados);
          error = rxbits-txbits;
          errores = NBitsTotales - sum(error==0);
          BERrx=errores/NBitsTotales;
          vec_error= [vec_error BERrx];
    end

%suma_error_signal=suma_error_signal/length(vectorOFDM)
BER_Teor = [];
for i= 1:length(EbN0_dB)
    BER_Teor=[BER_Teor D8PSK_BER(EbN0_dB(i))];
end
BER_Teor(find(BER_Teor<1e-5))=NaN;
figure
semilogy(EbN0_dB,vec_error)
hold on;
semilogy(EbN0_dB,BER_Teor)
grid on
legend('simulado','teorico')
%Para el 8 es una aproximaci�n y para el 8 hay una liger