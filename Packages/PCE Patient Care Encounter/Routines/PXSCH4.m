PXSCH4  ;ISL/JVS,SCK - SCHEDULING REDESIGN PROCEDURES-DIAG #4 ;6/11/96
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**194**;Aug 12, 1996;Build 2
        ;  Variable List
        ;
        ; DXN800  "PXK" global data for various nodes
        ; DXN802       ""
        ; DXNOD0       ""
        ; DXNOD12      ""
        ; PXSDX     The Main Diagnosis
        ; PXSINDX   Index for "PXK" global
        ; PXSPR   The main provider
        ;
DIAG    ;Create nodes for diagnosis
        Q:'$D(PXS("DIAGNOSIS"))
        S PXSDX=0 F  S PXSDX=$O(PXS("DIAGNOSIS",PXSDX)) Q:PXSDX=""  D
        .S PXSINDX=PXSINDX+1
        .D DXNOD
        Q
DXNOD   ;
        S DXNOD0="",$P(DXNOD0,"^")=+$G(PXS("DIAGNOSIS",PXSDX))
        S $P(DXNOD0,"^",2)=$G(PXS("PATIENT")) ;PROVIDER
        S $P(DXNOD0,"^",3)=$G(PXS("VISIT")) ;VISIT
        S PXSFILE=9000010.07
        ;K ^UTILITY("DIQ1",$J)
        ;S DIC=80,DA=PXSDX,DR=3 D EN^DIQ1
        S PXSZPN=$P($$ICDDX^ICDCODE(PXSDX),U,4) ; Modified for 194
        ;S PXSZPN=$G(^UTILITY("DIQ1",$J,80,DA,3))
        ;K ^UTILITY("DIQ1",$J),DIC,DA,DR
        S $P(DXNOD0,"^",4)=+$$PROVNARR^PXAPI(PXSZPN,PXSFILE)
        Q:$P(DXNOD0,"^",4)=-1
        S DXNOD12=""
        ;S $P(DXNOD12,"^")=$G(PXS("DATE")) ;DATE AND TIME
        ;S $P(DXNOD12,"^",3)=$G(PXS("STOP CODE ORIG")) ;CLINIC STOP
        ;S $P(DXNOD12,"^",4)=$G(PXSPR) ;PROVIDER
        ;S $P(DXNOD12,"^",5)=$G(PXS("CLINIC")) ;HOSPITAL LOCATION
        ;S $P(DXNOD12,"^",7)=$P(DXNOD0,"^",3) ;SECONDARY VISIT
        S DXN800=""
        I $D(PXS("CLASSIFICATION",1)) S $P(DXN800,"^",2)=1
        I $D(PXS("CLASSIFICATION",2)) S $P(DXN800,"^",3)=1
        I $D(PXS("CLASSIFICATION",3)) S $P(DXN800,"^",1)=1
        I $D(PXS("CLASSIFICATION",4)) S $P(DXN800,"^",4)=1
        ;K ^UTILITY("DIQ1",$J)
        ;S DIC=80,DA=PXSDX,DR=5,DIQ(0)="E" D EN^DIQ1
        N PXS1
        S PXS1=$P($$ICDDX^ICDCODE(PXSDX),U,6) ; Modified for 194
        S PXSZPN=$$GET1^DIQ(80.3,PXS1,.01)
        ;S PXSZPN=$G(^UTILITY("DIQ1",$J,80,DA,5,"E"))
        ;--DECIDED TO REMOVE CATEGORY
        ;K ^UTILITY("DIQ1",$J)
        ;S $P(DXN802,"^",1)=+$$PROVNARR^PXAPI(PXSZPN,PXSFILE)
        ;I $P(DXN802,"^",1)'>0 S $P(DXN802,"^",1)=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,0,"AFTER")=$G(DXNOD0)
        S ^TMP("PXK",$J,"POV",PXSINDX+1,0,"BEFORE")=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,12,"AFTER")=$G(DXNOD12)
        S ^TMP("PXK",$J,"POV",PXSINDX+1,12,"BEFORE")=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,800,"AFTER")=$G(DXN800)
        S ^TMP("PXK",$J,"POV",PXSINDX+1,800,"BEFORE")=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,802,"AFTER")=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,802,"BEFORE")=""
        S ^TMP("PXK",$J,"POV",PXSINDX+1,"IEN")=""
        S ^TMP("PXK",$J,"SOR")=8
        S ^TMP("PXK",$J,"VST",1,"IEN")=$G(PXS("VISIT"))
DXDUP   ;Look for duplicates on the same visit
        N XPFG,XP
        S (XPFG,XP)=0 F  Q:XPFG  S XP=$O(^AUPNVPOV("AD",PXS("VISIT"),XP)) Q:XP=""  D
        .I $P(^AUPNVPOV(XP,0),"^",1)=+$G(PXS("DIAGNOSIS",PXSDX)) D
        ..S ^TMP("PXK",$J,"POV",PXSINDX+1,0,"BEFORE")=$G(^AUPNVPOV(XP,0))
        ..S ^TMP("PXK",$J,"POV",PXSINDX+1,12,"BEFORE")=$G(^AUPNVPOV(XP,12))
        ..S ^TMP("PXK",$J,"POV",PXSINDX+1,800,"BEFORE")=$G(^AUPNVPOV(XP,800))
        ..S ^TMP("PXK",$J,"POV",PXSINDX+1,802,"BEFORE")=+$G(^AUPNVPOV(XP,802))
        ..S ^TMP("PXK",$J,"POV",PXSINDX+1,"IEN")=XP
        ..S XPFG=1
        Q
