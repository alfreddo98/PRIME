function numPaquetes = calcularNumeroPaquetesFEC(numBits, M, Nofdm, Nf)
    for i=1:numBits
        tx(i)=randi([0,1]);
    end
    Nbits=(Nofdm*log2(M)*Nf/2)-8;
    numPaquetes = ceil(length(tx)/Nbits);
end

