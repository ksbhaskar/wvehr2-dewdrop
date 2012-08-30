LRCAPBB ;SLC/AM/DALISC/FHS - STORE WORKLOAD FROM 65,65.5 INTO ^LRO(64.1 ; 4/4/07 7:40am
        ;;5.2;LAB SERVICE;**72,201,325**;Sep 27, 1994;Build 34
        ;Reference to ^%ZTLOAD supported by IA #1519
        ;Reference to $$NOW^XLFDT supported by IA #10103
        ;VBECS workload included in process
EN      ;
        Q:'$P($G(^LAB(69.9,1,0)),U,14)
        S:'$D(^LAB(69.9,1,"NITE")) ^("NITE")=""
VBEC    ;Process VBECS workload collection
        N ZTIO,ZTRTN,ZTDTH
        I ZTDESC="COLLECT BLOOD BANK WORKLOAD" S ZTIO="",ZTRTN="LRCAPBV",ZTDTH=$H,ZTDESC="COLLECT VBECS WORKLOAD DATA" D ^%ZTLOAD
        L +^LRD(65,"AA"):1 I '$T G FIN
        L +^LRE("AA"):1 I '$T G FIN
        S $P(^LAB(69.9,1,"NITE"),"^",4)=$$NOW^XLFDT
        ;S X="TRAP^LRCAPBB",@^%ZOSF("TRAP")
INVENT  ;
        D INIT G:'$O(^LRD(65,"AA",0)) DONOR D FT
        I LRERR K ^LRD(65,"AA") D DUMP S ^TMP("LR WL ERRORS",LRX)="BASIC LRD(65 DATA MISSING" G DONOR
        F  S LRREC=$O(^LRD(65,"AA",LRREC)) Q:LRREC=""  S LRTS="" D
        .S LRFILE=LRREC_";LRD(65," F  S LRTS=$O(^LRD(65,"AA",LRREC,LRTS)) Q:LRTS=""  S LRDTTM="" F  S LRDTTM=$O(^LRD(65,"AA",LRREC,LRTS,LRDTTM)) Q:LRDTTM=""  S LRACC=^(LRDTTM) D  K ^LRD(65,"AA",LRREC,LRTS,LRDTTM)
        ..S LRCC=0 F  S LRCC=$O(^LRD(65,LRREC,99,LRTS,1,LRDTTM,1,LRCC)) Q:LRCC<1  D
        ...; LRRRL3 is the log in person, LRRRL4 is location type
        ...;S $P(^LAB(69.9,1,"NITE"),U,4)=LRREC_"99 "_LRTS_","_LRDTTM_","_LRCC
        ...S LRX=$G(^LRD(65,LRREC,99,LRTS,1,LRDTTM,0)),LRRRL3=$P(LRX,U,2),LRIN=$P(LRX,U,3),(LRAA,LRMA)=+$P(LRX,U,4),LRLSS=+$P(LRX,U,5) S:'LRLSS LRLSS=LRMA D CHK
        ...S LRX=$G(^LRD(65,LRREC,99,LRTS,1,LRDTTM,1,LRCC,0)),LRCNT=+$P(LRX,U,2)
        ...S:'LRCNT LRCNT=1
        ...S LRCTM=$P(LRDTTM,".",2),LRCDT=$P(LRDTTM,"."),(LRUW,LRCWT)=1
        ...I $D(^LAM(LRCC,0))#2 S LRX=^(0),LRUW=$P(LRX,"^",3),LRCWT=$P(LRX,"^",11)
        ...I (LRIN="")!(LRCC="")!(LRCDT="")!(LRCTM="")!(LRTS="") D DUMP Q
        ...W:'$D(ZTQUEUED) !,"WKLD CODE "_LRCC
        ...D ^LRCAPV3
        ...S $P(^LRD(65,LRREC,99,LRTS,1,LRDTTM,1,LRCC,0),"^",3)=1
        ..Q
DONOR   ;
        I '$O(^LRE("AA",0)) G FIN
        S LRERR=0,LRREC="" D FT2
        I LRERR K ^LRE("AA") D DUMP S ^TMP("LR WL ERRORS",LRX)="BASIC LRE( DATA MISSING" G FIN
        F  S LRREC=$O(^LRE("AA",LRREC)) Q:LRREC=""  S LRI="",LRFILE=LRREC_";LRE(" F  S LRI=$O(^LRE("AA",LRREC,LRI)) Q:LRI=""  S LRTS="" F  S LRTS=$O(^LRE("AA",LRREC,LRI,LRTS)) Q:LRTS=""  D
        .S LRDTTM="" F LRDTTM=$O(^LRE("AA",LRREC,LRI,LRTS,LRDTTM)) Q:LRDTTM=""  S LRACC=^(LRDTTM) D
        ..W:'$D(ZTQUEUED) !?5,"DONOR "_LRDTTM
        ..S LRCC=0 F  S LRCC=$O(^LRE(LRREC,5,LRI,99,LRTS,1,LRDTTM,1,LRCC)) Q:LRCC<1  D  K ^LRE("AA",LRREC,LRI,LRTS,LRDTTM)
        ...; LRRRL3 is the log in person, LRRRL4 is location type
        ...;S $P(^LAB(69.9,1,"NITE"),U,4)=LRREC_"5 "_LRI_"99 "_LRTS_","_LRDTTM_","_LRCC
        ...S LRX=$G(^LRE(LRREC,5,LRI,99,LRTS,1,LRDTTM,0)),LRRRL3=$P(LRX,U,2)
        ...S LRX=$G(^LRE(LRREC,5,LRI,99,LRTS,1,LRDTTM,1,LRCC,0)),LRCNT=+$P(LRX,U,2)
        ...S:'LRCNT LRCNT=1
        ...S LRCTM=$P(LRDTTM,".",2),LRCDT=$P(LRDTTM,"."),(LRWU,LRCWT)=1
        ...I $D(^LAM(LRCC,0))#2 S LRX=^(0),LRUW=$P(LRX,"^",3),LRCWT=$P(LRX,"^",11)
        ...I (LRIN="")!(LRCC="")!(LRCDT="")!(LRCTM="")!(LRTS="") D DUMP Q
        ...D ^LRCAPV3
        ...S $P(^LRE(LRREC,5,LRI,99,LRTS,1,LRDTTM,1,LRCC,0),"^",3)=1
        ..Q
FIN     S $P(^LAB(69.9,1,"NITE"),"^",4)="" L -^LRD(65,"AA") L -^LRE("AA")
        I $D(ZTQUEUED) S ZTREQ="@"
        D CLEAN
        Q
FT      ;
        S LRX=$G(^LAB(69.9,1,8.1,+$G(^LAB(69.9,1,10)),0)),LRIN=$P(LRX,U),(LRAA,LRMA)=+$P(LRX,U,2),LRLSS=+$P(LRX,U,3) S:'LRLSS LRLSS=LRMA D CHK
        Q
FT2     ;
        S LRX=$G(^LAB(69.9,1,8.1,+$G(^LAB(69.9,1,10)),0)),LRIN=$P(LRX,U),(LRAA,LRMA)=+$P(LRX,U,4),LRLSS=+$P(LRX,U,5) S:'LRLSS LRLSS=LRMA D CHK
        Q
CHK     S LRERR=$S('LRIN:1,'LRMA:1,1:0) Q:LRERR
        S:'$D(^LRO(68,LRMA,0))#2 LRERR=1 Q:LRERR  S LRX=^(0) I '$P(LRX,U,16) S LRERR=1 Q
        S:'LRLSS LRLSS=LRMA S LRWA=LRLSS
        S LRLD=$S($L($P(LRX,U,19)):$P(LRX,U,19),1:"CP")
        Q
DUMP    ;
        S LRX=$S($D(^TMP("LR WL ERRORS",0))#2:$P(^(0),U,3),1:0)+1,^TMP("LR WL ERRORS",0)=U_U_LRX
        S LRESTR="BLOOD BANK RECORD= "_$S($D(LRREC):LRREC,1:"")_" TS= "_$S($D(LRTS):LRTS,1:"")_" CC= "_$S($D(LRCC):LRCC,1:"")_" IN= "_$S($D(LRIN):LRIN,1:"")
        S LRESTR=LRESTR_" CDT= "_$S($D(LRCDT):LRCDT,1:"")_" CT= "_$S($D(LRCTM):LRCTM,1:"")
        S ^TMP("LR WL ERRORS",LRX,$H)=LRESTR
        Q
CLEAN   ;
        Q:$D(TEST)  K LRACC,LRAD,LRCC,LRDTTM,LRCDT,LRCNT,LRCTM,LRFILE,LRIDT,LRIN,LRLSS,LRMA
        K LROAD,LROL,LRRREC,LRRRL,LRTEC,LRTS,LRUG,LRX,LRZCNT,LRERR,LRQC,LRII
        K LRNT,LRCWT,LRREC,LRUW,X,LRESTR,LRWA,%,LRLD,LROAD1,LROAD2,LRRRL1
        K LRRRL2,LRRRL3,LRRRL4,LRI,LRFIRST,LRFNUM,LREND
        Q
INIT    ;
        S (LRREC,LRTS,LRACC,LROAD,LROAD1,LROAD2,LRRRL,LRRRL1,LRRRL2,LRRRL3,LROL,LRII,LRIDT,LRTEC,LRFNUM,LRERR)="",LRRRL4="Z",LRUG=50 ; These variables are needed by LRCAPV3
        Q
TRAP    ;
        S LREND=1 S:$D(^LAB(69.9,1,"NITE")) $P(^LAB(69.9,1,"NITE"),U,4)="ERROR"_$P(^("NITE"),"^",4) D @^%ZOSF("ERRTN")
        Q
