FHMADM2A ; HISC/RTK - Calculate Multidiv NPO/Trays for Served Meals ;10/15/03  14:03
 ;;5.5;DIETETICS;;Jan 28, 2005
EN1 ; Calculate NPO/Trays
 F FHCOMM=0:0 S FHCOMM=$O(^FH(119.73,FHCOMM)) Q:FHCOMM'>0  D FHMULT
 Q
FHMULT ;
 D NOW^%DTC S NOW=%,DT=NOW\1,(TP,TC,TE,N,R)=0 F K=1:1:5 S S(K)=0
 I $G(^FH(119.73,FHCOMM,"I"))="Y" Q
 S FHZZ=$O(^FH(117,DT,2,"B",FHCOMM,"")) I FHZZ="" D
 .S Y=FHCOMM K DIC,DO S DA(1)=DT,DIC="^FH(117,"_DA(1)_",2,"
 .S DIC(0)="L",DIC("P")=$P(^DD(117,6,0),U,2),X=+Y
 .D FILE^DICN I Y=-1 Q
 S FHZZ=$O(^FH(117,DT,2,"B",FHCOMM,"")) I FHZZ="" Q
 F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD'>0  S FHWRDCM=$P($G(^FH(119.6,WRD,0)),U,8) Q:FHWRDCM'=FHCOMM  F FHDFN=0:0 S FHDFN=$O(^FHPT("AW",WRD,FHDFN)) Q:FHDFN=""  S ADM=^FHPT("AW",WRD,FHDFN) D CNT
 I '$D(^FH(117,DT,0)) S ^FH(117,DT,0)=DT,^FH(117,"B",DT,DT)="",X0=^FH(117,0),$P(^FH(117,0),"^",3,4)=DT_"^"_($P(X0,"^",4)+1)
 S MD=N-R
 S $P(^FH(117,DT,2,FHZZ,0),"^",20,28)=(3*TC)_"^"_(TP-TE*3)_"^"_S(1)_"^"_S(2)_"^"_S(3)_"^"_S(4)_"^"_S(5)_"^"_MD_"^"_N
 K %,%H,%I,A1,ADM,FHDFN,DFN,FHORD,K,MD,N,NOW,R,S,TC,TE,TP,TYP,WRD
 K X0,X1,Y0,ZZ Q
CNT ;
 Q:'ADM  S TP=TP+1 Q:'$D(^FHPT(FHDFN,"A",ADM,0))
 S X5=$O(^FHPT(FHDFN,"S",0)) I X5 S X5=$G(^(X5,0))
 I  I $P(X5,"^",1)<$P($G(^FHPT(FHDFN,"A",ADM,0)),"^",1) S X5=5,S(X5)=S(X5)+1 G C1
 S X5=$P(X5,"^",2) S:X5=""!(X5>4) X5=5 S S(X5)=S(X5)+1
C1 S X0=^FHPT(FHDFN,"A",ADM,0)
 S FHORD=$P(X0,"^",2),X1=$P(X0,"^",3),ZZ=$P(X0,"^",5) Q:'FHORD
 S Y0=$G(^FHPT(FHDFN,"A",ADM,"DI",FHORD,0)) Q:Y0=""
 S FHOR=$P(Y0,"^",2,6),FHLD=$P(Y0,"^",7)
 I FHLD'="" Q:ZZ=""  S N=N+1 Q
 S Z=$P(Y0,"^",13) Q:Z=""  S TE=TE+1,TYP=$P(Y0,"^",8) S:TYP="C" TC=TC+1 S N=N+1
 I "1^^^^"[FHOR S R=R+1
 Q
