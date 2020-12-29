function rx_bits = DMPSK_Demod(Y, M,piloto_fase)
% Función: Función que calcula la modulación DBPSK, DQPSK y D8PSK,
% dependiendo de M y usando los pilotos para calcular la primera
% diferencia.
% Output: Y= Vector de salida del demodulador OFDM que tiene el vector que se introducirá en el demodulador. 
% Input:M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. piloto_fase= Piloto para el cálculo de la primera diferencia
% para la modulación diferencial.
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