function rx_bits = DMPSK_Demod(Y, M,piloto_fase)
% Funci�n: Funci�n que calcula la modulaci�n DBPSK, DQPSK y D8PSK,
% dependiendo de M y usando los pilotos para calcular la primera
% diferencia.
% Output: Y= Vector de salida del demodulador OFDM que tiene el vector que se introducir� en el demodulador. 
% Input:M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. piloto_fase= Piloto para el c�lculo de la primera diferencia
% para la modulaci�n diferencial.
    if(M==2)
        demod = comm.DBPSKDemodulator(pi/4);
        rx_bits = demod(Y(:));
    elseif(M==4)
        demod = comm.DQPSKDemodulator('BitOutput',true);
        rx_bits = demod(Y(:));        
    elseif(M==8)   
        demod = comm.DPSKDemodulator(8,pi/8,'BitOutput',true);
        rx_bits = demod(Y(:));        
    end
    %demodDPSK=modem.dpskdemod('M',M,'OutputType','Bit','InitialPhase',piloto_fase);
    %rx_bits=demodulate(demodDPSK,Y);

end