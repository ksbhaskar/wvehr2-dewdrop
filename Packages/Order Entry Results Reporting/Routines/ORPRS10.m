ORPRS10 ; slc/dcm - Summary time, when the livin is easy... ;10/19/98  13:50
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**23,37,11,69,121**;Dec 17, 1997
DAY ;PROCESS 24-HR ORDER SUMMARY
 S OREND=0,ORTIT="DAILY ORDER SUMMARY",ORPRES=1
 D:$D(ORSCPAT)'>9 P^ORPRS01
 G:OREND END
 D DAY^ORPRS01()
 G:OREND END
 D CONT(ORTIT)
 Q
RANGE ;PROCESS START THRU STOP DATE/TIME RANGE
 S OREND=0,ORTIT="ORDER SUMMARY",ORPRES=1
 D:$D(ORSCPAT)'>9 P^ORPRS01
 G:OREND END
 D RANGE^ORPRS01()
 G:OREND END
 D CONT("Order summary for date range")
 Q
GENERIC ;PROCESS WITH PROMPTS FOR ALL REPORT VARIABLES
 S OREND=0
 D:$D(ORSCPAT)'>9 P^ORPRS01
 G:OREND!'$D(ORSCPAT) END
 D PRES^ORPRS09
 G:OREND END
 D SERV^ORPRS09
 G:OREND END
 D RANGE^ORPRS01()
 G:OREND END
 S ORTIT=$P(ORPRES,";",2)_" for "_ORGRP("NAM")_" SERVICES"
 D CONT(ORTIT)
 Q
CONT(DESC) ;
 D QUE^ORUTL1("EN1^ORPRS10",$G(DESC))
 Q
EN1 ;Entry point for Batch Processing
 ;Setup display group list, patient list, and process reports
 N ORDG,ORGRP,ORSEL,ORSEQ,ORLIST,ORAW
 U IO
 S ORDG=1,ORGRP("NAM")="ALL",ORGRP("ROOT")=1,ORSEL="BILD",ORSEQ=0,ORPRES=1
 S ORAW=$S(+$$GET^XPAR("SYS","OR ORDER SUMMARY CONTEXT",1,"I"):"AW",1:"")
 I $E(IOST)'="C",$L($G(ORSWDN)) S ORSLTR=$E(ORSWDN,1,(IOM\15)) D ^ORSLTR
 I ORSHORT D PTOP^ORPRS05(0,ORTIT,ORSHORT,ORSSTRT,ORSSTOP)
 S (NEXTP,OREND)=0
 F  S NEXTP=$O(ORSCPAT(NEXTP)) Q:NEXTP=""!(OREND=1)  D
 . S ORVP=+ORSCPAT(NEXTP)_";DPT("
 . D EN^ORQ1(ORVP,ORDG,+ORPRES,0,+ORSSTRT,+ORSSTOP,0,1,ORAW)
 . N ORPI,ORPA,ORPN,X,ORPIFN
 . S ORPI=0 F  S ORPI=$O(^TMP("ORR",$J,ORLIST,ORPI)) Q:'ORPI  D
 .. S ORPIFN=+^TMP("ORR",$J,ORLIST,ORPI),ORPA=$P(^(ORPI),";",2)
 .. I $D(^OR(100,ORPIFN,8,ORPA,0)) S X=^(0),ORPN=$P(X,"^",12)
 .. I $G(ORPN),$D(^ORD(100.02,ORPN,1)),'$P(^(1),"^",3) K ^TMP("ORR",$J,ORLIST,ORPI)
 . I $$GET^XPAR("ALL","ORPF SUMMARY SORT FORWARD",1,"I") D SORT^ORPRS02
 . D @$S(ORSHORT:"EN^ORPRS04",1:"EN^ORPRS03")
 . K ^TMP("ORR",$J,ORLIST)
 I ORSHORT W !
END ; Clean up variables
 K I,II,J,K,NEXTP,NB,ND,NS,ORSLTR,ORES,ODATE,ORAGE,ORDCFC,ORMD,ORDG,ORDIC,ORDOB,OREND,ORFT,ORGRP,ORH,ORH2,ORHI,ORIO,ORL,ORLST,ORODT,ORNP,ORPD,ORPFG,ORPNM,ORPRES,ORUSER,ORPV,ORREQ
 K ORSEL,ORSEQ,ORSEX,ORSP,ORSPAT,ORSPL,ORSSN,ORSSTOP,ORSSTRT,ORSTRT,ORSTOP,ORSTS,ORASTS,ORTIT,ORTM,ORTS,ORTX,ORVP,ORWARD,ORX,X,X1,Y,%,%DT,%IS,ORSWD,ORSWDN,ORRPG,ORIFN
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
