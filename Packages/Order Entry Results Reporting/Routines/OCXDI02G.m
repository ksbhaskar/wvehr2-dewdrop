OCXDI02G ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI02H
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.8:",100,3
 ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20," Execution trace  OILIST: ",$G(OILIST)
 ;;R^"860.8:",100,4
 ;;D^  ; N OCXPC,OCXOI,OCXOUT S OCXOUT=""
 ;;R^"860.8:",100,5
 ;;D^  ; F OCXPC=1:1:$L(OILIST,",") S OCXOI=$P(OILIST,",",OCXPC) I $L(OCXOI) D
 ;;R^"860.8:",100,6
 ;;D^  ; .N OCXL,OCXF,OCXD0
 ;;R^"860.8:",100,7
 ;;D^  ; .S OCXL="",OCXF=$$TERMLKUP(OCXOI,.OCXL)
 ;;R^"860.8:",100,8
 ;;D^  ; .S OCXD0=0 F  S OCXD0=$O(OCXL(OCXD0)) Q:'OCXD0  Q:$$OISESS^ORKCHK2(+OCXD0)
 ;;R^"860.8:",100,9
 ;;D^  ; .Q:OCXD0
 ;;R^"860.8:",100,10
 ;;D^  ; .S:$L(OCXOUT) OCXOUT=OCXOUT_", " S OCXOUT=OCXOUT_OCXOI
 ;;R^"860.8:",100,11
 ;;D^  ; Q OCXOUT
 ;;R^"860.8:",100,12
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^RECENT BARIUM STUDY
 ;;R^"860.8:",.01,"E"
 ;;D^RECENT BARIUM STUDY
 ;;R^"860.8:",.02,"E"
 ;;D^RECBAR
 ;;R^"860.8:",100,1
 ;;D^  ;RECBAR(DFN,HOURS) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(DFN) 0 Q:'$G(HOURS) 0 N OUT S OUT=$$RECENTBA^ORKRA(DFN,HOURS) Q:'$L(OUT) 0 Q 1_U_OUT
 ;;R^"860.8:",100,4
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^RECENT WBC LAB PROCEDURE
 ;;R^"860.8:",.01,"E"
 ;;D^RECENT WBC LAB PROCEDURE
 ;;R^"860.8:",.02,"E"
 ;;D^RECWBC
 ;;R^"860.8:",100,1
 ;;D^  ;RECWBC(DFN,DAYS) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(DFN) 0
 ;;R^"860.8:",100,4
 ;;D^  ; N OUT S OUT=$$RECNTWBC^ORKLR(DFN,DAYS) Q:'OUT 0 Q OUT
 ;;R^"860.8:",100,5
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^CREATININE CLEARANCE (ESTIMATED/CALCULATED)
 ;;R^"860.8:",.01,"E"
 ;;D^CREATININE CLEARANCE (ESTIMATED/CALCULATED)
 ;;R^"860.8:",.02,"E"
 ;;D^CRCL
 ;;R^"860.8:",100,1
 ;;D^  ;CRCL(DFN) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N WT,AGE,SEX,SCR,SCRD,CRCL,UNAV,OCXTL,OCXTLS,OCXT,OCXTS
 ;;R^"860.8:",100,4
 ;;D^  ; S UNAV="0^<Unavailable>"
 ;;R^"860.8:",100,5
 ;;D^  ; S WT=$P($$WT^ORQPTQ4(DFN),U,2)*.454 Q:'WT UNAV
 ;;R^"860.8:",100,6
 ;;D^  ; S AGE=$$AGE^ORQPTQ4(DFN) Q:'AGE UNAV
 ;;R^"860.8:",100,7
 ;;D^  ; S SEX=$P($$SEX^ORQPTQ4(DFN),U,1) Q:'$L(SEX) UNAV
 ;;R^"860.8:",100,8
 ;;D^  ; S OCXTL="" Q:'$$TERMLKUP("SERUM CREATININE",.OCXTL) UNAV
 ;;R^"860.8:",100,9
 ;;D^  ; S OCXTLS="" Q:'$$TERMLKUP("SERUM SPECIMEN",.OCXTLS) UNAV
 ;;R^"860.8:",100,10
 ;;D^  ; S SCR="",OCXT=0 F  S OCXT=$O(OCXTL(OCXT)) Q:'OCXT  D  Q:$L(SCR)
 ;;R^"860.8:",100,11
 ;;D^  ; .S OCXTS=0 F  S OCXTS=$O(OCXTLS(OCXTS)) Q:'OCXTS  D  Q:$L(SCR)
 ;;R^"860.8:",100,12
 ;;D^  ; ..S SCR=$$LOCL^ORQQLR1(DFN,OCXT,OCXTS)
 ;;R^"860.8:",100,13
 ;;D^  ; Q:'$L(SCR) UNAV  S SCRV=$P(SCR,U,3) Q:'SCRV UNAV
 ;;R^"860.8:",100,14
 ;;D^  ; S SCRD=$P(SCR,U,7) Q:'$L(SCRD) UNAV
 ;;R^"860.8:",100,15
 ;;D^  ; ;
 ;;R^"860.8:",100,16
 ;;D^  ; S CRCL=(((140-AGE)*WT)/(SCRV*72))
 ;;R^"860.8:",100,17
 ;;D^  ; ;
 ;;R^"860.8:",100,18
 ;;D^  ; I (SEX="M") Q SCRD_U_$J(CRCL,1,2)
 ;;R^"860.8:",100,19
 ;;D^  ; I (SEX="F") Q SCRD_U_$J((CRCL*.85),1,2)
 ;;R^"860.8:",100,20
 ;;D^  ; Q UNAV
 ;;R^"860.8:",100,21
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^CT MRI PHYSICAL LIMITS
 ;;R^"860.8:",.01,"E"
 ;;D^CT MRI PHYSICAL LIMITS
 ;;R^"860.8:",.02,"E"
 ;;D^CTMRI
 ;;R^"860.8:",100,1
 ;;D^  ;CTMRI(DFN,OCXOI) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N OCXDEV,OCXWTP,OCXHTP,OCXWTL,OCXHTL
 ;;R^"860.8:",100,4
 ;;D^  ; S OCXDEV=$$TYPE^ORKRA(OCXOI)
 ;;R^"860.8:",100,5
 ;;D^  ; Q:'((OCXDEV="MRI")!(OCXDEV="CT")) 0_U
 ;;R^"860.8:",100,6
 ;;D^  ; S OCXWTP=$P($$WT^ORQPTQ4(DFN),U,2),OCXHTP=$P($$HT^ORQPTQ4(DFN),U,2)
 ;;R^"860.8:",100,7
 ;;D^  ; I (OCXDEV="CT") S OCXWTL=$$GET^XPAR("ALL","ORK CT LIMIT WT",1,"Q"),OCXHTL=$$GET^XPAR("ALL","ORK CT LIMIT HT",1,"Q")
 ;;R^"860.8:",100,8
 ;;D^  ; I (OCXDEV="CT"),(OCXWTL),(OCXWTP>OCXWTL) Q 1_U_"too heavy"_U_"CT scanner"
 ;;R^"860.8:",100,9
 ;;D^  ; I (OCXDEV="CT"),(OCXHTL),(OCXHTP>OCXHTL) Q 1_U_"too tall"_U_"CT scanner"
 ;;R^"860.8:",100,10
 ;;D^  ; I (OCXDEV="MRI") S OCXWTL=$$GET^XPAR("ALL","ORK MRI LIMIT WT",1,"Q"),OCXHTL=$$GET^XPAR("ALL","ORK MRI LIMIT HT",1,"Q")
 ;;R^"860.8:",100,11
 ;;D^  ; I (OCXDEV="MRI"),(OCXWTL),(OCXWTP>OCXWTL) Q 1_U_"too heavy"_U_"MRI scanner"
 ;;R^"860.8:",100,12
 ;;D^  ; I (OCXDEV="MRI"),(OCXHTL),(OCXHTP>OCXHTL) Q 1_U_"too tall"_U_"MRI scanner"
 ;;R^"860.8:",100,13
 ;;D^  ; Q 0_U
 ;;R^"860.8:",100,14
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^GET ORDERABLE ITEM INTERNAL ENTRY NUMBER
 ;;R^"860.8:",.01,"E"
 ;;D^GET ORDERABLE ITEM INTERNAL ENTRY NUMBER
 ;;R^"860.8:",.02,"E"
 ;;D^GETOIIEN
 ;;R^"860.8:",100,1
 ;;D^ ;GETOIIEN(OCXPKG,OCXNAME) ;
 ;;R^"860.8:",100,2
 ;;D^ ; ;
 ;;R^"860.8:",100,3
 ;;D^ ; Q:'$L($G(OCXNAME)) 0 Q:'$L($G(OCXPKG)) 0 Q:'$D(^ORD(101.43,"S."_OCXPKG)) 0
 ;;R^"860.8:",100,4
 ;;D^ ; N OCXD0,OCXLIST,OCXOI
 ;;R^"860.8:",100,5
 ;1;
 ;
