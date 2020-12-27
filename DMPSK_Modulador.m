function modSymbols = DMPSK_Modulador(txbits, M, piloto_fase)
% Función: Función que calcula la modulación DBPSK, DQPSK y D8PSK,
% dependiendo de M y usando los pilotos para calcular la primera
% diferencia.
% Output: txbits= Vector de bits a los que se realizará la modulación. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. piloto_fase= Piloto para el cálculo de la primera diferencia
% para la modulación diferencial.
% Input: modSymbols= Resultado de la modulación del vector de bits txbits.
    modDPSK=modem.dpskmod('M',M,'InputType','Bit','InitialPhase',piloto_fase);
    modSymbols=modulate(modDPSK,txbits);
end
