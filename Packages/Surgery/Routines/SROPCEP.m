SROPCEP ;BIR/TJH - PCE UPDATES ;04/26/05  9:28 AM
 ;;3.0; Surgery ;**142,152,144,161**;24 Jun 93;Build 5
 ;
 ; Reference to $$DATA2PCE^PXAPI supported by DBIA #1889
 ; Reference to $$DELVFILE^PXAPI supported by DBIA #1890
 ; Reference to ^DIC(45.3 is supported by DBIA #218
 ;
 Q
START ; entry for update to PCE with surgery & non-OR procedure data
 I '$D(SRTN) S SRTN=$G(DA)
 I SRTN="" Q
 N DFN,SR,SRAO,SRATT,SRCHK,SRCPT,SRDATE,SRDIAG,SREC,SRHNC,SRIR,SRCV,SRPRJ,SRK,SRLOC,SRMST,SRNON,SROTH,SRPKG,SRPROV,SRS,SRSC,SRV,SRVSIT,SRX,SRX2
 N SRPLSC,SRPLAO,SRPLIR,SRPLEC,SRPLMST,SRPLHNC,SRPLCV,SRPLPRJ,SRADX,SRCNT,SRD,SRDX,SRRPROV,SRUP,SRINOUT,SRO,SRDEPC,SRPFSSAR
 N SRDP,SRDC,SRDI,SRDL,SRDIE,SRDG,SRDM,SRDR,SRDH,SRDK,SRDA,SRD0,SRDDER,SRDG,SRDIC,SRDIC1,SRDICRRE,SRDIEDA,SRDIG,SRDIH,SRDIIENS,SRDISL,SRDISYS,SRDIU,SRDIV,SRDIWT,SRDN,SRDQ,SRDX,SRDY
 D FM1 K DIC S DIC=9.4,DIC(0)="XM",X="SURGERY" D ^DIC K DIC D FM2 Q:Y=-1  S SRPKG=+Y
 S SRS="SURGERY DATA" K ^TMP("SRPXAPI",$J)
 D UTIL I 'SRK D PCE
 Q
DEL ; delete data from the Visit file and V files
 D FM1 K DA,DIE,DR S DA=SRTN,DIE=130,DR=".015///@" D ^DIE K DA,DIE,DR D FM2
 D FM1 S SRV=$$DELVFILE^PXAPI("ALL",SRVSIT) K SRVSIT D FM2
 Q
UTIL ; set procedure variables
 N SRDIV,SRSITE,SRSR
 S SRSR="",SRK=0,SRDIV=$P($G(^SRF(SRTN,8)),"^") I SRDIV S SRSITE=$O(^SRO(133,"B",SRDIV,0)),X=^SRO(133,SRSITE,0),SRUP=$P(X,"^",15),SRSR=$P(X,"^",19) I SRUP=""!(SRUP="N") S SRK=1 Q
 S SRX=$P($G(^SRF(SRTN,0)),"^",15) I SRX S SRVSIT=SRX D DEL I '$D(^SRF(SRTN,0)) S SRK=1 Q
 S SR(0)=$G(^SRF(SRTN,0)) I SR(0)=""!$P($G(^SRF(SRTN,30)),"^") S SRK=1 Q
 S DFN=$P(SR(0),"^")
 S SRNON=$S($P($G(^SRF(SRTN,"NON")),"^")="Y":1,1:0),SRCPT=$P($G(^SRO(136,SRTN,0)),"^",2) I 'SRCPT S SRK=1 Q
 Q:SRK  S SRDIAG=$P($G(^SRO(136,SRTN,0)),"^",3) I 'SRDIAG S SRK=1 Q
 I 'SRNON D  I SRK Q
 .S SRX=$P(SR(0),"^",21) I SRX S SRLOC=SRX
 .I 'SRX S SRX=$P(^SRO(137.45,$P(SR(0),"^",4),0),"^",5) I SRX S SRLOC=SRX
 .I 'SRX S SRX=$P(SR(0),"^",2) S:SRX SRLOC=$P(^SRS(SRX,0),"^") I 'SRX S SRK=1 Q
 .S SRX=$G(^SRF(SRTN,.2)),SRCHK=$P(SRX,"^",12) I 'SRCHK S SRK=1 Q
 .S SRDATE=$P(SRX,"^",10) I 'SRDATE S SRK=1 Q
 .S SRX=$G(^SRF(SRTN,.1)),SRPROV=$P(SRX,"^",4),SRATT=$P(SRX,"^",13) I 'SRPROV S SRK=1 Q
 .I SRSR'=0,'SRATT S SRK=1 Q
 I SRNON D  I SRK Q
 .S SRLOC=$P(SR(0),"^",21)
 .S SRX=^SRF(SRTN,"NON"),SRCHK=$P(SRX,"^",5) I 'SRCHK S SRK=1 Q
 .S SRDATE=$P(SRX,"^",4) I 'SRDATE S SRK=1 Q
 .I 'SRLOC S SRLOC=$P(SRX,"^",2) I 'SRLOC S SRK=1 Q
 .S SRPROV=$P(SRX,"^",6),SRATT=$P(SRX,"^",7) I 'SRPROV S SRK=1
 .I SRSR'=0,'SRATT S SRK=1
 S VAINDT=SRDATE
 D INP^VADPT
 I VAIN(1) S SRINOUT="I"
 I 'VAIN(1) S SRINOUT="O"
 K VAINDT,VAIN
 I '$$CLINIC^SROUTL(SRLOC,SRTN) S SRK=1 Q
 S SRX=0,SRX=$O(^SRO(136,SRTN,2,SRX)) I SRX="" S SRK=1 Q
 S SRX=0 F  S SRX=$O(^SRO(136,SRTN,3,SRX)) Q:'SRX  S SRX2=0,SRX2=$O(^SRO(136,SRTN,3,SRX,2,SRX2)) I $D(^SRO(136,SRTN,3,SRX,0)),(SRX2="") S SRK=1  Q:SRK
 S SRRPROV="" I $D(^SRF(SRTN,18)) S SRX=0,SRX=$O(^SRF(SRTN,18,SRX)) I SRX S SRRPROV=$P($G(^SRF(SRTN,18,SRX,0)),"^",7)
 S SRO(0)=$G(^SRO(136,SRTN,0))
 S (SRSC,SRAO,SREC,SRHNC,SRIR,SRMST,SRCV,SRPRJ)=0,SRSC=$P(SRO(0),"^",4),SRAO=$P(SRO(0),"^",5),SRIR=$P(SRO(0),"^",6),SREC=$P(SRO(0),"^",7),SRMST=$P(SRO(0),"^",8),SRHNC=$P(SRO(0),"^",9),SRCV=$P(SRO(0),"^",10),SRPRJ=$P(SRO(0),"^",11)
 I $$SWSTAT^IBBAPI(),'SRNON D
 .S SRX=$P(^SRO(137.45,$P(SR(0),"^",4),0),"^",2)
 .I SRX S SRDEPC=$$GET1^DIQ(45.3,SRX,2)
 Q
PCE ;
 N SRI,SRJ,SRCODE,SROTH D TMP
D2PCE ;
 S SRPFSSAR=$P($G(^SRF(SRTN,"PFSS")),"^")
 I $$SWSTAT^IBBAPI() D FM1 S SRV=$$DATA2PCE^PXAPI("^TMP(""SRPXAPI"",$J)",SRPKG,SRS,.SRVSIT,,,,,,.SRPFSSAR) D FM2
 I '$$SWSTAT^IBBAPI() D FM1 S SRV=$$DATA2PCE^PXAPI("^TMP(""SRPXAPI"",$J)",SRPKG,SRS,.SRVSIT) D FM2
 I SRVSIT D FM1 K DA,DIE,DR S DA=SRTN,DIE=130,DR=".015////"_SRVSIT D ^DIE K DA,DIE,DR D FM2
 K ^TMP("SRPXAPI",$J),SRVSIT
 Q
TMP ;
ENC S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"ENC D/T")=SRDATE
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"PATIENT")=DFN
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"HOS LOC")=SRLOC
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"CHECKOUT D/T")=SRCHK
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"SERVICE CATEGORY")="S"
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"ENCOUNTER TYPE")="P"
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"APPT")=9
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"SC")=SRSC
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"AO")=SRAO
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"IR")=SRIR
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"EC")=SREC
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"MST")=SRMST
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"HNC")=SRHNC
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"CV")=SRCV
 S ^TMP("SRPXAPI",$J,"ENCOUNTER",1,"SHAD")=SRPRJ
