PSOORFI4        ;BIR/SAB-CPRS order checks and display con't ;11:49 AM  3 Jan 2010
        ;;7.0;OUTPATIENT PHARMACY;**46,74,78,99,117,131,207,258,274,300,208**;DEC 1997;Build 59;WorldVistA 30-June-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;External reference to ^PS(51.2 supported by DBIA 2226
        ;External reference to ^PS(50.607 supported by DBIA 2221
        ;External reference ^PS(55 supported by DBIA 2228
        ;External reference to ^PS(50.7 is supported by DBIA 2223
        ;
ORCHK   D ORCHK^PSOORNE6
        Q
INST    ;displays patient instructions
        I $O(PSONEW("SIG",0)) G INST1
        S INST=0 F  S INST=$O(^PS(52.41,ORD,"INS1",INST)) Q:'INST  S (MIG,PSONEW("SIG",INST))=^PS(52.41,ORD,"INS1",INST,0) D
        .F SG=1:1:$L(MIG," ") S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(MIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",20)=" " S ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(MIG," ",SG)
        I $P($G(^PS(55,PSODFN,"LAN")),"^"),$O(^PS(52.41,ORD,"INS1",0)) D
        .I $G(^PS(50.7,PSODRUG("OI"),"INS1"))]"" S (X,PSONEW("SINS"))=^PS(50.7,PSODRUG("OI"),"INS1") D SSIG^PSOHELP
        .I $G(SINS1)]"" S PSONEW("SINS")=$E(SINS1,2,250)
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" Other Pat Instruct: "_$S($G(PSONEW("SINS"))]"":PSONEW("SINS"),1:"")
        K INST,TY,MIG,SG,SINS1
        Q
INST1   ;
        S INS=0 F  S INS=$O(PSONEW("SIG",INS)) Q:'INS  S MIG=PSONEW("SIG",INS) D
        .F SG=1:1:$L(MIG," ") S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(MIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",20)=" " S ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(MIG," ",SG)
        K INST,TY,MIG,SG
        I $P($G(^PS(55,PSODFN,"LAN")),"^") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" Other Pat Instruct: "_$S($G(PSONEW("SINS"))]"":PSONEW("SINS"),1:"")
        Q
PROVCOM ;
        I $G(PKI1)=1,'$G(PSORX("VERIFY")) D REA^PSOPKIV1 Q:$G(PSORX("DFLG"))
        I $O(PRC(0)),'$G(PSOPRC) D  D KV^PSOVER1
        .D EN^DDIOL("Provider Comments: ","","!")
        .F I=0:0 S I=$O(PRC(I)) Q:'I  D EN^DDIOL(PRC(I),"","!")
        . ;Begin WorldVistA Change ;PSO*7.0*208
        .;D KV^PSOVER1 S DIR(0)="Y",DIR("A")="Copy Provider Comments into the Patient Instructions",DIR("B")="No"
        .;D ^DIR Q:'Y!($D(DIRUT))
        . I $G(PSOAFYN)="Y" D KV^PSOVER1 ;vfam
        . I $G(PSOAFYN)'="Y" D KV^PSOVER1 S DIR(0)="Y",DIR("A")="Copy Provider Comments into the Patient Instructions",DIR("B")="No"
        . I $G(PSOAFYN)'="Y" D ^DIR Q:'Y!($D(DIRUT))
        . I $G(PSOAFYN)="Y" Q  ;vfam Provider Comments NOT Copied Into Patient Instructions
        . ;End WorldVistA Change
        .S PSOPRC=1,NI=0 F I=0:0 S I=$O(PSONEW("SIG",I)) Q:'I  S NI=I
        .S NC=0 F I=0:0 S I=$O(PRC(I)) Q:'I  S NC=NC+1
        .I NI'>1,NC=1,($L($G(PSONEW("SIG",NI)))+$L(PRC(1)))'>250 D  Q
        ..S X=PRC(1) D SIGONE^PSOHELP
        ..S PSONEW("SIG",1)=$G(PSONEW("SIG",NI))_INS1 K INS1,X
        ..S:$E(PSONEW("SIG",1))=" " PSONEW("SIG",1)=$E(PSONEW("SIG",1),2,250) S PSONEW("INS")=PSONEW("SIG",1) D EN^PSOFSIG(.PSONEW,1) K NI,NC
        .F I=0:0 S I=$O(PRC(I)) Q:'I  S NI=NI+1,(PSONEW("INS",NI),X)=PRC(I) D SIGONE^PSOHELP S PSONEW("SIG",NI)=INS1 K INS1
        .I $E(PSONEW("SIG",1))=" " S PSONEW("SIG",1)=$E(PSONEW("SIG",1),2,250)
        .D EN^PSOFSIG(.PSONEW,1) K NI,NC,X
        Q
DOSE    ;displays dosing info for pending orders.  called from psoorfi1
        K II,UNITS S DS=1
        I '$O(^PS(52.41,ORD,1,0)) S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (3)        *Dosage:" G DOSEX
        F I=0:0 S I=$O(^PS(52.41,ORD,1,I)) Q:'I  S DOSE=$G(^PS(52.41,ORD,1,I,1)),DOSE1=$G(^(2)) D  D DOSE1
        .S II=$G(II)+1 K PSONEW("UNITS",II)
        .S PSONEW("DOSE",II)=$P(DOSE1,"^"),PSONEW("DOSE ORDERED",II)=$P(DOSE1,"^",2),PSONEW("UNITS",II)=$P(DOSE,"^",9),PSONEW("NOUN",II)=$P(DOSE,"^",5)
        .S:$P(DOSE,"^",9) UNITS=$P(^PS(50.607,$P(DOSE,"^",9),0),"^")
        .S PSONEW("VERB",II)=$P(DOSE,"^",10),PSONEW("ROUTE",II)=$P(DOSE,"^",8)
        .S:$P(DOSE,"^",8) ROUTE=$P(^PS(51.2,$P(DOSE,"^",8),0),"^")
        .S PSONEW("SCHEDULE",II)=$P(DOSE,"^"),PSONEW("DURATION",II)=$P(DOSE,"^",2)
        .S DOENT=$G(DOENT)+1 I $P(DOSE,"^",6)]"" S PSONEW("CONJUNCTION",II)=$S($P(DOSE,"^",6)="S":"T",$P(DOSE,"^",6)="X":"X",1:"A")
        .I 'PSONEW("DOSE ORDERED",II),$G(PSONEW("VERB",II))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Verb: "_$G(PSONEW("VERB",II))
        .S:$G(DS) IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (3)"
DOSEX   S PSONEW("ENT")=+$G(II) K DOSE,DOSE1,II,I,UNITS,ROUTE,DG
        Q
DOSE1   I $G(DS)=1 S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"        *Dosage:" D FMD^PSOORFI3 G DU
        S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="            *Dosage:" D FMD^PSOORFI3
DU      I 'PSONEW("DOSE ORDERED",I),$P($G(^PS(55,PSODFN,"LAN")),"^") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" *Oth. Lang. Dosage: "_$G(PSONEW("ODOSE",I))
        I PSONEW("DOSE ORDERED",II),$G(PSONEW("VERB",II))]"" D
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Verb: "_$G(PSONEW("VERB",II))
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     Dispense Units: "_$S($E(PSONEW("DOSE ORDERED",II),1)=".":"0",1:"")_PSONEW("DOSE ORDERED",II)
        I PSONEW("NOUN",II)]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Noun: "_PSONEW("NOUN",II)
        I $G(ROUTE)]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="             *Route: "_$G(ROUTE)
        S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          *Schedule: "_PSONEW("SCHEDULE",II)
        I $G(PSONEW("DURATION",II))]"" D
        .S PSONEW("DURATION",II)=$S($E(PSONEW("DURATION",II),1)'?.N:$E(PSONEW("DURATION",II),2,99)_$E(PSONEW("DURATION",II),1),1:PSONEW("DURATION",II))
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          *Duration: "_PSONEW("DURATION",II)_" ("_$S(PSONEW("DURATION",II)["M":"MINUTES",PSONEW("DURATION",II)["H":"HOURS",PSONEW("DURATION",II)["L":"MONTHS",PSONEW("DURATION",II)["W":"WEEKS",1:"DAYS")_")"
        I $G(PSONEW("CONJUNCTION",II))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       *Conjunction: "_$S(PSONEW("CONJUNCTION",II)="T":"THEN",PSONEW("CONJUNCTION",II)="X":"EXCEPT",1:"AND")
        Q
DOSE2   ;displays pending order after edits.  called from psoornew
        I '$O(PSONEW("DOSE",0))!($O(PSONEW("DOSE",0))="") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (3)        *Dosage:" Q
        S DS=1
        F I=1:1:PSONEW("ENT") Q:'I  D  D DOSE3 K COJ
        .S:$G(PSONEW("UNITS",I))]"" UNITS=$P(^PS(50.607,PSONEW("UNITS",I),0),"^")
        .I $G(PSONEW("ROUTE",I))]"",$G(^PS(51.2,PSONEW("ROUTE",I),0))]"" S ROUTE=$P(^PS(51.2,PSONEW("ROUTE",I),0),"^")
        .S DUR=$G(PSONEW("DURATION",I)) S:$G(PSONEW("CONJUNCTION",I))]"" COJ=PSONEW("CONJUNCTION",I)
        .S NOUN=$G(PSONEW("NOUN",I)),VERB=$G(PSONEW("VERB",I))
        .I '$G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Verb: "_$G(PSONEW("VERB",I))
        .S:$G(DS) IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (3)"
        K I,UNITS,ROUTE,DUR,COJ,VERB,NOUN,DG
        Q
