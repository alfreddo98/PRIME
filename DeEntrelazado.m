function rx_bits_sin_entrelazado = DeEntrelazado(rx_bits, M, Nofdm, Nf)
        % Deshacemos el entrelazado
            rx_bits_sin_entrelazado=[];
            for iter=0:Nofdm-1

                if(M==2)
                    matriz= vec2mat(rx_bits(iter*(12*8)+ 1: (iter+1)*(12*8)),8,12);
                elseif(M==4)
                    matriz= vec2mat(rx_bits(iter*(12*16)+ 1: (iter+1)*(12*16)),16,12);
                elseif(M==8)
                    matriz= vec2mat(rx_bits(iter*(16*18)+ 1: (iter+1)*(16*18)),16,18);
                end
                matriz=matriz(:)';
                rx_bits_sin_entrelazado=[rx_bits_sin_entrelazado matriz];
            end 
    rx_bits_sin_entrelazado = rx_bits_sin_entrelazado';
end

