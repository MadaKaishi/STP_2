clear all
%definicja parametrów reg ciągłego
Kr = 0.241;
Ti = 10.06;
Td = 2.4144;
T = 0.5;
delay = 10;

%definicja parametrów PID dyskretnego
r0 = Kr*(1+ T/(2*Ti) + Td/T);
r1 = Kr*(T/(2*Ti)- 2*Td/T -1);
r2 = (Kr*Td)/T;

%wartości do równania obiektu
b0 = 0.05849;
b1 = 0.06538;
a0 = 0.716;
a1 = -1.695;

kk = 250; %koniec symulacji
kp = 24; %początek symulacji
ks = 28; %chwila skoku wartosci zadania

%War początkowe
u(1:kp) = 0; y(1:kp) = 0;
yzad(1:ks)=0; yzad(ks:kk)=1;
e(1:kp) = 0;


for k=kp:kk
    %symulacja obiektu
    y(k)=b1*u(k-(11+delay))+b0*u(k-(12+delay))-a1*y(k-1)-a0*y(k-2);
    %uchyb regulacji
    e(k)=yzad(k)-y(k);
    %sygnał streujący regulatorem
    u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
end


%Plot PID
% figure; stairs(y);
% hold on; stairs(yzad,':');
% title("Odpowiedź skokowa układu z regulatorem"); xlabel('k'); ylabel("y");
% hold off;

Tbad = [1.1:0.1:2];
Ybad = [0.956521739	0.913043478	0.87826087	0.843478261	0.814492754	0.785507246	0.765217391	0.739130435	0.71884058	0.698550725
]   
%Final Plot
figure;
plot(Tbad, Ybad);
hold on; xlabel("T_0/T_o^n^o^m"); ylabel("K_0/K_o^n^o^m")
title("Charakterystyka stabilności dla regulatora PID")
print("Char_Stab_PID",'-dpng','-r400')

