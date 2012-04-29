C0CRNFRPC   ; CCDCCR/GPL - Reference Name Format (RNF) RPCs; 12/9/09
 ;;1.0;C0C;;Dec 9, 2009;Build 2
 ;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 W "This is the Reference Name Format (RNF) RPC Library ",!
 W !
 Q
 ;
 ;This routine will be mirroring C0CRNF and transform the output
 ;of the tags into an RPC friendly format
 ;The tags will be exactly as they are in C0CRNF
FIELDS(C0CFRTN,C0CFILE) ; RETURNS AN ARRAY OF THE FIELDS IN FILE C0CF,
 ;C0CFRTN IS PASSED BY REFERENCE, C0CF IS PASSED BY VALUE
 ;RETURN FORMAT:
 ;^TMP("C0CRNF",$J,0)="NUMBER_OF_RESULTS
 ;^TMP("C0CRNF",$J,I)="FIELD_NAME^FILE_NUMBER^FIELD_NUMBER"
 ;
 ;SAMPLE OUTPUT FROM FIELDS^C0CRNF:
 ;C0CRNFFIELDS("*AMOUNT OF MILITARY RETIREMENT")="2^.3625"
 ;
 ;FORMAT APPEARS TO BE:
 ;VARIABLENAME("FIELD_NAME")="FILE_NUMBER^FIELD_NUMBER"
 ;
 ;SET DEBUG VALUE - REQUIRED - 0=OFF 1=ON
 S DEBUG=0
 ;SET RETURN VALUE
 S C0CFRTN=$NA(^TMP("C0CRNF",$J))
 K @C0CFRTN
 ;RUN WRAPPED CALL
 D FIELDS^C0CRNF("C0CRTN",C0CFILE)
 S J=""
 S I=1
 ;FORMAT RETURN
 F  S J=$O(C0CRTN(J)) Q:J=""  D  ; FOR EACH FIELD IN THE ARRAY
 . S @C0CFRTN@(I)=J_"^"_C0CRTN(J)
 . S I=I+1
 S @C0CFRTN@(0)=I-1
 ;CLEAN UP
 K J,I
 Q
 ;
GETNOLD(GRTN,GFILE,GIEN,GNN) ; GET FIELDS FOR ACCESS BY NAME
 ; GRTN IS PASSED BY NAME
 ;
 ; OLD TAG DO NOT USE!
 Q
 ;
