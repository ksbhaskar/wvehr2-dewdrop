ACKQTE ; GENERATED FROM 'ACKQAS VISIT ENTRY' INPUT TEMPLATE(#1338), FILE 509850.6;09/24/12
 D DE G BEGIN
DE S DIE="^ACK(509850.6,",DIC=DIE,DP=509850.6,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ACK(509850.6,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(13)=% S %=$P(%Z,U,5) S:%]"" DE(18)=% S %=$P(%Z,U,8) S:%]"" DE(22)=%
 I $D(^(5)) S %Z=^(5) S %=$P(%Z,U,2) S:%]"" DE(35)=%,DE(40)=% S %=$P(%Z,U,3) S:%]"" DE(44)=% S %=$P(%Z,U,4) S:%]"" DE(50)=% S %=$P(%Z,U,5) S:%]"" DE(55)=% S %=$P(%Z,U,8) S:%]"" DE(10)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="ACKQTE",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(1338,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=1338,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 I $G(ACKVISIT)'="NEW",$G(ACKVISIT)'="EDIT" W !!,"This option must only be run from QUASAR" S Y="@999"
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 D SETUP^ACKQUTL4
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 D HLOSS^ACKQUTL4
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S ACKCP=$$ACKCP^ACKQUTL4
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S ACKCPNO=$S(+ACKCP=0:"",1:$P(ACKCP,U,2)),ACKCP=+ACKCP
 Q
6 S DQ=7 ;@10
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 D EN^ACKQUTL7
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I $D(ACKDIRUT) S Y="@999"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I $$TIMECHEK^ACKQASU5(ACKVIEN,1) S Y="@15"
 Q
10 S DW="5;8",DV="RFXO",DU="",DLB="APPOINTMENT TIME",DIFLD=55
 S DQ(10,2)="S Y(0)=Y Q:'$D(Y)  S Y=$TR(Y,""."",""""),Y=$$FMT^ACKQUTL6(Y)"
 S DE(DW)="C10^ACKQTE"
 G RE
C10 G C10S:$D(DE(10))[0 K DB
 S X=DE(10),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
 S X=DE(10),DIC=DIE
 X "D KILLREF^ACKQUTL5(X,DA,""T"")"
C10S S X="" G:DG(DQ)=X C10F1 K DB
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
 S X=DG(DQ),DIC=DIE
 X "D SETREF^ACKQUTL5(X,DA,""T"")"
C10F1 Q
X10 K:$L(X)>8!($L(X)<1) X I $D(X) S X=$$DATACHEK^ACKQUTL6(X,DA) K:'X X I $D(X) I '$$DUPECHK^ACKQUTL6(X,DA,$G(ACKPAT)) S ACKITME=X K X
 I $D(X),X'?.ANP K X
 Q
 ;
11 S DQ=12 ;@15
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I ACKVISIT="EDIT" S Y="@16"
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="0;2",DV="RP509850.2X",DU="",DLB="PATIENT NAME",DIFLD=1
 S DE(DW)="C13^ACKQTE"
 S DU="ACK(509850.2,"
 S X=ACKPAT
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(509850.6,1,1,1,2.4)
 S X=DE(13),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(509850.6,1,1,2,2.4)
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"APT",$E(X,1,30),DA)
 S X=DE(13),DIC=DIE
 ;
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"APD",X,+^ACK(509850.6,DA,0),DA)
 S X=DE(13),DIC=DIE
 K ^ACK(509850.6,"C",$E(X,1,30),DA)
 S X=DE(13),DIC=DIE
 X "D KILLREF^ACKQUTL5(X,DA,""P"")"
 S X=DE(13),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(509850.6,1,1,1,1.1) X ^DD(509850.6,1,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X=DIV D AOA^ACKQAS X ^DD(509850.6,1,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"APT",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(509850.6,1,1,4,89.2) S X=$P(Y(101),U,2) S D0=I(0,0) S DIU=X K Y S X=DIV D IVD^ACKQAS X ^DD(509850.6,1,1,4,1.4)
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"APD",X,+^ACK(509850.6,DA,0),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"C",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "D SETREF^ACKQUTL5(X,DA,""P"")"
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C13F1 Q
X13 Q
14 S DQ=15 ;@16
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 S I(0,0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"")
 S DGO="^ACKQTE1",DC="^509850.2^ACK(509850.2," G DIEZ^DIE0
R15 D DE G A
 ;
16 S DQ=17 ;@30
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I ACKCP=0 S Y="@40"
 Q
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW="0;5",DV="S",DU="",DLB="Is this a C&P Visit ?",DIFLD=2.5
 S DE(DW)="C18^ACKQTE"
 S DU="0:NO;1:YES;"
 S Y="YES"
 G Y
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV D TRIGCP^ACKQUTL X ^DD(509850.6,2.5,1,1,2.4)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV D TRIGCP^ACKQUTL X ^DD(509850.6,2.5,1,1,1.4)
C18F1 Q
X18 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S ACKCP=X
 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S:'ACKCP Y="@40"
 Q
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 S:ACKCPNO="" Y="@40"
 Q
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="0;8",DV="F",DU="",DLB="LINKED C&P EXAM",DIFLD=.08
 S DE(DW)="C22^ACKQTE"
 S X=$S(ACKCPNO'="":ACKCPNO,1:"")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C22 G C22S:$D(DE(22))[0 K DB
 S X=DE(22),DIC=DIE
 K ^ACK(509850.6,"ALCP",$E(X,1,30),DA)
C22S S X="" G:DG(DQ)=X C22F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"ALCP",$E(X,1,30),DA)=""
C22F1 Q
X22 Q
23 S DQ=24 ;@40
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 D DIAGDIS^ACKQUTL4
 Q
25 D:$D(DG)>9 F^DIE17,DE S DQ=25,D=0 K DE(1) ;3
 S DIFLD=3,DGO="^ACKQTE2",DC="5^509850.63PA^1^",DV="509850.63M*P509850.1'X",DW="0;1",DOW="DIAGNOSTIC CODE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="ACK(509850.1,"
 G RE:D I $D(DSC(509850.63))#2,$P(DSC(509850.63),"I $D(^UTILITY(",1)="" X DSC(509850.63) S D=$O(^(0)) S:D="" D=-1 G M25
 S D=$S($D(^ACK(509850.6,DA,1,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M25 I D>0 S DC=DC_D I $D(^ACK(509850.6,DA,1,+D,0)) S DE(25)=$P(^(0),U,1)
 G RE
R25 D DE
 S D=$S($D(^ACK(509850.6,DA,1,0)):$P(^(0),U,3,4),1:1) G 25+1
 ;
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 IF $O(^ACK(509850.6,ACKVIEN,1,0))="" WRITE !!,"You must enter at least one Diagnosis" S Y="@40"
 Q
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 I '$$POSTDIAG^ACKQASU5(ACKVIEN) S Y="@40"
 Q
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 D HLOSS^ACKQUTL4
 Q
29 S DQ=30 ;@50
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 W @IOF
 Q
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 I ACKPCE'=1 S Y="@100"
 Q
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 I ACKSC=0 D CLASDIS^ACKQNQ S Y="@55"
 Q
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 D PATDIS^ACKQUTL4
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 D ELIGDIS^ACKQUTL4
 Q
35 S DW="5;2",DV="R*P8'",DU="",DLB="Enter the Eligibility for this Appointment",DIFLD=80
 S DE(DW)="C35^ACKQTE"
 S DU="DIC(8,"
 S X=ACKELIG
 S Y=X
 G Y
C35 G C35S:$D(DE(35))[0 K DB
 S X=DE(35),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C35S S X="" G:DG(DQ)=X C35F1 K DB
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C35F1 Q
X35 S DIC("S")="I $D(ACKELDIS(Y))",DIC("W")="W """"" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 S ACKELIG=$S(ACKPCE'=1:"",ACKELGCT=1:ACKELIG,1:X)
 Q
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 S Y="@60"
 Q
38 S DQ=39 ;@55
39 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=39 D X39 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X39 I $$GET1^DIQ(509850.6,ACKVIEN_",",80,"I")=ACKELIG1 S Y="@60"
 Q
40 D:$D(DG)>9 F^DIE17,DE S DQ=40,DW="5;2",DV="R*P8'",DU="",DLB="VISIT ELIGIBILITY",DIFLD=80
 S DE(DW)="C40^ACKQTE"
 S DU="DIC(8,"
 S X=ACKELIG1
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C40 G C40S:$D(DE(40))[0 K DB
 S X=DE(40),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C40S S X="" G:DG(DQ)=X C40F1 K DB
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C40F1 Q
X40 Q
41 S DQ=42 ;@60
42 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=42 D X42 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X42 I ACKPCE'=1 S Y="@100"
 Q
43 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=43 D X43 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X43 I ACKSC=0 S Y="@70"
 Q
44 D:$D(DG)>9 F^DIE17,DE S DQ=44,DW="5;3",DV="RS",DU="",DLB="Was care for SC Condition ?",DIFLD=20
 S DE(DW)="C44^ACKQTE"
 S DU="0:NO;1:YES;"
 S X=""
 S Y=X
 G Y
C44 G C44S:$D(DE(44))[0 K DB
 S X=DE(44),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C44S S X="" G:DG(DQ)=X C44F1 K DB
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C44F1 Q
X44 Q
45 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=45 D X45 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X45 I ACKPCE'=1 S Y="@100"
 Q
46 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=46 D X46 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X46 S ACKSC=$S(ACKSC=0:0,X=1:2,1:1)
 Q
47 S DQ=48 ;@70
48 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=48 D X48 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X48 I ACKAO=0 S Y="@80"
 Q
49 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=49 D X49 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X49 I ACKSC=2 S Y="@90"
 Q
50 D:$D(DG)>9 F^DIE17,DE S DQ=50,DW="5;4",DV="RS",DU="",DLB="Was care related to AO Exposure ?",DIFLD=25
 S DE(DW)="C50^ACKQTE"
 S DU="0:NO;1:YES;"
 S X=""
 S Y=X
 G Y
C50 G C50S:$D(DE(50))[0 K DB
 S X=DE(50),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C50S S X="" G:DG(DQ)=X C50F1 K DB
 D ^ACKQTE3
C50F1 Q
X50 Q
51 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=51 D X51 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X51 S ACKAO=$S(ACKAO=0:0,ACKSC'=1:ACKAO,X=1:2,1:1)
 Q
52 S DQ=53 ;@80
53 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=53 D X53 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X53 I ACKRAD=0 S Y="@85"
 Q
54 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=54 D X54 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X54 I ACKSC=2 S Y="@90"
 Q
55 D:$D(DG)>9 F^DIE17,DE S DQ=55,DW="5;5",DV="RS",DU="",DLB="Was care related to IR Exposure ?",DIFLD=30
 S DE(DW)="C55^ACKQTE"
 S DU="0:NO;1:YES;"
 S X=""
 S Y=X
 G Y
C55 G C55S:$D(DE(55))[0 K DB
 D ^ACKQTE4
C55S S X="" G:DG(DQ)=X C55F1 K DB
 D ^ACKQTE5
C55F1 Q
X55 Q
56 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=56 D X56 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X56 S ACKRAD=$S(ACKRAD=0:0,ACKSC'=1:ACKRAD,X=1:2,1:1)
 Q
57 S DQ=58 ;@85
58 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=58 D X58 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X58 I ACKENV=0 S Y="@90"
 Q
59 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=59 D X59 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X59 I ACKSC=2 S Y="@90"
 Q
60 D:$D(DG)>9 F^DIE17 G ^ACKQTE6
