DGX5F5 ; ;08/30/12
 D DE G BEGIN
DE S DIE="^DGPT(D0,""M"",",DIC=DIE,DP=45.02,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGPT(D0,"M",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,26) S:%]"" DE(7)=%,DE(10)=% S %=$P(%Z,U,27) S:%]"" DE(13)=%,DE(16)=% S %=$P(%Z,U,28) S:%]"" DE(19)=%,DE(22)=% S %=$P(%Z,U,29) S:%]"" DE(31)=%,DE(34)=% S %=$P(%Z,U,30) S:%]"" DE(37)=%,DE(41)=%
 I  S %=$P(%Z,U,31) S:%]"" DE(1)=%,DE(4)=% S %=$P(%Z,U,32) S:%]"" DE(25)=%,DE(28)=%
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
BEGIN S DNM="DGX5F5",DQ=1
1 S DW="0;31",DV="S",DU="",DLB="WAS TREATMENT RELATED TO COMBAT?",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="YES"
 G Y
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S Y="@905"
 Q
3 S DQ=4 ;@904
4 S DW="0;31",DV="S",DU="",DLB="POTENTIALLY RELATED TO COMBAT",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X4 Q
5 S DQ=6 ;@905
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 I '$D(DGEXQ(1)) S Y="@910"
 Q
7 S DW="0;26",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO AGENT ORANGE EXPOSURE?",DIFLD=26
 S DU="Y:YES;N:NO;"
 G RE
X7 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S Y="@915"
 Q
9 S DQ=10 ;@910
10 S DW="0;26",DV="SX",DU="",DLB="TREATED FOR AO CONDITION",DIFLD=26
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X10 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
11 S DQ=12 ;@915
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I '$D(DGEXQ(2)) S Y="@920"
 Q
13 S DW="0;27",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO IONIZING RADIATION EXPOSURE?",DIFLD=27
 S DU="Y:YES;N:NO;"
 G RE
X13 S DGFLAG=2 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S Y="@925"
 Q
15 S DQ=16 ;@920
16 S DW="0;27",DV="SX",DU="",DLB="TREATED FOR IR CONDITION",DIFLD=27
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X16 S DGFLAG=2 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
17 S DQ=18 ;@925
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 I '$D(DGEXQ(3)) S Y="@930"
 Q
19 S DW="0;28",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO SERVICE IN SW ASIA?",DIFLD=28
 S DU="Y:YES;N:NO;"
 G RE
X19 S DGFLAG=3 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S Y="@935"
 Q
21 S DQ=22 ;@930
22 S DW="0;28",DV="SX",DU="",DLB="EXPOSED TO SW ASIA CONDITIONS",DIFLD=28
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X22 S DGFLAG=3 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
23 S DQ=24 ;@935
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 I '$D(DGEXQ(7)) S Y="@940"
 Q
25 S DW="0;32",DV="S",DU="",DLB="WAS TREATMENT RELATED TO PROJ 112/SHAD?",DIFLD=32
 S DU="Y:YES;N:NO;"
 G RE
X25 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S Y="@945"
 Q
27 S DQ=28 ;@940
28 S DW="0;32",DV="S",DU="",DLB="TREATMENT FOR SHAD",DIFLD=32
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X28 Q
29 S DQ=30 ;@945
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 I '$D(DGEXQ(4)) S Y="@950"
 Q
31 S DW="0;29",DV="S",DU="",DLB="WAS TREATMENT RELATED TO MILITARY SEXUAL TRAUMA?",DIFLD=29
 S DU="Y:YES;N:NO;"
 G RE
X31 Q
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 S Y="@955"
 Q
33 S DQ=34 ;@950
34 S DW="0;29",DV="S",DU="",DLB="TREATMENT FOR MST",DIFLD=29
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X34 Q
35 S DQ=36 ;@955
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 I '$D(DGEXQ(5)) S Y="@960"
 Q
37 S DW="0;30",DV="S",DU="",DLB="WAS TREATMENT RELATED TO HEAD AND/OR NECK CANCER?",DIFLD=30
 S DU="Y:YES;N:NO;"
 G RE
X37 Q
38 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=38 D X38 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X38 I X["Y",$D(DFN),$$FILEHNC^DGNTAPI1(DFN)
 Q
39 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=39 D X39 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X39 S Y="@965"
 Q
40 S DQ=41 ;@960
41 S DW="0;30",DV="S",DU="",DLB="TREATMENT FOR HEAD/NECK CA",DIFLD=30
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X41 Q
42 S DQ=43 ;@965
43 S DQ=44 ;@999
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 K DGEXQ S Y=DGNFLD
 Q
45 G 1^DIE17
