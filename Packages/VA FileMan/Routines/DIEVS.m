DIEVS ;SFIRMFO/DPC-BATCH VALIDATION ;2:03 PM  21 Jul 2000
 ;;22.0;VA FileMan;**55**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;;
VALS(DIVSFLAG,DIVSEFDA,DIVSIFDA,DIVSMSG) ;
VALSX ;
 N DIVSFILE,DIVSIENS,DIVSFLD,DIVSVAL,DIVSNFLG,DIVSANS,DIVSTYPE
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 S DIVSFLAG=$G(DIVSFLAG) I '$$VERFLG^DIEFU(DIVSFLAG,"KRU") G OUT
 S DIVSEFDA=$G(DIVSEFDA) I '$$VROOT^DIEFU(DIVSEFDA) G OUT
 S DIVSIFDA=$G(DIVSIFDA) I '$$VROOT^DIEFU(DIVSIFDA) G OUT
 I DIVSIFDA=""!(DIVSIFDA=DIVSEFDA) D BLD^DIALOG(313) G OUT
 S DIVSNFLG=$E("R",DIVSFLAG["R")_"FU"
 N DIVSNG S DIVSNG=0
 S DIVSFILE=""
 F  S DIVSFILE=$O(@DIVSEFDA@(DIVSFILE)) Q:DIVSFILE=""  D
 . S DIVSIENS=""
 . F  S DIVSIENS=$O(@DIVSEFDA@(DIVSFILE,DIVSIENS)) Q:DIVSIENS=""  D
 . . S DIVSFLD=""
 . . F  S DIVSFLD=$O(@DIVSEFDA@(DIVSFILE,DIVSIENS,DIVSFLD)) Q:DIVSFLD=""  D
 . . . S DIVSVAL=@DIVSEFDA@(DIVSFILE,DIVSIENS,DIVSFLD)
 . . . ;Quit if field is w-p -- no validation.
 . . . D DTYP^DIOU(DIVSFILE,DIVSFLD,.DIVSTYPE)
 . . . I DIVSTYPE=5 S @DIVSIFDA@(DIVSFILE,DIVSIENS,DIVSFLD)=DIVSVAL Q
 . . . D VAL^DIEV(DIVSFILE,DIVSIENS,DIVSFLD,DIVSNFLG,DIVSVAL,.DIVSANS,DIVSIFDA)
 . . . I DIVSANS=U S @DIVSIFDA@(DIVSFILE,DIVSIENS,DIVSFLD)=U,DIVSNG=1
 ;Now do Key Validation
 I DIVSFLAG'["U" S DIVSNG='$$KEYVAL^DIEVK($E("K",DIVSFLAG["K"),DIVSIFDA)
OUT I $G(DIVSMSG)]"" D CALLOUT^DIEFU(DIVSMSG)
 Q
