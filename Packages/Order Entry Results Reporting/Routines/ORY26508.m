ORY26508 ;SLC/JEH - OCX PACKAGE RULE TRANSPORT ROUTINE - PLUS ;NOV 16, 2006 15:00
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**265**;Dec 17,1997;Build 17
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;;  ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;
SCH ; This code will correct the pointer to imaging.
 N DTIME,DLAYGO,DINUM,DIC,Y,X,IX,OLD,RPTID,DONEX
 S DIC="^ORD(100.98,"   ; Find the IEN of IMAGING in the Display File
 S DIC(0)="N,O,X"
 S X="IMAGING"
 D ^DIC
 I $G(Y) D   ; RPT SCHEDULED/DUE ACTIVITY replace IEN for NURSING (13) (found at some sites) with IMAGING IEN
 . S X=+Y
 . ;
 . S (IX,DONEX,RPTID,OLD)=0
 . S RPTID=$O(^ORD(102.21,"B","RPT SCHEDULED/DUE ACTIVITY",0))
 . F  S IX=$O(^ORD(102.21,RPTID,1,IX)) Q:('IX)!DONEX  D
 . . I $P(^ORD(102.21,RPTID,1,IX,0),U,4)="IMAGING" D
 . . . I ^ORD(102.21,RPTID,1,IX,1,1,0)'=X D
 . . . . S OLD=^ORD(102.21,RPTID,1,IX,1,1,0)
 . . . . S ^ORD(102.21,RPTID,1,IX,1,1,0)=X
 . . . . K ^ORD(102.21,RPTID,1,IX,1,"B",OLD,1)
 . . . . S ^ORD(102.21,RPTID,1,IX,1,"B",X,1)="",DONEX=1
 W !,"FINISHED: UPDATING CPRS QUERY DEFINITION NAME / RPT SCHEDULED/DUE ACTIVITY"
 W !
 ;
OCX ; this code updates the expert system to compile code that allows results with "<>=" in matching the threshold limit.
 N LINE,UPDATE,TEXT1,TEXT2,ADDTEXT,TTALCNT,CNT
 S UPDATE=0
 S TEXT1="",TEXT2=""
 S TTALCNT=$P(^OCXS(860.8,53,"CODE",0),"^",3)+1
 S LINE=1
 S ADDTEXT=$P($T(DATA+1),";",3,40)
 F   S LINE=$O(^OCXS(860.8,53,"CODE",LINE)) Q:(LINE=TTALCNT)!(LINE="")!(LINE]"@")  D
 . I ^OCXS(860.8,53,"CODE",LINE,0)=ADDTEXT S TTALCNT=LINE+1 Q  ; If change has already been made
 . I UPDATE=0,^OCXS(860.8,53,"CODE",LINE,0)="  ; Q:'$G(OCXLAB)!'$G(OCXSPEC)!'$G(OCXRSLT)!'$L($G(OCXOP)) 0" D
 . . S TEXT1=^OCXS(860.8,53,"CODE",LINE,0)
 . . S ^OCXS(860.8,53,"CODE",LINE,0)=$P($T(DATA+1),";",3,40)
 . . S UPDATE=1
 . . ; Q
 . I UPDATE=1 D
 . . S TEXT2=TEXT1
 . . S CNT=LINE+1
 . . S TEXT1=$G(^OCXS(860.8,53,"CODE",CNT,0))
 . . S ^OCXS(860.8,53,"CODE",CNT,0)=TEXT2
 . . Q:TEXT1=""
 I UPDATE=1 D
 . S $P(^OCXS(860.8,53,"CODE",0),"^",3)=TTALCNT
 . S $P(^OCXS(860.8,53,"CODE",0),"^",4)=TTALCNT
 . W !,"FINISHED: UPDATING ORDER CHECK COMPILER FUNCTIONS"
 . W !!,"THE EXPERT SYSTEM WILL NEED TO BE RECOMPILED TO COMPLETE THIS PROCESS"
 . W !,"PLEASE SEE THE PATCH INSTRUCTION ON RECOMPILING THE EXPERT SYSTEM"
 I UPDATE=0 W !,"NO UPDATE NEEDED OR MADE TO EXPERT SYSTEM"
 Q
 ;
RECOVER ; RESET TO OLD GLOBAL
 N LINE,TEXT1,TTALCNT
 S TEXT1=""
 S TTALCNT=$P(^OCXS(860.8,53,"CODE",0),"^",3)+1
 S LINE=0
 F   S LINE=$O(^OCXS(860.8,53,"CODE",LINE)) Q:(LINE=TTALCNT)!(LINE="")!(LINE]"@")  D
 . S TEXT1=$P($T(DATA2+LINE),";",3,40)
 . S ^OCXS(860.8,53,"CODE",LINE,0)=TEXT1
 S ^OCXS(860.8,53,"CODE",0)="^^16^16^3060823^"
 Q
 ;
