IBXS8I6 ; ;08/30/12
 D DE G BEGIN
DE S DIE="^DGCR(399,D0,""PRV"",",DIC=DIE,DP=399.0222,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGCR(399,D0,"PRV",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,5) S:%]"" DE(2)=%,DE(14)=% S %=$P(%Z,U,6) S:%]"" DE(6)=%,DE(18)=% S %=$P(%Z,U,7) S:%]"" DE(10)=%,DE(22)=% S %=$P(%Z,U,12) S:%]"" DE(1)=%,DE(13)=% S %=$P(%Z,U,13) S:%]"" DE(5)=%,DE(17)=%
 I  S %=$P(%Z,U,14) S:%]"" DE(9)=%,DE(21)=%
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
BEGIN S DNM="IBXS8I6",DQ=1
1 S DW="0;12",DV="*P355.97'R",DU="",DLB="PRIM INS PERF PROV SECONDARY ID TYPE",DIFLD=.12
 S DE(DW)="C1^IBXS8I6"
 S DU="IBE(355.97,"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.12)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.12)
C1F1 Q
X1 S DIC("S")="I $$RAINS^IBCEPU(Y)!($$RAOWN^IBCEPU(Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;5",DV="FX",DU="",DLB="PRIM INS PERF PROV SECONDARY ID",DIFLD=.05
 S DE(DW)="C2^IBXS8I6"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.05)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X=Y(0)="SLF000" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399.0222,.05,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.05)
C2F1 Q
X2 I $D(DA) N Z S Z=$G(^DGCR(399,DA(1),"PRV",DA,0)) S:X="/ID" X=$$RECALC^IBCEP2A(.DA,1,$P(Z,U,5)) K:$L(X)>15!'$L(X) X I $D(X),$P(Z,U,2)="",$S($$INPAT^IBCEF(DA(1),1):1,1:X'="SLF000") K X
 I $D(X),X'?.ANP K X
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S Y="@8382"
 Q
4 S DQ=5 ;@8392
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW="0;13",DV="*P355.97'R",DU="",DLB="SECOND INS PERF PROV SECONDARY ID TYPE",DIFLD=.13
 S DE(DW)="C5^IBXS8I6"
 S DU="IBE(355.97,"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.13)
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.13)
C5F1 Q
X5 S DIC("S")="I $$RAINS^IBCEPU(Y)!($$RAOWN^IBCEPU(Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;6",DV="FX",DU="",DLB="SECOND INS PERF PROV SECONDARY ID",DIFLD=.06
 S DE(DW)="C6^IBXS8I6"
 G RE
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.06)
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.06)
C6F1 Q
X6 I $D(DA) N Z S Z=$G(^DGCR(399,DA(1),"PRV",DA,0)) S:X="/ID" X=$$RECALC^IBCEP2A(.DA,2,$P(Z,U,6)) K:$L(X)>15!'$L(X) X I $D(X),$P(Z,U,2)="",$S($$INPAT^IBCEF(DA(1),1):1,1:X'="SLF000") K X
 I $D(X),X'?.ANP K X
 Q
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S Y="@8383"
 Q
8 S DQ=9 ;@8393
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW="0;14",DV="*P355.97'R",DU="",DLB="TERTIARY INS PERF PROV SECONDARY ID TYPE",DIFLD=.14
 S DE(DW)="C9^IBXS8I6"
 S DU="IBE(355.97,"
 G RE
C9 G C9S:$D(DE(9))[0 K DB
 S X=DE(9),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.14)
C9S S X="" G:DG(DQ)=X C9F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.14)
C9F1 Q
X9 S DIC("S")="I $$RAINS^IBCEPU(Y)!($$RAOWN^IBCEPU(Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S DQ=10,DW="0;7",DV="FX",DU="",DLB="TERTIARY INS PERF PROV SECONDARY ID",DIFLD=.07
 S DE(DW)="C10^IBXS8I6"
 G RE
C10 G C10S:$D(DE(10))[0 K DB
 S X=DE(10),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.07)
C10S S X="" G:DG(DQ)=X C10F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.07)
C10F1 Q
X10 I $D(DA) N Z S Z=$G(^DGCR(399,DA(1),"PRV",DA,0)) S:X="/ID" X=$$RECALC^IBCEP2A(.DA,3,$P(Z,U,7)) K:$L(X)>15!'$L(X) X I $D(X),$P(Z,U,2)="",$S($$INPAT^IBCEF(DA(1),1):1,1:X'="SLF000") K X
 I $D(X),X'?.ANP K X
 Q
 ;
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S Y="@8305"
 Q
12 S DQ=13 ;@8371
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="0;12",DV="*P355.97'",DU="",DLB="PRIM INS PROVIDER ID TYPE",DIFLD=.12
 S DE(DW)="C13^IBXS8I6"
 S DU="IBE(355.97,"
 S X=DIPA("PRIDT")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.12)
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.12)
C13F1 Q
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S DQ=14,DW="0;5",DV="FX",DU="",DLB="PRIMARY INS CO ID NUMBER",DIFLD=.05
 S DE(DW)="C14^IBXS8I6"
 S X=DIPA("PRID")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C14 G C14S:$D(DE(14))[0 K DB
 S X=DE(14),DIC=DIE
 ;
 S X=DE(14),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.05)
C14S S X="" G:DG(DQ)=X C14F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X=Y(0)="SLF000" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"PRV",D1,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399.0222,.05,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.05)
C14F1 Q
X14 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S Y="@8382"
 Q
16 S DQ=17 ;@8372
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW="0;13",DV="*P355.97'",DU="",DLB="SEC INS PROVIDER ID TYPE",DIFLD=.13
 S DE(DW)="C17^IBXS8I6"
 S DU="IBE(355.97,"
 S X=DIPA("PRIDT")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C17 G C17S:$D(DE(17))[0 K DB
 S X=DE(17),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.13)
C17S S X="" G:DG(DQ)=X C17F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.13)
C17F1 Q
X17 Q
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW="0;6",DV="FX",DU="",DLB="SECONDARY INS CO ID NUMBER",DIFLD=.06
 S DE(DW)="C18^IBXS8I6"
 S X=DIPA("PRID")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.06)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.06)
C18F1 Q
X18 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S Y="@8383"
 Q
20 S DQ=21 ;@8373
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW="0;14",DV="*P355.97'",DU="",DLB="TERT INS PROVIDER ID TYPE",DIFLD=.14
 S DE(DW)="C21^IBXS8I6"
 S DU="IBE(355.97,"
 S X=DIPA("PRIDT")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C21 G C21S:$D(DE(21))[0 K DB
 S X=DE(21),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.14)
C21S S X="" G:DG(DQ)=X C21F1 K DB
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA(1),DA,.14)
C21F1 Q
X21 Q
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="0;7",DV="FX",DU="",DLB="TERTIARY INS CO ID NUMBER",DIFLD=.07
 S DE(DW)="C22^IBXS8I6"
 S X=DIPA("PRID")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C22 G C22S:$D(DE(22))[0 K DB
 D ^IBXS8I7
C22S S X="" G:DG(DQ)=X C22F1 K DB
 D ^IBXS8I8
C22F1 Q
X22 Q
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 S Y="@8305"
 Q
24 S DQ=25 ;@8305
25 S DQ=26 ;@8399
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 W @IOF
 Q
27 G 1^DIE17
