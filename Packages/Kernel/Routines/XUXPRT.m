XUXPRT ;MJM/SF-CIOFO - PRINT OF EXCEPTIONS FOUND IN STATE FILE;OCT 30, 1998@11:07
 ;;8.0;KERNEL;**105**;OCT 30,1998
 S Y="PRT^XUXPRT",Z="EXCEPTIONS LISTING FROM STATE FILE"
 D EN^XUTMDEVQ(Y,Z)
 Q
PRT ;LINE TAG TO PRINT EXCEPTION FOUND WITH COUNTY FIELDS IN THE STATE FILE
 S XUXNUM=0
 F  S XUXNUM=$O(^XTMP("XUXTMP",XUXNUM)) Q:+XUXNUM'>0  D
 .S XUXLINE=^XTMP("XUXTMP",XUXNUM)
 .W !,XUXLINE
 K XUXNUM,XUXLINE
 Q
