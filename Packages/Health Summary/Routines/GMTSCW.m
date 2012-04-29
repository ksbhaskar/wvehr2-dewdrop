GMTSCW ; SLC/DJP - TIU CWD Component driver ; 04/11/2001
 ;;2.7;Health Summary;**12,45**;Oct 20, 1995
 ;
 ; External References
 ;    DBIA  3155 call MAIN^TIULAPI
 ;    DBIA 10006 call ^DIC
 ;
 ; CWAD - Clinical Warnings and Advanced Directives
CW ;   Clinical Warning Display
 N X,DIC,TIUTYPE,Y,TIUFPRIV,TIUNAM,GMTSTIUC S TIUFPRIV=1,(TIUNAM,X)="CLINICAL WARNING",GMTSTIUC="C"
 S DIC="^TIU(8925.1,",DIC(0)="X",DIC("S")="I $P($G(^(0)),U,4)=""DC""" D ^DIC I Y>0 S TIUTYPE=+Y D MAIN
 Q
CN ;   Crisis Note Display
 N X,DIC,TIUTYPE,Y,TIUFPRIV,TIUNAM,GMTSTIUC S TIUFPRIV=1,(TIUNAM,X)="CRISIS NOTE",GMTSTIUC="C"
 S DIC="^TIU(8925.1,",DIC(0)="X",DIC("S")="I $P($G(^(0)),U,4)=""DC""" D ^DIC I Y>0 S TIUTYPE=+Y D MAIN
 Q
CD ;   Advance Directive Display
 N X,DIC,TIUTYPE,Y,TIUFPRIV,TIUNAM,GMTSTIUC S TIUFPRIV=1,(TIUNAM,X)="ADVANCE DIRECTIVE",GMTSTIUC="C"
 S DIC="^TIU(8925.1,",DIC(0)="X",DIC("S")="I $P($G(^(0)),U,4)=""DC""" D ^DIC I Y>0 S TIUTYPE=+Y D MAIN
 Q
 ;
MAIN ; Control branching
 N ADATE,ADMIT,ASUB,ATDATE,ATTNDNG,ATTYPE,ATYPE,AUTHOR,CHILD,CONEED
 N COSAME,COSGEDBY,COSIG,CURIEN,DISCHG,GMTSA,GMTSAI,GMTSAII,GMTSCNT
 N GMTSD,GMTSDIC,GMTSEXSG,GMTSI,GMTSIEN,GMTSII,GMTSIQ,GMTSJ,GMTSK
 N GMTSODIC,GMTSPDIC,GMTSTDIC,GMTSPR,GMTSREC,GMTST,GMTSX,GMTSXTRA
 N I,PARIEN,PDATE,PN,PSUB,PTYPE,REASON,SIGNEDBY,STATUS,TSPEC,TYPE,X,Y
 K ^TMP("TIU",$J) D MAIN^TIULAPI(DFN,TIUTYPE,"ALL",GMTS1,GMTS2,GMTSNDM,1)
 Q:'$D(^TMP("TIU",$J))  D PNOTE^GMTSPN Q
