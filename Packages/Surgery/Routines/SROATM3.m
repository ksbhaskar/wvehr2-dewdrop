SROATM3 ;BIR/MAM - NON CARDIAC TRANSMISSION (CONT) ;06/21/10
        ;;3.0; Surgery ;**27,38,62,88,97,111,142,153,174**;24 Jun 93;Build 8
        ;** NOTICE: This routine is part of an implementation of a nationally
        ;**         controlled procedure. Local modifications to this routine
        ;**         are prohibited.
        ;;
        N SRCONMOD,SRMOD,SRPMOD,SR10SP
        S SHEMP=SHEMP_$J($P(SRA(201),"^",16),5)_$J($P(SRA(202),"^",16),7)_$J($P(SRA(201),"^",17),4)_$J($P(SRA(202),"^",17),7)_$J($P(SRA(203),"^"),5)_$J($P(SRA(204),"^"),7)_$J($P(SRA(203),"^",2),5)_$J($P(SRA(204),"^",2),7)
        S SHEMP=SHEMP_$J($P(SRA(203),"^",16),5)_$J($P(SRA(204),"^",16),7)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" 10",SRACNT=SRACNT+1
        S SHEMP=SHEMP_$J($P(SRA(203),"^",3),3)_$J($P(SRA(204),"^",3),7)_$J($P(SRA(203),"^",4),3)_$J($P(SRA(204),"^",4),7)_$J($P(SRA(203),"^",6),4)_$J($P(SRA(204),"^",6),7)
        S SHEMP=SHEMP_$J($P(SRA(203),"^",7),6)_$J($P(SRA(204),"^",7),7)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" 11",SRACNT=SRACNT+1
        S SHEMP=SHEMP_$J($P(SRA(203),"^",8),4)_$J($P(SRA(204),"^",8),7)_$J($P(SRA(203),"^",9),5)_$J($P(SRA(204),"^",9),7)_$J($P(SRA(203),"^",10),4)_$J($P(SRA(204),"^",10),7)
        S SHEMP=SHEMP_$J($P(SRA(203),"^",12),4)_$J($P(SRA(204),"^",12),7)_$J($P(SRA(203),"^",13),5)_$J($P(SRA(204),"^",13),7)_$J($P(SRA(203),"^",14),5)_$J($P(SRA(204),"^",14),7)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" 12",SRACNT=SRACNT+1
        S (SRPMOD,SRCONMOD)="",SR10SP="          " F I="OP","CON" S SRA(I)=$G(^SRF(SRTN,I))
        S CPT=$P($G(^SRO(136,SRTN,0)),"^",2) D
        .I SRA("CON"),$P($G(^SRF(SRA("CON"),30)),"^")!($P($G(^SRF(SRA("CON"),31)),"^",8)) S SRA("CON")=""
        .I CPT S CPT=$P($$CPT^ICPTCOD(CPT),"^",2),SRCASE=SRTN D MOD S SRPMOD=SRM
        .S SHEMP=SHEMP_$J(CPT,5),SRPMOD=SRPMOD_SR10SP
        S CPT="",CON=$P(SRA("CON"),"^") S:CON CPT=$P($G(^SRO(136,CON,0)),"^",2) D
        .I CPT S CPT=$P($$CPT^ICPTCOD(CPT),"^",2),SRCASE=CON D MOD S SRCONMOD=SRM
        .S SHEMP=SHEMP_$J(CPT,5),SRCONMOD=SRCONMOD_SR10SP
        S CPT="",SHEMP=SHEMP_$J(CPT,5)
        K CPT F I=1:1:10 S (CPT(I),SRMOD(I))=""
        S (OPS,CNT)=0 F  S OPS=$O(^SRO(136,SRTN,3,OPS)) Q:'OPS!(CNT=10)  S CNT=CNT+1,X=$P($G(^SRO(136,SRTN,3,OPS,0)),"^") I X S CPT(CNT)=$P($$CPT^ICPTCOD(X),"^",2) D OTH
        S SHEMP=SHEMP_$J(CPT(1),5)_$J(CPT(2),5)_$J(CPT(3),5)_$J(CPT(4),5)_$J(CPT(5),5)_$J(CPT(6),5)_$J(CPT(7),5)_$J(CPT(8),5)_$J(CPT(9),5)_$J(CPT(10),5)
        S SHEMP=SHEMP_$E(SRPMOD,1,10)_$E(SRCONMOD,1,10) F I=1:1:10 S SHEMP=SHEMP_$E(SRMOD(I)_SR10SP,1,10)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SRACNT=SRACNT+1
        ;
        ;Ethnicity contained in VADM(11)
        N SROETCD,SROPTF S SHEMP=$E(SHEMP,1,11)_" 13"
        S SROETCD="",SROPTF=""
        S SROETCD=$P($G(VADM(11,1)),U,1)            ;Ethnicity code
        S SROPTF=$$PTR2CODE^DGUTL4(SROETCD,2,4)     ;PTF Ethnicity code
        S SHEMP=SHEMP_$J($G(SROPTF),1)   ;Ethnicity
        ;
        ;Multiple races contained in VADM(12)
        N SRORAC,SRORCD,SRORCE S SRORCE=0,SRORAC="",SRORACE="",SRORCD=""
        F  S SRORCE=$O(VADM(12,SRORCE)) Q:SRORCE=""  D
        .S SRORAC=$P($G(VADM(12,SRORCE)),U,1)       ;Race code
        .S SRORCD=$$PTR2CODE^DGUTL4(SRORAC,1,4)     ;PTF race code
        .S SRORACE=SRORACE_$J(SRORCD,1)
        S SRORACE=SRORACE_"          "
        S SHEMP=SHEMP_$E(SRORACE,1,10)
        ;get name of person who completed assessment
        N SRP S SRP=$P($G(^SRF(SRTN,"RA")),"^",9) I SRP S Y=SRP,C=$P(^DD(130,272.1,0),"^",2) D Y^DIQ S SRP=Y
        S X=$L(SRP)+1 F I=X:1:35 S SRP=SRP_" "
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP_SRP   ;Line 13
        S SRACNT=SRACNT+1
        ;
        S SHEMP=$E(SHEMP,1,11)_" A1"
        S SHEMP=SHEMP_SRANAME,^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A2",SRACNT=SRACNT+1
        S SRA(0)=^SRF(SRTN,0),DFN=$P(SRA(0),"^") K SRA,VADM D ADD^VADPT
        S SHEMP=SHEMP_VAPA(1),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A3",SRACNT=SRACNT+1
        S SHEMP=SHEMP_VAPA(2),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A4",SRACNT=SRACNT+1
        S SHEMP=SHEMP_VAPA(3),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A5",SRACNT=SRACNT+1
        S SHEMP=SHEMP_VAPA(4),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A6",SRACNT=SRACNT+1
        S SHEMP=SHEMP_$P(VAPA(5),"^",2),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A7",SRACNT=SRACNT+1
        S SHEMP=SHEMP_VAPA(6),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_" A8",SRACNT=SRACNT+1
        S SHEMP=SHEMP_VAPA(8),^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SRACNT=SRACNT+1
        Q
MOD     ; get principal CPT modifiers
        S SRI=0,SRCNT=1,SRM="" F  S SRI=$O(^SRO(136,SRCASE,1,SRI)) Q:'SRI  D  Q:SRCNT>5
        .S X=$P(^SRO(136,SRCASE,1,SRI,0),"^"),Y=$P($$MOD^ICPTMOD(X,"I"),"^",2)
        .I Y'="" S SRM=SRM_Y,SRCNT=SRCNT+1
        Q
OTH     ; get other procedure CPT modifiers
        S SRI=0,SRCNT=1 F  S SRI=$O(^SRO(136,SRTN,3,OPS,1,SRI)) Q:'SRI  D  Q:SRCNT>5
        .S X=$P(^SRO(136,SRTN,3,OPS,1,SRI,0),"^"),Y=$P($$MOD^ICPTMOD(X,"I"),"^",2)
        .I Y'="" S SRMOD(CNT)=SRMOD(CNT)_Y,SRCNT=SRCNT+1
        Q
