function rx_bits_no_interleaver = DeEntrelazado(rx_bits, M, Nofdm, Nf)
% Función: Función que se utiliza para ejecutar el desentrelazado de los bits,
% se transforman los bits en una matriz que se transpone y se vuelve a
% convertir en un vector, se utiliza para evitar que se produzcan muchos
% errores seguidos. Se realiza justo la operación inversa al entrelazado.
% Input: rx_bits= vector de bits a desentrelazar. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96, Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: rx_bits_no_interleaver= vector de bits desentrelazados.
            rx_bits_no_interleaver=[];
            
            for i=0:Nofdm-1
                
                if(M==2)
                    
                    matriz= vec2mat(rx_bits(i*(12*8)+ 1: (i+1)*(12*8)),8,12);
                    
                elseif(M==4)
                    
                    matriz= vec2mat(rx_bits(i*(12*16)+ 1: (i+1)*(12*16)),16,12);
                    
                elseif(M==8)
                    
                    matriz= vec2mat(rx_bits(i*(16*18)+ 1: (i+1)*(16*18)),16,18);
                    
                end
                
                matriz=matriz(:)';
                
                rx_bits_no_interleaver=[rx_bits_no_interleaver matriz];
                
            end 
            
    rx_bits_no_interleaver = rx_bits_no_interleaver';
    
end

