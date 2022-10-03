%Liczenie transmitancji
G_s = tf([0 0 K0], [T1*T2 T1+T2 1], "InputDelay", T0);
G_z = c2d(G_s, Tp);


%Tworzenie wykresu
stepplot(G_z)
hold on;
stepplot(G_s)
legend("G_z", "G_s")
title("Odpowiedzi skokowe transmitanjci")
name = "zad1_g_plot";
hold off;
print(name,'-dpng','-r400')