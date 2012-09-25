ONCPST52        ;Hines OIFO/GWB - POST-INSTALL ROUTINE FOR PATCH ONC*2.11*52 ;11/04/10
        ;;2.11;ONCOLOGY;**52**;Mar 07, 1995;Build 13
        ;
IT1016  N CNT,DCC,DCLC,DOLCOD,DTENT,FAA,FIEN,IEN,ONCPT,PBI,SGC,SGP
        W !!," Re-calculating DATE CASE LAST CHANGED..."
        S IEN=0 F CNT=1:1 S IEN=$O(^ONCO(165.5,IEN)) Q:IEN'>0  W:CNT#100=0 "." D
        .S SGC=$P($G(^ONCO(165.5,IEN,2)),U,20)
        .S SGP=$P($G(^ONCO(165.5,IEN,2.1)),U,4)
        .I SGC="1E" S $P(^ONCO(165.5,IEN,2),U,20)=1,$P(^ONCO(165.5,IEN,24),U,22)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="1E" S $P(^ONCO(165.5,IEN,2.1),U,4)=1,$P(^ONCO(165.5,IEN,24),U,23)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGC="2E" S $P(^ONCO(165.5,IEN,2),U,20)=2,$P(^ONCO(165.5,IEN,24),U,22)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="2E" S $P(^ONCO(165.5,IEN,2.1),U,4)=2,$P(^ONCO(165.5,IEN,24),U,23)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGC="3E" S $P(^ONCO(165.5,IEN,2),U,20)=3,$P(^ONCO(165.5,IEN,24),U,22)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="3E" S $P(^ONCO(165.5,IEN,2.1),U,4)=3,$P(^ONCO(165.5,IEN,24),U,23)=1,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGC="3S" S $P(^ONCO(165.5,IEN,2),U,20)=3,$P(^ONCO(165.5,IEN,24),U,22)=2,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="3S" S $P(^ONCO(165.5,IEN,2.1),U,4)=3,$P(^ONCO(165.5,IEN,24),U,23)=2,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGC="3ES" S $P(^ONCO(165.5,IEN,2),U,20)=3,$P(^ONCO(165.5,IEN,24),U,22)=5,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="3ES" S $P(^ONCO(165.5,IEN,2.1),U,4)=3,$P(^ONCO(165.5,IEN,24),U,23)=5,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGC="4S" S $P(^ONCO(165.5,IEN,2),U,20)=4,$P(^ONCO(165.5,IEN,24),U,22)=2,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I SGP="4S" S $P(^ONCO(165.5,IEN,2.1),U,4)=4,$P(^ONCO(165.5,IEN,24),U,23)=2,$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .S PBI=$P($G(^ONCO(165.5,IEN,24)),U,5)
        .I PBI="000" S $P(^ONCO(165.5,IEN,24),U,5)="B0",$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I PBI="001" S $P(^ONCO(165.5,IEN,24),U,5)="B0",$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I PBI="002" S $P(^ONCO(165.5,IEN,24),U,5)="B1",$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I PBI="003" S $P(^ONCO(165.5,IEN,24),U,5)="",$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .I PBI=999 S $P(^ONCO(165.5,IEN,24),U,5)="",$P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .Q:$P($G(^ONCO(165.5,IEN,7)),U,2)'=3
        .S ONCPT=$P($G(^ONCO(165.5,IEN,0)),U,2)
        .S DOLCOD=$$GET1^DIQ(160,ONCPT,16,"I")
        .S DCLC=$P($G(^ONCO(165.5,IEN,7)),U,21)
        .S DCC=$P($G(^ONCO(165.5,IEN,7)),U,1)
        .S DTENT=""
        .S FAA=$S('$D(^ONCO(160,ONCPT,"F","AA")):"",1:9999999-$O(^ONCO(160,ONCPT,"F","AA",0)))
        .I FAA'="" S FIEN=$O(^ONCO(160,ONCPT,"F","B",FAA,0)) S DTENT=$P(^ONCO(160,ONCPT,"F",FIEN,0),U,11)
        .I DOLCOD="",DCLC="" D  Q
        ..S $P(^ONCO(165.5,IEN,7),U,21)=DCC
        ..S ^ONCO(165.5,"AAE",DCC,IEN)=""
        ..S $P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        .Q:DOLCOD=""
        .I DTENT'="" S DOLCOD=DTENT
        .Q:($P(DOLCOD,"/",1)=99)!($P(DOLCOD,"/",2)=99)
        .I DTENT="" S DOLCOD=($P(DOLCOD,"/",3)-1700)_$P(DOLCOD,"/",1)_$P(DOLCOD,"/",2)
        .I DOLCOD>DCLC D
        ..I DCLC'="" K ^ONCO(165.5,"AAE",DCLC,IEN)
        ..S $P(^ONCO(165.5,IEN,7),U,21)=DOLCOD
        ..S ^ONCO(165.5,"AAE",DOLCOD,IEN)=""
        ..S $P(^ONCO(165.5,IEN,"EDITS"),U,2)=11
        ;
ITEM14  ;Add BENDAMUSTINE to CHEMOTHERAPEUTIC DRUGS (164.18) file
        N CHEMOIEN,D0,DA,DD,DIC,X,Y
        Q:$D(^ONCO(164.18,"B","BENDAMUSTINE"))
        K DD,DO
        S DIC="^ONCO(164.18,",DIC(0)="L"
        S X="BENDAMUSTINE"
        S DIC("DR")="1///065628"
        D FILE^DICN
        I Y=-1 Q
        S CHEMOIEN=+Y
        S DA(1)=CHEMOIEN
        S DIC="^ONCO(164.18,"_DA(1)_",1,"
        S DIC(0)="L"
        F X="TREANDA","RIBOMUSTIN","SDX-105" D FILE^DICN
