function x = OFDM_Modulador(mod_DMPSK,piloto_fase,NFFT,Nofdm)
    X = zeros(NFFT, Nofdm);

    X(87,:) = exp(1i*piloto_fase); % piloto
    X(88:183,:) = mod_DMPSK;

    X(331,:)=flipud(conj( X(87,:))); % piloto
    X(332:427,:) = flipud(conj(X(88:183,:)));

    x = ifft(X,NFFT,'symmetric')*NFFT;
    x = x(:)';
end

