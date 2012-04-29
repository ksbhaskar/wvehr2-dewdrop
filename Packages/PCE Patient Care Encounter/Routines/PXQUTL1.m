PXQUTL1 ;ISL/JVS - DEBUGGING UTILITIES ;5/1/97  08:30
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**4,29,163**;Aug 12 1996
 ;
 ;
DEC(VISIT,FLENUM,VISUAL,PXQFORM) ;Test looking through DD to find fields pointing to the visit entries.
 ;Q:'$D(^AUPNVSIT(VISIT)) ""
 Q:'$D(DUZ) ""
 Q:$G(PXQFORM)=""
 ; VISIT  =Visit ien to looked up and counted
 ; VISUAL =Set to 1 if you want and interactive display of what is found
 ; PXQFORM=The format that it is to be diplayed.
 ;
 ; Look for file and field
 ;
 N DD,PXQKY,COUNT,FIELD,FILE,GET,PIECE,PX,REF,SNDPIECE,STOP,SUB,PXQDATA
 N PXQTYPE,VAR,UPFILE,PXQVGHN,PXQFLD,PXQLIEN,PXQKY,PXQKY1,PXQKY2,PXQKY3
 N PXQNFLD,PXX
 K VDD,VDDN,VDDR
 ;
 S PXQTYPE=$P(PXQFORM,"^",2),PXQFORM=$P(PXQFORM,"^",1) D:$G(PXQTYPE)="C" ADD2  D:$G(PXQTYPE)="D" MUST
 S DD="^DD"
 S FILE=""
 F  S FILE=$O(@DD@(FLENUM,0,"PT",FILE)) Q:FILE=""  D
 .S FIELD=""
 .F  S FIELD=$O(@DD@(FLENUM,0,"PT",FILE,FIELD)) Q:FIELD=""  D
 ..I $E(FILE,1,5)=19908,FLENUM=9000010 Q
 ..S VDD(FILE,FIELD)=""
 D EN1^PXQUTL2
 D REF,QUE
 K VDDN,VDDR
 K ^TMP("PXQADDITIONAL",$J)
 I $G(VISUAL) W !,"COUNT= "
 Q COUNT
 ;
REF ;Look for all of the regular cross references and other
 ;
 S FILE="" F  S FILE=$O(VDD(FILE)) Q:FILE=""  D
 .S FIELD="" F  S FIELD=$O(VDD(FILE,FIELD)) Q:FIELD=""  D
 ..D REG
 K VDD
 Q
 ;
REG ;Look for regular cross references
 ;
 S STOP=0
 I '$D(@DD@(FILE,FIELD,1)) S VDDN(FILE,FIELD)="" Q
 S SUB=0 F  S SUB=$O(@DD@(FILE,FIELD,1,SUB)) Q:SUB=""  D
 .S GET=$G(@DD@(FILE,FIELD,1,SUB,0))
 .I $P(GET,"^",3)']"" S VDDR(FILE,SUB)=FILE_"^"_FIELD_"^"_SUB S STOP=1
 .E  S VDDN(FILE,FIELD)=""
 Q
QUE ;CHECK OUT CROSS REFERENCE
 ;
 S FILE="",FIELD="",STOP="",COUNT=0
 F  S FILE=$O(VDDR(FILE)) Q:FILE=""  D
 .S SUB=0,STOP="" F  S SUB=$O(VDDR(FILE,SUB)) Q:SUB=""  Q:STOP=1  S GET=$G(VDDR(FILE,SUB)) D
 ..S REF=$G(@DD@($P(GET,"^",1),$P(GET,"^",2),1,$P(GET,"^",3),1))
 ..I $P(REF,"""",1)["DA(1)" Q
 ..S PIECE=$P(REF," ",2)
 ..S SNDPIECE=$P(PIECE,"""",1,2)_""""
 ..S PXQVGHN=$P(PIECE,"""",1,2)_""")"
 ..I $D(@PXQVGHN) D  S STOP=1
 ...S PX=SNDPIECE_",VISIT)"
 ...I $D(@PX) D
 ....S PXQKY=0 F  S PXQKY=$O(@PX@(PXQKY)) Q:PXQKY=""  S COUNT=COUNT+1,PXB=PXQKY  S:FILE=409.68 PXQENC(PXQKY)="" D
 .....S VAR="" S VAR=$O(@PX@(PXQKY,VAR)) I VAR="" D DIS S PX=PXX Q
 .....S PXQKY1=0 F  S PXQKY1=$O(@PX@(PXQKY,PXQKY1)) Q:PXQKY1=""  S PXB1=PXQKY1 D
 ......S VAR="" S VAR=$O(@PX@(PXQKY,PXQKY1,VAR)) I VAR="" D DIS S PX=PXX Q
 ......S PXQKY2=0 F  S PXQKY2=$O(@PX@(PXQKY,PXQKY1,PXQKY2)) Q:PXQKY2=""  S PXB2=PXQKY2 D
 .......S VAR="" S VAR=$O(@PX@(PXQKY,PXQKY1,PXQKY2,VAR)) I VAR="" D DIS S PX=PXX Q
 .......S PXQKY3=0 F  S PXQKY3=$O(@PX@(PXQKY,PXQKY1,PXQKY2,PXQKY3)) Q:PXQKY3=""  S PXB3=PXQKY3 D
 ........S VAR="" S VAR=$O(@PX@(PXQKY,PXQKY1,PXQKY2,PXQKY3,VAR)) I VAR="" D DIS S PX=PXX Q
 Q
 ;
