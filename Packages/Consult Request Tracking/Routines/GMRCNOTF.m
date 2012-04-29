GMRCNOTF ;SLC/JFR - NOTIFICATION RECIPIENT UTILITIES; 7/31/99 21:58
 ;;3.0;CONSULT/REQUEST TRACKING;**11**;DEC 27, 1997
EN ; -- main entry point for GMRC NOTIFICATION RECIPS
 N GMRCSV
 D SELSS Q:'$D(GMRCSV)
 D INIT
 D EN^VALM("GMRC NOTIFICATION RECIPS")
 Q
 ;
SELSS ; select new service
 N DIR,X,Y,DIRUT,DUOUT,DTOUT
 D FULL^VALM1
 S DIR(0)="PO^123.5:EMQ",DIR("A")="Select Service"
 D ^DIR
 I $D(DIRUT) Q
 S GMRCSV=+Y
 K ^TMP("GMRCNOTF",$J)
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Notification Recipients for: "
 S VALMHDR(1)=VALMHDR(1)_$P(^GMR(123.5,+GMRCSV,0),U)
 Q
 ;
INIT ; -- init variables and list array
 N GMRCADUZ,LINE,GMRCI,PERS
 D EN^GMRCT(+GMRCSV,,1)
 I '$D(GMRCADUZ) S ^TMP("GMRCNOTF",$J,1,0)="No notification recipients"
 S GMRCI=0,LINE=1
 F  S GMRCI=$O(GMRCADUZ(GMRCI)) Q:'GMRCI  D
 . S PERS=$$GET1^DIQ(200,GMRCI,.01)
 . S ^TMP("GMRCNOTF",$J,"B",PERS)=GMRCADUZ(GMRCI)
 S PERS="" F  S PERS=$O(^TMP("GMRCNOTF",$J,"B",PERS)) Q:PERS=""  D
 . I $L($P(^TMP("GMRCNOTF",$J,"B",PERS),"~",2)) D  Q
 .. N LOOP,SERV S LOOP=2
 .. N SPACES S SPACES=$$REPEAT^XLFSTR(" ",(34-$L(PERS)))
 .. S ^TMP("GMRCNOTF",$J,LINE,0)=PERS_SPACES_$P(^TMP("GMRCNOTF",$J,"B",PERS),"~")
 .. S LINE=LINE+1
 .. F  S SERV=$P(^TMP("GMRCNOTF",$J,"B",PERS),"~",LOOP) Q:SERV=""  D
 ... S ^TMP("GMRCNOTF",$J,LINE,0)=$$REPEAT^XLFSTR(" ",34)_SERV
 ... S LOOP=LOOP+1,LINE=LINE+1
 . N SPACES S SPACES=$$REPEAT^XLFSTR(" ",(34-$L(PERS)))
 . S ^TMP("GMRCNOTF",$J,LINE,0)=PERS_SPACES_^TMP("GMRCNOTF",$J,"B",PERS)
 . S LINE=LINE+1
 K ^TMP("GMRCNOTF",$J,"B")
 S VALMCNT=$O(^TMP("GMRCNOTF",$J,999999),-1)
 S VALMBG=1
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
