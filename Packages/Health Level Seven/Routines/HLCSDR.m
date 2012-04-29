HLCSDR ;ALB/RJS - INITIALIZE VARIABLES AND OPEN DEVICE FOR RECEIVER ;07/20/99  14:00
 ;;1.6;HEALTH LEVEL SEVEN;**2,14,49,57**;Oct 13, 1995
 ;
INIT ;
 S HLZER=0
 I '$D(HLDP)&($G(%)'="") S HLDP=% ;LAUNCHED FROM VMS
 I '$D(HLDP) Q
 D DT^DICRW
 I HLDP'>0 S HLDP=$O(^HLCS(870,"B",HLDP,""))
 I HLDP'>0 G EXIT
 ;HLDP IEN of LOGICAL LINK file #870
 S HLDNODE=$G(^HLCS(870,HLDP,0))
 S HLPARM=$G(^HLCS(870,HLDP,200))
 ;pointer to DEVICE file
 S HLDEVPTR=$P(HLPARM,U)
 G EXIT:HLDEVPTR'>0
 S HLDEVICE=$P($G(^%ZIS(1,HLDEVPTR,0)),"^",1)
 G EXIT:HLDEVICE=""
 D FILE
INIT1 ;
 G END:'HLZER
 S HLZER=0
 D OPEN G INIT1
FILE ;
 D NOW^%DTC
 L +^HLCS(870,HLDP,0):DTIME I '$T G FILE
 ;9=Time Started, 10=Time Stopped, 11=Task Number
 ;14=Shutdown LLP, 3=Shutdown LLP, 18=Gross Errors
 I '$D(ZTSK) S ZTSK=""
 S DIE="^HLCS(870,",DA=HLDP,DR="9////^S X=%;10////@;11////^S X=ZTSK;14////0;3////SH;18////@" D ^DIE K DIE,DA,DR
 L -^HLCS(870,HLDP,0)
OPEN ;
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSDR"
 E  S X="ERROR^HLCSDR",@^%ZOSF("TRAP")
OPEN1 I $P($G(^HLCS(870,HLDP,0)),U,15) G END
 S HLST="OPEN" D STATUS(HLST,HLDP)
 S IOP=HLDEVICE,%ZIS=0 D ^%ZIS
 I POP S HLST="OPENFAIL" D STATUS(HLST,HLDP) H 5 G OPEN1
INIT2 ;
 ;Re-transmission attempts, Node, Hang Time, Start character,
 ;End character, LLP Version Number
 S HLDAPP=$P(HLDNODE,U,1)
 S HLRETPRM=$P(HLPARM,U,2),HLDBSIZE=$P(HLPARM,U,3),HLDREAD=$P(HLPARM,U,4),HLDWRITE=$P(HLPARM,U,5),HLDSTRT=$P(HLPARM,U,6),HLDEND=$P(HLPARM,U,7),HLDVER=$P(HLPARM,U,8)
 ;Defaults
 I HLRETPRM="" S HLRETPRM=5
 I HLDREAD="" S HLDREAD=10
 I HLDWRITE="" S HLDWRITE=2
 I HLDSTRT="" S HLDSTRT=11
 I HLDEND="" S HLDEND=28
 I HLDVER="" S HLDVER=21
 I HLDBSIZE'>1 S HLDBSIZE=245
 ;Set up Device Params
 S X=255 U IO X ^%ZOSF("EOFF"),^%ZOSF("RM"),^%ZOSF("TRMON")
START ;
 D START^HLCSDR1(HLDP,HLRETPRM,HLDREAD,HLDWRITE,HLDSTRT,HLDEND,HLDVER,HLDBSIZE)
END ;
 I '$G(HLDP) G EXIT
 D NOW^%DTC
 L +^HLCS(870,HLDP,0):DTIME I '$T G END
 ;10=Time Stopped,9=Time Started,11=Task Number
 S DIE="^HLCS(870,",DA=HLDP,DR="10////^S X=%;9////@;11////@" D ^DIE K DIE,DA,DR
 L -^HLCS(870,HLDP,0)
EXIT ;
 D ^%ZISC
 K HLDNODE,HLDEVPTR,HLDEVICE,HLRETPRM,HLDAPP,X,HLDEND,HLDSTRT,HLDVER,HLDREAD,HLDWRITE,HLTRACE,ZTSK,HLDBSIZE,HLPARM
 Q
STATUS(HLST,HLDP) ;Update field 4
 ;HLST=Current Status
 ;HLDP=IEN of Logical Link
 S DIE="^HLCS(870,",DA=HLDP,DR="4///^S X=HLST" D ^DIE K DIE,DA,DR
 Q
ERROR ;Trap disconnect & read errors
 I $$EC^%ZOSV["DSCON"!($$EC^%ZOSV["data set hang-up") S HLST="DSCONECT" D STATUS(HLST,HLDP) H 3 S HLZER=1 I 1
 E  D ^%ZTER
 S IO("C")=1 D ^%ZISC
 G UNWIND^%ZTER
 Q
