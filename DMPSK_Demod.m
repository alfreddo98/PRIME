function demodulado = DMPSK_Demod(rx_mod, M,piloto, Nofdm, NBitsOfdm, Nportadoras)
%%
% Funcion que demodula en DBPSK, DQPSK, D8PSK según corresponda, usa las
% funciones correspondientes dentro de comm.    
    k=log2(M);    
    for i = 0:Nofdm-1
            rxbits1= rx_mod(i*Nportadoras+1:Nportadoras*i+Nportadoras);
            size(rxbits1);
            if M==2
                 H = comm.DBPSKDemodulator(piloto(i+1));
                 demodulado1=step(H, rxbits1');
            end
            if M==4
                 H = comm.DQPSKDemodulator(piloto(i+1), 'BitOutput', true);
                 demodulado1=step(H, rxbits1');
            end 
            if M==8
                H = modem.dpskdemod('M', M, ...
                'SymbolOrder', 'Gray', 'OutputType', ...
                'Bit', 'InitialPhase', piloto(i+1));
                demodulado1 = demodulate(H, rxbits1');
            end
            demodulado(i*NBitsOfdm+1:(NBitsOfdm)*(i+1))=demodulado1.';
        end


end