DATA ;
 ;;  ; S OCXRSLT=$TR($G(OCXRSLT),"<>=","")
 ;
 ;;^OCXS(860.8,53,0)=LAB THRESHOLD EXCEEDED BOOLEAN^LABTHRSB
 ;;^OCXS(860.8,53,"CODE",0)=^^17^17^3060823^
 ;;^OCXS(860.8,53,"CODE",1,0)=  ;LABTHRSB(OCXLAB,OCXPEC,OCXRSLT,OCXOP)       ;
 ;;^OCXS(860.8,53,"CODE",2,0)=  ; ;
 ;;^OCXS(860.8,53,"CODE",3,0)=  ; S OCXRSLT=$TR($G(OCXRSLT),"<>=","")
 ;;^OCXS(860.8,53,"CODE",4,0)=  ; Q:'$G(OCXLAB)!'$G(OCXPEC)!'$G(OCXRSLT)!'$L($G(OCXOP)) 0
 ;;^OCXS(860.8,53,"CODE",5,0)=  ; ;
 ;;^OCXS(860.8,53,"CODE",6,0)=  ; N OCXX,OCXPENT,OCXERR,OCXLABSP,OCXPVAL,OCXEXCD
 ;;^OCXS(860.8,53,"CODE",7,0)=  ; S OCXEXCD=0,OCXLABSP=OCXLAB_";"_OCXPEC
 ;;^OCXS(860.8,53,"CODE",8,0)=  ; D ENVAL^XPAR(.OCXX,"ORB LAB "_OCXOP_" THRESHOLD",OCXLABSP,.OCXERR)
 ;;^OCXS(860.8,53,"CODE",9,0)=T+; I $G(OCXTRACE) W !,"Lab parameter values:",! ZW OCXX,OCXERR
 ;;^OCXS(860.8,53,"CODE",10,0)=  ; Q:+$G(ORERR)'=0 OCXEXCD
 ;;^OCXS(860.8,53,"CODE",11,0)=  ; Q:+$G(OCXX)=0 OCXEXCD
 ;;^OCXS(860.8,53,"CODE",12,0)=  ; S OCXPENT="" F  S OCXPENT=$O(OCXX(OCXPENT)) Q:'OCXPENT!OCXEXCD=1  D
 ;;^OCXS(860.8,53,"CODE",13,0)=  ; .S OCXPVAL=OCXX(OCXPENT,OCXLABSP)
 ;;^OCXS(860.8,53,"CODE",14,0)=  ; .I $L(OCXPVAL) D
 ;;^OCXS(860.8,53,"CODE",15,0)=  ; ..I $P(OCXPENT,";",2)="VA(200,",@((+OCXRSLT)_OCXOP_OCXPVAL) D
 ;;^OCXS(860.8,53,"CODE",16,0)=  ; ...S OCXEXCD=1
 ;;^OCXS(860.8,53,"CODE",17,0)=  ; Q OCXEXCD
 ;
DATA2 ;
 ;;  ;LABTHRSB(OCXLAB,OCXPEC,OCXRSLT,OCXOP)       ;
 ;;  ; ;
 ;;  ; Q:'$G(OCXLAB)!'$G(OCXSPEC)!'$G(OCXRSLT)!'$L($G(OCXOP)) 0
 ;;  ; ;
 ;;  ; N OCXX,OCXPENT,OCXERR,OCXLABSP,OCXPVAL,OCXEXCD
 ;;  ; S OCXEXCD=0,OCXLABSP=OCXLAB_";"_OCXPEC
 ;;  ; D ENVAL^XPAR(.OCXX,"ORB LAB "_OCXOP_" THRESHOLD",OCXLABSP,.OCXERR)
 ;;T+; I $G(OCXTRACE) W !,"Lab parameter values:",! ZW OCXX,OCXERR
 ;;  ; Q:+$G(ORERR)'=0 OCXEXCD
 ;;  ; Q:+$G(OCXX)=0 OCXEXCD
 ;;  ; S OCXPENT="" F  S OCXPENT=$O(OCXX(OCXPENT)) Q:'OCXPENT!OCXEXCD=1  D
 ;;  ; .S OCXPVAL=OCXX(OCXPENT,OCXLABSP)
 ;;  ; .I $L(OCXPVAL) D
 ;;  ; ..I $P(OCXPENT,";",2)="VA(200,",@((+OCXRSLT)_OCXOP_OCXPVAL) D
 ;;  ; ...S OCXEXCD=1
 ;;  ; Q OCXEXCD
 ;
