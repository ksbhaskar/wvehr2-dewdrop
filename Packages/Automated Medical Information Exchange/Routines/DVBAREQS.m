DVBAREQS ;ALB ISC/THM-SHORT RPT FOR NEW 7131 REQUESTS; 21 JUL 89@0129
 ;;2.7;AMIE;**2,17**;Apr 10, 1995
 ;called by DVBAREQ1 for short version of new requests
 ;
SETUP S %DT="AE",DIC="^DVB(396,",BDT1=$$FMTE^XLFDT(BDT,"5DZ"),EDT1=$$FMTE^XLFDT(EDT,"5DZ")
 I XDIV'="ALL" S (BDIV,EDIV)=$P(^DG(40.8,XDIV,0),U,1)
 I XDIV="ALL" S BDIV="@",EDIV=""
 ;
INFO S DHD="VARO 7131 NEW REQUEST REPORT FOR "_BDT1_" TO "_EDT1_" * SHORT VERSION *",L=0,FLDS=".01;L15,1;L12,2;L12,NUMDATE4(#3);L10;""ACT/ADM DATE"",23;L11,29;L9"
 S ^TMP(396,$J,1,2,3,4,5,6)=""
 S DIOBEG="K ^TMP(396,$J) D TMPSET^DVBAREQS(BDT,EDT,XDIV)"
 S (FR(0),TO(0))=""
 S DISPAR(0,2)="^;""DOCUMENT TYPE: "";S2"
 S BY(0)="^TMP(396,$J,",L(0)=6
 S DHIT="I $P($G(^DVB(396,D0,2)),U,9)="""" W ?9,""** REGIONAL OFFICE MUST EDIT THE INCOMPLETE REQUEST LISTED ABOVE **"",!"
 ;
PRINT D EN1^DIP
 ;
EXIT K FR,BY,DIS,DHIT,TO,L,FLDS,DHD,^TMP(396,$J),DIOBEG,FR(0),TO(0),BY(0),L(0)
 Q
 ;
NAME ;this is called from DVBAREQ1 when a selection is made by name.
 S DHD="VARO 7131 NEW REQUEST REPORT FOR "_$P(DA,U,2)_" * SHORT VERSION *",(FR,TO)=+DA,BY="@NUMBER"
 S L=0,DIC="^DVB(396,"
 S FLDS=".01;L15,1;L12,2;L12,NUMDATE4(#3);L10;""ACT/ADM DATE"",23;L11,29;L9"
 D PRINT
 Q
 ;
VERSION() ;Get whether user wants long or short version
 N DTOUT,DUOUT,Y
 S DIR(0)="SM^L:Long;S:Short",DIR("A")="Select version",DIR("B")="Long"
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) Q 0
 Q $S(Y="L"!(Y="S"):Y,1:0)
 ;
KILL1 ;
 K DVBDA,DVBVER,DA,NODTA,QQ,DVBAON2,^TMP($J),VAR
 Q
 ;
KILL S XRTN=$T(+0)
 D SPM^DVBCUTL4
 I $D(ZTQUEUED)&($D(DVBAMAN)) D KILL^%ZTLOAD
 K DVBAON2,DVBAMAN,^TMP($J),LPDIV,DVBOUT,DVBSEL,VAR,DVBVER,DVBDA,DVBATASK,DVBSTOP
 D KILL^DVBAUTIL
 Q
 ;
TMPSET(BDT,EDT,XDIV) ;**Set ^TMP X-Ref for short report
 ;** ^TMP("396",$J) array returned and must be KILLed by calling rtn
 N LPDT,LPDIV,LPDA,DOCTYPE,DTOFREQ,DIV,PATNAME,TYPEORD
 F LPDT=((BDT-1)+.2359):0 S LPDT=$O(^DVB(396,"AE",LPDT)) Q:LPDT>EDT!(LPDT="")  DO
 .S:XDIV'="ALL" LPDIV=+XDIV-1
 .S:XDIV="ALL" LPDIV=""
 .F  S LPDIV=$O(^DVB(396,"AE",LPDT,LPDIV)) Q:(LPDIV=""!(XDIV'="ALL"&(XDIV'=LPDIV)))  DO
 ..F LPDA=0:0 S LPDA=$O(^DVB(396,"AE",LPDT,LPDIV,LPDA)) Q:LPDA=""  DO
 ...S DOCTYPE=$P($G(^DVB(396,LPDA,2)),U,10)
 ...S TYPEORD=$S(DOCTYPE="A":1,DOCTYPE="L":2,1:3)
 ...S DOCTYPE=$S(DOCTYPE="A":"ADMISSION DATE",DOCTYPE="L":"ACTIVITY DATE",1:"")
 ...S DTOFREQ=$P($G(^DVB(396,LPDA,1)),U,1)
 ...S DIV=$P($G(^DVB(396,LPDA,2)),U,9)
 ...S PATNAME=$P($G(^DVB(396,LPDA,0)),U,1)
 ...S ^TMP("396",$J,TYPEORD,DOCTYPE,DTOFREQ,DIV,PATNAME,LPDA)=""
 Q
