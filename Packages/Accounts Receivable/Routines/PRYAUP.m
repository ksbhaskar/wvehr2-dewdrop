PRYAUP ;WASH-ISC@ALTOONA,PA/LDB- CHAMPVA AR DEBT LIST ;4/6/95  4:36 PM
V ;;4.5;Accounts Receivable;**1**;Mar 20, 1995
 ;Add entry to AR DEBT LIST
 N DA,DIC,DIE,DR,X,Y
 I $D(^PRCA(430.6,"B","CHMPV")) Q
 S DIC="^PRCA(430.6,",DIC(0)="L",X="CHMPV",DLAYGO=430.6
 D ^DIC Q:Y<0
 S DA=+Y
 S DIE=DIC,DR="1////^S X="_"""CHAMPVA SUBSISTENCE"""_";3////^S X="_"""CP"""
 D ^DIE
 Q
