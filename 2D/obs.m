function [od]=obs()
od=[41 50;42 50;43,50;44 50;38 50;32 50;33 50;34 50;35 50;36 50;37 50;39 50;40 50;20 40;20 28;20 29;20 30;20 31;20 32;20 33;20 34;20 35;20 36;20 37;20 38;20 39
    44 38;44 37;44 36;44 35;44 34;44 33;42 35;42 34;42 33;42 32;42 31;42 30;46 40;46 39;46 38;46 37;46 36;46 35;48 38;48 37;48 42;48 41;48 43;48 40;48 39
    22 50];
%20 34;21 43;22 44;23 45;24 46;25 47;26 48;27 49;28 50;20 36;20 38;46 40;46 38;48 38;48 41;48 43;40 22;40 24;40 26;40 29;40 32;40 34;42 22;42 24;42 26;42 28;42 30;42 32;42 34;42 34;
%44 22;44 24;44 26;44 28;44 30;44 32;44 34;44 36;44 38;44 40];
plot( od(:,1),od(:,2),'sk','MarkerSize',8,'MarkerFaceColor','k'); 
axis([0 60 0 70]);
hold on