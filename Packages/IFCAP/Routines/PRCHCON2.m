PRCHCON2 ;WISC/KMB-CONV. TEMPORARY 2237 TO PC ORDER ;1/9/97  3:08 PM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
SET442 ; set variables needed to create 442 record
 N NDA,SERV,IC,AA,BB,CC,CR,BOC,FSC,TOTAL,STR1,I,J,II,ZS,ZSO,PMULT,CONV,CONT,ITEM,VSTOCK,UCOST,UOP,MAX,NSN,CCEN,NCOST
 N NDC,QTY,SKU,SPEC,PRCHCV,PRCHCCP,PRCHV,PRCHCPD,PRCHCI,PRCHCII,PRCHCPO
 N VENDOR,VENDOR1,CNT,CNNT,CP,FCP,TDATE,SG,NDA,AR,PRCHPC
 S PRCHPC=2,PRCKAREN=1
 S PRC("SITE")=$P(PNW(1),"-"),PRC("FY")=$P(PNW(1),"-",2),PRC("QTR")=$P(PNW(1),"-",3),PRCSQ=1
 S (CNNT,CNT,IC)=""
 F I=1:1:14 S AR(I)=$G(^PRCS(410,DA,I))
 S CCEN=$P(AR(3),U,3),VENDOR=$P(AR(3),U,4),VENDOR1=$P(AR(2),U),NCOST=$P(AR(4),U),CR=$P(AR(1),U,5),SG=$P(AR(11),U),FCP=PRC("CP"),CP=$P(PRC("CP")," ")
 S CCEN=$P(CCEN," ")
 S PRCHCV=VENDOR1,PRCHCPD=+$P(AR(1),U,15),PRCHCCP=CP
 S CNNT=$P($G(^PRCS(410,DA,"IT",0)),U,4) I CNNT'="" S IC=1 F I=1:1:CNNT D
 .S STR1=$G(^PRCS(410,DA,"IT",I,0)) I STR1="" Q
 .S (FSC,PMULT,NSN,MAX,NDC,SKU,CONT,CONV)="",AA(IC)=$P(STR1,U) F II=2:1:7 S AA(IC)=AA(IC)_"^"_$P(STR1,"^",II)
 .S UCOST=$P(STR1,U,7),ITEM=$P(STR1,U,5),QTY=$P(STR1,U,2)
 .I VENDOR'="",ITEM'="",$G(^PRC(441,ITEM,2,+VENDOR,0))'="" D
 ..S ZSO=$G(^PRC(441,ITEM,2,+VENDOR,0)),ZS=$G(^PRC(441,ITEM,0))
 ..S NSN=$P(ZS,U,5),BOC=$P(ZS,U,10),FSC=$P(ZS,U,3),UCOST=$P(ZSO,U,2),CONT=$P(ZSO,U,3)
 ..S PMULT=$P(ZSO,U,8),MAX=$P(ZSO,U,9),CONV=$P(ZSO,U,10) S:CONT'="" CONT=$P($G(^PRC(440,+VENDOR,4,CONT,0)),U)
 ..S SKU=$P($G(^PRC(441,ITEM,3)),U,8)
 .S CNT=+$P($G(^PRCS(410,DA,"IT",IC,1,0)),U,2) I CNT'="" S CNT=+$P($G(^PRCS(410,DA,"IT",IC,1,0)),U,4)
 .I $G(CNT)'="" F J=1:1:CNT S BB(IC,J)=$G(^PRCS(410,DA,"IT",IC,1,J,0))
 .S AA(IC)=AA(IC)_"^"_"^^"_UCOST_"^^^"_PMULT_"^"_NSN_"^"_MAX_"^"_NDC_"^"_SKU_"^"_CONV
 .S TOTAL=QTY*UCOST,CC(IC)=TOTAL_"^"_CONT_"^"_FSC
 .S IC=IC+1
 S CNNT=IC-1,PRC("PARAM")=$$NODE^PRC0B("^PRC(411,PRC(""SITE""),",0)
 D NOW^%DTC S SPEC=$P($G(^PRC(420,PRC("SITE"),1,CP,0)),U,12),SERV=$P($G(^(0)),U,10),TDATE=X
 ;;;;;;;;;;;;;;;;
 S NDA=DA K DA D ^PRCHCON3
 I $G(PDA)'="" S $P(^PRCS(410,NDA,4),"^",5)=$P($P(^PRC(442,PDA,0),"^"),"-",2)
 K %,PDA,OUT,DR,DA,DIE,FLAG,PRC,PRCKAREN Q
