function BER = CalcularErrorRuido(signal, Nf, NFFT, M ,Nofdm, tx_bits, ruido)
% Función: Función que recibe la señal transmitida y la recibida,
% demodulada la recibida, las compará y devuelve el BER de la transmisión.
% En este caso al final, se debe añadir una fase de dealeatorización. En
% este apartado además, se añadirá ruido dado el vector y se devolverá un
% vector de BERs.
% Input:Signal= La señal modulada que se recibé del receptor. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96. NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK.  Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también. tx_bits= Bits que se transmiten, se usará para
% compararlos con los bits recibidos después de demodular y calcular los errores. ruido= Vector de ruido SNR.
% Output: BER= El BER computado en la transmisión, con los errores dividido
% entre el número de bits transmitidos, en este caso será un vector, un
% elemento para cada ruido.
% Bucle para recorrer todo el vector de ruidos
    for i=1:length(ruido)
% Añadimos ruido a la señal recibida
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
% Demodulación OFDM
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
% Demodulación DMPSK
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
% Dealeatorización del vector con la llamada a la función Scrambler
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
% Cálculo de los errores comparando los transmitidos con los recibidos
        errores = sum(xor(tx_bits(:), rx_bits(:)));
        BER(i) = errores / length(tx_bits);
    end
end
