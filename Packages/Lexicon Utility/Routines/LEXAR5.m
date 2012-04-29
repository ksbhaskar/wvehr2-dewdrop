LEXAR5 ;ISL/KER - Look-up Response (Select Entry) ;09/08/2008
 ;;2.0;LEXICON UTILITY;**14,25,26,38,55**;Sep 23, 1996;Build 11
 ;
 ; External References
 ;   DBIA 10104  $$UP^XLFSTR
 ;   DBIA 10103  $$DT^XLFDT
 ;   DBIA  3992  $$STATCHK^ICDAPIU
 ;   DBIA  1997  $$STATCHK^ICPTAPIU
 ;   DBIA  1612  ^YSD(627.7,
 ;
SETEXP(LEXX)   ; Set LEX("SEL","EXP")
 S LEXX=+($G(LEXX)) Q:LEXX'>0  Q:'$D(^LEX(757.01,LEXX,0))
 N LEXYPE S LEXYPE=$$TYPE(LEXX)
 N LEXC S LEXC=+($G(LEX("SEL","EXP",0))),LEXC=LEXC+1
 S LEX("SEL","EXP",LEXC)=LEXX_"^"_^LEX(757.01,LEXX,0),LEX("SEL","EXP",0)=LEXC
 S LEX("SEL","EXP","B",LEXX,LEXC)=""
 S:LEXYPE'="" LEX("SEL","EXP","C",LEXYPE,LEXC)=""
 Q
TYPE(LEXX)     ; Expression Type
 N LEXYPE S LEXYPE=$P($G(^LEX(757.01,LEXX,1)),"^",2)
 I +LEXYPE'>0!('$D(^LEX(757.011,+LEXYPE,0))) S LEXYPE="OTH"
 I +LEXYPE>0,$D(^LEX(757.011,+LEXYPE,0)) D
 . S LEXYPE=$P($G(^LEX(757.011,+LEXYPE,0)),"^",1)
 . S:$L(LEXYPE)<3 LEXYPE="OTH"
 . S LEXYPE=$$UP^XLFSTR($E(LEXYPE,1,3))
 S LEXX=LEXYPE Q LEXX
SETDEF(LEXX)   ; Set LEX("SEL","SIG")
 S LEXX=+($G(LEXX)) Q:LEXX=0
 Q:'$D(^LEX(757.01,LEXX,3,1,0))
 N LEXC,LEXR S LEXR=0
 F  S LEXR=$O(^LEX(757.01,LEXX,3,LEXR)) Q:+LEXR=0  D
 . S LEXC=+($G(LEX("SEL","SIG",0))),LEXC=LEXC+1
 . S LEX("SEL","SIG",LEXC)=$G(^LEX(757.01,LEXX,3,LEXR,0))
 . S LEX("SEL","SIG",0)=LEXC
 Q
SETSTY(LEXX)   ; Set LEX("SEL","STY")
 S LEXX=+($G(LEXX)) Q:LEXX=0
 Q:'$D(^LEX(757.1,"B",LEXX))
 N LEXC,LEXR,LEXSC,LEXST S LEXR=0
 F  S LEXR=$O(^LEX(757.1,"B",LEXX,LEXR)) Q:+LEXR=0  D
 . S LEXSC=+($P($G(^LEX(757.1,LEXR,0)),"^",2)) Q:LEXSC=0  Q:'$D(^LEX(757.11,LEXSC))
 . S LEXSC=$P($G(^LEX(757.11,LEXSC,0)),"^",2) Q:'$L(LEXSC)
 . S LEXST=+($P($G(^LEX(757.1,LEXR,0)),"^",3)) Q:LEXST=0  Q:'$D(^LEX(757.12,LEXST))
 . S LEXST=$P($G(^LEX(757.12,LEXST,0)),"^",2) Q:'$L(LEXST)
 . S LEXC=+($G(LEX("SEL","STY",0))),LEXC=LEXC+1
 . S LEX("SEL","STY",LEXC)=LEXSC_"^"_LEXST
 . S LEX("SEL","STY",0)=LEXC
 Q
SETSRC(LEXX,LEXVDT)     ; Set LEX("SEL","SRC")
 N LEXSO,LEXSRC,LEXS,LEXC,LEXLD,LEXLS,LEXSN S LEXS=0
 F  S LEXS=$O(^LEX(757.02,"B",LEXX,LEXS)) Q:+LEXS=0  D
 . S LEXSN=$G(^LEX(757.02,LEXS,0)),LEXSO=$P(LEXSN,"^",2),LEXSRC=$P(LEXSN,"^",3) Q:LEXSRC=0
 . Q:+$$STATCHK^LEXSRC2(LEXSO,LEXVDT)'=1
 . Q:'$D(^LEX(757.02,"AVA",(LEXSO_" "),LEXX))
 . S LEXSRC=$P(^LEX(757.03,LEXSRC,0),"^",2) Q:'$L(LEXSRC)
 . S LEXC=+($G(LEX("SEL","SRC",0))),LEXC=LEXC+1
 . S LEX("SEL","SRC",LEXC)=LEXSRC_"^"_LEXSO_"^"_LEXX
 . S LEX("SEL","SRC","B",LEXSRC,LEXC)=""
 . S LEX("SEL","SRC","C",LEXSO,LEXC)=""
 . S LEX("SEL","SRC","D",LEXX,LEXC)=""
 . S LEX("SEL","SRC",0)=LEXC
 D SETVAS(LEXX,+($G(LEXVDT)))
 Q
