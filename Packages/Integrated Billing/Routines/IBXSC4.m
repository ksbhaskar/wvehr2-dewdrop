IBXSC4 ; GENERATED FROM 'IB SCREEN4' INPUT TEMPLATE(#510), FILE 399;08/30/12
 D DE G BEGIN
DE S DIE="^DGCR(399,",DIC=DIE,DP=399,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DGCR(399,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,9) S:%]"" DE(23)=%
 I $D(^("U")) S %Z=^("U") S %=$P(%Z,U,8) S:%]"" DE(7)=% S %=$P(%Z,U,9) S:%]"" DE(6)=% S %=$P(%Z,U,10) S:%]"" DE(5)=% S %=$P(%Z,U,12) S:%]"" DE(11)=% S %=$P(%Z,U,20) S:%]"" DE(3)=%
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
BEGIN S DNM="IBXSC4",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(510,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=510,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S:IBDR20'["41" Y="@42"
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I $P($G(^DGCR(399,DA,0)),U,8) S Y="@411"
 Q
3 S DW="U;20",DV="FXO",DU="",DLB="NON-PTF ADMISSION HOUR",DIFLD=159.5
 S DQ(3,2)="S Y(0)=Y S Y=$S(Y=0:""12AM"",Y<12:Y_""AM"",Y=12:""12PM"",Y=99:Y,1:(Y-12)_""PM"")"
 S X="12AM"
 S Y=X
 G Y
X3 D NOPTF^IBCU
 I $D(X),X'?.ANP K X
 Q
 ;
4 S DQ=5 ;@411
5 S DW="U;10",DV="FX",DU="",DLB="ACCIDENT HOUR",DIFLD=160
 G RE
X5 K:$L(X)>2!($L(X)<1)!(X=99) X
 I $D(X),X'?.ANP K X
 Q
 ;
6 S DW="U;9",DV="S",DU="",DLB="SOURCE OF ADMISSION",DIFLD=159
 S DU="1:PHYSICIAN REFERRAL;2:CLINIC REFERRAL;3:HMO REFERRAL;4:TRANSFER FROM HOSPITAL;5:TRANSFER FROM SKILLED NURSING FAC.;6:TRANSFER FROM OTHER HEALTH CARE FAC.;7:EMERGENCY ROOM;8:COURT/LAW ENFORCEMENT;9:INFO NOT AVAILABLE;"
 G RE
X6 Q
7 S DW="U;8",DV="S",DU="",DLB="TYPE OF ADMISSION",DIFLD=158
 S DU="1:EMERGENCY;2:URGENT;3:ELECTIVE;4:NEWBORN;5:TRAUMA;9:INFORMATION NOT AVAILABLE;"
 G RE
X7 Q
8 S D=0 K DE(1) ;48
 S DIFLD=48,DGO="^IBXSC41",DC="3^399.048P^OT^",DV="399.048M*P399.1'",DW="0;1",DOW="SNF/SA CARE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DGCR(399.1,"
 G RE:D I $D(DSC(399.048))#2,$P(DSC(399.048),"I $D(^UTILITY(",1)="" X DSC(399.048) S D=$O(^(0)) S:D="" D=-1 G M8
 S D=$S($D(^DGCR(399,DA,"OT",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M8 I D>0 S DC=DC_D I $D(^DGCR(399,DA,"OT",+D,0)) S DE(8)=$P(^(0),U,1)
 G RE
R8 D DE
 S D=$S($D(^DGCR(399,DA,"OT",0)):$P(^(0),U,3,4),1:1) G 8+1
 ;
9 S DQ=10 ;@42
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S:IBDR20'["42" Y="@43"
 Q
11 S DW="U;12",DV="*P399.1'",DU="",DLB="DISCHARGE STATUS",DIFLD=162
 S DU="DGCR(399.1,"
 G RE
X11 S DIC("S")="I $P(^DGCR(399.1,+Y,0),""^"",6)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
12 S DQ=13 ;@43
13 S DQ=14 ;@45
14 S DQ=15 ;@46
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S:IBDR20'["46" Y="@47"
 Q
16 S D=0 K DE(1) ;41
 S DIFLD=41,DGO="^IBXSC42",DC="4^399.041IPA^OC^",DV="399.041M*P399.1'",DW="0;1",DOW="OCCURRENCE CODE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DGCR(399.1,"
 G RE:D I $D(DSC(399.041))#2,$P(DSC(399.041),"I $D(^UTILITY(",1)="" X DSC(399.041) S D=$O(^(0)) S:D="" D=-1 G M16
 S D=$S($D(^DGCR(399,DA,"OC",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M16 I D>0 S DC=DC_D I $D(^DGCR(399,DA,"OC",+D,0)) S DE(16)=$P(^(0),U,1)
 G RE
R16 D DE
 S D=$S($D(^DGCR(399,DA,"OC",0)):$P(^(0),U,3,4),1:1) G 16+1
 ;
17 S DQ=18 ;@47
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S:IBDR20'["47" Y="@44"
 Q
19 S D=0 K DE(1) ;40
 S DIFLD=40,DGO="^IBXSC43",DC="1^399.04PA^CC^",DV="399.04M*P399.1'",DW="0;1",DOW="CONDITION CODE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DGCR(399.1,"
 G RE:D I $D(DSC(399.04))#2,$P(DSC(399.04),"I $D(^UTILITY(",1)="" X DSC(399.04) S D=$O(^(0)) S:D="" D=-1 G M19
 S D=$S($D(^DGCR(399,DA,"CC",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M19 I D>0 S DC=DC_D I $D(^DGCR(399,DA,"CC",+D,0)) S DE(19)=$P(^(0),U,1)
 G RE
R19 D DE
 S D=$S($D(^DGCR(399,DA,"CC",0)):$P(^(0),U,3,4),1:1) G 19+1
 ;
20 S DQ=21 ;@44
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 S:IBDR20'["44" Y="@48"
 Q
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 S IBZ20=$P(^DGCR(399,DA,0),U,9)
 Q
23 S DW="0;9",DV="SX",DU="",DLB="PROCEDURE CODING METHOD",DIFLD=.09
 S DU="4:CPT-4;5:HCPCS (HCFA COMMON PROCEDURE CODING SYSTEM);9:ICD-9-CM;"
 G RE
X23 S:X=4 X=5
 Q
 ;
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 S IBPROT=X
 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 D PRO^IBCSC4B
 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S IBASKCOD=1
 Q
27 S DQ=28 ;@48
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 S:IBDR20'["48" Y="@49"
 Q
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 I $P(^DGCR(399,DA,0),U,19)=2 S Y="@49"
 Q
30 S D=0 K DE(1) ;47
 S DIFLD=47,DGO="^IBXSC44",DC="2^399.047PA^CV^",DV="399.047M*P399.1'X",DW="0;1",DOW="VALUE CODE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DGCR(399.1,"
 G RE:D I $D(DSC(399.047))#2,$P(DSC(399.047),"I $D(^UTILITY(",1)="" X DSC(399.047) S D=$O(^(0)) S:D="" D=-1 G M30
 S D=$S($D(^DGCR(399,DA,"CV",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M30 I D>0 S DC=DC_D I $D(^DGCR(399,DA,"CV",+D,0)) S DE(30)=$P(^(0),U,1)
 G RE
R30 D DE
 S D=$S($D(^DGCR(399,DA,"CV",0)):$P(^(0),U,3,4),1:1) G 30+1
 ;
31 S DQ=32 ;@49
32 G 0^DIE17