DOSE3   I $G(DS)=1 S II=I,^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"        *Dosage:" D FMD^PSOORFI3 G DO
        S II=I,IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="            *Dosage:" D FMD^PSOORFI3
DO      I '$G(PSONEW("DOSE ORDERED",I)),$P($G(^PS(55,PSODFN,"LAN")),"^") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" *Oth. Lang. Dosage: "_$G(PSONEW("ODOSE",I))
        I $G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Verb: "_$G(PSONEW("VERB",I))
        I $G(PSONEW("DOSE ORDERED",I)) S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     Dispense Units: "_$S($E(PSONEW("DOSE ORDERED",I),1)=".":"0",1:"")_PSONEW("DOSE ORDERED",I)
        I $G(PSONEW("NOUN",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               NOUN: "_PSONEW("NOUN",I)
        I $G(ROUTE)]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="             *Route: "_$G(ROUTE)
        S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          *Schedule: "_PSONEW("SCHEDULE",I)
        I $G(PSONEW("DURATION",I))]"" D
        .S PSONEW("DURATION",I)=$S($E(PSONEW("DURATION",I),1)'?.N:$E(PSONEW("DURATION",I),2,99)_$E(PSONEW("DURATION",I),1),1:PSONEW("DURATION",I))
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          *Duration: "_PSONEW("DURATION",I)_" ("_$S(PSONEW("DURATION",I)["M":"MINUTES",PSONEW("DURATION",I)["H":"HOURS",PSONEW("DURATION",I)["L":"MONTHS",PSONEW("DURATION",I)["W":"WEEKS",1:"DAYS")_")"
        I $G(PSONEW("CONJUNCTION",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       *Conjunction: "_$S(PSONEW("CONJUNCTION",I)="T":"THEN",PSONEW("CONJUNCTION",I)="X":"EXCEPT",1:"AND")
        Q
OBX     ;formats obx section
        N COM,II
        D:$G(PKI1) L1^PSOPKIV1
        I $O(^PS(52.41,ORD,"OBX",0)) S (T,IEN)=0,IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="Order Checks:" F  S T=$O(^PS(52.41,ORD,"OBX",T)) Q:'T  D  S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" "
        .S COM=$G(^PS(52.41,ORD,"OBX",T,0))
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     " F II=1:1:$L(COM," ") D
        ..I $L(^TMP("PSOPO",$J,IEN,0)_" "_$P(COM," ",II))>80 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     "
        ..S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_" "_$P(COM," ",II)
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     Overriding Provider: "_$G(^PS(52.41,ORD,"OBX",T,1))
        .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     Overriding Reason:"
        .F T1=0:0 S T1=$O(^PS(52.41,ORD,"OBX",T,2,T1)) Q:'T1  D
        ..S MIG=^PS(52.41,ORD,"OBX",T,2,T1,0)
        ..F SG=1:1:$L(MIG," ") S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(MIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",23)=" " S ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(MIG," ",SG)
        Q
PP      S PSODFN=PAT D NOW^%DTC S TM=$E(%,1,12),TM1=$P(TM,".",2)
        Q
SPL     K PSOFIN S POERR("QFLG")=0 S PSONOLCK=1,PSOPTLOK=PAT
        Q
CLQTY   ;
        K PSONEW("QTY")
        D QTY^PSOSIG(.PSONEW)
        S:'$G(PSONEW("QTY")) PSONEW("QTY")=0
        Q
PQTY    ;
        S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_", days supply of "_+$P(OR0,"^",22)_" and a qty of "_+$P(OR0,"^",10)
        Q
REF     Q:$G(PSODRUG("DEA"))']""
        S CS=0 F DEA=1:1 Q:$E(PSODRUG("DEA"),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S CS=1
        S PTRF=PSONEW("# OF REFILLS"),PSDAYS=PSONEW("DAYS SUPPLY")
        I CS D
        .S PSOX1=$S(PTRF>5:5,1:PTRF),PSOX=$S(PSOX1=5:5,1:PSOX1)
        .S PSOX=$S('PSOX:0,PSDAYS=90:1,1:PSOX),PSDY1=$S(PSDAYS<60:5,PSDAYS'<60&(PSDAYS'>89):2,PSDAYS=90:1,1:0)
        E  D
        .S PSOX1=PTRF,PSOX=$S(PSOX1=11:11,1:PSOX1),PSOX=$S('PSOX:0,PSDAYS=90:3,1:PSOX)
        .S PSDY1=$S(PSDAYS<60:11,PSDAYS'<60&(PSDAYS'>89):5,PSDAYS=90:3,1:0)
        S PSONEW("# OF REFILLS")=$S(PSONEW("# OF REFILLS")>PSDY1:PSDY1,1:PSONEW("# OF REFILLS"))
        Q
