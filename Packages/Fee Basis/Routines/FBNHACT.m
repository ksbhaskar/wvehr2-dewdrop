FBNHACT ;AISC/DMK - COMMMUNITY NURSING HOME ACTIVITY REPORT ;4/28/93  11:03
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 D HED
 D DATE^FBAAUTL G END:FBPOP
 S FBBEG=9999999.9999-(ENDDATE+.2399),FBEND=9999999.9999-BEGDATE
 S VAR="FBBEG^FBEND",VAL=FBBEG_"^"_FBEND,PGM="START^FBNHACT" D ZIS^FBAAUTL G END:FBPOP
START S QQ="",$P(QQ,"=",80)="=",FBOUT="" U IO W @IOF D HED1
 F FBDFN=0:0 S FBDFN=$O(^FBAACNH("AF",FBDFN)) Q:'FBDFN!(FBOUT)  F I=FBBEG:0 S I=$O(^FBAACNH("AF",FBDFN,I)) Q:'I!(I>FBEND)!(FBOUT)  F J=0:0 S J=$O(^FBAACNH("AF",FBDFN,I,J)) Q:'J!(FBOUT)  I $D(^FBAACNH(J,0)) S FB(0)=^(0) D SET
END K BEGDATE,DFN,ENDDATE,FB,FBBEG,FBDFN,FBEND,FBNAME,FBOUT,FBVEN,I,J,K,QQ,X,Y
 D CLOSE^FBAAUTL Q
SET F K=3:1:9 S FB(K)=$P(FB(0),"^",K)
 S FBNAME=$$NAME^FBCHREQ2(FBDFN)_" -"_$$SSN^FBAAUTL(FBDFN,1)
 D VENDOR
 S FB("AC")=$S(FB(3)="A":"ADMISSION",FB(3)="T":"TRANSFER",FB(3)="D":"DISCHARGE",1:"")
 S FB("ADTP")=$S(FB(6)=4:"ALL OTHER",FB(6)=3:"FROM ASIH <15 DAYS",FB(6)=1:"AFTER RE-HOSPITALIZATION >15 DAYS",FB(6)=2:"TRANSFER FROM OTHER CNH",1:"")
 S FB("TR")=$S(FB(7)=1:"TO AUTHORIZED ABSENSE",FB(7)=2:"TO UNAUTHORIZED ABSENSE",FB(7)=3:"TO ASIH",FB(7)=4:"FROM AUTHORIZED ABSENSE",FB(7)=5:"FROM UN-AUTHORIZED ABSENSE",FB(7)=6:"FROM ASIH <15 DAYS",1:"")
 S FB("DC")=$S(FB(8)=1:"REGULAR",FB(8)=2:"DEATH",FB(8)=3:"TRANSFER FROM OTHER CNH",FB(8)=4:"ASIH",FB(8)=5:"DEATH WHILE ASIH",FB(8)=6:"REGULAR - PRIVATE PAY",1:"")
WRT W !,$S(FB(4)="Y":"*",1:""),?2,FBNAME,?40,FBVEN,!?3,FB("DAT"),?30,FB("AC"),"  -  ",$S(FB(3)="A":FB("ADTP"),FB(3)="T":FB("TR"),FB(3)="D":FB("DC"),1:""),!
 I $Y+5>IOSL D HANG Q:FBOUT  D HED1
 Q
HED W !?20,"COMMUNITY NURSING HOME REPORT",!?19,"-------------------------------",! Q
HED1 D HED W ?18,"('*' Represents ACTIVE ADMISSION)",!,"PATIENT NAME",?48,"VENDOR",!?3,"ACTIVITY DATE",?30,"ACTIVITY TYPE",!,QQ,! Q
VENDOR I FB(9) S FBVEN=$E($$VNAME^FBNHEXP(FB(9)),1,33)_" -"_$E($$VID^FBNHEXP(FB(9)),6,9)
 S FB("DAT")=$$DATX^FBAAUTL(9999999.9999-I) Q
HANG I $E(IOST,1,2)["C-" S DIR(0)="E" D ^DIR K DIR I 'Y S FBOUT=1
 W @IOF Q
