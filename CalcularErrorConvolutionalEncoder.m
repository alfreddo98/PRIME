function BER = CalcularErrorConvolutionalEncoder(signal, Nf, NFFT, M ,Nofdm, tx_bits, enrejado)
% Función: Función que recibe la señal transmitida y la recibida,
% demodulada la recibida, las compará y devuelve el BER de la transmisión.
% En este caso al final, se debe añadir una fase de desentralazado, dealeatorización y decodificación.
% Input:Signal= La señal modulada que se recibé del receptor. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96. NFFT= Elemento que indica el tamaño de la
% FFT, se usará a la hora de calcular la FFT. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK.  Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también. tx_bits= Bits que se transmiten, se usará para
% compararlos con los bits recibidos después de demodular y calcular los
% errores. enrejado=  resultado de la función polytrellis que funciona como registro
% de desplazamiento.
% Output: BER= El BER computado en la transmisión, con los errores dividido
% entre el número de bits transmitidos.
% Demodulación OFDM
    [Y,pilotos_angulos] = OFDM_Demodulador(signal,NFFT,Nofdm);
% Demodulación DMPSK
    rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
% Deshacer entrelazado con la llamada a la función DeEntrelazado  
    rx_bits_aleatorios = DeEntrelazado(rx_bits_aleatorios(:), M, Nofdm, Nf);
% Dealeatorización del vector con la llamada a la función Scrambler     
    rx_bits = Scrambler(rx_bits_aleatorios(:)');
% Decodificador
    rx_bits = vitdec(rx_bits,enrejado,5*7,'trunc','hard');
% Cálculo de los errores comparando los transmitidos con los recibidos
    errores = sum(bitxor(tx_bits(:), rx_bits'));
    BER = errores / (Nf*Nofdm*log2(M));    
end