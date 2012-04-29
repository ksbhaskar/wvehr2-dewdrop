IBDF6 ;ALB/CJM - ENCOUNTER FORM - ENTRY FOR BUILDING A FORM ;NOV 16,1992
 ;;3.0;AUTOMATED INFO COLLECTION SYS;**10,29,30**;APR 24, 1997
 ;
FORMLIST ;
 N IBTKFORM,IBDEVICE,IBAPI,IOVL,IOHL,IOBRC,IOBLC,IOTRC,IOTLC,IBFORM
 ;IBDEVICE stores parameters related to device for printing forms
 D DEVICE^IBDFUA(1,.IBDEVICE)
 S IBTKFORM=0 ;IBTKFORM=1 only for toolkit forms
 S IBAPI("INDEX")="D IDXFORMS^IBDF6"
 S IBAPI("SELECT")="D SELECT^IBDF6"
 N IBFASTXT ;set to 1 for fast exit from system
 S IBFASTXT=0
 K XQORS,VALMEVL,DIR
 S IBCLINIC=""
 D CLINIC
 I IBCLINIC D EN^VALM("IBDF CLINIC FORM LIST")
 Q
ONENTRY ;
 D IDXFORMS
 Q
ONEXIT ;
 D KILL^%ZISS
 K ^TMP("IB",$J),^TMP("IBDF",$J),IBCLINIC,VALMY,IBQUIT,VALMBCK,X,Y,I,DA,D0
 Q
EDITFORM ;allows user to select a form, then displays it for edit
 N IBFORM,ARY,DFN,IBAPPT,RTNLIST,IBPRINT
 S ARY="^TMP(""IBDF"",$J,""TEMPORARY CLINIC LIST"")"
 ;
 K @ARY
 S VALMBCK=""
 I $G(IBAPI("SELECT"))'="" X IBAPI("SELECT")
 I IBFORM D CLINICS^IBDFU4(IBFORM,ARY) I $G(@ARY@(0))>1 W !,"The form is in use by other clinics!" D LIST^IBDFU4(ARY,4) S DIR(0)="Y",DIR("A")="Still want to edit",DIR("B")="N" D ^DIR K DIR I $D(DIRUT)!(Y=0) S IBFORM=""
 K ARY
 I IBFORM,'$$LOCKFRM2^IBDFU7(IBFORM) D LOCKMSG2^IBDFU7(IBFORM) S IBFORM=""
 I IBFORM D PRNTPRMS^IBDFU1C(.IBPRINT,0,1,0,1),UNCMPL^IBDF19(IBFORM,0),EN^VALM("IBDF DISPLAY FORM FOR EDIT"),UNCMPL^IBDF19(IBFORM,0),FREEFRM2^IBDFU7(IBFORM)
 S VALMBCK="R"
 Q
 ;
CLINIC ;
 N DIR,DIC,DIE,DR,DA
 S DIR(0)="409.95,.01",DIR("A")="EDIT FORMS FOR WHICH CLINIC? "
 D ^DIR
 K DIR
 I $D(DIRUT)!(+Y<0) Q
 S IBCLINIC=+Y
 Q
 ;
IDXFORMS ;build an array of forms used by IBCLINIC for the list processor
 N FORM,SETUP,NODE,SUB,SUBREC,USE,ID
 K @VALMAR
 S SETUP="",VALMCNT=0,ID=0
 S SETUP=$O(^SD(409.95,"B",IBCLINIC,"")) Q:'SETUP
 S NODE=$G(^SD(409.95,SETUP,0)) Q:NODE=""
 F SUB=2,6,8,9,3,4,5,7 S FORM=$P(NODE,"^",SUB) I FORM D
 .I $D(^IBE(357,FORM,0)) D
 ..S USE=""
 ..D ENTRY
 Q
ENTRY ;adds an entry to the array
 S USE=USE_$S(SUB=2:"Basic Encounter Form",SUB=3:"Supplemental Form - Established Patients",SUB=4:"Supplemental Form - New Patients",SUB=5:"Form To Print With No Patient Data",1:"")
 S:USE="" USE=USE_$S(SUB=7:"For Future Use",1:"Supplemental Form - All Patients")
 S ID=ID+1,VALMCNT=VALMCNT+1,@VALMAR@(VALMCNT,0)=$$DISPLAY1(FORM,USE,ID),@VALMAR@("IDX",VALMCNT,ID)=FORM D FLDCTRL^VALM10(VALMCNT) ;set video for ID column
 S VALMCNT=VALMCNT+1,@VALMAR@(VALMCNT,0)=$$DISPLAY2(FORM),@VALMAR@("IDX",VALMCNT,ID)=FORM_"^"_$S(SUB=2:.02,SUB=3:.03,SUB=4:.04,SUB=5:.05,SUB=6:.06,SUB=7:.07,SUB=8:.08,SUB=9:.09,1:0)
 Q
HDR ;
 S VALMHDR(1)="FORMS CURRENTLY USED BY '"_$$CLNCNAME_"' HOSPITAL LOCATION"
 Q
CLNCNAME() ;
 Q $P($G(^SC(IBCLINIC,0)),"^",1)
DISPLAY1(FORM,USE,ID) ;
 N NODE,NAME,RET
 S RET=$J(ID,3)_$$SP(2)
 S NODE=$G(^IBE(357,FORM,0))
 S NAME=$P(NODE,"^",1)
 S RET=RET_$$PR(NAME,30)_$$SP(2)_USE
 Q RET
DISPLAY2(FORM) ;
 N NODE,DESCR,RET
 S RET=$$SP(37)
 S NODE=$G(^IBE(357,FORM,0))
 S DESCR=$P(NODE,"^",3)
 S RET=RET_$E(DESCR,1,80)
 Q RET
PR(STR,LEN) ; pad right
 Q:'$G(LEN) ""
 N B S STR=$E($G(STR),1,LEN)
 S:LEN'=$L(STR) $P(B," ",LEN-$L($G(STR)))=" "
 Q STR_$G(B)
SP(LEN) ;
 Q:'$G(LEN)
 N S S $P(S," ",LEN)=" "
 Q S
CHNGCLNC ;allows the user to change the clinic
 N SAVECLNC S SAVECLNC=IBCLINIC
 D FULL^VALM1
 S VALMBCK="R"
 D CLINIC I 'IBCLINIC S IBCLINIC=SAVECLNC Q
 D HDR
 X IBAPI("INDEX")
 Q
 ;
SELECT  ;
 N SEL
 D EN^VALM2(XQORNOD(0),"S")
 S SEL=$O(VALMY(""))
 S IBFORM=$S('SEL:"",1:+$G(@VALMAR@("IDX",2*SEL,SEL)))
 Q
