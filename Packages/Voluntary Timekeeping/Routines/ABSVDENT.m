ABSVDENT ;VAMC ALTOONA/CTB - FILE ENTER EDIT ;4/19/02  9:01 AM
V ;;4.0;VOLUNTARY TIMEKEEPING;***25,26,29***;JULY 6, 1994
 ;NEW ENTRY INTO DONATION FILE
NEW ;
 N DIC,CTBX,D0,DDER,DIG,DIH,DISYS,DIU,DIV,RCVD,ORG,ORGDA,COUNTER,DLAYGO,PLTR,SNAME
 S X="This option creates a new Donation Entry*!" D MSG^ABSVQ
 D ^ABSVSITE Q:'%
 S DIC("A")="Select VOLUNTEER ORGANIZATION CODE: "
 S DIC=503334,DIC(0)="AEMNZ" D ^DIC Q:Y<0
 S ORG=$P(Y,"^",2),ORGDA=+Y,COUNTER="00000"_$$NEXTORG(ORGDA)
 S %DT="AEX",%DT("A")="Select DATE RECEIVED: " D ^%DT
 Q:($D(DTOUT)!(Y<0))
 S RCVD=$P(Y,".",1)
 S X=ABSV("SITE")_"-"_ORG_"-"_$E(COUNTER,$L(COUNTER)-3,$L(COUNTER))
 S SNAME=$$XREF(X)
 S DIC="^ABS(503340,",DIC(0)="EMZL",DLAYGO=DIC
 S DIC("DR")="1///"_ORGDA_";2////"_RCVD_";.5////"_SNAME D FILE^DICN
 K DIC("A"),DIC,DR Q:Y<0
 W ! S X="THIS RECORD HAS BEEN ASSIGNED NUMBER "_$P(Y,"^",2)_"*" D MSG^ABSVQ
 S DA=+Y,DR="[ABSV DONATIONS ENTER]",DIE="^ABS(503340,"
 D ^DIE
 I $G(PLTR)=1 D X^ABSVDPNT
 QUIT
NEXTORG(DA) N X
 L +^ABS(503334,DA,0):10
 S X=$P(^ABS(503334,DA,0),"^",6),X=X+1,$P(^ABS(503334,DA,0),"^",6)=X
 L -^ABS(503334,DA,0)
 QUIT X
DELETE ;Delete a Donation Record Entered in Error
 N DIC,Y,DA,ABSVXA,ABSVXB,%
 D ^ABSVSITE Q:'%
 S DIC=503340,DIC(0)="AEMNQ",DIC("A")="Select Donation Record to be Deleted: ",DIC("S")="I $P(^(0),""-"",1)=ABSV(""SITE"")" D ^DIC Q:Y<0  S DA=+Y
 W !
 S ABSVXA="You are about to PERMENANTLY remove Donation Record "_$P(Y,U,2),ABSVXA(1)="ARE YOU SURE",ABSVXB="",%=2 D ^ABSVYN
 I %'=1 D NA^ABSVQ QUIT
 W ! S ABSVXA="Last chance to abort permanent deletion of "_$P(Y,U,2),ABSVXA(1)="ARE YOU SURE",ABSVXB="",%=2 D ^ABSVYN
 I %'=1 D NA^ABSVQ QUIT
 S DIK=DIC D ^DIK
 S X="  RECORD DELETED*" D MSG^ABSVQ
 QUIT
VIEW ;View a Single Donation Record
 N DIC,DA,DIQ,Y,X,S,I,D0,DISYS,DIW,DIWT,DK
 D ^ABSVSITE Q:'%
 S DIC("S")="I $P(^(0),U,15)=ABSV(""INST"")"
 S DIC=503340,DIC(0)="AEMNZQ" D ^DIC Q:'Y
 S DA=+Y,DIQ=DIC D EN^DIQ
 QUIT
XREF(X) ;CROSS REFERENCE FOR .01 FIELD OF 503340
 N Y,Z
 S Z=$P(X,"-",1) I Z="" Q Z
 S Y=$O(^ABS(503338,"C",Z,0))
 Q Y
