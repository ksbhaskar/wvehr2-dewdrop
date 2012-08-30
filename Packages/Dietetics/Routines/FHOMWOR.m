FHOMWOR ;Hines OIFO/RTK OUTPATIENT MEALS/HL7 MESSAGING  ;10/21/03  10:15
        ;;5.5;DIETETICS;**2,5,19**;Jan 28, 2005;Build 2
        S FHDFN="",FHZ115="P"_DFN D ADD^FHOMDPA
        I 'FHDFN S TXT="Outpatient not found" D GETOR^FHWOR,ERR Q
        ;Decode FHMSG(3) - PV1
        S FHX=$G(FHMSG(3))
        I $E(FHX,1,3)'="PV1" S TXT="3rd msg not PV1" D GETOR^FHWOR,ERR Q
        S FHLOC=$P($P(FHX,"|",4),U,1)
        I FHLOC="" S TXT="Missing Location" D GETOR^FHWOR,ERR Q
        S FHLOC=$O(^FH(119.6,"AL",FHLOC,""))
        I 'FHLOC S TXT="Invalid Location" D GETOR^FHWOR,ERR Q
        ;Decode FHMSG(4) - ORC
        S FHX=$G(FHMSG(4))
        I $E(FHX,1,3)'="ORC" S TXT="4th msg not ORC" D GETOR^FHWOR,ERR Q
        S FHORN=$P(FHX,"|",3),FHORN=+FHORN,FILL=$P(FHX,"|",4)
        S FHDUR=$P(FHX,"|",8),FHDOW=$P(FHDUR,U,2)
        S DATE=$E($P(FHDUR,U,4),1,8) D CVT^FHWOR S STDT=DATE,FHOSTDT=STDT
        S DATE=$P(FHDUR,U,5) D CVT^FHWOR S ENDT=DATE I ENDT'="" S ENDT=ENDT_.99
        I ENDT="" S ENDT=9999999.99
        S ACT=$P(FHX,"|",2) I ACT="CA"!(ACT="DC") D CANCEL Q
        I ACT="NA" D NA Q
        I ACT="SS" D OMSTAT^FHWORR Q
        I ACT'="NW" S TXT="Action not NW, CA or DC" D GETOR^FHWOR,ERR Q
        D NOW^%DTC S FHNOW=$P(%,".",1)
        I STDT=""!(STDT<FHNOW) S TXT="Start Date not valid" D GETOR^FHWOR,ERR Q
        I ENDT<STDT S TXT="End Date not valid" D GETOR^FHWOR,ERR Q
        S FHPV=$P(FHX,"|",13),FHEFF=$P(FHX,"|",16)
        I FHEFF="" S TXT="No effective date" D ERR Q
        ;Decode FHMSG(5) - ODS/ODT
        S FHX=$G(FHMSG(5))
        S FHINST=$P(FHX,"|",4),FHBAG="N" I FHINST="bagged" S FHBAG="Y"
        S FHSVCP=$P($P(FHX,"|",3),U,4)
        I $E(FHX,1,3)="ODT" D HL7SET^FHOMRE1 Q  ;EARLY/LATE
        I $E(FHX,1,3)="OBR" D HL7SET^FHOMIP Q  ;ISOLATION/PRECAUTION
        I $E(FHX,1,3)'="ODS" S TXT="5th message not ODT or ODS as expected" D GETOR^FHWOR,ERR Q
        S FHTYPC=$P(FHX,"|",2) I FHTYPC="ZE" D HL7SET^FHOMRT1 Q  ;TUBEFEEDING
        S FHDTX=$P(FHX,"|",4),FHDIET=$P(FHDTX,U,4),FHDTX=$E(FHDTX,4,$L(FHDTX))
        S FHCOM=$P(FHX,"|",5),FHM3=$P(FHX,"|",3)
        I $E(FHDTX,1,4)="FH-6" D HL7SET^FHOMRA1 Q  ;ADDITIONAL ORDERS
        S FHMEAL=$S(FHM3=1:"B",FHM3=3:"N",FHM3=5:"E",1:"")
        I FHMEAL="" S TXT="Meal missing" D GETOR^FHWOR,ERR Q
        I FHDIET="" S TXT="Missing diet" D GETOR^FHWOR,ERR Q
        I '$D(^FH(111,FHDIET)) S TXT="Invalid diet" D GETOR^FHWOR,ERR Q
        I FHTYPC="S" D SM  ;SPECIAL MEAL REQUEST
        I FHTYPC="D" D RM I $G(FHAIL)'="" Q  ;RECURRING MEAL ORDER
        D SEND^FHWOR Q
SM      ; Special Meal Request
        ; FHDFN,FHLOC set at top of FHOMWOR
        D NOW^%DTC S FHNOW=%
        S FHDUZ=$P($G(FHMSG(4)),"|",11),FHSTAT="P",FHRMBD=""
        I FHDUZ'="",$D(^XUSEC("FHAUTH",FHDUZ)) S FHSTAT="A"
        S FHQEL=1 D SETNODE^FHOMSR1
        S FILL="S;"_FHSMID
        Q
