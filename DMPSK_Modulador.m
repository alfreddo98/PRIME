function modSymbols = DMPSK_Modulador(txbits, M, piloto_fase)
% Funci�n: Funci�n que calcula la modulaci�n DBPSK, DQPSK y D8PSK,
% dependiendo de M y usando los pilotos para calcular la primera
% diferencia.
% Output: txbits= Vector de bits a los que se realizar� la modulaci�n. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. piloto_fase= Piloto para el c�lculo de la primera diferencia
% para la modulaci�n diferencial.
% Input: modSymbols= Resultado de la modulaci�n del vector de bits txbits.
    if(M==2)
        mod = comm.DBPSKModulator(pi/4);
        modSymbols= mod(txbits(:));
    elseif(M==4)
        mod = comm.DQPSKModulator('BitInput',true);
        modSymbols= mod(txbits(:));
    elseif(M==8)   
        mod = comm.DPSKModulator(8,pi/8,'BitInput',true);
        modSymbols= mod(txbits(:));
    end
    modSymbols=reshape(modSymbols, [96,63]);
    %modDPSK=modem.dpskmod('M',M,'InputType','Bit','InitialPhase',piloto_fase);
    %modSymbols=modulate(modDPSK,txbits);
end
