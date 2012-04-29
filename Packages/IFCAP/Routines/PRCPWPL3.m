PRCPWPL3 ;WISC/RFJ-whse post issue book (post)                      ;13 Jan 94
 ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
 ;
POST ;  post issue book
 D FULL^VALM1
 S VALMBCK="R"
 I '$O(^TMP($J,"PRCPWPLMPOST",0)) S VALMSG="THERE ARE NO ITEMS TO POST" D  Q
 .   W !!!!?5,$G(PRCP("RV1")),"WARNING: ",VALMSG,$G(PRCP("RV0")),!
 .   I $G(PRCPFINL) D FINAL^PRCPWPL5 K VALMBCK Q
 .   I $D(PRCPFINL) Q
 .   I $$FINALASK^PRCPWPL2=1 D FINAL^PRCPWPL5 K VALMBCK
 ;
 I $G(PRCPFERR) S VALMSG="ALL ERRORS MUST BE FIXED BEFORE POSTING" Q
 ;
 N %,CANTEEN,COSTCNTR,DRUGACCT,IBDATA,INVCOST,ITEMDA,ITEMDATA,LINEDA,PRCPFLAG,PRCPPORD,PRCPWORD,PRCPWPL3,QTYPOST,QUANTITY,TOTALINV,TOTALSAL,TOTCOST,TOTLINES,UNITCOST,X
 N PRCPPBFY,PRCPPFCP,PRCPPSTA,PRCPWBFY,PRCPWFCP,PRCPWSTA
 ;  get whse and primary fcp data for fms code sheets
 ;  variables will be passed to prcpsfiv routine
 D IVDATA^PRCPSFIU(PRCPDA,PRCPINPT)
 ;
 ;  primary updated by whse posting
 I PRCPFPRI D
 .   I $P($G(^PRCP(445,PRCPPRIM,0)),"^",20)="D" S X="PSAGIP" I $D(^%ZOSF("TEST")) X ^("TEST") I $T S DRUGACCT=1 K X S X(1)="NOTE: This is a DRUG ACCOUNTABILITY inventory point." D DISPLAY^PRCPUX2(1,79,.X)
 ;
RETRY ;  come back to this label if reference voucher number not found
 S XP="ARE YOU SURE YOU WANT TO POST THIS ISSUE BOOK"
 W ! I $$YN^PRCPUYN(1)'=1 Q
 ;
 I '$$LOCK Q
 ;
 ;  get reference number if it does not exist
 I $G(PRCPORD)="" D  I PRCPORD="" D UNLOCK G RETRY
 .   S PRCPORD=$$IBCNS^PRCPWPU1(PRC("SITE")_"-I"_$E(PRC("FY"),2))
 .   I PRCPORD="" Q
 .   S $P(^PRCS(410,PRCPDA,445),"^")=PRCPORD
 ;
 S PRCPWORD=$$ORDERNO^PRCPUTRX(PRCPINPT)
 I PRCPFPRI S PRCPPORD=$$ORDERNO^PRCPUTRX(PRCPPRIM)
 W !!?4,"REFERENCE VOUCHER NUMBER    : ",PRCPORD
 W !?4,"WHSE TRANSACTION REGISTER ID: R",PRCPWORD
 I $P($G(^PRC(420,PRCPPSTA,1,PRCPPFCP,0)),"^",12)=4 S CANTEEN=1
 D POST^PRCPWPL4
 Q
 ;
 ;
LOCK() ;  lock whse and primary invpts
 ;  return 1 for success
 L +^PRCP(445,PRCPINPT,1):5 I '$T D SHOWWHO^PRCPULOC(445,PRCPINPT_"-1",0) Q 0
 I PRCPFPRI L +^PRCP(445,PRCPPRIM,1):5 I '$T D SHOWWHO^PRCPULOC(445,PRCPPRIM_"-1",0) L -^PRCP(445,PRCPINPT,1) Q 0
 D ADD^PRCPULOC(445,PRCPINPT_"-1",0,"Post Issue Book")
 I PRCPFPRI D ADD^PRCPULOC(445,PRCPPRIM_"-1",0,"Post Issue Book")
 Q 1
 ;
 ;
UNLOCK ;  unlock whse and primary invpts
 D CLEAR^PRCPULOC(445,PRCPINPT_"-1",0)
 L -^PRCP(445,PRCPINPT,1)
 I PRCPFPRI D CLEAR^PRCPULOC(445,PRCPPRIM_"-1",0) L -^PRCP(445,PRCPPRIM,1)
 Q