RM      ;
        ; Recurring orders from CPRS will only have ONE diet, not up to 5 like
        ; for NonVA patients/inpatients therefore can set FHDIETX1-5 = NULL
        ; FHDFN,FHLOC set at top of FHOMWOR
        S FHMPNUM=$O(^FHPT(FHDFN,"OP","C",""),-1) I FHMPNUM="" S FHMPNUM=0
        S FHMPNUM=FHMPNUM+1
        S (FHAIL,FHRMBD,FHDIETX(1),FHDIETX(2),FHDIETX(3),FHDIETX(4),FHDIETX(5))=""
        S (C,FHENDL)=0,STDTLP=STDT,FHDZ="" F  Q:FHENDL=1  D
        .S X=STDTLP D H^%DTC S:%Y=0 %Y=7 S FHDZ=FHDZ_%Y_"^",X1=STDTLP,X2=1
        .D C^%DTC S STDTLP=X,C=C+1 I STDTLP>ENDT!(C>6) S FHENDL=1 Q
        S FHDAYS="" F FHH=1:1:7 S FHPCE=$P(FHDOW,"~",FHH) Q:FHPCE=""  D
        .S FHD3=$E(FHPCE,3)
        .I FHD3'>0,FHD3'<8 Q
        .I FHDZ'[FHD3 Q
        .S FHDAYS=FHDAYS_$E("MTWRFSX",FHD3)
        I FHDAYS="",$E(STDT,1,7)'=$E(ENDT,1,7) S (TXT,FHAIL)="Day of week invalid or not within date range" D GETOR^FHWOR,ERR Q
        I FHDAYS="",$E(STDT,1,7)=$E(ENDT,1,7) S X=$E(STDT,1,7) D DOW^%DTC S FHDAYS=$E("XMTWRFS",Y+1)
        D SETNODE^FHOMRO1
        S FILL="R;"_FHMPNUM_";"_STDT_";"_ENDT_";"_FHDAYS_";"_FHMEAL
        Q
CANCEL  ;Cancel outpatient orders
        S FHENDT=ENDT,FHX=$G(FHMSG(4)),FILL=$P(FHX,"|",4),FHMPNUM=""
        S FHORSAV=FHORN,FHILSAV=FILL,FHACTSV=ACT
        S FHTYPE=$P(FILL,";",1) I FHTYPE="R" S FHMPNUM=$P(FILL,";",2)
        I "AEIGSRT"'[FHTYPE S TXT="Invalid cancel code" D ERR Q
        S X1=STDT,X2=-1 D C^%DTC S STDT1=X
        I "AET"[FHTYPE F FHRMDT=STDT1:0 S FHRMDT=$O(^FHPT(FHDFN,"OP","B",FHRMDT)) Q:FHRMDT'>0!(FHRMDT>FHENDT)  D
        .F FHRNUM=0:0 S FHRNUM=$O(^FHPT(FHDFN,"OP","B",FHRMDT,FHRNUM)) Q:FHRNUM'>0  D
        ..I FHTYPE="A" D CANAO^FHOMRC1 Q
        ..I FHTYPE="E" D CANEL^FHOMRC1 Q
        ..I FHTYPE="T" D CANTF^FHOMRC1 Q
        I FHTYPE="R" F FHRNUM=0:0 S FHRNUM=$O(^FHPT(FHDFN,"OP","C",FHMPNUM,FHRNUM)) Q:FHRNUM'>0  S FHRMDT=$P($G(^FHPT(FHDFN,"OP",FHRNUM,0)),U,1) D CANRM^FHOMRC1,ASSOC^FHOMRC2
        I FHTYPE="I" D CAN^FHOMIP
        I FHTYPE="S" S FHSMID=$P(FILL,";",2),FHCDT=FHDFN_"^"_FHSMID D CAN^FHOMSC1,CNSMEL^FHOMRC2  ;cancel a SM and associated SM Late Tray
        I FHTYPE="G" S FHSMID=$P(FILL,";",2),FHCDT=FHDFN_"^"_FHSMID D CNSMEL^FHOMRC2  ;cancel a SM Late Tray only
        S FHORN=FHORSAV,FILL=FHILSAV,ACT=FHACTSV D CSEND^FHWOR Q
        Q
NA      ;Number assign for outpatient
        S FILL=$P(FHX,"|",4)
        S FHTYPE=$P(FILL,";",1) S (FHMPN,FHRNUM)=+$P(FILL,";",2)
        D NA^FHOMWOR1
        Q
ERR     ;
        K MSG D RMSH^FHWOR  ;Sets MSG(1) & MSG(2)
        S ACT="UA" I $P(FHMSG(4),"|",2)="CA" S ACT="U"_$E($P(FHMSG(4),"|",2),1)
        S $P(MSG(3),"|",1,2)="ORC|"_ACT,$P(MSG(3),"|",3)=FHORN
        S $P(MSG(3),"|",4)=$P(FHMSG(3),"|",4)
        S $P(MSG(3),"|",13)=$P(FHMSG(3),"|",13)
        S $P(MSG(3),"|",16)=$P(FHMSG(3),"|",16),$P(MSG(3),"|",17)=TXT
        ;
        ;W ! F RK=0:0 S RK=$O(MSG(RK)) Q:RK'>0  W !,"  MSG"_RK_"= ",MSG(RK)
        ;F RK=0:0 S RK=$O(FHMSG(RK)) Q:RK'>0  W !,"FHMSG"_RK_"= ",FHMSG(RK)
        ;W !!,"TXT=",TXT,!!
        ;
        D EVSEND^FHWOR Q
        Q