SETVAS(LEXX,LEXVDT)     ; Find VA sources for LEX("SEL","VAS")
 N LEXSAB,LEXRTN,LEXR,LEXVP S LEXVDT=$S(+($G(LEXVDT))>0:+($G(LEXVDT)),1:$$DT^XLFDT)
 F LEXSAB="ICD","ICP","CPT","DS4" D
 . K LEXSRC S LEXRTN=LEXSAB_"^LEXAR5"
 . D ALL^LEXSRC(LEXX,LEXSAB,LEXVDT) I +($G(LEXSRC(0)))>0 D @LEXRTN
 Q
ICD ; Intl' Classification of Diseases (diagnosis)
 N LEXO,LEXI,LEXSO,LEXR,LEXVP S LEXI=0 F  S LEXI=$O(LEXSRC(LEXI)) Q:+LEXI=0  D
 . S LEXSO=$G(LEXSRC(LEXI)) Q:LEXSO=""
 . S LEXO=$$STATCHK^ICDAPIU(LEXSO,+($G(LEXVDT))) Q:+LEXO'>0
 . S LEXO=+($P(LEXO,"^",2)) Q:+LEXO'>0  S LEXC=+($G(LEX("SEL","VAS",0)))+1
 . S LEXVP=+LEXO_";ICD9(" D VAS("80",LEXSO,LEXX,LEXVP,LEXC)
 Q
ICP ; Intl' Classification of Diseases (procedures)
 N LEXI,LEXSO,LEXR,LEXVP S LEXI=0 F  S LEXI=$O(LEXSRC(LEXI)) Q:+LEXI=0  D
 . S LEXSO=$G(LEXSRC(LEXI)) Q:LEXSO=""
 . S LEXO=$$STATCHK^ICDAPIU(LEXSO,+($G(LEXVDT))) Q:+LEXO'>0
 . S LEXO=+($P(LEXO,"^",2)) Q:+LEXO'>0  S LEXC=+($G(LEX("SEL","VAS",0)))+1
 . S LEXVP=+LEXO_";ICD0(" D VAS("80.1",LEXSO,LEXX,LEXVP,LEXC)
 Q
CPT ; Current Procedural Terminology
 N LEXI,LEXSO,LEXR,LEXVP S LEXI=0 F  S LEXI=$O(LEXSRC(LEXI)) Q:+LEXI=0  D
 . S LEXSO=$G(LEXSRC(LEXI)) Q:LEXSO=""
 . S LEXO=$$STATCHK^ICPTAPIU(LEXSO,+($G(LEXVDT))) Q:+LEXO'>0
 . S LEXO=+($P(LEXO,"^",2)) Q:+LEXO'>0  S LEXC=+($G(LEX("SEL","VAS",0)))+1
 . S LEXVP=+LEXO_";ICPT(" D VAS("81",LEXSO,LEXX,LEXVP,LEXC)
 Q
DS4 ; Diagnostic and Statistical Manual of Mental Disorders
 Q:'$D(LEXX)  S LEXX=+($G(LEXX)) Q:LEXX=0  Q:'$D(^LEX(757.01,LEXX,0))
 N LEXEXP,LEXR,LEXVP,LEXI,LEXSO,LEXVA,LEXIEN,LEXC S LEXEXP=$G(^LEX(757.01,LEXX,0)) Q:'$L(LEXEXP)
 S LEXI=0 F  S LEXI=$O(LEXSRC(LEXI)) Q:+LEXI=0  D
 . S LEXSO=$G(LEXSRC(LEXI)) Q:LEXSO=""  Q:'$D(^YSD(627.7,"B",LEXSO))  N LEXVA,LEXIEN S (LEXIEN,LEXVA)=0
 . F  S LEXVA=$O(^YSD(627.7,"B",LEXSO,LEXVA)) Q:+LEXVA=0  D
 . . I $$UP($G(^YSD(627.7,LEXVA,"D")))=$$UP(LEXEXP) S LEXIEN=LEXVA
 . Q:LEXIEN=0  S LEXR=LEXIEN,LEXC=+($G(LEX("SEL","VAS",0))),LEXC=LEXC+1
 . Q:+LEXR'>0  S LEXVP=LEXR_";YSD(627.7," D VAS("627.7",LEXSO,LEXX,LEXVP,LEXC)
 Q
VAS(LEXFI,LEXSO,LEXIEN,LEXV,LEXCNT)     ; Set LEX("SEL","VAS")
 S LEX("SEL","VAS",LEXCNT)=LEXFI_"^"_LEXV_"^"_LEXSO_"^"_LEXIEN
 S LEX("SEL","VAS","B",LEXFI,LEXCNT)=""
 S LEX("SEL","VAS","C",LEXSO,LEXCNT)=""
 S LEX("SEL","VAS","D",LEXIEN,LEXCNT)=""
 S LEX("SEL","VAS","V",LEXV,LEXCNT)=""
 S LEX("SEL","VAS",0)=LEXCNT
 Q
UP(X) ; Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