GETN(C0CGRTN,GFILE,GREF,GNDX,GNN) ; GET BY NAME ; RETURN A FIELD VALUE MAP
 ; FORMAT ARRAY @GRTN@("FIELD NAME")="FILE^FIELD#^VALUE" ;GPL
 ; GRTN, PASSED BY NAME, RETURNS A FIELD MAP AND A VALUE MAP
 ; .. FIELD MAP @GRTN@("F","FIELDNAME^FILE^FIELD#")=""
 ; ... ANY FIELD USED BY ANY RECORD PROCESSED IS IN THE FIELD MAP
 ; .. VALUE MAP @GRTN@("V","IEN","FIELDNAME")=VALUE
 ; .. IF GNN="ALL" THEN ALL FIELDS FOR THE FILE ARE IN THE FIELD MAP
 ; .. EVEN IF GNN="ALL" ONLY POPULATED FIELDS ARE RETURNED IN THE VALUE MAP
 ; .. NULL FIELDS CAN BE DETERMINED BY CHECKING FIELD MAP - THIS SAVES SPACE
 ; IF GREF IS "" THE FIRST RECORD IS OBTAINED
 ; IF GNDX IS NULL, GREF IS AN IEN FOR THE FILE
 ; GNDX IS THE INDEX TO USE TO OBTAIN THE IEN
 ; GREF IS THE VALUE FOR THE INDEX
 ; GANN= NOT NULL - IF GANN IS "ALL" THEN EVEN NULL FIELDS WILL BE RETURNED
 ; OTHERWISE, ONLY POPULATED FIELDS ARE RETURNED IN GRTN
 ;
 ;
 ;RETURN FORMAT:
 ;^TMP("C0CRNF",$J,0)="NUMBER_OF_RESULTS^FILE_NUMBER^RNF1^IEN^CURRENT_DATE^$J^DUZ_$C(30)"
 ;^TMP("C0CRNF",$J,I)="FIELD_NAME^FILE_NUMBER^FIELD_NUMBER^VALUE^INTERNAL_VALUE_$C(30)"
 ;
 ;SAMPLE OUTPUT FROM FIELDS^C0CRNF:
 ;C0CRNFGETN(0)="2^RNF1^5095^3091209^2908^3268"
 ;C0CRNFGETN("1U4N")="2^.0905^H5369"
 ;C0CRNFGETN("1U4N","I")="^^H5369"
 ;C0CRNFGETN("ADDRESS CHANGE DT/TM")="2^.118^OCT 21,2009@08:03:26"
 ;C0CRNFGETN("ADDRESS CHANGE DT/TM","I")="^^3091021.080326"
 ;
 ;FORMAT APPEARS TO BE:
 ;VARIABLENAME(0)="FILE_NUMBER^RNF1^IEN^CURRENT_DATE^$J^DUZ"
 ;VARIABLENAME("FIELD_NAME")="FILE_NUMBER^FIELD_NUMBER^VALUE"
 ;VARIABLENAME("FIELD_NAME","I")="^^INTERNAL_VALUE"
 ;
 ;SET DEBUG VALUE - REQUIRED - 0=OFF 1=ON
 S DEBUG=0
 ;SET RETURN VALUE
 S C0CGRTN=$NA(^TMP("C0CRNF",$J))
 K @C0CGRTN
 ;RUN WRAPPED CALL
 D GETN^C0CRNF("C0CRTN",$G(GFILE),$G(GREF),$G(GNDX),$G(GNN))
 S J=""
 S I=1
 ;FORMAT RETURN
 F  S J=$O(C0CRTN(J)) Q:J=""  D  ; FOR EACH FIELD IN THE ARRAY
 . I J=0 S J=$O(C0CRTN(J)) ; SKIP THE 0 NODE
 . S @C0CGRTN@(I)=J_"^"_C0CRTN(J)_"^" ; GETS THE FIRST LINE
 . ;S J=$O(C0CRTN(J)) ; INCREMENT J SO WE CAN GET THE INTERNAL DATA
 . ;TEST TO SEE IF INTERNAL DATA EXISTS
 . I $D(C0CRTN(J,"I"))=1 D
 . . S @C0CGRTN@(I)=@C0CGRTN@(I)_$P(C0CRTN(J,"I"),U,3) ; GETS THE INTERNAL VALUE PIECE 3
 . S I=I+1
 S @C0CGRTN@(0)=I-1_"^"_C0CRTN(0)
 ;CLEAN UP
 K J,I
 Q
 ;
