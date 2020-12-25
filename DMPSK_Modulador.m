function modSymbols = DMPSK_Modulador(txbits, M, piloto_fase)
    modDPSK=modem.dpskmod('M',M,'InputType','Bit','InitialPhase',piloto_fase);
    modSymbols=modulate(modDPSK,txbits);
end
