%tworzenie wykresu
plot(out.u.time, out.u.signals.values(:,1))
hold on;
plot(out.y.time, out.y.signals.values(:,1))
ylabel("y");
xlabel("t(s)");
name = "zad3_trans_ciagla_kp_"+Kp;
title("PID Kp = " + Kp + " Ti = " + Ti + " Td = " + Td)
hold off;
print(name,'-dpng','-r400');