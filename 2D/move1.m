function [Goal]=move1(X,lx,ly,od)
length=[X(1)-lx;X(2,1)-ly];
d=sqrt((X(1)-lx)^2+(X(2,1)-ly)^2);
length=(length/d)*5;

Xo=[lx ly];%起点位置
k=50;%计算引力需要的增益系数
K=0;%初始化
m=10;%计算斥力的增益系数，都是自己设定的。
Po=7;%障碍影响距离，当障碍和车的距离大于这个距离时，斥力为0，即不受该障碍的影响。也是自己设定。
n=size(od,1);%障碍个数
a=15;
l=0.5;%步长
J=2000;%循环迭代次数
%如果不能实现预期目标，可能也与初始的增益系数，Po设置的不合适有关。
%end
%给出障碍和目标信息
Xsum=[X';od];%这个向量是(n+1)*2维，其中[10 10]是目标位置，剩下的都是障碍的位置。
Xj=Xo;%j=1循环初始，将车的起始坐标赋给Xj
%***************初始化结束，开始主体循环******************
for j=1:J%循环开始
    Goal(j,1)=Xj(1);%Goal是保存车走过的每个点的坐标。刚开始先将起点放进该向量。
    Goal(j,2)=Xj(2);
%调用计算角度模块
   Theta=compute_angle(Xj,Xsum,n);%Theta是计算出来的车和障碍，和目标之间的与X轴之间的夹角，统一规定角度为逆时针方向，用这个模块可以计算出来。
%调用计算引力模块
   Angle=Theta(1);%Theta（1）是车和目标之间的角度，目标对车是引力。
   angle_at=Theta(1);%为了后续计算斥力在引力方向的分量赋值给angle_at
   [Fatx,Faty]=compute_Attract(Xj,Xsum,k,Angle,0,Po,n);%计算出目标对车的引力在x,y方向的两个分量值。
   
    for i=1:n
       angle_re(i)=Theta(i+1);%计算斥力用的角度，是个向量，因为有n个障碍，就有n个角度。
     end
%调用计算斥力模块
    [Frerxx,Freryy,Fataxx,Fatayy]=compute_repulsion(Xj,Xsum,m,angle_at,angle_re,n,Po,a);%计算出斥力在x,y方向的分量数组。
%计算合力和方向，这有问题，应该是数，每个j循环的时候合力的大小应该是一个唯一的数，不是数组。应该把斥力的所有分量相加，引力所有分量相加。
    Fsumyj=Faty+Freryy+Fatayy;%y方向的合力
    Fsumxj=Fatx+Frerxx+Fataxx;%x方向的合力
    Position_angle(j)=atan(Fsumyj/Fsumxj);%合力与x轴方向的夹角向量
%计算车的下一步位置
    Xnext(1)=Xj(1)+l*cos(Position_angle(j));
    Xnext(2)=Xj(2)+l*sin(Position_angle(j));
    %保存车的每一个位置在向量中
    Xj=Xnext;
    %判断
    if ((Xj(1)-Xsum(1,1))>0)&&((Xj(2)-Xsum(1,2))>0)%是应该完全相等的时候算作到达，还是只是接近就可以？现在按完全相等的时候编程。
       K=j;%记录迭代到多少次，到达目标。
       break;
       %记录此时的j值
    end%如果不符合if的条件，重新返回循环，继续执行。
end%大循环结束
K=j;
Goal(K,1)=Xsum(1,1);%把路径向量的最后一个点赋值为目标
Goal(K,2)=Xsum(1,2);
%***********************************画出障碍，起点，目标，路径点*************************
%画出路径
X=Goal(:,1);
Y=Goal(:,2);
%路径向量Goal是二维数组,X,Y分别是数组的x,y元素的集合，是两个一维数组。
hold on
plot( od(:,1),od(:,2),'sk','MarkerSize',6,'MarkerFaceColor','k');
axis([0 60 0 70]);
hold on
plot( X,Y,'dm','MarkerSize',3,'MarkerFaceColor','r');
 axis([0 60 0 70]);


% for i=1:K
% Robot(:,3)=Robot(:,1);
% Robot(:,1)=Robot(:,2);
% Robot(:,2)=Goal(k,:)';
% plot( od(:,1),od(:,2),'sk','MarkerSize',6,'MarkerFaceColor','k');
% axis([-20 80 -20 80]);
% hold on
% plot( Robot(1,:),Robot(2,:),'dm','MarkerSize',8,'MarkerFaceColor','r');
% hold on
% plot([Robot(1,1),Robot(1,2)],[Robot(2,1),Robot(2,2)],'-k','LineWidth',2);
% hold on
% plot([Robot(1,2),Robot(1,3)],[Robot(2,2),Robot(2,3)],'-k','LineWidth',2);
% axis([-20 80 -20 80]);
% pause(0.1);
% hold off
% end

    