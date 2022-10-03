clear
%Inicjalizacja zmiennych obiektu
K0 = 5.9; T0 = 5; T1 = 2.24; T2 = 4.51;
%Okres próbkowania
Tp = 0.5;

%Transmitancja odbiektu
G_s = tf([0 0 K0], [T1*T2 T1+T2 1], "InputDelay", T0);
G_z = c2d(G_s, Tp);

%Odpowiedź skokowa:
s = step(G_z, 2000);

%Wyznaczanie parametru D

for k = 1:2000
   if s(k) > 0.995 * s(2000)
        D = k;
        break;
   end
end