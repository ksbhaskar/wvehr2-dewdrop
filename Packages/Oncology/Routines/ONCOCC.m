ONCOCC  ;HINES OIFO/GWB - CLASS OF CASE (165.5,.04) 5 OR 8 ;06/03/96
        ;;2.11;ONCOLOGY;**5,13,16,19,20,22,24,26,30,33,36,37,39,47,50**;Mar 07, 1995;Build 29
        ;
        S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16)
        S TPG=$P($G(^ONCO(165.5,D0,2)),U,1)
        S SGRP="" I TPG'="" S SGRP=$P($G(^ONCO(164,TPG,0)),U,16)
        F P=5,9,12,15,18,24 S $P(^ONCO(165.5,D0,3),U,P)=""
        K ^ONCO(165.5,DA,6) S $P(^ONCO(165.5,DA,3),U,7)=0
        K ^ONCO(165.5,DA,14),^ONCO(165.5,DA,15),^ONCO(165.5,DA,16),^ONCO(165.5,DA,17),^ONCO(165.5,DA,18),^ONCO(165.5,DA,20),^ONCO(165.5,DA,21)
        I COC=5 D COC5
        I COC=8 D COC8
        D SCT Q
        ;
COC5    S $P(^ONCO(165.5,D0,3),U,35)=9
        S $P(^ONCO(165.5,D0,3),U,27)=$S(DTDX>2951231:"00",1:0)
        S $P(^ONCO(165.5,D0,3.1),U,5)=$S(DTDX>2951231:"00",1:0)
        S $P(^ONCO(165.5,D0,3.1),U,29)=1
        S $P(^ONCO(165.5,D0,3.1),U,30)=1
        S $P(^ONCO(165.5,D0,3),U,34)=1
        S $P(^ONCO(165.5,D0,3.1),U,28)=0
        S $P(^ONCO(165.5,D0,3.1),U,39)=0
        S $P(^ONCO(165.5,D0,0),U,10)=6
        S $P(^ONCO(165.5,D0,3),U,26)=9
        S $P(^ONCO(165.5,D0,3),U,28)=8
        S TPG=$P($G(^ONCO(165.5,DA,2)),U,1)
        I ($E(TPG,3,4)=76)!(TPG=67809)!(TPG=67420)!(TPG=67421)!(TPG=67423)!(TPG=67424) S $P(^ONCO(165.5,DA,3),U,28)=9
        S MO=$$HIST^ONCFUNC(DA)
        S HIST14=$E(MO,1,4)
        I (HIST14=9750)!((HIST14>9759)&(HIST14<9765))!((HIST14>9799)&(HIST14<9821))!(HIST14=9826)!((HIST14>9830)&(HIST14<9921))!((HIST14>9930)&(HIST14<9965))!((HIST14>9979)&(HIST14<9990)) S $P(^ONCO(165.5,DA,3),U,28)=9
        I $$LYMPHOMA^ONCFUNC(DA),($E(TPG,3,4)=77) S $P(^ONCO(165.5,DA,3),U,28)=9
        S $P(^ONCO(165.5,D0,3.1),U,31)=0
        S $P(^ONCO(165.5,D0,3.1),U,32)=0
        I ($E(TPG,1,4)=6770)!($E(TPG,1,4)=6771)!($E(TPG,1,4)=6772)!($E(TPG,1,4)=6776)!(($$LYMPHOMA^ONCFUNC(DA)=1)&($E(TPG,1,4)=6777))!($E(TPG,1,4)=6776)!(TPG=67809)!(TPG=67420)!(TPG=67421)!(TPG=67423)!(TPG=67424)!((MO'<97310)&(MO'>99899)) D
        .S $P(^ONCO(165.5,D0,3.1),U,31)=9
        .S $P(^ONCO(165.5,D0,3.1),U,32)=9
        S $P(^ONCO(165.5,D0,3.1),U,33)=0
        S $P(^ONCO(165.5,D0,3.1),U,34)=0
        S $P(^ONCO(165.5,D0,3),U,33)=$S(DTDX>2971231:1,1:9)
        F P=6,10,25 S $P(^ONCO(165.5,D0,3),U,P)=0
        F P=12,20 S $P(^ONCO(165.5,D0,3.1),U,P)=0
        S $P(^ONCO(165.5,DA,"THY1"),U,43)=$S(DTDX>2971231:0,1:"")
        S $P(^ONCO(165.5,DA,3),U,13)="00"
        S $P(^ONCO(165.5,DA,3.1),U,14)="00"
        S $P(^ONCO(165.5,DA,3),U,16)="00"
        S $P(^ONCO(165.5,DA,3.1),U,16)="00"
        S $P(^ONCO(165.5,DA,3),U,19)="00"
        S $P(^ONCO(165.5,DA,3.1),U,18)="00"
        S $P(^ONCO(165.5,DA,3.1),U,36)=1
        S $P(^ONCO(165.5,DA,3),U,20)=$S(DTDX>2971231:0,1:"")
        S $P(^ONCO(165.5,DA,3),U,21)=$S(DTDX>2971231:1,1:"")
        S $P(^ONCO(165.5,DA,3),U,22)=$S(DTDX>2971231:0,1:"")
        S $P(^ONCO(165.5,DA,3),U,29)=$S(DTDX>2971231:0,1:"")
        S $P(^ONCO(165.5,DA,3),U,39)=$S(DTDX>2971231:1,1:"")
        S $P(^ONCO(165.5,DA,3.1),U,3)=$S(DTDX>2971231:0,1:"")
        S $P(^ONCO(165.5,DA,3.1),U,1)=$S(DTDX>2971231:1,1:"")
        S $P(^ONCO(165.5,DA,"THY1"),U,36)="0000000"
        S $P(^ONCO(165.5,DA,"BLA2"),U,16)="0000000"
        S $P(^ONCO(165.5,DA,"BLA2"),U,18)=1
        S $P(^ONCO(165.5,DA,3),U,5)=""
        F PP=1,4,11,14,17,23,31 S $P(^ONCO(165.5,DA,3),U,PP)="0000000"
        F PP=6,8,13:2:19,21:1:25,35,38 S $P(^ONCO(165.5,DA,3.1),U,PP)="0000000"
        K ^ONCO(165.5,"ATX",DA)
        S ^ONCO(165.5,"ATX",DA,"0000000S1")=""
        S ^ONCO(165.5,"ATX",DA,"0000000S2")=""
        S ^ONCO(165.5,"ATX",DA,"0000000S3")=""
        S ^ONCO(165.5,"ATX",DA,"0000000R")=""
        S ^ONCO(165.5,"ATX",DA,"0000000C")=""
        S ^ONCO(165.5,"ATX",DA,"0000000H")=""
        S ^ONCO(165.5,"ATX",DA,"0000000B")=""
        S ^ONCO(165.5,"ATX",DA,"0000000E")=""
        S ^ONCO(165.5,"ATX",DA,"0000000O")=""
        Q
        ;