PROC S SRI=1,SRCODE=SRCPT D PMOD,CPT
 S SROTH=0 F  S SROTH=$O(^SRO(136,SRTN,3,SROTH)) Q:'SROTH  S SRCODE=$P($G(^SRO(136,SRTN,3,SROTH,0)),"^") I SRCODE S SRI=SRI+1 D OMOD,CPT
PROV S ^TMP("SRPXAPI",$J,"PROVIDER",1,"NAME")=SRPROV
 S ^TMP("SRPXAPI",$J,"PROVIDER",1,"PRIMARY")=1
 I 'SRNON S ^TMP("SRPXAPI",$J,"PROVIDER",1,"COMMENT")="Surgeon"
 I SRPROV=SRATT!'SRATT S ^TMP("SRPXAPI",$J,"PROVIDER",1,"ATTENDING")=1 G DIAG
 I 'SRATT G DIAG
 S ^TMP("SRPXAPI",$J,"PROVIDER",2,"NAME")=SRATT
 S ^TMP("SRPXAPI",$J,"PROVIDER",2,"ATTENDING")=1
 S ^TMP("SRPXAPI",$J,"PROVIDER",2,"PRIMARY")=1
 S ^TMP("SRPXAPI",$J,"PROVIDER",1,"PRIMARY")=0
 I 'SRNON S ^TMP("SRPXAPI",$J,"PROVIDER",2,"COMMENT")="Attending Surgeon"
