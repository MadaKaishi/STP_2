clear all
%definicja parametrów reg ciągłego
Kr = 0.222;
Ti = 10.06;
Td = 2.4144;
T = 0.5;

%definicja parametrów PID dyskretnego
r0 = Kr*(1+ T/(2*Ti) + Td/T);
r1 = Kr*(T/(2*Ti)- 2*Td/T -1);
r2 = (Kr*Td)/T;

%wartości do równania obiektu
b0 = 0.05849;
b1 = 0.06538;
a0 = 0.716;
a1 = -1.695;

kk = 150; %koniec symulacji

%warunki początkowe
u(1:12) = 0; y(1:12) = 0;
yzad(1:15)=0; yzad(16:kk)=1;
e(1:12) = 0;

for k=13:kk
    %symulacja obiektu
    y(k)=b1*u(k-11)+b0*u(k-12)-a1*y(k-1)-a0*y(k-2);
    %uchyb regulacji
    e(k)=yzad(k)-y(k);
    %sygnał streujący regulatorem
    u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
end

%wyniki symluacji
figure; stairs(u);
title("Wartość sterowania PID"); xlabel('k'); ylabel("u");
name = "zad4_PID_u";
print(name,'-dpng','-r400')

figure; stairs(y);
hold on; stairs(yzad,':');
title("Odpowiedź skokowa układu z regulatorem"); xlabel('k'); ylabel("y");
hold off;
name = "zad4_PID_y";
print(name,'-dpng','-r400')
