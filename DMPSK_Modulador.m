function modSymbols = DMPSK_Modulador(txbits, M, piloto_fase)
% Funci�n: Funci�n que calcula la modulaci�n DBPSK, DQPSK y D8PSK,
% dependiendo de M y usando los pilotos para calcular la primera
% diferencia.
% Output: txbits= Vector de bits a los que se realizar� la modulaci�n. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. piloto_fase= Piloto para el c�lculo de la primera diferencia
% para la modulaci�n diferencial.
% Input: modSymbols= Resultado de la modulaci�n del vector de bits txbits.
    modDPSK=modem.dpskmod('M',M,'InputType','Bit','InitialPhase',piloto_fase);
    modSymbols=modulate(modDPSK,txbits);
end
