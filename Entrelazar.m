function tx_bits_interleaver= Entrelazar(tx_bits, M, Nofdm, Nf)
% Funci�n: Funci�n que se utiliza para ejecutar el entrelazado de los bits,
% se transforman los bits en una matriz que se transpone y se vuelve a
% convertir en un vector, se utiliza para evitar que se produzcan muchos
% errores seguidos.
% Input: tx_bits= vector de bits a entrelazar. M= Tipo de modulaci�n que se emplear�, M = 2 DBPSK, M = 4 DQPSK,
% M = 8 D8PSK. Nf= El n�mero de portadoras con datos, viene especificado en
% el standard, el m�ximo ser� 96, Nofdm= N�mero de s�mbolos por
% trama para la modulaci�n OFDM, especificado en el standard tambi�n.
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

