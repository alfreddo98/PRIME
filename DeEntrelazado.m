function rx_bits_no_interleaver = DeEntrelazado(rx_bits, M, Nofdm, Nf)
% Funci�n: Funci�n que se utiliza para ejecutar el desentrelazado de los bits,
% se transforman los bits en una matriz que se transpone y se vuelve a
% convertir en un vector, se utiliza para evitar que se produzcan muchos
% errores seguidos. Se realiza justo la operaci�n inversa al entrelazado.
% Input: rx_bits= vector de bits a desentrelazar. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96, Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
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

