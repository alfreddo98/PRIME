function tx_bits_interleaver= Entrelazar(tx_bits, M, Nofdm, Nf)
    % Se realiza el entrelazado que depende de cada modo de de modulación que
    % se emplee

    %================ENTRELAZADO================%
    tx_bits_interleaver_def=[];

        for i=1:Nofdm

           tx_bits_interleaver = tx_bits(:,i)'; 
           tx_bits_interleaver = flip(tx_bits_interleaver);
            % nc y nf son las columnas y filas respectivamente, ya que para
            % cada modo de modulación el interleaver va a cambiar
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

    % Los pasamos a matriz para realizar la modulacion posteriormente
    tx_bits_interleaver = vec2mat(tx_bits_interleaver_def,Nf*log2(M));
    tx_bits_interleaver=transpose(tx_bits_interleaver);
end

