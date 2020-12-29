function BER = CalcularErrorRuido(signal, Nf, NFFT, M ,Nofdm, tx_bits, ruido)
% Funci�n: Funci�n que recibe la se�al transmitida y la recibida,
% demodulada la recibida, las compar� y devuelve el BER de la transmisi�n.
% En este caso al final, se debe a�adir una fase de dealeatorizaci�n. En
% este apartado adem�s, se a�adir� ruido dado el vector y se devolver� un
% vector de BERs.
% Input:Signal= La se�al modulada que se recib� del receptor. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96. NFFT= Elemento que indica el tama�o de la
% FFT, se usar� a la hora de calcular la FFT. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK.  Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n. tx_bits= Bits que se transmiten, se usar� para
% compararlos con los bits recibidos despu�s de demodular y calcular los errores. ruido= Vector de ruido SNR.
% Output: BER= El BER computado en la transmisi�n, con los errores dividido
% entre el n�mero de bits transmitidos, en este caso ser� un vector, un
% elemento para cada ruido.
% Bucle para recorrer todo el vector de ruidos
    for i=1:length(ruido)
% A�adimos ruido a la se�al recibida
        fb = 10*log10( (NFFT/2)/Nf );
        y  = awgn(signal,ruido(i)-fb,'measured');
% Demodulaci�n OFDM
        [Y,pilotos_angulos] = OFDM_Demodulador(y,NFFT,Nofdm);
% Demodulaci�n DMPSK
        rx_bits_aleatorios = DMPSK_Demod(Y, M, pilotos_angulos);
% Dealeatorizaci�n del vector con la llamada a la funci�n Scrambler
        rx_bits = Scrambler(rx_bits_aleatorios(:)');
% C�lculo de los errores comparando los transmitidos con los recibidos
        errores = sum(xor(tx_bits(:), rx_bits(:)));
        BER(i) = errores / length(tx_bits);
    end
end
