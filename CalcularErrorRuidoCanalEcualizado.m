function BER = CalcularErrorRuidoCanalEcualizado(signal, Nf, NFFT, M ,Nofdm, tx_bits, ruido, canal, piloto)
% Función: Función que recibe la señal transmitida y la recibida,
% demodulada la recibida, las compará y devuelve el BER de la transmisión.
% En este caso al final, se debe añadir una fase de dealeatorización. En
% este apartado además, se añadirá ruido dado el vector y se devolverá un
% vector de BERs. Se añade además el canal indicado en el enunciado. Se le
% añadirá un apartado de prefijo cíclico y ecualizador.
% Input:Signal= La señal modulada que se recibé del receptor. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96. NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK.  Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también. tx_bits= Bits que se transmiten, se usará para
% compararlos con los bits recibidos después de demodular y calcular los
% errores. piloto= Piloto que se usará para el ecualizador Zero-Forcing. canal= respuesta del canal
% indicado en el enunciado.
% ruido= Vector de ruido SNR.
% Output: BER= El BER computado en la transmisión, con los errores dividido
% entre el número de bits transmitidos, en este caso será un vector, un
% elemento para cada ruido.
    freq = fft(piloto, NFFT);
% Bucle para recorrer todo el vector de ruidos
    for i=1:length(ruido)
% Se añade ruido a la señal recibida
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
% Efecto del canal:
        y_conv = conv(y, canal);
        y = y_conv(1:length(y));
        y = reshape(y,[NFFT+48, Nofdm]);
% Eliminar prefijo cíclico
        y = y(49:end,:);
% Ecualización y demodulación OFDM:
        [pilotos_angulos , Y] = Ecualizador(y, NFFT, Nofdm, freq);
% Demodulación DMPSK: 
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
% Dealeatorización del vector con la llamada a la función Scrambler
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
% Cálculo de los errores comparando los transmitidos con los recibidos
        errores = sum(bitxor(tx_bits(:), rx_bits(:)));
        BER(i) = errores / (Nf*Nofdm*log2(M));
    end
end
