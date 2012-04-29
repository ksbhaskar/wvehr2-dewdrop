OCXSEND8        ;SLC/RJS,CLA - BUILD RULE TRANSPORTER ROUTINES (Build Library Routine 4) ;1/31/01  08:44
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,96,105,243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
EN()    ;
        ;
        N R,LINE,TEXT,NOW,RUCI
        S NOW=$$NOW^OCXSEND3,RUCI=$$NETNAME^OCXSEND
        F LINE=1:1:999 S TEXT=$P($T(TEXT+LINE),";",2,999) Q:TEXT  S TEXT=$P(TEXT,";",2,999) S R(LINE,0)=$$CONV^OCXSEND3(TEXT)
        ;
        M ^TMP("OCXSEND",$J,"RTN")=R
        ;
        S DIE="^TMP(""OCXSEND"","_$J_",""RTN"",",XCN=0,X=$$RNAME^OCXSEND3(4,1)
        W !,X X ^%ZOSF("SAVE") K ^TMP("OCXSEND",$J,"RTN")
        ;
        Q " "
        ;
TEXT    ;
        ;;|$$RNAME^OCXSEND3(4,1)| ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE |OCXPATCH| ;|NOW|
        ;;|OCXLIN2|
        ;;|OCXLIN3|
        ;; ;
        ;;S ;
        ;; ;  Field Utilities
        ;; Q
        ;; ;
        ;;EDITFLD(OCXCREF,OCXDD,OCXFLD,OCXSUB) ;
        ;; ;
        ;; N DDPATH,OCXDA,OCXPC,OCXLVL,QUIT
        ;; ;
        ;; S QUIT=0,DDPATH=$P($P($$APPEND(OCXCREF,OCXDD),"(",2),")",1)
        ;; S OCXLVL=$L(DDPATH,",")
        ;; F OCXPC=1:1:OCXLVL S OCXDA(OCXLVL-OCXPC)=+$P($P(DDPATH,",",OCXPC),":",2)
        ;; S OCXDA=OCXDA(0) K OCXDA(0)
        ;; I $L($G(@OCXCREF@(OCXDD,OCXFLD,"E"))) D
        ;; .N RESP
        ;; .Q:(OCXFLAG["D")
        ;; .I (OCXFLAG["A") S RESP=$$READ("Y"," Do you want to change the local '"_$$FILENAME^OCXSENDD(+OCXDD)_"' field ?","YES") I 'RESP S QUIT=(RESP[U) Q
        ;; .S OCXGREF=$$GETREF^|$$RNAME^OCXSEND3(2,1)|(+OCXDD,.OCXDA,OCXLVL-1) Q:'$L(OCXGREF)
        ;; .D DIE^|$$RNAME^OCXSEND3(2,1)|(OCXDD,OCXGREF,OCXFLD,@OCXCREF@(OCXDD,OCXFLD,"E"),.OCXDA,OCXLVL-1)
        ;; ;
        ;; Q QUIT
        ;; ;
        ;;DELFLD(OCXCREF,OCXDD,OCXFLD,OCXSUB) ;
        ;; ;
        ;; N DDPATH,OCXDA,OCXPC,OCXLVL,QUIT,RESP
        ;; ;
        ;; S QUIT=0,DDPATH=$P($P($$APPEND(OCXCREF,OCXDD),"(",2),")",1)
        ;; S OCXLVL=$L(DDPATH,",")
        ;; F OCXPC=1:1:OCXLVL S OCXDA(OCXLVL-OCXPC)=+$P($P(DDPATH,",",OCXPC),":",2)
        ;; S OCXDA=OCXDA(0) K OCXDA(0)
        ;; Q:(OCXFLAG["D") 0
        ;; I (OCXFLAG["A") S RESP=$$READ("Y"," Do you want to Delete the local '"_$$FILENAME^OCXSENDD(+OCXDD)_"' value ?","YES") I 'RESP S QUIT=(RESP[U) Q QUIT
        ;; S OCXGREF=$$GETREF^|$$RNAME^OCXSEND3(2,1)|(+OCXDD,.OCXDA,OCXLVL-1) Q:'$L(OCXGREF)
        ;; D DIE^|$$RNAME^OCXSEND3(2,1)|(OCXDD,OCXGREF,OCXFLD,"@",.OCXDA,OCXLVL-1)
        ;; ;
        ;; Q QUIT
        ;; ;
        ;;CREATE(OCXCREF,OCXDD,OCXDA,OCXLVL) ;
        ;; ;
        ;; N OCXFLD,OCXGREF
        ;; ;
        ;; S OCXGREF=$$GETREF^|$$RNAME^OCXSEND3(2,1)|(+OCXDD,.OCXDA,OCXLVL) Q:'$L(OCXGREF)  S:'OCXDA OCXDA=$O(@(OCXGREF_"""@"")"),-1)+1
        ;; ;
        ;; I '$D(@(OCXGREF_"0)")) S @(OCXGREF_"0)")=U_$$FILEHDR^OCXSENDD(+OCXDD)_U_U
        ;; ;
        ;; S OCXFLD=0 F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'OCXFLD  Q:(OCXFLD[":")  I '$$EXFLD^|$$RNAME^OCXSEND3(1,1)|(+OCXDD,OCXFLD) D
        ;; .I $L($G(@OCXCREF@(OCXDD,OCXFLD,"E"))) D DIE^|$$RNAME^OCXSEND3(2,1)|(OCXDD,OCXGREF,OCXFLD,@OCXCREF@(OCXDD,OCXFLD,"E"),.OCXDA,OCXLVL)
        ;; ;
        ;; D PUSH(.OCXDA)
        ;; S OCXFLD="" F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'$L(OCXFLD)  I (OCXFLD[":") D
        ;; .S OCXDA=$P(OCXFLD,":",2) W ! D CREATE($$APPEND(OCXCREF,OCXDD),OCXFLD,.OCXDA,OCXLVL+1)
        ;; D POP(.OCXDA)
        ;; Q
        ;; ;
        ;;PUSH(OCXDA) ;
        ;; N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB),-1) Q:'OCXSUB  S OCXDA(OCXSUB+1)=OCXDA(OCXSUB)
        ;; S OCXDA(1)=OCXDA,OCXDA=0
        ;; Q
        ;; ;
        ;;POP(OCXDA) ;
        ;; N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB)) Q:'OCXSUB  S OCXDA(OCXSUB)=$G(OCXDA(OCXSUB+1))
        ;; S OCXDA=OCXDA(1) K OCXDA($O(OCXDA(""),-1))
        ;; Q
        ;; ;
        ;;APPEND(ARRAY,OCXSUB) ;
        ;; S:'(OCXSUB=+OCXSUB) OCXSUB=""""_OCXSUB_""""
        ;; Q:'(ARRAY["(") ARRAY_"("_OCXSUB_")"
        ;; Q $E(ARRAY,1,$L(ARRAY)-1)_","_OCXSUB_")"
        ;; ;
        ;;READ(OCXZ0,OCXZA,OCXZB,OCXZL) ;
        ;; N OCXLINE,DIR,DTOUT,DUOUT,DIRUT,DIROUT
        ;; Q:'$L($G(OCXZ0)) U
        ;; S DIR(0)=OCXZ0
        ;; S:$L($G(OCXZA)) DIR("A")=OCXZA
        ;; S:$L($G(OCXZB)) DIR("B")=OCXZB
        ;; F OCXLINE=1:1:($G(OCXZL)-1) W !
        ;; D ^DIR
        ;; I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q U
        ;; Q Y
        ;; ;
        ;;PAUSE() W "  Press Enter " R X:DTIME W ! Q (X[U)
        ;; ;
        ;;$
        ;1;
        ;
