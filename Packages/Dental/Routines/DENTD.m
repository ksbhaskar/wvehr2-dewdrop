DENTD ;WASH ISC/TJK,JA-SCREEN HANDLER ;6/29/92  14:34 ;12/17/91  9:49 AM
 ;;1.2;DENTAL;***15**;Oct 08, 1992
EN K ^TMP($J,"DJST"),DJST,^TMP($J,"DJ") S:$D(DJSC) X=DJSC
 S Y=$O(^DENT(220.6,"B",X,0)) S:Y="" Y=-1
 I Y<0 W !!,"SCREEN NOT DEFINED",*7 Q
 S DJR=Y,DJR(0)=^DENT(220.6,Y,0),DJZ=$P(DJR(0),"^",6) I '$D(DJZ) S DJZ=$S(DJZ="":"",$D(^DIC(DJZ,0,"GL"))=1:^("GL"),1:"") I DJZ=""!($D(^DENT(220.6,+Y,1))=0) W !,"SCREEN OR GLOBAL NOT DEFINED PROPERLY",*7 H 1 Q
 S DJNM=$P(^DENT(220.6,Y,0),"^",1) G:$D(DJDN) D
RD ;D RL Q:X="^"!(X="")  G RD
RL K V
D D:'$D(DJRJ) ^DENTDPAR Q:'$D(DJRJ)
 I '$D(DJDN) D ^DENTDPL G EXIT1:$D(DJY) D ^DENTDNJ G EXIT1
 I '$D(DJDIS),$D(DJDN) D ^DENTDPL G EXIT1:$D(DJY) S (DA,W(V))=DJDN D ^DENTD1 S DJW=1,DJW1=1 D EN^DENTDNJ G EXIT1
 I $D(DJDIS) D ^DENTDPL G EXIT1:$D(DJY) S (DA,W(V))=DJDN D ^DENTD1 S DJW=1,DJW1=1 D EN^DENTDNJ G EXIT1
 ;
Q ; LOCATE SCREEN
 D:'$D(DJRJ) ^DENTDPAR Q:'$D(DJRJ)
 S DIC("A")="Select Screen Name: ",DIC(0)="AEMQ",DIC="^DENT(220.6," S:DJOP=2 DLAYGO=220.6,DIC(0)=DIC(0)_"L"
 S DIC("S")=$S(DUZ(0)'="@":"I 1 S DJX=$P(^DENT(220.6,+Y,0),""^"",4) F DJK=1:1:$L(DJX) I DUZ(0)[$E(DJX,DJK) Q",1:"I Y") I DJOP=5 S DIC("S")="I $P(^DENT(220.6,+Y,0),""^"",3)="""",'$D(^DD($P(^DENT(220.6,+Y,0),""^"",6),0,""UP"")) "_DIC("S")
 D ^DIC K DIC(0),DLAYGO,DIC("A"),DIC("S") Q:Y<0
 S (X,DJDNM)=$P(Y,U,2) Q
EX K DIC,DJRJ,I,J,K,O,S,X,XY Q
EXIT1 X DJCL W DJLIN K DJLIN,DJCL,DJCP,DJEOP,DJRJ,DJR I $D(IOST),IOST["C-Q" W DJHIN
 K DJHIN
EXIT I $D(X),X=U S DUOUT=""
 K DJJ,C,V,X,Y,DIC,DJQ,DJDPL,DJKV,DJNM,DJW,DIE,DE,DJ,DH,DI,DJDIS,DJW1,DJDN,DJ0,DJAT,DJMU,DJST,DJSC,DJI,DJOP,DWLW,DJLG,DJNN,DJSW2,DIADD
 K D,D0,DA,DJ4,DJ3,DJ2,DJDD,DJDNM,DJERR,DJF,DJL,DJN,DJP,DJRNM,DJT,DJX,DJY,DJZ,DFAST,DU,DENTDC
 K ^TMP($J,"DJST"),DJ5,DJ6,DJ7,DJ9,DJA,DJAD,DJBD,DJD,DJDA,DJDP,DJDUZ,DJFF,DJLSTN,DJSM,DJ44,DJNODE,XY
 K DJ11,DJ01,DJXL,DJXT,DJXX,DJX1,DJX3,DJ8,DX,DY,DJK,DJDIC,DJDICS,W,DJWR,D0,DEDF,DEBDIC
 Q
 ;