COC8    ;CLASS OF CASE (165.5,.04) value 8 (Death cert) used by central
        ;registries only
        Q
        ;
SCT     I $D(^ONCO(165.5,D0,4)) S SCTIEN=0 F  S SCTIEN=$O(^ONCO(165.5,D0,4,SCTIEN)) Q:SCTIEN'>0  D
        .S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,4)="00"
        .I COC=5 D
        ..F P=11,12,13,14,15,16,17 S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,P)="0000000"
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,5)=0
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,6)="00"
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,7)="00"
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,9)=0
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,0),U,10)=0
        ..S $P(^ONCO(165.5,D0,4,SCTIEN,3),U,19)=0
        K BRM,FLD,P,REC,RFNR,RFNC,RFNHT,RR
        K SA,SC,SM,SO,SPS,SCTIEN,SGRP,TPG
        Q
        ;
SATFDFR ;SURGERY OF PRIMARY @FAC (R) (165.5,50.2) default
        N SPS S SPS=$P($G(^ONCO(165.5,D0,3)),U,38)
        D SGROUP I TPG="" Q
        I (SPS="00")!(SPS=1)!($G(^ONCO(164,SGRP,"SPS",SPS,0))["Unknown") S Y="@427" Q
        S SPSDF="" I (COC=1)!(COC=2) D  Q
        .S SPSDF=$P($G(^ONCO(164,SGRP,"SPS",SPS,0)),U,1)
        .S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16) S:DTDX<2980000 SPSDF=""
        Q
        ;
