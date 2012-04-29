VAQDIS42 ;ALB/JRP/JFP - PRINT ACTION PROFILE (CONT);30APR92
 ;;1.5;PATIENT DATA EXCHANGE;**13**;NOV 17, 1993
DEMOG ;PRINT PHARMACY DEMOGRAPHICS
 ;CHECK PARAMETERS
 N LOOP,X,TMP,TMP1,TMP2,ADDRESS,FLAG
 ;
R1 S X=$$SETSTR^VALM1($G(@XTRCT@("VALUE",2,.01,0)),"",1,40)
 S X=$$SETSTR^VALM1("SSN: "_$G(@XTRCT@("VALUE",2,.09,0)),X,42,37)
 D TMP^VAQDIS20
 ; -- SET UP ADDRESS ARRAY
 S X=1
 F LOOP=.111,.112,.113 D
 .S VAQTMP=$G(@XTRCT@("VALUE",2,LOOP,0))
 .I VAQTMP'="" S ADDRESS(X)=VAQTMP,X=X+1
 S ADDRESS(X)=$G(@XTRCT@("VALUE",2,.114,0))_", "_$G(@XTRCT@("VALUE",2,.115,0))_" "_$G(@XTRCT@("VALUE",2,.1112,0))
 K LOOP,VAQTMP,X
R2 ;
 S VAQINF=$S($D(ADDRESS(1)):ADDRESS(1),1:"")
 S X=$$SETSTR^VALM1(VAQINF,"",1,40)
 S X=$$SETSTR^VALM1("DOB: "_$G(@XTRCT@("VALUE",2,.03,0)),X,42,37)
 D TMP^VAQDIS20 K VAQINF
R3 ;
 S VAQINF=$S($D(ADDRESS(2)):ADDRESS(2),1:"")
 S X=$$SETSTR^VALM1(VAQINF,"",1,39)
 S X=$$SETSTR^VALM1("Phone: "_$G(@XTRCT@("VALUE",2,.131,0)),X,40,39)
 D TMP^VAQDIS20 K VAQINF
R4 ;
 S VAQINF=$S($D(ADDRESS(3)):ADDRESS(3),1:"")
 S X=$$SETSTR^VALM1(VAQINF,"",1,40)
 S X=$$SETSTR^VALM1("Elig: "_$G(@XTRCT@("VALUE",2,.361,0)),X,41,36)
 D TMP^VAQDIS20 K VAQINF
R5 ;
 I $D(ADDRESS(4)) S X=$$SETSTR^VALM1(ADDRESS(4),"",1,40) D TMP^VAQDIS20
 K ADDRESS
 D BLANK^VAQDIS20
 ;
R6 ; -- Print Narrative
 S VAQTMP=$G(@XTRCT@("VALUE",55,1,0))
 I VAQTMP=""  S X=$$SETSTR^VALM1("Pharmacy Narrative: None","",1,79) D TMP^VAQDIS20
 I VAQTMP'="" D
 .D SETNAR
 .S K=""
 .F J=0:0  S K=$O(LN($J,K))  Q:K=""  D
 ..S:K=1 X=$$SETSTR^VALM1("Pharmacy Narrative:"_$G(LN($J,K)),"",1,79)
 ..S:K'=1 X=$$SETSTR^VALM1("                   "_$G(LN($J,K)),"",1,79)
 ..D TMP^VAQDIS20
 D BLANK^VAQDIS20
 K VAQTMP,VAQLN,VAQWORD,LN,K,J
 ;
R7 ; -- Print rated disabilities
 S SEQ=""
 F J=1:1  S SEQ=$O(@XTRCT@("VALUE",2.04,.01,SEQ))  Q:SEQ=""  D
 .S VAQTMP1=$G(@XTRCT@("VALUE",2.04,.01,SEQ))
 .S VAQTMP2=$G(@XTRCT@("VALUE",2.04,2,SEQ))
 .S VAQTMP3=$G(@XTRCT@("VALUE",2.04,3,SEQ))
 .S VAQTMP4=$S(VAQTMP3="YES":"SC",1:"NSC")
 .S VAQINF=VAQTMP1_" ("_VAQTMP2_"%-"_VAQTMP4_")"
 .S:J=1 X=$$SETSTR^VALM1("Rated Disabilities: "_VAQINF,"",1,79)
 .S:J'=1 X=$$SETSTR^VALM1("                    "_VAQINF,"",1,79)
 .D TMP^VAQDIS20
 I J=1 S X=$$SETSTR^VALM1("Rated Disability: None","",1,79) D TMP^VAQDIS20
 D BLANK^VAQDIS20
 K VAQTMP1,VAQTMP2,VAQTMP3,VAQTMP4,VAQINF,SEQ,J
 ;
R8 ; -- PRINT REACTIONS
 S (SEQ,VAQLN)=""
 F J=1:1  S SEQ=$O(@XTRCT@("VALUE",120.8,.02,SEQ))  Q:SEQ=""  D
 .S VAQTMP=$G(@XTRCT@("VALUE",120.8,.02,SEQ))
 .I ($L(VAQLN_", "_VAQTMP)>68)&(J=1) S X=$$SETSTR^VALM1("Reactions: "_VAQLN,"",1,79) D TMP^VAQDIS20 S VAQLN=""
 .I ($L(VAQLN_", "_VAQTMP)>68)&(J'=1) S X=$$SETSTR^VALM1("           "_VAQLN,"",1,79) D TMP^VAQDIS20 S VAQLN=""
 .I J=1 S VAQLN=VAQLN_VAQTMP
 .I J'=1 S VAQLN=VAQLN_", "_VAQTMP
 I VAQLN'="" S X=$$SETSTR^VALM1("Reactions: "_VAQLN,"",1,79) D TMP^VAQDIS20
 I VAQLN="" S X=$$SETSTR^VALM1("Reactions: None","",1,79) D TMP^VAQDIS20
 K VAQTMP,VAQLN,SEQ,J
 D BLANK^VAQDIS20
 QUIT
 ;
SETNAR ; -- Sets display line for narrative
 S VAQLN="",K=1
 F J=1:1  D  Q:VAQWORD=""
 .S VAQWORD=$P(VAQTMP," ",J)
 .Q:VAQWORD=""
 .I ($L(VAQLN_" "_VAQWORD)>59) S LN($J,K)=VAQLN,VAQLN="",K=K+1
 .S VAQLN=VAQLN_" "_VAQWORD
 I $D(VAQLN) S LN($J,K)=VAQLN
 QUIT
 ;
END ; -- End of Code
 QUIT
 ;
