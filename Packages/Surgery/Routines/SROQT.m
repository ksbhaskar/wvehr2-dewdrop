SROQT   ;BIR/ADM - QTRLY RPT MESSAGE TO SERVER ;05/11/10
        ;;3.0; Surgery ;**38,43,62,67,70,77,50,95,123,126,129,153,160,163,174**;24 Jun 93;Build 8
        ;** NOTICE: This routine is part of an implementation of a nationally
        ;**         controlled procedure. Local modifications to this routine
        ;**         are prohibited.
        ;
        S SRD=^XMB("NETNAME"),ISC=0 I $E(SRD,1,3)="FO-"!(SRD["ISC-")!(SRD["ISC.")!(SRD["FORUM")!(SRD["TST")!(SRD[".FO-") S ISC=1
        K ^TMP("SRQTR",$J),^TMP("SRATT",$J) N SRDIV S SRDIV=$P($$SITE^SROVAR,"^",3)_$S(SRIEN:"-"_SRIEN,1:"")
        S SRSMO=$E(SRSTART,4,5),SRQTR=$S(SRSMO=10:1,SRSMO="01":2,SRSMO="04":3,1:4),SRFYR=$S(SRQTR=1:$E(SRSTART,1,3)+1,1:$E(SRSTART,1,3))+1700,SRFQ=SRFYR_SRQTR
        S SRNODE=SRDIV_"^1^"_SRFQ_"^"_DT_"^"_SRCASES_"^"_SRMAJOR_"^"_SRMORT_"^"_SRCOMP_"^"_SRINPAT_"^"_SREMERG_"^"_SR60 F I=1:1:7 S SRNODE=SRNODE_"^"_SRASA(I)
        S SRNODE=SRNODE_"^"_SROPD_"^"_SRINV("O")_"^"_SRINV("I")_"^"_SRADMT
        I SRIEN S SRNODE=SRNODE_"^"_SRINST_"^"_SRSTATN
        S ^TMP("SRQTR",$J,1)=SRNODE
SP      S SRNODE=SRDIV_"^2" F SRSS=50:1:55 S SRNODE=SRNODE_"^"_^TMP("SRSS",$J,SRSS)
        S ^TMP("SRQTR",$J,2)=SRNODE
        S SRNODE=SRDIV_"^3" F SRSS=56:1:61 S SRNODE=SRNODE_"^"_^TMP("SRSS",$J,SRSS)
        S ^TMP("SRQTR",$J,3)=SRNODE
        S SRNODE=SRDIV_"^4" F SRSS=62,48,49,78,"ZZ" S SRNODE=SRNODE_"^"_^TMP("SRSS",$J,SRSS)
        S ^TMP("SRQTR",$J,4)=SRNODE
IX      S SRNODE=SRDIV_"^5" F J=1:1:6 D PROC
        S SRNODE=SRNODE_"^^^" F J=9:1:12 D PROC
        S ^TMP("SRQTR",$J,5)=SRNODE
COMP    S SRNODE=SRDIV_"^6" F I=1:1:39 S SRNODE=SRNODE_"^"_SRC(I)
        S ^TMP("SRQTR",$J,6)=SRNODE
RES     S X="" F I=1:1:14,99 S X=X_$G(SRATT(I))_"^"
        S ^TMP("SRATT",$J,"TOTAL")=X
        F K="J","N" S X="" D
        .F I=1:1:14,99 S X=X_$G(SRATT(K,I))_"^"
        .S ^TMP("SRATT",$J,K)=X
        S SRNODE=SRDIV_"^7^"_SRWC_"^"_$P(^TMP("SRATT",$J,"TOTAL"),"^",1,4)_"^"_$P(^TMP("SRATT",$J,"TOTAL"),"^",15)
        S SRNODE=SRNODE_"^"_SRIN_"^"_$P(^TMP("SRATT",$J,"J"),"^",1,4)_"^"_$P(^TMP("SRATT",$J,"J"),"^",15)_"^"_$P(^TMP("SRATT",$J,"N"),"^",1,4)_"^"_$P(^TMP("SRATT",$J,"N"),"^",15)
        S SRNODE=SRNODE_"^"_$P(^TMP("SRATT",$J,"TOTAL"),"^",5,8)_"^"_$P(^TMP("SRATT",$J,"J"),"^",5,8)_"^"_$P(^TMP("SRATT",$J,"N"),"^",5,8)
        S ^TMP("SRQTR",$J,7)=SRNODE
HIP     S SRNODE=SRDIV_"^8" F J=7,8 D PROC
        S SRNODE=SRNODE_"^"_SRTOV_"^"_SRTONO_"^"_SRTONE_"^"_SRICY_"^"_SRICNO_"^"_SRICNR_"^"_SRICNE_"^"_SRSCY_"^"_SRSCNO_"^"_SRSCNR_"^"_SRSCNE
        F I="C","D","N","P","S","U","O","ZZ" S SRNODE=SRNODE_"^"_SRHAIR(I)
        S ^TMP("SRQTR",$J,8)=SRNODE
        S SRNODE=SRDIV_"^9^"_$P(^TMP("SRATT",$J,"TOTAL"),"^",9,14)_"^"_$P(^TMP("SRATT",$J,"J"),"^",9,14)_"^"_$P(^TMP("SRATT",$J,"N"),"^",9,14)
        S ^TMP("SRQTR",$J,9)=SRNODE
MSG     ; create mail message to server
        S X=$$ACTIVE^XUSER(DUZ) I '+X S XMDUZ=.5
        S XMSUB="QUARTERLY REPORT - SURGICAL SERVICE"
        K XMY I 'ISC S (XMY("S.SRCOSERV@FO-HINES.MED.VA.GOV"),XMY("G.SRCOSERV@FO-HINES.MED.VA.GOV"))=""
        I ISC S XMY("G.SR-QUARTERLY@"_SRD)=""
        S XMTEXT="^TMP(""SRQTR"",$J," N I D ^XMD K ^TMP("SRQTR",$J),XMY,XMTEXT
        Q:SRIEN
MSG1    S XMY("G.SR-QUARTERLY@"_SRD)="",XMSUB="QUARTERLY REPORT TRANSMISSION"
        S SRMSG(1)="The Quarterly Report for quarter #"_$E(SRFQ,5)_" of fiscal year "_$E(SRFQ,1,4)_" has been"
        S SRMSG(2)="transmitted to the central database of Surgical Service, VHA Headquarters."
        S XMTEXT="SRMSG(" N I D ^XMD K XMY,XMTEXT
        D ^SROQM,SITE
        Q
PROC    S X=^TMP("SRPROC",$J,J),SRNODE=SRNODE_"^"_$P(X,"^")_"^"_$P(X,"^",3)_"^"_$P(X,"^",2)
        Q
QUE     ; queue creation of report to central database
        W ! K %DT S %DT("A")="Queue report to run at what date/time ? ",%DT(0)="NOW",%DT("B")="NOW",%DT="AEFXT" D ^%DT I Y=-1 S SRSOUT=1 G END^SROQ
        D TSK G END^SROQ
TSK     S ZTDTH=Y,ZTIO="",ZTDESC="Surgery Quarterly Report",(ZTSAVE("SRSTART"),ZTSAVE("SREND"),ZTSAVE("SRFLG"),ZTSAVE("SRT"))="",ZTRTN="EN^SROQT" D ^%ZTLOAD
        Q
EN      ; entry point when queued to generate mail report only
        K SRINSTP N SRDVSN,SRIEN,SRMULT S SRDVSN="",(SRCOUNT,SRIEN,SRMULT,X)=0 D
        .F  S X=$O(^SRO(133,X)) Q:'X  I '$P($G(^SRO(133,X,0)),"^",21) S SRCOUNT=SRCOUNT+1,SRDVSN(X)=$P(^SRO(133,X,0),"^")
        .I SRCOUNT>1 S SRMULT=1
        D SET^SROQ2,SROQT I SRMULT D
        .S SRIEN=0 F  S SRIEN=$O(SRDVSN(SRIEN)) Q:'SRIEN  D
        ..S SRINSTP=SRDVSN(SRIEN),SRINST=$$GET1^DIQ(4,SRINSTP,.01),SRSTATN=$$GET1^DIQ(4,SRINSTP,99)
        ..D SET^SROQ2,SROQT
        F I="SRATT","SRDEATH","SRDPT","SRDREL","SRDTH","SREXP","SRINOUT","SRIOD","SRP","SRPROC","SRREL","SRSP","SRSS","SRTN" K ^TMP(I,$J)
        S ZTREQ="@"
        I SRQTR=2 D Q1 Q
        I SRQTR=3 D Q2 Q
        I SRQTR=4 D Q3
        Q
SITE    ; update site parameters file
        S X=$E(SRSTART,4,7),Y=$S(X="1001":1,X="0101":2,X="0401":3,1:4),SRLATE=SRYR_Y
        S SRE=0 F  S SRE=$O(^SRO(133,SRE)) Q:'SRE  I $P(^SRO(133,SRE,0),"^",18)<SRLATE S $P(^(0),"^",18)=SRLATE
DALERT  ; delete alert
        S XQAID="SRQTR-"_SRLATE,XQAKILL=0 D DELETEA^XQALERT
        Q
NIGHT   ; determine if current quarterly report has been transmitted
        D CURRENT S SRYR=SRYR+1700,SRFQ=SRYR_SRQTR,SRE=0 S SRE=$O(^SRO(133,SRE)) I $P(^SRO(133,SRE,0),"^",18)'<SRFQ Q
        S SRALERT=0 I SRDAY>206&(SRDAY<214)!(SRDAY>507&(SRDAY<515))!(SRDAY>806&(SRDAY<814))!(SRDAY>1106&(SRDAY<1114)) S SRALERT=1
        D:SRALERT ALERT^SROQ1A D:'SRALERT AUTO
        Q
CURRENT ; get current reporting quarter
        S SRYR=$E(DT,1,3),SRDAY=$E(DT,4,7),SRQTR=4 I SRDAY>206 S SRQTR=$S(SRDAY<508:1,SRDAY<807:2,SRDAY<1107:3,1:4)
        I SRQTR=4,SRDAY<207 S SRYR=SRYR-1
        Q
DATES   ; get start and end dates
        S SRSMO=$S(SRQTR=1:"1001",SRQTR=2:"0101",SRQTR=3:"0401",1:"0701"),SREMO=$S(SRQTR=1:"1231",SRQTR=2:"0331",SRQTR=3:"0630",1:"0930"),SRSTART=$S(SRQTR=1:SRYR-1,1:SRYR)_SRSMO,SREND=$S(SRQTR=1:SRYR-1,1:SRYR)_SREMO
        Q
VAR     ; set report variables for non-interactive calls     
        D CURRENT,DATES S SRFLG=1
        Q
AUTO    ; automatic transmission of report
        D VAR S (SRT,SRSOUT)=1 D NOW^%DTC S Y=$E(%,1,12) D TSK
        Q
Q1      ; transmit report for 1st quarter
        S (SRFLG,SRT)=1 D NOW^%DTC S SRNOW=+$E(%,1,12)
        S SRYR=$E(SRSTART,1,3),SRYR=SRYR-1,SRSTART=SRYR_"1001",SREND=SRYR_"1231" D TSK1
        Q
Q2      ; transmit report for 2nd quarter
        S (SRFLG,SRT)=1 D NOW^%DTC S SRNOW=+$E(%,1,12)
        S SRYR=$E(SRSTART,1,3),SRSTART=SRYR_"0101",SREND=SRYR_"0331" D TSK1
        Q
Q3      ; transmit report for 3rd quarter
        S (SRFLG,SRT)=1 D NOW^%DTC S SRNOW=+$E(%,1,12)
        S SRYR=$E(SRSTART,1,3),SRSTART=SRYR_"0401",SREND=SRYR_"0630" D TSK1
        Q
TSK1    S ZTDTH=SRNOW,ZTIO="",ZTDESC="Surgery Quarterly Report",(ZTSAVE("SRSTART"),ZTSAVE("SREND"),ZTSAVE("SRFLG"),ZTSAVE("SRT"))="",ZTRTN="EN^SROQT" D ^%ZTLOAD
        Q
