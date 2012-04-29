PSOBKDED ;BIR/SAB - Edit backdoor Rx Order entry ;04/17/95
 ;;7.0;OUTPATIENT PHARMACY;**11,46,91,78,99,117,133,143,268**;DEC 1997;Build 9
 ;Ref PS(50.607 IA 2221
 ;Ref PS(50.7 IA 2223
 ;Ref PS(51.2 IA 2226
 ;Ref PSDRUG( IA 221
 ;Ref DOSE^PSSORPH IA 3234
 ;Ref PS(55 IA 2228
1 S %DT="AEX",%DT(0)=-PSONEW("FILL DATE"),Y=PSONEW("ISSUE DATE") X ^DD("DD") S %DT("A")="ISSUE DATE: ",%DT("B")=Y D ^%DT
 I "^"[$E(X) D KX K %DT Q
 G:Y=-1 1 S (PSOID,PSONEW("ISSUE DATE"))=Y D KX K %DT
 Q
2 S PSONEW("FLD")=2 D FILLDT^PSODIR2(.PSONEW) ;Fdt
 Q
3 S:$G(POERR) PSONEW("ISSUE DATE")=PSOID
 S PSONEW("FLD")=3 D PTSTAT^PSODIR1(.PSONEW) ;Sta
 Q
4 S PSONEW("FLD")=4 D PROV^PSODIR(.PSONEW) ;Pro
 Q
5 S PSONEW("FLD")=5 D CLINIC^PSODIR2(.PSONEW) ;Cli
 Q
6 S PSONEW("FLD")=6 D ^PSODRG,EN^PSODIAG ;Drg/ICD
 D 6^PSODRGN
 Q
7 S PSONEW("FLD")=7 D QTY^PSODIR1(.PSONEW) ;Qty
 Q
8 S PSONEW("FLD")=8 D DAYS^PSODIR1(.PSONEW) ;Day
 K PSMAX,PSTMAX D REF^PSOORNEW S PSONEW("N# REF")=PSONEW("# OF REFILLS")
 Q
9 S PSONEW("FLD")=9 D REFILL^PSODIR1(.PSONEW) ;Ref
 K PSMAX,PSTMAX
 Q
10 S PSONEW("FLD")="3A" D DOSE^PSODIR(.PSONEW) ;Dose
 Q
 ;
 Q  I $G(COPY),$G(SIGOK) S PSOFDR=1 K PSONEW("SIG")
 S PSONEW("FLD")=10 D SIG^PSODIR1(.PSONEW) ;Sig
 I $G(COPY) K PSOFDR
 S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR D KV
 Q
INS S PSONEW("FLD")="3B" D INS^PSODIR(.PSONEW) ;Ins
 Q
11 S PSONEW("FLD")=11 D COPIES^PSODIR1(.PSONEW) ;Cop
 Q
12 S PSONEW("FLD")=12 D MW^PSODIR2(.PSONEW) ;M/W
 Q
13 S PSONEW("FLD")=13 D RMK^PSODIR2(.PSONEW) ;Rem
 Q
DOSE ;backdoor
 I '$G(PSONEW("ENT")) S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (5) Dosage Ordered: " G INS1
 S SD=1 F I=1:1:PSONEW("ENT") D
 .I '$G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Verb: "_$G(PSONEW("VERB",I))
 .S:$G(SD)=1 IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (5)",DS=1 K SD
 .D DOSE1
INS1 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (6)Pat Instruction:"
INS2 I $O(PSONEW("SIG",0)) F D=0:0 S D=$O(PSONEW("SIG",D)) Q:'D  D
 .F SG=1:1:$L(PSONEW("SIG",D)) S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(PSONEW("SIG",D)," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",21)=" " D
 ..S:$P(PSONEW("SIG",D)," ",SG)'="" ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(PSONEW("SIG",D)," ",SG)
 I $P($G(^PS(55,PSODFN,"LAN")),"^") D  Q
 .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" Other Patient Inst.: "
 .I $G(^PSRX(+$G(PSONEW("OIRXN")),"INSS"))]"" S PSONEW("SINS")=^PSRX(PSONEW("OIRXN"),"INSS")
 .S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_$G(PSONEW("SINS"))
 Q
 ;
DOSE1 I $G(DS)=1 D  K DS G DU
 .S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_" Dosage Ordered: "_$S($E(PSONEW("DOSE",I),1)="."&($G(PSONEW("DOSE ORDERED",I))):"0",1:"")_PSONEW("DOSE",I)_$S($G(PSONEW("UNITS",I))'="":" ("_$P(^PS(50.607,PSONEW("UNITS",I),0),"^")_")",1:"")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="      Dosage Ordered: "_$S($E(PSONEW("DOSE",I),1)="."&($G(PSONEW("DOSE ORDERED",I))):"0",1:"")_PSONEW("DOSE",I)_$S($G(PSONEW("UNITS",I))'="":" ("_$P(^PS(50.607,PSONEW("UNITS",I),0),"^")_")",1:"")
DU I '$G(PSONEW("DOSE ORDERED",I)),$P($G(^PS(55,PSODFN,"LAN")),"^") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="   Oth. Lang. Dosage: "_$G(PSONEW("ODOSE",I))
 I $G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Verb: "_$G(PSONEW("VERB",I))
 S:$G(PSONEW("DOSE ORDERED",I)) IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="      Dispense Units: "_$S($E($G(PSONEW("DOSE ORDERED",I)),1)=".":"0",1:"")_$G(PSONEW("DOSE ORDERED",I))
 I $G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("NOUN",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Noun: "_PSONEW("NOUN",I)
 I $G(PSONEW("ROUTE",I)) S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Route: "_$P(^PS(51.2,PSONEW("ROUTE",I),0),"^")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="            Schedule: "_PSONEW("SCHEDULE",I)
 I $G(PSONEW("DURATION",I))]"" D
 .S IEN=IEN+1
 .S ^TMP("PSOPO",$J,IEN,0)="           *Duration: "_PSONEW("DURATION",I)_" ("_$S(PSONEW("DURATION",I)["M":"MINUTES",PSONEW("DURATION",I)["W":"WEEKS",PSONEW("DURATION",I)["L":"MONTHS",PSONEW("DURATION",I)["H":"HOURS",1:"DAYS")_")"
 I $G(PSONEW("CONJUNCTION",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="         Conjunction: "_$S($G(PSONEW("CONJUNCTION",I))="A":"AND",$G(PSONEW("CONJUNCTION",I))="T":"THEN",$G(PSONEW("CONJUNCTION",I))="X":"EXCEPT",1:"")
 Q
RTE I $G(DRET) S PSORXED("ROUTE",ENT)=""
 I $G(RTE) K RTE
 K DIR,DIRUT S DIR(0)="FO^2:45",DIR("A")="ROUTE",DIR("?")="^D HLP^PSOORED4"
 S DIR("B")=$S($G(PSORXED("ROUTE",ENT)):$P(^PS(51.2,PSORXED("ROUTE",ENT),0),"^"),$G(RTE)]"":RTE,$G(DRET):"",1:"PO") K:DIR("B")="" DIR("B")
 ;I '$G(PSORXED("ROUTE",ENT)),$G(PSOREEDT) K DIR("B")
 D ^DIR I X[U,$L(X)>1 S FIELD="RTE",JUMP=1 K DIRUT,DTOUT Q
 Q:$D(DTOUT)!($D(DUOUT))
 I X="@"!(X="") K RTE,ERTE S DRET=1,PSORXED("ROUTE",ENT)="" Q
 K DRET I X=$P($G(^PS(51.2,+$G(PSORXED("ROUTE",ENT)),0)),"^") S RTE=$P(^PS(51.2,PSORXED("ROUTE",ENT),0),"^") W X_" "_$G(ERTE) Q
 S DIC=51.2,DIC(0)="QEZM",DIC("S")="I $P(^(0),""^"",4)" D ^DIC Q:X[U  G:Y=-1 RTE W "  "_$P(Y(0),"^",2)
 S:X'="" PSORXED("ROUTE",ENT)=+Y,RTE=Y(0,0),ERTE=$P(Y(0),"^",2)
 Q
ASK K JUMP,UNITN,DOSE D KV D DOSE^PSSORPH(.DOSE,PSODRUG("IEN"),"O",PSODFN)
 I $D(DOSE("DD")) I $G(PSOFROM)="PENDING"!($G(PSOREEDQ)) D LST2^PSOBKDE1 G ASK1
 D:$G(PSOFROM)="NEW"&($G(PSORX("EDIT"))']"")!($G(PSOFROM1))!($G(COPY)) LST^PSOBKDE1:$O(DOSE(0))
ASK1 S STRE=$P($G(DOSE("DD",PSODRUG("IEN"))),"^",5),UNITN=$P($G(DOSE("DD",PSODRUG("IEN"))),"^",6),DOSE("LD")=$P($G(DOSE("DD",PSODRUG("IEN"))),"^",11)
 W ! S DIR(0)="F^1:60",DIR("A",1)="Select from list of Available Dosages, Enter Free Text Dose",DIR("?")="^D LST1^PSOBKDE1",DIR("A")="or Enter a Question Mark (?) to view list"
 I $G(PSORXED("DOSE",ENT))]"" S DIR("B")=PSORXED("DOSE",ENT) D
 .I $G(PSORXED("UNITS",ENT))]"",DIR("B")'[($P($G(^PS(50.607,PSORXED("UNITS",ENT),0)),"^")) S DIR("B")=DIR("B")_$P($G(^PS(50.607,PSORXED("UNITS",ENT),0)),"^")
 K:$G(PSOREEDQ)!($G(PSOBDRG)) DIR("B")
 D ^DIR
 I X[U,$L(X)>1 S FIELD="ASK",JUMP=1 K DIRUT,DTOUT Q
 I $D(DIRUT) S:$G(ORD) PSODSPL=1 Q
 I X=$G(PSORXED("DOSE",ENT)),$D(DOSE(Y)) G GD1
 I X=$G(PSORXED("DOSE",ENT)) D  G DOS
 .S DOSE=X,UNITS=$G(PSORXED("UNITS",ENT))
 .I DOSE'?.N&(DOSE'?.N1".".N)!'DOSE("LD") S (UNITN,UNITS,PSORXED("UNITS",ENT))="" K PSORXED("DOSE ORDERED",ENT),DUPD,PSORXED("NOUN",ENT)
GD1 N PSORXTE
 I $D(DOSE(Y)) D  G DOS ;from list
 .S DOSE=$S($P(DOSE(Y),"^"):$P(DOSE(Y),"^"),$P(DOSE(Y),"^",3)]"":$P(DOSE(Y),"^",3),1:1),DOLST=Y
 .I $P(DOSE(Y),"^") S UNITS=$P(DOSE(Y),"^",2),DUPD=$P(DOSE(Y),"^",3),UNITN=$P(DOSE("DD",PSODRUG("IEN")),"^",6),PSORXTE("DOSE ORDERED",ENT)=DUPD
 .S PSORXTE("NOUN",ENT)=$P(DOSE(Y),"^",6),PSORXTE("VERB",ENT)=$P(DOSE(Y),"^",8)
 .I DOSE'?.N&(DOSE'?.N1".".N)!'DOSE("LD") D  Q
 ..S (UNITN,UNITS,PSORXED("UNITS",ENT))="" K PSORXED("DOSE ORDERED",ENT),DUPD,PSORXED("NOUN",ENT)
 ..I $P($G(^PS(55,PSODFN,"LAN")),"^"),$G(PSOFROM)="PENDING" D LAN^PSOORED5 Q
 ..I $P($G(^PS(55,PSODFN,"LAN")),"^"),$G(PSOFROM)="NEW" D LAN^PSOORED5
 .S PSORXTE("UNITS",ENT)=$G(UNITS)
 S DOSE=Y,DOLST=0 ;non-numeric and numeric not in list
 I DOSE("LD") D
 .F I=1:1:$L(DOSE)  I $E(DOSE,I)'?.N&($E(DOSE,I)'?1" ")&($E(DOSE,I)'?1".") S DCHK=$G(DCHK)_$E(DOSE,I)
 .I $G(DCHK)]"" D
 ..S DCHK=$TR(DCHK,"qwertyuioplkjhgfdsazxcvbnm","QWERTYUIOPLKJHGFDSAZXCVBNM")
 ..I DCHK=UNITN S DOSE=+DOSE
 K I,DCHK
 S PSOINDT=$$GET1^DIQ(50,PSODRUG("IEN"),100,"I") I PSOINDT,DT>PSOINDT G DOS
 S PSORXTE("NOUN",ENT)=$P(DOSE("DD",PSODRUG("IEN")),"^",9),PSORXTE("VERB",ENT)=$P(DOSE("DD",PSODRUG("IEN")),"^",10)
 I DOSE'?.N&(DOSE'?.N1".".N)!'DOSE("LD") S (UNITN,UNITS,PSORXED("UNITS",ENT))="" K PSORXED("NOUN",ENT),PSORXED("ODOSE",ENT) G DOS
 S:$P(DOSE("DD",PSODRUG("IEN")),"^",6)]"" (PSORXTE("UNITS",ENT),UNITS)=$O(^PS(50.607,"B",$P(DOSE("DD",PSODRUG("IEN")),"^",6),0)),UNITN=$P(DOSE("DD",PSODRUG("IEN")),"^",6)
 S:$P(DOSE("DD",PSODRUG("IEN")),"^",5) DUPD=DOSE/$P(DOSE("DD",PSODRUG("IEN")),"^",5),PSORXTE("DOSE ORDERED",ENT)=DUPD
DOS W " "_$S($E(DOSE,1)="."&($G(UNITN)'=""):"0",1:"")_DOSE W:$G(UNITN)'="" UNITN
 W ! K DIR,DIRUT S DIR(0)="Y",DIR("A")="You entered "_$S($E(DOSE,1)="."&($G(UNITN)'=""):"0",1:"")_DOSE_$S($G(UNITN)'="":UNITN,1:"")_" is this correct",DIR("B")="Yes"
 D ^DIR I 'Y D KX K DOSE,UNITS,PSORXTE,PSOINDT G ASK
 S PSORXED("DOSE",ENT)=DOSE
 S:$G(PSORXTE("DOSE ORDERED",ENT))]"" PSORXED("DOSE ORDERED",ENT)=PSORXTE("DOSE ORDERED",ENT)
 S:$G(PSORXTE("NOUN",ENT))]"" PSORXED("NOUN",ENT)=PSORXTE("NOUN",ENT)
 S:$G(PSORXTE("VERB",ENT))]"" PSORXED("VERB",ENT)=PSORXTE("VERB",ENT)
 S:$G(PSORXTE("UNITS",ENT))]"" PSORXED("UNITS",ENT)=PSORXTE("UNITS",ENT)
 I $G(PSORXED("DOSE",ENT))'?.N&($G(PSORXED("DOSE",ENT))'?.N1".".N)!'DOSE("LD"),$P($G(^PS(55,PSODFN,"LAN")),"^") D
 .K OTHDOS(ENT) D KX S DIR(0)="52.0113,9"
 .I '$G(OTHDOS(ENT)),$G(PSORXED("ODOSE",ENT))']"" D LAN^PSOORED5
 .I $G(PSORXED("ODOSE",ENT))]"" S DIR("B")=PSORXED("ODOSE",ENT) K:DIR("B")="" DIR("B")
 .K DTOUT,DUOUT,DIRUT,Y,X D ^DIR K DIR K:$G(X)="@"!($G(X)="") DIRUT I $D(DIRUT) Q
 .I X="@" S OTHDOS(ENT)=1 D KX K PSORXED("ODOSE",ENT) Q
 .S:X'="" PSORXED("ODOSE",ENT)=X
 Q
 ;
SCH D KX
 S DIR("?")="^D SCHLP^PSOORED4",DIR("A")="Schedule: ",DIR(0)="FA^1:20^I X[""""""""!(X?.E1C.E)!($A(X)=45)!($L(X,"" "")>3)!($L(X)>20)!($L(X)<1) K X"
 I '$D(PSOSCH),'$D(PSORXED("SCHEDULE",ENT)),$P(^PS(50.7,PSODRUG("OI"),0),"^",8)]"" S PSOSCH=$P(^PS(50.7,PSODRUG("OI"),0),"^",8)
 S DIR("B")=$S($D(PSOSCH)&('$D(PSORXED("SCHEDULE",ENT))):PSOSCH,$G(PSORXED("SCHEDULE",ENT))]"":PSORXED("SCHEDULE",ENT),1:"") K:DIR("B")="" DIR("B")
 I $G(PSORXED("SCHEDULE",ENT))']"",$G(PSOREEDT) K DIR("B")
 D ^DIR
 Q
KX K X,Y
KV K DTOUT,DUOUT,DIR,DIRUT
 Q
