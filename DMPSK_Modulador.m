function modSymbols = DBPSK_Modulador(txbits, M, piloto, Nofdm, NBitsOfdm)
% Esta función realiza la modulación DMPSK de los txbits de entrada siendo
% M los diferentes tamaños de símbolo dependiendo de la modulación (2, 4 u
% 8) y fase tiene el valor de la fase inicial o lo que es lo mismo, es la
% BPSK del piloto.
%
%   function modSymbols = DMPSK_Modulador(txbits, M, fase)
    k=log2(M);
    for i = 0:Nofdm-1
        txbits1= txbits(i*NBitsOfdm+1:NBitsOfdm*i+NBitsOfdm);
        if M==2
             modSymbols1 = comm.DBPSKModulator(piloto(i+1));
             modSymbols1=step(modSymbols1, txbits1');
        end
        if M==4
             modSymbols1 = comm.DQPSKModulator(piloto(i+1),'BitInput', true);
             modSymbols1=step(modSymbols1, txbits1');
        end 
        if M==8
        modSymbols1 = comm.DPSKModulator(8,piloto(i+1), 'BitInput', true);
        modSymbols1 = step(modSymbols1, txbits1');
        end
        modSymbols((i*NBitsOfdm/k)+1:(NBitsOfdm/k)*i+(NBitsOfdm/k)) = modSymbols1.';
    end
end