SATFDEF ;SURGERY OF PRIMARY @FAC (F) (165.5,58.7) default
        N SPS S SPS=$P($G(^ONCO(165.5,D0,3.1)),U,29)
        I SPS="" Q
        D SGROUP I TPG="" Q
        I (SPS="00")!(SPS=1)!($G(^ONCO(164,SGRP,"SPS",SPS,0))["Unknown") S Y="@43" Q
        S (SPSDF,SPSDTDF)="" I (COC=1)!(COC=2) D  Q
        .S SPSDF=$P($G(^ONCO(164,SGRP,"SPS",SPS,0)),U,1)
        .S SPSDTDF=$$GET1^DIQ(165.5,D0,50,"E")
        .S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16) S:DTDX<2980000 (SPSDF,SPSDTDF)=""
        Q
        ;
RATFDEF ;RADIATION @FACILITY (165.5,51.4) default
        S RD=$P($G(^ONCO(165.5,D0,3)),U,6)
        S RADDF="",RADDTDF="" I (COC=1)!(COC=2) D  Q
        .I RD'="" D
        ..S XX=$F(^DD(165.5,51.2,0),RD_":")
        ..S YY=$F(^DD(165.5,51.2,0),";",XX)
        ..S RADDF=$E(^DD(165.5,51.2,0),XX,YY-2)
        .S RADDTDF=$P($G(^ONCO(165.5,D0,3)),U,4)
        Q
        ;
CATFDEF ;CHEMOTHERAPY @FAC (165.5,53.3) default
        S CH=$P($G(^ONCO(165.5,D0,3)),U,13)
        S CHEMDF="",CHMDTDF="" I (COC=1)!(COC=2) D  Q
        .I CH'="" D
        ..S XX=$F(^DD(165.5,53.2,0),CH_":")
        ..S YY=$F(^DD(165.5,53.2,0),";",XX)
        ..S CHEMDF=$E(^DD(165.5,53.2,0),XX,YY-2)
        .S CHMDTDF=$P($G(^ONCO(165.5,D0,3)),U,11)
        Q
        ;
HATFDEF ;HORMONE THERAPY @FAC (165.5,54.3) default
        S HT=$P($G(^ONCO(165.5,D0,3)),U,16)
        S HTDF="",HTDTDF="" I (COC=1)!(COC=2) D  Q
        .I HT'="" D
        ..S XX=$F(^DD(165.5,54.2,0),HT_":")
        ..S YY=$F(^DD(165.5,54.2,0),";",XX)
        ..S HTDF=$E(^DD(165.5,54.2,0),XX,YY-2)
        .S HTDTDF=$P($G(^ONCO(165.5,D0,3)),U,14)
        Q
        ;
IATFDEF ;IMMUNOTHERAPY @FAC (165.5,55.3) default
        S IMM=$P($G(^ONCO(165.5,D0,3)),U,19)
        S IMMDF="",IMMDTDF="" I (COC=1)!(COC=2) D  Q
        .I IMM'="" D
        ..S XX=$F(^DD(165.5,55.2,0),IMM_":")
        ..S YY=$F(^DD(165.5,55.2,0),";",XX)
        ..S IMMDF=$E(^DD(165.5,55.2,0),XX,YY-2)
        .S IMMDTDF=$P($G(^ONCO(165.5,D0,3)),U,17)
        Q
        ;
OATFDEF ;OTHER TREATMENT @FAC (165.5,57.3) default
        S OTH=$P($G(^ONCO(165.5,D0,3)),U,25)
        S OTHDF="",OTHDTDF="" I (COC=1)!(COC=2) D  Q
        .I OTH'="" D
        ..S XX=$F(^DD(165.5,57.2,0),OTH_":")
        ..S YY=$F(^DD(165.5,57.2,0),";",XX)
        ..S OTHDF=$E(^DD(165.5,57.2,0),XX,YY-2)
        .S OTHDTDF=$P($G(^ONCO(165.5,D0,3)),U,23)
        Q
        ;