DIAG S SRI=1,SRDX=SRDIAG D DX
 S SRD=0 F  S SRD=$O(^SRO(136,SRTN,4,SRD)) Q:'SRD  S SRDX=$P(^SRO(136,SRTN,4,SRD,0),"^") I SRDX D DX
 Q
DX S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"DIAGNOSIS")=SRDX
 I SRI=1 D
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PRIMARY")=1
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"ORD/RES")="R"
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL SC")=SRSC
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL AO")=SRAO
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL IR")=SRIR
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL EC")=SREC
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL MST")=SRMST
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL HNC")=SRHNC
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL CV")=SRCV
 .S ^TMP("SRPXAPI",$J,"DX/PL",1,"PL SHAD")=SRPRJ
 I SRI'=1 D
 .S SR(4)=$G(^SRO(136,SRTN,4,SRD,0))
 .S (SRPLSC,SRPLAO,SRPLIR,SRPLEC,SRPLMST,SRPLHNC,SRPLCV,SRPLPRJ)=0,SRPLSC=$P(SR(4),"^",2),SRPLAO=$P(SR(4),"^",3)
 .S SRPLIR=$P(SR(4),"^",4),SRPLMST=$P(SR(4),"^",5),SRPLHNC=$P(SR(4),"^",6),SRPLEC=$P(SR(4),"^",7),SRPLCV=$P(SR(4),"^",8),SRPLPRJ=$P(SR(4),"^",9)
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"ORD/RES")="R"
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL SC")=SRPLSC
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL AO")=SRPLAO
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL IR")=SRPLIR
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL EC")=SRPLEC
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL MST")=SRPLMST
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL HNC")=SRPLHNC
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL CV")=SRPLCV
 .S ^TMP("SRPXAPI",$J,"DX/PL",SRI,"PL SHAD")=SRPLPRJ
 S SRI=SRI+1
 Q
