%%
% Con 1 muestra de DBPSK, DQPSK y D8PSK sin ruido y sin FEC y sin nada funciona
% correctamente, no da errores al demodular. Tambi�n haciendo el scramble
% de los bits a la entrada. Cuando pasamos a m�s s�mbolos de OFDM, sin
% ruido y sin nada, empieza a dar errores. (Se le a�ade tambi�n la fase
% modulada en BPSK), que es lo mismo que dejarla a 0 si es un 0 o ponerla en pi si es 1.
% (Usamos 32 muestras).