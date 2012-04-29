LEXQH ;ISL/KER - Query History - Main ;10/30/2008
 ;;2.0;LEXICON UTILITY;**62**;Sep 23, 1996;Build 16
 ;;
 ;
 ; Global Variables
 ;    ^TMP("LEXQH")       SACC 2.3.2.5.1
 ;    ^TMP("LEXQHL")      SACC 2.3.2.5.1
 ;    ^TMP("LEXQHLA")     SACC 2.3.2.5.1
 ;    ^TMP("LEXQHO")      SACC 2.3.2.5.1
 ;
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^DIM                ICR  10016
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;
EN ; Main Entry Point
 N DIR,DIRB,DIROUT,DIRUT,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,DTOUT,DUOUT,LEX,LEX1,LEX2,LEX3,LEXACT,LEXAT,LEXATD,LEXB,LEXC,LEXC1,LEXC2,LEXCMD
 N LEXCODE,LEXCOM,LEXCT,LEXCTY,LEXD,LEXDC,LEXDG,LEXDI,LEXDISP,LEXDR,LEXDRG,LEXDS,LEXDT,LEXE,LEXEC,LEXEF,LEXEIEN,LEXENT,LEXEX,LEXFD,LEXEXIT,LEXFI
 N LEXFILE,LEXFIRST,LEXG,LEXH,LEXHD,LEXHDR,LEXI,LEXIA,LEXIAD,LEXICT,LEXID,LEXIEN,LEXIN,LEXIT,LEXIX,LEXKEY,LEXL,LEXL1,LEXL2,LEXL3,LEXLAST,LEXLEN
 N LEXM,LEXMAX,LEXMC,LEXMCI,LEXMCT,LEXMD,LEXMDG,LEXMDRG,LEXMOD,LEXMS,LEXN,LEXN1,LEXN2,LEXN3,LEXNAME,LEXNC,LEXNM,LEXNMD,LEXNN,LEXNODE,LEXO,LEXO1
 N LEXO2,LEXO3,LEXOC,LEXOMD,LEXP,LEXRAN,LEXROOT,LEXRTN,LEXS,LEXSAB,LEXSEL,LEXSIEN,LEXSO,LEXSS,LEXSTR,LEXT,LEXT1,LEXT2,LEXT3,LEXTAG,LEXTD,LEXTN
 N LEXTOT,LEXTQ,LEXTS,LEXTTT,LEXTY,LEXTYPE,LEXUN,LEXUND,LEXUSR,LEXV,LEXVAL,LEXVDT,LEXVT,LEXX,X,Y
 K ^TMP("LEXQH",$J),^TMP("LEXQHL",$J),^TMP("LEXQHLA"),^TMP("LEXQHO",$J)
 S LEXEXIT=0,LEXTD=$$DT^XLFDT W ! S LEXSO=$$SO^LEXQL K ^TMP("LEXQH",$J) I +LEXEXIT>0!('$L(LEXSO)) W !!,?4,"Code not selected" G ABT
 S LEXIEN=+LEXSO,LEXCODE=$P(LEXSO,U,4),LEXNAME=$P(LEXSO,U,5),LEXFILE=$P(LEXSO,U,3),LEXTYPE=$$TY(LEXFILE),LEXROOT=$P(LEXSO,U,2)
 I '$L(LEXCODE)!('$L(LEXFILE))!('$L(LEXNAME))!('$L(LEXIEN))!('$L(LEXTYPE))!('$L(LEXROOT))!(+LEXIEN'>0) W !!,?4,"Valid Code not selected" G ABT
 S LEXROOT="^"_LEXROOT S LEXNODE=@(LEXROOT_LEXIEN_",0)") I '$L(LEXNODE) W !!,?4,"Record for code not found" G ABT
 S LEXDISP=$$DIS^LEXQHA I +($G(LEXEXIT))>0!("^CH^SB^"'[("^"_LEXDISP_"^")) W !!,?4,"Display not selected" G ABT
 S (LEXTAG,LEXRTN,LEXENT)="" S:LEXFILE=80 LEXENT="D EN^LEXQHL1("_+LEXIEN_",$G(LEXDISP))" S:LEXFILE=80.1 LEXENT="D EN^LEXQHL2("_+LEXIEN_",$G(LEXDISP))"
 S:LEXFILE=81 LEXENT="D EN^LEXQHL3("_+LEXIEN_",$G(LEXDISP))" S LEXEXIT=0
 S:LEXFILE=81.3 LEXENT="D EN^LEXQHL4("_+LEXIEN_",$G(LEXDISP),$G(LEXRAN))",LEXRAN=$$RAN^LEXQHA
 I +($G(LEXEXIT))>0!(LEXFILE=81.3&($G(LEXRAN)["^")) W !!,?4,"Range not selected" G ABT
 S LEXT=$S(LEXDISP="CH":"Chronological ",LEXDISP="SB":"Subjective ",1:"")
 S LEXT=LEXT_"Display of "_LEXTYPE_" "_LEXCODE
 S:$L(LEXNAME) LEXT=LEXT_", """_LEXNAME
 S:$L(LEXNAME)&((LEXFILE'=81.3)!(LEXFILE=81.3&(+($G(LEXRAN))'>0))) LEXT=LEXT_""""
 S:$L(LEXNAME)&(LEXFILE=81.3&(+($G(LEXRAN))>0)) LEXT=LEXT_","""
 S:LEXFILE=81.3&(+($G(LEXRAN))>0) LEXT=LEXT_" with CPT Code Ranges"
 W !!,?2,"Display a ",$S(LEXDISP="CH":"Chronological ",LEXDISP="SB":"Subjective ",1:""),"History of ",LEXTYPE," ",LEXCODE
 W !,?4,LEXNAME W:LEXFILE=81.3&(+($G(LEXRAN))>0) !,?6,"with CPT Code Ranges" W !
 S LEXTAG=$P(LEXENT,U,1) S:LEXTAG[" " LEXTAG=$P(LEXTAG," ",2) S LEXRTN=$P(LEXENT,U,2) S:LEXRTN["(" LEXRTN=$P(LEXRTN,"(",1)
 K ^TMP("LEXQHO",$J) S X=LEXENT D ^DIM S:'$D(X) LEXEXIT=1
 I +($$TAG^LEXQD((LEXTAG_"^"_LEXRTN)))'>0!(+($G(LEXEXIT))>0) W !!,?4,"Invalid Code or Display selected" G ABT
 X LEXENT I '$D(^TMP("LEXQHO",$J)) W !!,?4,"No history to display" G ABT
 D:$D(^TMP("LEXQHO",$J)) DSP^LEXQO("LEXQHO") K ^TMP("LEXQH",$J),^TMP("LEXQHL",$J),^TMP("LEXQHLA",$J)
 Q
ABT ;   Abort
 K ^TMP("LEXQH",$J),^TMP("LEXQHL",$J),^TMP("LEXQHLA",$J),^TMP("LEXQHO",$J)
 Q
TY(X) ;   Code Type
 Q:+($G(X))=80 "ICD Diagnostic Code"
 Q:+($G(X))=80.1 "ICD Procedural Code"
 Q:+($G(X))=81 "CPT/HCPCS Procedural Code"
 Q:+($G(X))=81.3 "CPT Modifier Code"
 Q ""
EV(X) ;   Check environment
 N LEX S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 W !!,?5,"DUZ not defined" Q 0
 S LEX=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(LEX) W !!,?5,"DUZ not valid" Q 0
 Q 1
