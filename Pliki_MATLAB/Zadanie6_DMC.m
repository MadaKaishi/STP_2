clear


%Inicjalizacja zmiennych obiektu
K0 = 5.9; T0 = 5; T1 = 2.24; T2 = 4.51;
%Okres próbkowania
Tp = 0.5;

%Transmitancja odbiektu
G_s = tf([0 0 K0], [T1*T2 T1+T2 1], "InputDelay", T0);
G_z = c2d(G_s, Tp);

K_man = 0.14;
delay = 10;

%Parametry modelu
b0 = 0.05849;
b1 = 0.06538;
a0 = 0.716;
a1 = -1.695;

%Horyzonty
D = 65; %Horyzont Dynamiki
N= 17;    %Horyzont predykcji
Nu = 2; %Horyzont sterowania

%Macierz odpowiedzi skokowej
s = step(G_z, D);

%Współczynnik kary
lamb = 20;

kk = 1000; %koniec symulacji
kp = max(13,D+1); %początek symulacji
ks = max(19,D+7); %chwila skoku wartosci zadania

%War początkowe
u(1:kp) = 0; y(1:kp) = 0;
yzad(1:ks)=0; yzad(ks:kk)=1;
e(1:kp) = 0;

%Macierz M
M=zeros(N,Nu);
for i=1:N
   for j=1:Nu
      if (i>=j)
         M(i,j)=s(i-j+1);
      end
   end
end

%Macierz MP
MP=zeros(N,D-1);
for i=1:N
   for j=1:D-1
      if i+j<=D
         MP(i,j)=s(i+j)-s(j);
      else
         MP(i,j)=s(D)-s(j);
      end      
   end
end

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
Y = zeros(N,1);
%główne wykonanie programu
for k=kp:kk
    for n=1:N
    %yzad dla horyzontu predykcji
        Y_zad(n,1) = yzad(k);
    end
    %symulacja obiektu
    y(k)=K_man*(b1*u(k-(11+delay))+b0*u(k-(12+delay)))-a1*y(k-1)-a0*y(k-2);
    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    Yo = MP*DUp+Y;
    DU = K*(Y_zad - Yo);
    u(k)=u(k-1)+DU(1);   
    wejscie_u(k)=u(k);
    wyjscie_y(k)=y(k); 
end

iteracja = 0:1:kk-1;  
%Plot wyjście
% figure;
% stairs(iteracja, wyjscie_y)
% hold on;
% stairs(iteracja, yzad);
% hold off;
% title("Odpowiedź skokowa układu z regulatorem DMC" + newline + "D = " + D + " N = " + N + " Nu = " + Nu +  " lambda = " + lamb); 
% xlabel('k'); ylabel("y");
% legend("Opowiedź z regulatorem","Wartość zadana", "Location", "southeast")

Tbad = [1.1:0.1:2];
Ybad = [1.054227405	1.054227405	1.023323615	0.986005831	0.959183673	0.530612245	0.29154519	0.157434402	0.087463557	0.075801749
]
%Final Plot
figure;
plot(Tbad, Ybad);
hold on; xlabel("T_0/T_o^n^o^m"); ylabel("K_0/K_o^n^o^m")
title("Charakterystyka stabilności dla regulatora DMC")
print("Char_Stab_DMC",'-dpng','-r400')

