function BER = CalcularErrorInterleaver(signal, Nf, NFFT, M ,Nofdm, tx_bits)
% Funci�n: Funci�n que recibe la se�al transmitida y la recibida,
% demodulada la recibida, las compar� y devuelve el BER de la transmisi�n.
% En este caso al final, se debe a�adir una fase de desentralazado y dealeatorizaci�n.
% Input:Signal= La se�al modulada que se recib� del receptor. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96. NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK.  Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n. tx_bits= Bits que se transmiten, se usar� para
% compararlos con los bits recibidos despu�s de demodular y calcular los errores. 
% Output: BER= El BER computado en la transmisi�n, con los errores dividido
% entre el n�mero de bits transmitidos.
% Demodulaci�n OFDM
    [Y,pilotos_angulos] = OFDM_Demodulador(signal,NFFT,Nofdm);
% Demodulaci�n DMPSK
     rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
% Dealeatorizaci�n con la llamada a la funci�n DeEntrelazado  
     rx_bits_aleatorios = DeEntrelazado(rx_bits_aleatorios(:), M, Nofdm, Nf);
% Dealeatorizaci�n del vector con la llamada a la funci�n Scrambler     
     rx_bits = Scrambler(rx_bits_aleatorios(:)');
% C�lculo de los errores comparando los transmitidos con los recibidos
     errores = sum(bitxor(tx_bits(:), rx_bits'));
     BER = errores / (Nf*Nofdm*log2(M));    
end