CPT S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"ENC PROVIDER")=$S($P($G(^SRF(SRTN,.1)),"^",3)="R":SRATT,1:SRPROV)  ;; << *161 RJS
 S:SRRPROV'="" ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"ORD PROVIDER")=SRRPROV
 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"EVENT D/T")=SRDATE
 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"PROCEDURE")=SRCODE
 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"QTY")=1
 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"COMMENT")=$S(SRI=1:"Principal Procedure",1:"Other Procedure")
 I $G(SRDEPC) S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DEPARTMENT")=SRDEPC
 I SRI=1 D
 .S SRCNT=1,SRX=0 F  S SRX=$O(^SRO(136,SRTN,2,SRX)) Q:'SRX  D
 ..S SRADX=$P(^SRO(136,SRTN,2,SRX,0),"^")
 ..I SRCNT=1 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS")=SRADX
 ..I SRCNT=2 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 2")=SRADX
 ..I SRCNT=3 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 3")=SRADX
 ..I SRCNT=4 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 4")=SRADX
 ..I SRCNT=5 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 5")=SRADX
 ..I SRCNT=6 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 6")=SRADX
 ..I SRCNT=7 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 7")=SRADX
 ..I SRCNT=8 S ^TMP("SRPXAPI",$J,"PROCEDURE",1,"DIAGNOSIS 8")=SRADX
 ..S SRCNT=SRCNT+1
 I SRI'=1 D
 .S SRCNT=1,SRX=0 F  S SRX=$O(^SRO(136,SRTN,3,SROTH,2,SRX)) Q:'SRX  D
 ..S SRADX=$P(^SRO(136,SRTN,3,SROTH,2,SRX,0),"^")
 ..I SRCNT=1 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS")=SRADX
 ..I SRCNT=2 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 2")=SRADX
 ..I SRCNT=3 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 3")=SRADX
 ..I SRCNT=4 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 4")=SRADX
 ..I SRCNT=5 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 5")=SRADX
 ..I SRCNT=6 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 6")=SRADX
 ..I SRCNT=7 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 7")=SRADX
 ..I SRCNT=8 S ^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"DIAGNOSIS 8")=SRADX
 ..S SRCNT=SRCNT+1
 Q
PMOD ;
 N SRM,SRMOD,X
 S SRM=0 F  S SRM=$O(^SRO(136,SRTN,1,SRM)) Q:'SRM  S X=$P(^SRO(136,SRTN,1,SRM,0),"^"),SRMOD=$P($$MOD^ICPTMOD(X,"I"),"^",2),^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"MODIFIERS",SRMOD)=""
 Q
OMOD ;
 N SRM,SRMOD,X
 S SRM=0 F  S SRM=$O(^SRO(136,SRTN,3,SROTH,1,SRM)) Q:'SRM  S X=$P(^SRO(136,SRTN,3,SROTH,1,SRM,0),"^"),SRMOD=$P($$MOD^ICPTMOD(X,"I"),"^",2),^TMP("SRPXAPI",$J,"PROCEDURE",SRI,"MODIFIERS",SRMOD)=""
 Q
FM1 M SRDA=DA,SRDP=DP,SRDC=DC,SRDI=DI,SRDL=DL,SRDIE=DIE,SRDG=DG,SRDM=DM,SRDR=DR,SRDH=DH,SRDK=DK,SRD0=D0,SRDDER=DDER,SRDG=DG,SRDIC=DIC,SRDIC1=DIC1,SRDICRRE=DICRREC
 M SRDIEDA=DIEDA,SRDIG=DIG,SRDIH=DIH,SRDIIENS=DIIENS,SRDISL=DISL,SRDISYS=DISYS,SRDIU=DIU,SRDIV=DIV,SRDIWT=DIWT,SRDN=DN,SRDQ=DQ,SRDX=DX,SRDY=DY
FM2 M DA=SRDA,DP=SRDP,DC=SRDC,DI=SRDI,DL=SRDL,DIE=SRDIE,DG=SRDG,DM=SRDM,DR=SRDR,DH=SRDH,DK=SRDK,D0=SRD0,DDER=SRDDER,DG=SRDG,DIC=SRDIC,DIC1=SRDIC1,DICRREC=SRDICRRE
 M DIEDA=SRDIEDA,DIG=SRDIG,DIH=SRDIH,DIIENS=SRDIIENS,DISL=SRDISL,DISYS=SRDISYS,DIU=SRDIU,DIV=SRDIV,DIWT=SRDIWT,DN=SRDN,DQ=SRDQ,DX=SRDX,DY=SRDY