PATFDEF ;PALLIATIVE PROCEDURE @FAC (165.5,13) default
        S PP=$P($G(^ONCO(165.5,D0,3.1)),U,26)
        S PPDF="" I (COC=1)!(COC=2) D  Q
        .I PP'="" D
        ..S XX=$F(^DD(165.5,12,0),PP_":")
        ..S YY=$F(^DD(165.5,12,0),";",XX)
        ..S PPDF=$E(^DD(165.5,12,0),XX,YY-2)
        Q
        ;
SCOPER  ;SCOPE OF LN SURGERY @FAC (R) (165.5,138.1) default
        N SCOPE S SCOPE=$P($G(^ONCO(165.5,D0,3)),U,40) I SCOPE="" Q
        D SGROUP I TPG="" Q
        S SCPDF="" I (COC=1)!(COC=2) D  Q
        .S SCPDF=$P($G(^ONCO(164,SGRP,"SC5",SCOPE,0)),U,1)
        Q
        ;
SCOPE   ;SCOPE OF LN SURGERY @FAC (F) (165.5,138.5) default
        ;SCOPE OF LN SURGERY @FAC DATE (165.5,138.3) default
        N SCOPE S SCOPE=$P($G(^ONCO(165.5,D0,3.1)),U,31) I SCOPE="" Q
        S (SCPDF,SCPDTDF)="" I (COC=1)!(COC=2) D  Q
        .I SCOPE'="" D
        ..S XX=$F(^DD(165.5,138.5,0),SCOPE_":")
        ..S YY=$F(^DD(165.5,138.5,0),";",XX)
        ..S SCPDF=$E(^DD(165.5,138.5,0),XX,YY-2)
        .S SCPDTDF=$P($G(^ONCO(165.5,D0,3.1)),U,22)
        Q
        ;
NUMN    ;NUMBER OF LN REMOVED @FAC (R) (165.5,140.1) default
        N NODES S NODES=$P($G(^ONCO(165.5,D0,3)),U,42)
        S NUMDF="" I (COC=1)!(COC=2) D  Q
        .S NUMDF=NODES
        .I NUMDF="00" S NUMDF=NUMDF_"  No nodes removed"
        .I NUMDF="90" S NUMDF=NUMDF_"  90 or more nodes removed"
        .I NUMDF="95" S NUMDF=NUMDF_"  No nodes removed, aspiration performed"
        .I NUMDF="96" S NUMDF=NUMDF_"  Node removal as a sampling, number unknown"
        .I NUMDF="97" S NUMDF=NUMDF_"  Node removal as dissection, number unknown"
        .I NUMDF="98" S NUMDF=NUMDF_"  Nodes surgically removed, number unknown"
        .I NUMDF="99" S NUMDF=NUMDF_"  Unknown, not stated, death cert ONLY"
        Q
        ;
SOSNR   ;SURG PROC/OTHER SITE @FAC (R) (165.5,139.1) default
        N SOSN S SOSN=$P($G(^ONCO(165.5,D0,3)),U,41) I SOSN="" Q
        D SGROUP I TPG="" Q
        S SOSNDF="" I (COC=1)!(COC=2) D  Q
        .S SOSNDF=$P($G(^ONCO(164,SGRP,"SO5",SOSN,0)),U,1)
        Q
        ;
SOSN    ;SURG PROC/OTHER SITE @FAC (F) (165.5,139.5) default
        N SOSN S SOSN=$P($G(^ONCO(165.5,D0,3.1)),U,33) I SOSN="" Q
        S (SOSNDF,SOSNDTDF)="" I (COC=1)!(COC=2) D  Q
        .I SOSN'="" D
        ..S XX=$F(^DD(165.5,139.5,0),SOSN_":")
        ..S YY=$F(^DD(165.5,139.5,0),";",XX)
        ..S SOSNDF=$E(^DD(165.5,139.5,0),XX,YY-2)
        .S SOSNDTDF=$P($G(^ONCO(165.5,D0,3.1)),U,24)
        Q
        ;
SGROUP  S TPG=$P($G(^ONCO(165.5,D0,2)),U,1) I TPG="" Q
        S SGRP=$P($G(^ONCO(164,TPG,0)),U,16)
        Q
