PSOORNW2        ;ISC-BHAM/SAB - edit orders from oerr ;7:47 AM  12 Apr 2010
        ;;7.0;OUTPATIENT PHARMACY;**10,23,37,46,117,131,133,148,222,269,206;208**;Build 59;Build 39;WorldVistA 30-Jan-08
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
        ;Reference to ^YSCL(603.01 supported by DBIA 2697
        ;Reference to ^PS(55 supported by DBIA 2228
        ;Reference to ^PSDRUG( supported by DBIA 221
        ;Reference to ^PS(50.606 supported by DBIA 2174
        ;Reference to ^PS(50.7 supported by DBIA 2223
        ;Reference to $$GETNDC^PSSNDCUT supported by IA 4707
        ;
1       I $G(PSODRUG("OI")) M:$G(PSOBDRG) PSOBDR=PSODRUG W !!,"Current Orderable Item: "_$P(^PS(50.7,PSODRUG("OI"),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")
        S DIC("B")=$S($G(PSODRUG("OIN"))]"":PSODRUG("OIN"),1:""),DIC="^PS(50.7,",DIC(0)="AEMQZ"
        S DIC("S")="I '$P(^PS(50.7,+Y,0),""^"",4)!($P(^(0),""^"",4)'<DT) N PSOF,PSOL S (PSOF,PSOL)=0 F  S PSOL=$O(^PSDRUG(""ASP"",+Y,PSOL)) Q:PSOF!'PSOL  "
        S DIC("S")=DIC("S")_"I $P($G(^PSDRUG(PSOL,2)),U,3)[""O"",'$G(^(""I""))!($G(^(""I""))'<DT) S PSOF=1"
        ;BHW;PSO*7*269;Modify ^DIC call to call MIX^DIC to use only the B and C Cross-References.
        S D="B^C" D MIX^DIC1 K DIC,D I X["^"!($D(DTOUT)) S OUT=1 Q
        S PSOY=Y
        I +Y'=OI D  I 'Y!($D(DIRUT)) D KV,MP1^PSOOREDX K DIC,Y,PSOY S OUT=1 Q
        .D KV S DIR(0)="Y",DIR("B")="NO",DIR("A",1)="",DIR("A")="This edit will create a new order.  Do you want to continue" D ^DIR
        G:Y<1 1 S PSODRUG("OI")=+PSOY,PSODRUG("OIN")=$P(PSOY,"^",2),PSONEW("CLERK CODE")=DUZ D KV K DIC,PSOY
        N PSOIC S PSOIC=1 D DREN
        D 2^PSOORNEW Q
4       S PSONEW("FLD")=1 D ISSDT^PSODIR2(.PSONEW) ; Issue Date
        I PSOID>PSONEW("FILL DATE") S PSONEW("FILL DATE")=PSOID,PSORX("FILL DATE")=PSORX("ISSUE DATE")
        Q
        ;
5       S PSONEW("FLD")=2 D FILLDT^PSODIR2(.PSONEW) ; Fill date
        Q
        ;
INS     S PSONEW("FLD")=114 D INS^PSODIR(.PSONEW) ; Pat Inst
        I $P($G(^PS(55,PSODFN,"LAN")),"^") D SINS^PSODIR(.PSONEW)
        Q
        ;
3       S PSONEW("FLD")=3 D PTSTAT^PSODIR1(.PSONEW) ; Get Patient Status
        I +$G(^PS(55,PSODFN,"PS")) S RXPT=+^("PS") I $G(^PS(53,RXPT,0))]"" D  Q
        .S PSONEW("# OF REFILLS")=$S(+$P(OR0,"^",11)>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:+$P(OR0,"^",11)),PSOMAX=+$P(^PS(53,RXPT,0),"^",4)
        .S PSOMAX=$S($G(PSOCS):5,1:11),PSOMAX=$S(PSOMAX>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:PSOMAX)
        .S PSONEW("# OF REFILLS")=$S(PSONEW("# OF REFILLS")>PSOMAX:PSOMAX,1:PSONEW("# OF REFILLS"))
        I $G(PSOMAX) S PSONEW("# OF REFILLS")=$S(+$P(OR0,"^",11)>PSOMAX:PSOMAX,1:+$P(OR0,"^",11))
        I $G(PSODRUG("DEA"))["A"&($G(PSODRUG("DEA"))'["B")!($G(PSODRUG("DEA"))["F")!($G(PSODRUG("DEA"))[1)!($G(PSODRUG("DEA"))[2) D
        .S PSONEW("# OF REFILLS")=0,VALMSG="No refills allowed on "_$S(PSODRUG("DEA")["A":"this narcotic drug.",1:"this drug.")
        Q
        ;
12      S PSONEW("FLD")=4 D PROV^PSODIR(.PSONEW) ; Get Provider
        Q
        ;
11      S PSONEW("FLD")=5 D CLINIC^PSODIR2(.PSONEW) ; Get Clinic
        Q
        ;
8       S PSONEW("FLD")=7 D QTY^PSODIR1(.PSONEW) ; Get quantity
        Q
        ;
7       I '$G(PSODRUG("IEN")) W $C(7),!!,"No Dispense Drug!",! K DIR,DUOUT,DIRUT,DTOUT D 2^PSOORNW1
        I '$G(PSODRUG("IEN")) W !,$C(7),"No Dispense Drug Selected! A new Orderable Item may need to be selected.",! Q
        S PSONEW("FLD")=8 D DAYS^PSODIR1(.PSONEW) ; Get days supply
        Q:'$G(PSONEW("PATIENT STATUS"))
        K PSDY,PSDY1,PSMAX,PSTMAX S PSDAYS=PSONEW("DAYS SUPPLY"),PSRF=PSONEW("# OF REFILLS"),PTST=$P(^PS(53,PSONEW("PATIENT STATUS"),0),"^"),PTDY=$P(^(0),"^",3),PTRF=$P(^(0),"^",4),PSODEA=PSODRUG("DEA"),CS=0 ;D EDNEW^PSOORNW1
        Q
9       ;
        I '$G(PSONEW("PATIENT STATUS")) W !!,"Rx Patient Status required!",! D 3 I '$G(PSONEW("PATIENT STATUS")) S VALMSG="Rx Patient Status required!",VALMBCK="R" Q
        I +$G(^PS(55,PSODFN,"PS")) S RXPT=+^("PS") I $G(^PS(53,RXPT,0))]"" D  G ASK
        .S PSOMAX=$S($G(CLOZPAT)=2:3,$G(CLOZPAT)=1:1,$G(CLOZPAT)=0:0,1:+$P(^PS(53,RXPT,0),"^",4)) K RXPT
        .S:'$G(PSONEW("# OF REFILLS")) PSONEW("# OF REFILLS")=$S(+$P(OR0,"^",11)>PSOMAX:PSOMAX,1:+$P(OR0,"^",11))
        .S (PSONEW("N# REF"),PSONEW("# OF REFILLS"))=$S(PSONEW("# OF REFILLS")>PSOMAX:PSOMAX,1:PSONEW("# OF REFILLS"))
        .I '$D(CLOZPAT) I $G(PSODRUG("DEA"))["A"&($G(PSODRUG("DEA"))'["B")!($G(PSODRUG("DEA"))["F")!($G(PSODRUG("DEA"))[1)!($G(PSODRUG("DEA"))[2) D  Q
        ..S (PSOMAX,PSONEW("N# REF"),PSONEW("# OF REFILLS"))=0,VALMSG="No refills allowed on "_$S(PSODRUG("DEA")["A":"this narcotic drug.",1:"this drug.")
        .I $D(PSODRUG("DEA")) F DEA=1:1 Q:$E(PSODRUG("DEA"),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S PSOMAX=5
        I '$D(CLOZPAT) I $G(PSODRUG("DEA"))["A"&($G(PSODRUG("DEA"))'["B")!($G(PSODRUG("DEA"))["F")!($G(PSODRUG("DEA"))[1)!($G(PSODRUG("DEA"))[2) D  Q
        .S (PSONEW("N# REF"),PSONEW("# OF REFILLS"))=0,VALMSG="No refills allowed on "_$S(PSODRUG("DEA")["A":"this narcotic drug.",1:"this drug.")
        S (PSONEW("N# REF"),PSOMAX,PSONEW("# OF REFILLS"))=+$P(OR0,"^",11)
ASK     S PSONEW("FLD")=9 D REFILL^PSODIR1(.PSONEW) ; Get # of refills
        K PSOMAX,PSMAX,PSTMAX S PSDAYS=PSONEW("DAYS SUPPLY"),PSRF=PSONEW("# OF REFILLS"),PTST=$P(^PS(53,PSONEW("PATIENT STATUS"),0),"^"),PTDY=$P(^(0),"^",3),PTRF=$P(^(0),"^",4),PSODEA=$G(PSODRUG("DEA")),CS=0 D EDNEW^PSOORNW1
        Q
        ;
6       Q  K DA S PSONEW("FLD")=10 D SIG^PSODIR1(.PSONEW) ; Get sig
        I $G(PSONEW("SIG"))]"" D EN^PSOSIGNO(ORD,PSONEW("SIG")) S SIG(1)=PSONEW("SIG")
        I $G(PSOSIGFL) D
        .K DIRUT,DUOUT,DTOUT,DIR S DIR(0)="Y",DIR("B")="NO",DIR("A",1)="",DIR("A")="This edit will create a new order.  Do you want to continue" D ^DIR
        .I 'Y!($D(DIRUT)) K DIR,DIRUT,DUOUT,DTOUT,DIC,Y,PSOSIGFL,PSONEW("SIG") S SIGOK=1
        S PSONEW("CLERK CODE")=DUZ K DIR,DIRUT,DUOUT,DTOUT,DIC,Y
        Q
        ;
13      S PSONEW("FLD")=11 D COPIES^PSODIR1(.PSONEW) ; Get # of copies
        Q
        ;
10      S PSONEW("FLD")=12 D MW^PSODIR2(.PSONEW) ; Get Mail/Window Info
        Q
        ;
14      S PSONEW("FLD")=13 D RMK^PSODIR2(.PSONEW) ; Get Remarks
        Q
        ;WVEHR ;begin p208
        ;
DRGMSG  ;From PSOORNEW
        F SG=1:1:$L($P(^PSDRUG(PSODRUG("IEN"),0),"^",10)) S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P($P(^PSDRUG(PSODRUG("IEN"),0),"^",10)," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",20)=" " D
        .S:$P($P(^PSDRUG(PSODRUG("IEN"),0),"^",10)," ",SG)'="" ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P($P(^PSDRUG(PSODRUG("IEN"),0),"^",10)," ",SG)
        K SG Q
        ;
        ;WVEHR ;end p208
DREN    ;
        S (PSDC,PSI)=0
        F  S PSI=$O(^PSDRUG("ASP",PSODRUG("OI"),PSI)) Q:'PSI  I $S('$D(^PSDRUG(PSI,"I")):1,'^("I"):1,DT'>^("I"):1,1:0),$S($P($G(^PSDRUG(PSI,2)),"^",3)'["O":0,1:1) S PSDC=PSDC+1,PSDC(PSDC)=PSI
        I PSDC'=1 D  G DRENX
        .I $P($G(^PSDRUG(+$G(PSODRUG("IEN")),2)),"^")=$G(PSODRUG("OI")) Q
        .K PSODRUG("NAME"),PSODRUG("IEN")
        K PSOY S PSI=PSDC(1),PSOY=^PSDRUG(PSI,0)
        I $P($G(^PSDRUG(PSI,"CLOZ1")),"^")="PSOCLO1",'$O(^YSCL(603.01,"C",PSODFN,0)) K PSOY,PSI Q
        S PSODRUG("IEN")=+PSI,PSODRUG("VA CLASS")=$P(PSOY,"^",2),PSODRUG("NAME")=$P(PSOY,"^")
        S PSODRUG("NDF")=$S($G(^PSDRUG(PSI,"ND"))]"":+^("ND")_"A"_$P(^("ND"),"^",3),1:0)
        S PSODRUG("MAXDOSE")=$P(PSOY,"^",4),PSODRUG("DEA")=$P(PSOY,"^",3),PSODRUG("CLN")=$S($D(^PSDRUG(+PSI,"ND")):+$P(^("ND"),"^",6),1:0)
        S PSODRUG("SIG")=$P(PSOY,"^",5),PSODRUG("NDC")=$$GETNDC^PSSNDCUT(+PSI,$G(PSOSITE)),PSODRUG("STKLVL")=$G(^PSDRUG(+PSI,660.1))
        S PSODRUG("DAW")=+$$GET1^DIQ(50,+PSI,81)
        G:$G(^PSDRUG(+PSI,660))']"" DRENX
        S PSOX1=$G(^PSDRUG(+PSI,660)),PSODRUG("COST")=$P($G(PSOX1),"^",6),PSODRUG("UNIT")=$P($G(PSOX1),"^",8),PSODRUG("EXPIRATION DATE")=$P($G(PSOX1),"^",9)
DRENX   K PSDC,PSI,PSOY,Y,PSOXI,X Q
KV      K DIR,DIRUT,DUOUT,DTOUT Q
