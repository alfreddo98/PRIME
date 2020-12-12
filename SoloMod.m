clear; close all, format compact
%% 
% Seleccion:
N_tramas = 1;
NFFT  =	512;  % Tamaño de la FFT
df    =   200 ;  % Separación entre portadoras
Fs    =	 NFFT*df;  % Frecuencia de muestreo
Nf    =	96 ;  % Numero de portadoras con datos
M =	8;  % Indicador de modulacion digital de cada portadora
Nofdm  = 96  % Número de símbolos OFDM
NBitsOfdm = Nf * log2(M)
NBitsTotales_Tramas = Nf * log2(M) * Nofdm * N_tramas
NBitsTotales = Nf * log2(M) * Nofdm
    %%
    % Piloto de la subportadora según el standard:
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

    %% Modulación OFDM
    % Creamos una matriz para la IFFT, tendrá el numero de FFT (512) filas y
    % numero de simbolos OFDM como columnas, se irá metiendo el piloto en cada
    % simbolo OFDM.
    matrizFFT = zeros(NFFT, Nofdm);
    % Iniciamos un bucle que recorra el numero de símbolos OFDM
    for i=0:Nofdm-1
        Simbolos = mod(i*Nf+1:Nf*i+Nf)*pref(i+1);
        % Usamos un vector para meter el piloto junto con los simbolos
        % modulados que toquen en simbolo OFDM.
        vector_add = [pref(i+1) Simbolos];
        % Añadimos el vector entre 86 y 182 de la IFFT:
        matrizFFT(87:183, i+1) = vector_add;
        % Añadimos el conjugado, esta vez entre 330 y 426:
        matrizFFT(331:427,i+1) = conj(fliplr(vector_add));
    end
    % Hacemos la ifft de la matriz:
    matrizIFFT = ifft(matrizFFT,NFFT,'symmetric')*NFFT;
    vectorOFDM = matrizIFFT(:);

      %% Proceso inverso: Demodulación
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
      for i=1:Nofdm
        matriz_rx_frec = matriz_rx_frec(i+1,:) .* exp(-j*vec_pilotos_angulos(i+1));
      end
      vec_demod = matrix_demod(:)';
      rxbits_aleatorizados=DMPSK_Demod(vec_demod, M,vec_pilotos_angulos, Nofdm, NBitsOfdm, Nf);
      rxbits=Scrambler(rxbits_aleatorizados);
      error = rxbits-txbits;
      errores = NBitsTotales - sum(error==0)
      %%
     % Esta correcto porque no tenemos errores, que es lo que esperabamos al no meterle ruido (es lo ideal).