DIS ;--DISPLAY
 S PXX=PX
 W:$G(VISUAL) !,"   ",SNDPIECE_","_VISIT_","_$G(PXB) S PXBIEN=$G(PXB)
 W:$G(VISUAL) $S($G(PXB1):","_$G(PXB1),1:"") S PXBIEN=PXBIEN_","_$G(PXB1)
 W:$G(VISUAL) $S($G(PXB2):","_$G(PXB2),1:"") S PXBIEN=PXBIEN_","_$G(PXB2)
 W:$G(VISUAL) $S($G(PXB3):","_$G(PXB3),1:"") S PXBIEN=PXBIEN_","_$G(PXB3)
 K ^TMP("PXQDATA",$J)
 ;
 ;
 ;--REVERSE ORDER OF PXBIEN
 S PXQIENS="" F PXQI=($L(PXBIEN,",")-1):-1:1 S PXQJ=+$P($G(PXBIEN),",",PXQI) D
 .I PXQJ>0 S PXQIENS=PXQIENS_PXQJ_","
 K PXBIEN
 ;
 ;--DO FIRST CALL TO GETS^DIQ
 S PXQFORM2=PXQFORM
 I FILE=8925,PXQFORM["**" S PXQFORM=".01:.999;2.1:999999"
 I $G(PXQIENS) D GETS^DIQ(FILE,PXQIENS,PXQFORM,"NE","^TMP(""PXQDATA"",$J")
 D ADD
 ;
 ;--GET NEXT FILE NUMBER
 S UPFILE=FILE
 F  S UPFILE=$G(@DD@(UPFILE,0,"UP")) Q:UPFILE'>0  D
 .S PXQIENS=$P($G(PXQIENS),",",2,10)
 .I (FILE=8925!(PXX[19908)),PXQFORM["**" S PXQFORM=".01:.999;2.1:999999"
 .I $G(PXQIENS) D GETS^DIQ(UPFILE,PXQIENS,PXQFORM,"NE","^TMP(""PXQDATA"",$J")
 .D ADD1
 S PXQFORM=PXQFORM2
 ;
 ;
 D PRINT
EXIT ;---CLEAN UP AND QUIT DOESN'T QUIT THE ROUTINE
 K PXB,PXB1,PXB2,PXB3,PXQI,PXQJ
 K PXQIENS,PXQTEST,PXQWORD
 S VAR=""
 Q
PRINT ;--PRINT TO SCREEN
 N PXQFILE,PXQIENS,PXQFIELD,PXQLEIN,PXQNAME,PXQSPAC,PXQENTRY,PXQENTR
 N PXQX
 S PXQLIEN=0
 S PXQFILE="" F  S PXQFILE=$O(^TMP("PXQDATA",$J,PXQFILE)) Q:PXQFILE=""  D
 .S PXQNAME=$O(@DD@(PXQFILE,0,"NM",""))
 .S PXQSPAC="?"_(PXQLIEN+4)_","
 .S PXQTEST=PXQSPAC_""""_"FILE = "_PXQNAME_" #"_PXQFILE
 .S PXQIENS="" F  S PXQIENS=$O(^TMP("PXQDATA",$J,PXQFILE,PXQIENS)) Q:PXQIENS=""  D
 ..S PXQLIEN=($L(PXQIENS,",")*4)
 ..S PXQENTRY=$P(PXQIENS,",",1) ;--($L(PXQIENS,",")-1))
 ..S PXQENTR="  RECORD #"_PXQENTRY
 ..W $$RE^PXQUTL(""_PXQTEST_PXQENTR_"""")
 ..S PXQFIELD="" F  S PXQFIELD=$O(^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD)) Q:PXQFIELD=""  D
 ...;---NEW CODE 3/24/97
 ...D FIELD^DID(PXQFILE,PXQFIELD,"","TYPE","PXQWORD","PXQWORD")
 ...I PXQWORD("TYPE")["WORD-PROCESSING" D
 ....K PXQWORD,^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD)
 ....S ^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD,"E")="(word-processing field)"
 ...S PXQX=$G(^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD,"E"))
 ...I PXQX["""" S PXQX="(not displayable-look up entry)"
 ...S ^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD,"E")=PXQX
 ...;---END OF CODE
 ...N PXQNF,PXQMOV
 ...S PXQMOV=""",?35,"""
 ...S PXQNF=$P($G(@DD@(PXQFILE,PXQFIELD,0)),"^",1)_PXQMOV_" = "_$G(^TMP("PXQDATA",$J,PXQFILE,PXQIENS,PXQFIELD,"E"))
 ...W $$RE^PXQUTL(""_"?"_PXQLIEN_","_""""_PXQNF_"""")
 W $$RE^PXQUTL("______________________________________________________________")
 Q
 ;
ADD ;--GET FIELD VALUES FOR FILE
 I $D(^TMP("PXQADDITIONAL",$J,FILE)) D
 .S PXQNFLD=0 F  S PXQNFLD=$O(^TMP("PXQADDITIONAL",$J,FILE,PXQNFLD)) Q:PXQNFLD=""  D
 ..I $G(PXQIENS) D GETS^DIQ(FILE,PXQIENS,PXQNFLD,"E","^TMP(""PXQDATA"",$J,")
 Q
 ;
ADD1 ;--GET FIELD VALUES FOR UPFILE
 I $D(^TMP("PXQADDITIONAL",$J,UPFILE)) D
 .S PXQNFLD=0 F  S PXQNFLD=$O(^TMP("PXQADDITIONAL",$J,UPFILE,PXQNFLD)) Q:PXQNFLD=""  D
 ..I $G(PXQIENS) D GETS^DIQ(UPFILE,PXQIENS,PXQNFLD,"E","^TMP(""PXQDATA"",$J,")
 Q
 ;
ADD2 ;--ADDITIONAL FIELDS IN A FILE TO BE DIAPLAYED
 ;--LOCATE DUZ ENTRY
 ;  VARIABLES:
 ;  PXQUSER =   Entry in file #812 representing the DUZ
 ;  PXQFLE  =   File Number
 ;  PXQFLEIE=   File Number IEN in file #812
 ;  PXQFLD  =   The Field in the above file
 ;
 N PXQUSER,PXQFLE,PXQFLEIE,PXQFLD
 S PXQUSER=$O(^PXD(812,"B",DUZ,0)) I PXQUSER="" Q
 ;--LOCATE FILE NUMBERS
 S PXQFLE=0 F  S PXQFLE=$O(^PXD(812,PXQUSER,"FILE","B",PXQFLE)) Q:PXQFLE=""  D
 .S PXQFLEIE=0 F  S PXQFLEIE=$O(^PXD(812,PXQUSER,"FILE","B",PXQFLE,PXQFLEIE)) Q:PXQFLEIE=""  D
 ..S PXQFLD=0 F  S PXQFLD=$O(^PXD(812,PXQUSER,"FILE",PXQFLEIE,"FIELD","B",PXQFLD)) Q:PXQFLD=""  D
 ...S ^TMP("PXQADDITIONAL",$J,PXQFLE,PXQFLD)=""
 ;
MUST ;--MUST ADDITIONAL ENTRIES TO MAKE SENSE
 S ^TMP("PXQADDITIONAL",$J,9000010.18,.16)="" ;-QUANTITY -V CPT
 S ^TMP("PXQADDITIONAL",$J,409.51,21)="" ;-CPT CODES - SCHEDULING VISITS
 S ^TMP("PXQADDITIONAL",$J,409.51,22)="" ;   "             "
 S ^TMP("PXQADDITIONAL",$J,409.51,23)="" ;   "             "
 S ^TMP("PXQADDITIONAL",$J,409.51,24)="" ;   "             "
 S ^TMP("PXQADDITIONAL",$J,409.51,25)="" ;   "             "
 S ^TMP("PXQADDITIONAL",$J,409.68,.04)="" ;-LOCATION - ENCOUNTER
 S ^TMP("PXQADDITIONAL",$J,409.68,.08)="" ;-ORIGINATING - ENCOUNTER
 S ^TMP("PXQADDITIONAL",$J,9000010,.22)="" ;-VISIT - LOCATION
 S ^TMP("PXQADDITIONAL",$J,9000010,.05)="" ;-VISIT - PATIENT
 S ^TMP("PXQADDITIONAL",$J,70.02,3)="" ;-REGISTERED EXAMS - DIVISION
 S ^TMP("PXQADDITIONAL",$J,70.02,4)="" ;-REGISTERED EXAMS - LOCATION
 S ^TMP("PXQADDITIONAL",$J,70.02,5)="" ;-REGISTERED EXAMS - EXAM SET
 S ^TMP("PXQADDITIONAL",$J,70.03,2)="" ;-EXAMINATIONS - PROCEDURE
 S ^TMP("PXQADDITIONAL",$J,70.03,3)="" ;-EXAMINATIONS - EXAM STATUS
 S ^TMP("PXQADDITIONAL",$J,70.03,4)="" ;-EXAMINATIONS - CATEGORY
 S ^TMP("PXQADDITIONAL",$J,70.03,23)="" ;-EXAMINATIONS - CLINIC STOP REC
 S ^TMP("PXQADDITIONAL",$J,70.03,26)="" ;-EXAMINATIONS - CREDIT METHOD
 ;
 ;S ^TMP("PXQADDITIONAL",$J,8925,.02)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,.03)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,.04)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,.05)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,.07)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,.1)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1201)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1202)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1204)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1205)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1301)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1302)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1404)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1502)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1503)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1504)="" ;-TIU FIELDS
 ;S ^TMP("PXQADDITIONAL",$J,8925,1505)="" ;-TIU FIELDS
 Q
