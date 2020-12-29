function tx_bits_interleaver= Entrelazar(tx_bits, M, Nofdm, Nf)
% Función: Función que se utiliza para ejecutar el entrelazado de los bits,
% se transforman los bits en una matriz que se transpone y se vuelve a
% convertir en un vector, se utiliza para evitar que se produzcan muchos
% errores seguidos.
% Input: tx_bits= vector de bits a entrelazar. M= Tipo de modulación que se empleará, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El número de portadoras con datos, viene especificado en
% el standard, el máximo será 96, Nofdm= Número de símbolos por
% trama para la modulación OFDM, especificado en el standard también.
% Output: tx_bits_interleaver= vector de bits entrelazados.
    tx_bits_interleaver_def=[];

        for i=1:Nofdm

           tx_bits_interleaver = tx_bits(:,i)'; 
           tx_bits_interleaver = flip(tx_bits_interleaver);
           if M==2
               nc = 12;
               nf = 8;
               tx_bits_interleaver = reshape(tx_bits_interleaver, [nc,nf])';

           elseif M==4
               nc = 12;
               nf = 16;
               tx_bits_interleaver = reshape(tx_bits_interleaver, [nc,nf])';

           else
               nc = 18;
               nf = 16;
               tx_bits_interleaver = reshape(tx_bits_interleaver, [nc,nf])';
           end

           tx_bits_interleaver = flip(tx_bits_interleaver);
           

           for j=1:nc
               intermedio = tx_bits_interleaver(:,j)';
               if j==1
                   tx_bits_interleaver_s = intermedio;
               else
                   tx_bits_interleaver_s = horzcat(intermedio,tx_bits_interleaver_s);
               end
           end
           tx_bits_interleaver_def= horzcat(tx_bits_interleaver_def,tx_bits_interleaver_s);

        end
    tx_bits_interleaver = vec2mat(tx_bits_interleaver_def,Nf*log2(M));
    tx_bits_interleaver=transpose(tx_bits_interleaver);
end