GETN1(GRTN,GFILE,GREF,GNDX,GNN) ; NEW GET ;GPL ; RETURN A FIELD VALUE MAP
 ; THE FOLLOWING COMMENTS ARE WRONG.. THIS ROUTINE STILL RETURNS AN RNF1
 ; FORMAT ARRAY @GRTN@("FIELD NAME")="FILE^FIELD#^VALUE" ;GPL
 ; GETN IS AN EXTRINSIC WHICH RETURNS THE NEXT IEN AFTER THE CURRENT GIEN
 ; GRTN, PASSED BY NAME, RETURNS A FIELD MAP AND A VALUE MAP
 ; .. FIELD MAP @GRTN@("F","FIELDNAME^FILE^FIELD#")=""
 ; ... ANY FIELD USED BY ANY RECORD PROCESSED IS IN THE FIELD MAP
 ; .. VALUE MAP @GRTN@("V","IEN","FIELDNAME")=VALUE
 ; .. GRTN IS NOT INITIALIZED, SO MULTIPLE CALLS ARE CUMULATIVE
 ; .. IF GNN="ALL" THEN ALL FIELDS FOR THE FILE ARE IN THE FIELD MAP
 ; .. EVEN IF GNN="ALL" ONLY POPULATED FIELDS ARE RETURNED IN THE VALUE MAP
 ; .. NUL FIELDS CAN BE DETERMINED BY CHECKING FIELD MAP - THIS SAVES SPACE
 ; IF GREF IS "" THE FIRST RECORD IS OBTAINED
 ; IF GNDX IS NULL, GREF IS AN IEN FOR THE FILE
 ; GNDX IS THE INDEX TO USE TO OBTAIN THE IEN
 ; GREF IS THE VALUE FOR THE INDEX
 ; GANN= NOT NULL - IF GANN IS "ALL" THEN EVEN NULL FIELDS WILL BE RETURNED
 ; OTHERWISE, ONLY POPULATED FIELDS ARE RETURNED IN GRTN
 ;
 ;
 N GIEN,GF
 S GF=$$FILEREF(GFILE) ;CLOSED FILE REFERENCE FOR FILE NUMBER GFILE
 I ('$D(GNDX))!(GNDX="") S GIEN=GREF ; IF NO INDEX USED, GREF IS THE IEN
 E  D  ; WE ARE USING AN INDEX
 . ;N ZG
 . S ZG=$Q(@GF@(GNDX,GREF)) ;ACCESS INDEX
 . I ZG'="" D  ;
 . . I $QS(ZG,3)=GREF D  ; IS GREF IN INDEX?
 . . . S GIEN=$QS(ZG,4) ; PULL OUT THE IEN
 . . E  S GIEN="" ; NOT FOUND IN INDEX
 . E  S GIEN="" ;
 ;W "IEN: ",GIEN,!
 ;N C0CTMP,C0CI,C0CJ,C0CREF,C0CNAME
 I $D(GNN) I GNN="ALL" S C0CNN=0 ; NOT NON-NULL (ALL FIELDS TO BE RETURNED)
 E  S C0CNN=1 ; NON-NULL IS TRUE (ONLY POPULATED FIELDS RETURNED)
 S C0CREF=GIEN_"," ; OPEN ROOT REFERENCE INTO FILE
 D CLEAN^DILF ; MAKE SURE WE ARE CLEANED UP
 K C0CTMP
 D GETS^DIQ(GFILE,C0CREF,"**","IE","C0CTMP")
 D FIELDS(GRTN,GFILE) ;GET ALL THE FIELD NAMES FOR THE FILE
 S @GRTN@(0)=GFILE_"^RNF1^"_GIEN_"^"_DT_"^"_$J_"^"_DUZ ; STRUCTURE SIGNATURE
 S (C0CI,C0CJ)=""
 F  S C0CJ=$O(C0CTMP(C0CJ)) Q:C0CJ=""  D  ; FOR ALL SUBFILES
 . S C0CREF=$O(C0CTMP(C0CJ,"")) ; RECORD REFERENCE
 . F  S C0CI=$O(C0CTMP(C0CJ,C0CREF,C0CI)) Q:C0CI=""  D  ; ARRAY OF FIELDS
 . . ;W C0CJ," ",C0CI,!
 . . S C0CNAME=$P(^DD(C0CJ,C0CI,0),"^",1) ;PULL THE FIELD NAME
 . . S C0CVALUE=C0CTMP(C0CJ,C0CREF,C0CI,"E") ;
 . . I C0CVALUE["C0CTMP" D  ; WP FIELD
 . . . N ZT,ZWP S ZWP=0 ;ITERATOR
 . . . S ZWP=$O(C0CTMP(C0CJ,C0CREF,C0CI,ZWP)) ; INIT TO FIRST LINE
 . . . S C0CVALUE=C0CTMP(C0CJ,C0CREF,C0CI,ZWP) ; INIT TO FIRST LINE
 . . . F  S ZWP=$O(C0CTMP(C0CJ,C0CREF,C0CI,ZWP)) Q:'ZWP  D  ;
 . . . . S ZT=" "_C0CTMP(C0CJ,C0CREF,C0CI,ZWP) ;LINE OF WP
 . . . . S ZT=$TR(ZT,"^""","|'") ;HACK TO GET RID OF ^ AND " IN TEXT "
 . . . . S C0CVALUE=C0CVALUE_ZT ;
 . . S $P(@GRTN@(C0CNAME),"^",3)=C0CVALUE ;RETURN VALUE IN P3
 . . S $P(@GRTN@(C0CNAME,"I"),"^",3)=$G(C0CTMP(C0CJ,C0CREF,C0CI,"I"))
 I C0CNN D  ; IF ONLY NON-NULL VALUES ARE TO BE RETURNED
 . S C0CI=""
 . F  S C0CI=$O(@GRTN@(C0CI)) Q:C0CI=""  D  ; GO THROUGH THE WHOLE ARRAY
 . . I $P(@GRTN@(C0CI),"^",3)="" K @GRTN@(C0CI) ; KILL THE NULL ENTRIES
 Q
 ;
GETN2(GARTN,GAFILE,GAIDX,GACNT,GASTRT,GANN) ; RETURN FIELD MAP AND VALUES
 ; GARTN, PASSED BY NAME, RETURNS A FIELD MAP AND A VALUE MAP
 ; .. FIELD MAP @GARTN@("F","FIELDNAME")="FILE;FIELD#"
 ; ... ANY FIELD USED BY ANY RECORD PROCESSED IS IN THE FIELD MAP
 ; .. VALUE MAP @GARTN@("V","IEN","FIELDNAME","N")=VALUE
 ; .. WHERE N IS THE INDEX FOR MULTIPLES.. 1 FOR SINGLE VALUES
 ; .. GARTN IS NOT INITIALIZED, SO MULTIPLE CALLS ARE CUMULATIVE
 ; .. IF GANN="ALL" THEN ALL FIELDS FOR THE FILE ARE IN THE FIELD MAP
 ; .. EVEN IF GANN="ALL" ONLY POPULATED FIELDS ARE RETURNED IN THE VALUE MAP
 ; .. NUL FIELDS CAN BE DETERMINED BY CHECKING FIELD MAP - THIS SAVES SPACE
 ; GAFILE IS THE FILE NUMBER TO BE PROCESSED. IT IS PASSED BY VALUE
 ; GAIDX IS THE OPTIONAL INDEX TO USE IN THE FILE. IF GAIDX IS "" THE IEN
 ; .. OF THE FILE WILL BE USED
 ; GACNT IS THE NUMBER OF RECORDS TO PROCESS. IT IS PASSED BY VALUE
 ; .. IF GARCNT IS NULL, ALL RECORDS ARE PROCESSED
 ; GASTRT IS THE IEN OF THE FIRST RECORD TO PROCESS. IT IS PASSED BY VALUE
 ; .. IF GARSTART IS NULL, PROCESSING STARTS AT THE FIRST RECORD
 ; GANN= NOT NULL - IF GANN IS "ALL" THEN EVEN NULL FIELDS WILL BE RETURNED
 ; OTHERWISE, ONLY POPULATED FIELDS ARE RETURNED IN GARFLD AND GARVAL
 ;N GATMP,GAI,GAF
 S GAF=$$FILEREF(GAFILE) ; GET CLOSED ROOT FOR THE FILE NUMBER GAFILE
 I '$D(GAIDX) S GAIDX="" ;DEFAULT
 I '$D(GANN) S GANN="" ;DEFAULT ONLY POPULATED FIELDS RETURNED
 I GAIDX'="" S GAF=$NA(@GAF@(GAIDX)) ; IF WE ARE USING AN INDEX
 W GAF,!
 W $O(@GAF@(0)) ;
 S GAI=0 ;ITERATOR
 F  S GAI=$O(@GAF@(GAI)) Q:GAI=""  D  ;
 . D GETN1("GATMP",GAFILE,GAI,GAIDX,GANN) ;GET ONE RECORD
 . N GAX S GAX=0
 . F  S GAX=$O(GATMP(GAX)) Q:GAX=""  D  ;PULL OUT THE FIELDS
 . . D ADDNV(GARTN,GAI,GAX,GATMP(GAX)) ;INSERT THE NAME/VALUE INTO GARTN
 Q
 ;
ADDNV(GNV,GNVN,GNVF,GNVV) ; CREATE AN ELEMENT OF THE MATRIX
 ;
 S @GNV@("F",GNVF)=$P(GNVV,"^",1)_"^"_$P(GNVV,"^",2) ;NAME=FILE^FIELD#
 S @GNV@("V",GNVN,GNVF,1)=$P(GNVV,"^",3) ;SET THE VALUE
 Q
 ;
RNF2CSV(RNRTN,RNIN,RNSTY) ;CONVERTS AN RFN2 GLOBAL TO A CSV FORMAT
 ; READY TO WRITE FOR USE WITH EXCEL @RNRTN@(0) IS NUMBER OF LINES
 ; RNSTY IS STYLE OF THE OUTPUT -
 ; .. "NV"= ROWS ARE NAMES, COLUMNS ARE VALUES
 ; .. "VN"= ROWS ARE VALUES, COLUMNS ARE NAMES
 ; .. DEFAULT IS "NV" BECAUSE MANY MATRICES HAVE MORE FIELDS THAN VALUES
 N RNR,RNC ;ROW ROOT,COL ROOT
 N RNI,RNJ,RNX
 I '$D(RNSTY) S RNSTY="NV" ;DEFAULT
 I RNSTY="NV" D NV(RNRTN,RNIN)  ; INTERNAL SUBROUTINES DEPENDING ON ORIENTATION
 E  D VN(RNRTN,RNIN) ;
 Q
 ;
NV(RNRTN,RNIN) ;
 S RNR=$NA(@RNIN@("F"))
 S RNC=$NA(@RNIN@("V"))
 ;S RNY=$P(@RNIN@(0),"^",1) ; FILE NUMBER
 S RNX="""FILE"""_"," ; FIRST COLUMN NAME IS "FIELD"
 S RNI=""
 F  S RNI=$O(@RNC@(RNI)) Q:RNI=""  D  ; FOR EACH COLUMN
 . S RNX=RNX_RNI_"," ;ADD THE COLUMM ELEMENT AND A COMMA
 S RNX=$E(RNX,1,$L(RNX)-1) ; STRIP OFF THE LAST COMMA
 D PUSH^GPLXPATH(RNRTN,RNX) ; FIRST LINE CONTAINS COLUMN HEADINGS
 S RNI=""
 F  S RNI=$O(@RNR@(RNI)) Q:RNI=""  D  ; FOR EACH ROW
 . S RNX=""""_RNI_""""_"," ; FIRST ELEMENT ON ROW IS THE FIELD
 . S RNJ=""
 . F  S RNJ=$O(@RNC@(RNJ)) Q:RNJ=""  D  ; FOR EACH COL
 . . I $D(@RNC@(RNJ,RNI,1)) D  ; THIS ROW HAS THIS COLUMN
 . . . S RNX=RNX_""""_@RNC@(RNJ,RNI,1)_""""_"," ; ADD THE ELEMENT PLUS A COMMA
 . . E  S RNX=RNX_"," ; NUL COLUMN
 . S RNX=$E(RNX,1,$L(RNX)-1) ; STRIP OFF THE LAST COMMA
 . D PUSH^GPLXPATH(RNRTN,RNX)
 Q
 ;
VN(RNRTN,RNIN) ;
 S RNR=$NA(@RNIN@("V"))
 S RNC=$NA(@RNIN@("F"))
 ;S RNY=$P(@RNIN@(0),"^",1) ; FILE NUMBER
 S RNX="""FILE"""_"," ; FIRST COLUMN NAME IS "FIELD"
 S RNI=""
 F  S RNI=$O(@RNC@(RNI)) Q:RNI=""  D  ; FOR EACH COLUMN
 . S RNX=RNX_RNI_"," ;ADD THE COLUMM ELEMENT AND A COMMA
 S RNX=$E(RNX,1,$L(RNX)-1) ; STRIP OFF THE LAST COMMA
 D PUSH^GPLXPATH(RNRTN,RNX) ; FIRST LINE CONTAINS COLUMN HEADINGS
 S RNI=""
 F  S RNI=$O(@RNR@(RNI)) Q:RNI=""  D  ; FOR EACH ROW
 . S RNX=""""_RNI_""""_"," ; FIRST ELEMENT ON ROW IS THE FIELD
 . S RNJ=""
 . F  S RNJ=$O(@RNC@(RNJ)) Q:RNJ=""  D  ; FOR EACH COL
 . . I $D(@RNR@(RNI,RNJ,1)) D  ; THIS ROW HAS THIS COLUMN
 . . . S RNX=RNX_""""_@RNR@(RNI,RNJ,1)_""""_"," ; ADD THE ELEMENT PLUS A COMMA
 . . E  S RNX=RNX_"," ; NUL COLUMN
 . S RNX=$E(RNX,1,$L(RNX)-1) ; STRIP OFF THE LAST COMMA
 . D PUSH^GPLXPATH(RNRTN,RNX)
 Q
 ;
READCSV(PATH,NAME,GLB) ; READ A CSV FILE IN FROM UNIX TO GLB, PASSED BY NAME
 ;
 Q $$FTG^%ZISH(PATH,NAME,GLB,1)
 ;
FILE2CSV(FNUM,FVN) ; WRITES OUT A FILEMAN FILE TO CSV
 ;
 ;N G1,G2
 I '$D(FVN) S FVN="NV" ; DEFAULT ORIENTATION OF CVS FILE
 S G1=$NA(^TMP($J,"C0CCSV",1))
 S G2=$NA(^TMP($J,"C0CCSV",2))
 D GETN2(G1,FNUM) ; GET THE MATRIX
 D RNF2CSV(G2,G1,FVN) ; PREPARE THE CVS FILE
 K @G1
 D FILEOUT(G2,"FILE_"_FNUM_".csv")
 K @G2
 Q
 ;
FILEOUT(FOARY,FONAM) ; WRITE OUT A FILE
 ;
 W $$OUTPUT^GPLXPATH($NA(@FOARY@(1)),FONAM,^TMP("GPLCCR","ODIR"))
 Q
 ;
FILEREF(FNUM) ; EXTRINSIC THAT RETURNS A CLOSED ROOT FOR FILE NUMBER FNUM
 ;
 N C0CF
 S C0CF=^DIC(FNUM,0,"GL") ;OPEN ROOT TO FILE
 S C0CF=$P(C0CF,",",1)_")" ; CLOSE THE ROOT
 I C0CF["()" S C0CF=$P(C0CF,"()",1)
 Q C0CF
 ;
SKIP ;
 N TXT,DIERR
 S TXT=$$GET1^DIQ(8925,TIUIEN,"2","","TXT")
 I $D(DIERR) D CLEAN^DILF Q
 W "  report_text:",!  ;Progress Note Text
 N LN S LN=0
 F  S LN=$O(TXT(LN)) Q:'LN  D
 . W "    text"_LN_": "_TXT(LN),!
 . Q
 Q
 ;
ZFILE(ZFN,ZTAB) ; EXTRINSIC TO RETURN FILE NUMBER FOR FIELD NAME PASSED
 ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 1 OF @ZTAB@(ZFN)
 ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
 I '$D(ZTAB) S ZTAB="C0CA"
 Q $P(@ZTAB@(ZFN),"^",1)
ZFIELD(ZFN,ZTAB) ;EXTRINSIC TO RETURN FIELD NUMBER FOR FIELD NAME PASSED
 ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 2 OF @ZTAB@(ZFN)
 ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
 I '$D(ZTAB) S ZTAB="C0CA"
 Q $P(@ZTAB@(ZFN),"^",2)
ZVALUE(ZFN,ZTAB) ;EXTRINSIC TO RETURN VALUE FOR FIELD NAME PASSED
 ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 3 OF @ZTAB@(ZFN)
 ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
 I '$D(ZTAB) S ZTAB="C0CA"
 Q $P($G(@ZTAB@(ZFN)),"^",3)
 ;
ZVALUEI(ZFN,ZTAB) ;EXTRINSIC TO RETURN INTERNAL VALUE FOR FIELD NAME PASSED
 ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 3 OF @ZTAB@(ZFN)
 ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
 I '$D(ZTAB) S ZTAB="C0CA"
 Q $P($G(@ZTAB@(ZFN,"I")),"^",3)
 ;
