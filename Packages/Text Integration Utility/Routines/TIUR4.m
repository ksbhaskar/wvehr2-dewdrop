TIUR4 ; SLC/JER - Integrated Document Review ;11/01/03 [1/12/05 11:48am]
 ;;1.0;TEXT INTEGRATION UTILITIES;**157**;Jun 20, 1997
 ;This routine was created from a copy of TIUR1 and modified for use
 ; in option TIU REVIEW UNSIGNED ADDSIG
GATHER(CLASS,TIUPREF) ; Find/sort
 N TIUSFLD
 S TIUSFLD=$P(TIUPREF,U,3)
 I +$G(TIUQUIK)=1 D ADDSIGN(DUZ,CLASS,TIUSFLD)
 Q
DADINTYP(TIUDA) ; addendum's parent belong? 12/1/00 Removed param TYPES
 N TIUI,TIUDTYP,TIUY S (TIUI,TIUY)=0
 S TIUDTYP=+$G(^TIU(8925,+$P($G(^TIU(8925,+TIUDA,0)),U,6),0))
 F  S TIUI=$O(^TMP("TIUTYP",$J,TIUI)) Q:+TIUI'>0!+TIUY  D
 . I +$P(^TMP("TIUTYP",$J,TIUI),U,2)=TIUDTYP S TIUY=1
 Q TIUY
RESOLVE(DA,DR) ; resolve sort field values
 N TIUD0,TIUD12,TIUD13,TIUD15,TIUY
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD12=$G(^TIU(8925,+DA,12))
 S TIUD13=$G(^TIU(8925,+DA,13)),TIUD15=$G(^TIU(8925,+DA,15))
 I DR=.01 S TIUY=$$PNAME^TIULC1(+TIUD0) G RESX
 I DR=.02 S TIUY=$$PTNAME^TIULC1(+$P(TIUD0,U,2)) G RESX
 I DR=.05 S TIUY=$P(TIUD0,U,5) G RESX
 I DR=1202 S TIUY=$$PERSNAME^TIULC1(+$P(TIUD12,U,2)) S:TIUY="UNKNOWN" TIUY="" G RESX
 I DR=1208 S TIUY=$$PERSNAME^TIULC1(+$P(TIUD12,U,8)) S:TIUY="UNKNOWN" TIUY="" G RESX
 I DR=1301 S TIUY=$P(TIUD13,U) G RESX
 ;I DR=1507,($P(TIUD0,U,5)=7),(+$P(TIUD15,U,7)'>0) S DR=1501
 I DR=1507,(($P(TIUD0,U,5)=7)!($P(TIUD0,U,5)=8)),(+$P(TIUD15,U,7)'>0) S DR=1501 ;TIU*1*100 amended notes were sorting at top w sortval=ZZZZEMPTY for sortfld=complete, even tho they had sign date and displayed it.
 I DR=1501 S TIUY=$P(TIUD15,U) G RESX
 I DR=1507 S TIUY=$P(TIUD15,U,7)
RESX I $G(TIUY)']"" S TIUY="ZZZZEMPTY"
 Q TIUY
 ;
ADDSIGN(USER,CLASS,SORTBY) ; Get documents for which the user is the additional signer
 N TIUI,TIUY S TIUI=0
 D NEEDSIG^TIULX(.TIUY,USER,CLASS)
 F  S TIUI=$O(@TIUY@(TIUI)) Q:+TIUI'>0  D
 . N TIUDA,TIUD13,TIUQ,TIUJ
 . S TIUDA=+$G(@TIUY@(TIUI)),TIUD13=$G(^TIU(8925,TIUDA,13))
 . S TIUQ=$$RESOLVE(TIUDA,SORTBY),TIUJ=9999999-+TIUD13
 . ; S ^TMP("TIUI",$J,TIUQ,TIUJ,TIUDA)="" ; P113
 . S ^TMP("TIUI",$J,TIUQ,TIUJ,TIUDA)=1
 K @TIUY
 Q
