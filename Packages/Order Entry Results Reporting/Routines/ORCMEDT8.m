ORCMEDT8        ;SLC/JM-QO, Generate quick order CRC ;10/18/07
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**245,243**;Dec 17, 1997;Build 242
        Q
        ;
UPDQNAME(ORIEN) ; Rename personal quick order name if needed
        N OLDNAME,NEWNAME,DA,DR,DIE,DIDEL
        I $P($G(^ORD(101.41,ORIEN,0)),U,4)'="Q" Q
        S OLDNAME=$P($G(^ORD(101.41,ORIEN,0)),U,1)
        I $E($P(OLDNAME,U),1,6)'="ORWDQ " Q
        S NEWNAME="ORWDQ "_$$CRC4QCK(ORIEN)
        I OLDNAME'=NEWNAME D
        . S NEWNAME=$$ENSURNEW(NEWNAME)
        . S DA=ORIEN,DR=".01///"_NEWNAME,DIE="^ORD(101.41," D ^DIE
        Q
        ;
ENSURNEW(NAME)  ; Ensures the name is a new entry
        N IDX,BASENAME,ABC,NEWNAME
        S NEWNAME=NAME
        S IDX=0,BASENAME=NEWNAME,ABC=97 ; Find an unused name
        F  S IDX=$O(^ORD(101.41,"B",NEWNAME,0))  Q:'IDX  D
        . S NEWNAME=BASENAME_$C(ABC) ; append letter 'a' - 'z'
        . S ABC=ABC+1 I ABC>122 S BASENAME=BASENAME_"a",ABC=97
        Q NEWNAME
RAWCRC(ORIEN)   ; Get a raw CRC value to determine if a record has changed
        N ORDATA,RESULT,ADDCRLF,LASTLINE,LASTIDX,OLDCRC
        S (RESULT,OLDCRC)=""
        I $P($G(^ORD(101.41,ORIEN,0)),U,4)'="Q" G RWQ
        I $E($P($G(^ORD(101.41,ORIEN,0)),U),1,6)'="ORWDQ " G RWQ
        D LOADRSP^ORWDX(.ORDATA,ORIEN)
        D PARSE
RWQ     Q RESULT
        ;
        ; The following code attemps to duplicate the CRC calculated by the Delphi code
        ; in CPRS for quick orders.  It will not match all the time, since not all the
        ; data neded to make the determination is stored on the M side, but it does it's best.
        ;
CRC4QCK(ORIEN)  ; Get CRC for a personal quick order
        N ORDATA,DISPGRP,DEFDLG,FORMID,RESULT,FORMDATA,ADDCRLF
        N LASTLINE,LASTIDX,OLDCRC,FORMINFO,IDINFO,NEXTFORM
        S RESULT="",FORMID=0
        ; Must be personal quick order
        I $P($G(^ORD(101.41,ORIEN,0)),U,4)'="Q" G EXT
        I $E($P($G(^ORD(101.41,ORIEN,0)),U),1,6)'="ORWDQ " G EXT
        S OLDCRC=$E($P($G(^ORD(101.41,ORIEN,0)),U,1),7,14)
        F  Q:(RESULT=OLDCRC)!(FORMID="")  D
        . K ORDATA D LOADRSP^ORWDX(.ORDATA,ORIEN)
        . ; First pass don't use any form id - get baseline CRC
        . I FORMID=1 D  Q:FORMID=""
        . . S FORMID=""
        . . S DISPGRP=$P($G(^ORD(101.41,ORIEN,0)),U,5) I '+DISPGRP Q  ; Must have a valid display group
        . . S DEFDLG=$P($G(^ORD(100.98,DISPGRP,0)),U,4) I '+DEFDLG Q  ; Display group must have a valid default dialog
        . . D FORMID^ORWDXM(.FORMID,DEFDLG) I '+FORMID S FORMID="" Q  ; Default dialog must have a valid windows form ID
        . . I (FORMID=130)!(FORMID=140) D
        . . . N NEWFORM D CHK94^ORWDPS1(.NEWFORM) I NEWFORM=1 S FORMID=135
        . . D FORMINFO(.FORMINFO,.IDINFO,.NEXTFORM)
        . I FORMID=0 S FORMID=1
        . E  D SORTDATA I FORMDATA="" S FORMID="" Q  ; Updates FORMID
        . D PARSE
EXT     Q RESULT
        ;
PARSE   ; Parse Data
        N DATAIDX,IDX,LINE,CODE,CRCDATA,OUTPUT,DONE,ISMASTER,LASTMSTR,FIRST,P3,LK4SPACE
        S DATAIDX="",(IDX,DONE,ISMASTER,LASTMSTR,LASTIDX)=0,LASTLINE=""
        F  D GETLINE Q:DONE  D  Q:DONE
        . I ISMASTER D
        . . S OUTPUT=+$P(LINE,U,1)_U_+$P(LINE,U,2)_U
        . . S IDX=IDX+1,CRCDATA(IDX)=OUTPUT
        . . S FIRST=1,P3=$P(LINE,U,3)
        . . I P3="COMMENT" S ADDCRLF=1,LK4SPACE=1
        . . E  D
        . . . I P3="STATEMENTS" S ADDCRLF=1,LK4SPACE=0
        . . . E  S ADDCRLF=0,LK4SPACE=0
        . . F  D GETLINE Q:DONE!ISMASTER  D
        . . . I CODE="i" S IDX=IDX+1,CRCDATA(IDX)=LINE
        . . . I CODE="t" D
        . . . . I FIRST S FIRST=0,OUTPUT=LINE
        . . . . E  D
        . . . . . I $L(LASTLINE)=0 S OUTPUT=$C(13)_$C(10)_LINE Q
        . . . . . I LK4SPACE,$L(LASTLINE)>1,$E(LASTLINE,$L(LASTLINE))=" " S OUTPUT=""
        . . . . . E  D
        . . . . . . I ADDCRLF S OUTPUT=$C(13)_$C(10) ; ,$L(LASTLINE)<65
        . . . . . . E  S OUTPUT=" "
        . . . . . S OUTPUT=OUTPUT_LINE
        . . . . S LASTLINE=LINE
        . . . . S IDX=IDX+1,CRCDATA(IDX)=OUTPUT
        . . . . I ADDCRLF S LASTIDX=IDX
        . . I ISMASTER,'DONE S LASTMSTR=1
        S RESULT=$$CRC4ARRY^ORCRC(.CRCDATA)
        ; Same data can generate 2 different CRCs - CRLF on end of comments are stripped
        I OLDCRC'="",RESULT'=OLDCRC,LASTIDX>0 D
        . S CRCDATA(LASTIDX)=CRCDATA(LASTIDX)_$C(13)_$C(10)
        . S RESULT=$$CRC4ARRY^ORCRC(.CRCDATA)
        Q
        ;
SORTDATA        ; Sorts data by fields according to FormID
        N IN,OUT,LINE,DATA,ID,CODE,INDEX,END,IDX,RTN,SUBFORM,SUBFORM2,SUBIDX,NODE
        S SUBFORM="",SUBFORM2=""
        S FORMDATA=$G(FORMINFO(FORMID)) I FORMDATA="" Q
        I $E(FORMDATA,1,2)'="00" S RTN="SUBID"_$E(FORMDATA,1,2) D @RTN S FORMDATA=$G(FORMINFO(FORMID)) I FORMDATA="" Q
        S IN=0,OUT=0,END=1000000,IDX=0
        F  S IN=$O(ORDATA(IN)) Q:'+IN  D
        . S LINE=ORDATA(IN)
        . I $E(LINE)="~" D
        . . S IDX=1,ID=$P(LINE,U,3),CODE="."_IDINFO(ID)_".",NODE=$P(LINE,U,2)
        . . S INDEX=$F(FORMDATA,CODE),SUBIDX=0
        . . I INDEX=0,SUBFORM'="" D
        . . . S INDEX=($F(FORMDATA,".ZZZ."))
        . . . I INDEX>0 S SUBIDX=$F(SUBFORM,CODE) I SUBIDX<1 S INDEX=0
        . . I INDEX=0,SUBFORM2'="" D
        . . . S INDEX=($F(FORMDATA,".XXX."))
        . . . I INDEX>0 S SUBIDX=$F(SUBFORM2,CODE) I SUBIDX<1 S INDEX=0
        . . I INDEX=0 S OUT=END,END=END+1
        . . E  D
        . . . I SUBIDX>0 D  I 1
        . . . . S OUT=(INDEX-4)*250
        . . . . S SUBIDX=(SUBIDX-4)\4
        . . . . S OUT=OUT+SUBIDX+(NODE*20)
        . . . E  S OUT=(INDEX-4)*250
        . I IDX>0 D
        . . S DATA(OUT,IDX)=LINE
        . . S IDX=IDX+1
        K ORDATA
        S (IN,OUT,INDEX)=0
        F  S IN=$O(DATA(IN)) Q:'+IN  D
        . F  S INDEX=$O(DATA(IN,INDEX)) Q:'+INDEX  D
        . . S OUT=OUT+1
        . . S ORDATA(OUT)=DATA(IN,INDEX)
        S FORMID=$G(NEXTFORM(FORMID))
        Q
        ;
GETLINE ;
        I LASTMSTR S LASTMSTR=0 Q
        S DATAIDX=$O(ORDATA(DATAIDX))
        S DONE=(DATAIDX="")
        I 'DONE S CODE=$E(ORDATA(DATAIDX),1),LINE=$E(ORDATA(DATAIDX),2,9999),ISMASTER=(CODE="~")
        Q
        ;
FORMINFO(FORMINFO,IDINFO,NEXTFORM)      ; populates FORMINFO,IDINFO and NEXTFORM arrays
        N IDX,LINE,CODE,RTN,NEXT
        S IDX=1
        F  S LINE=$E($T(FORMTBL+IDX),21,999) Q:$L(LINE)<1  D
        . S CODE=$E(LINE,1,3),NEXT=$E(LINE,5,7),LINE=$E(LINE,9,999)
        . S FORMINFO(CODE)=LINE
        . I NEXT'="   " S NEXTFORM(CODE)=NEXT
        . S IDX=IDX+1
        S IDX=1
        F  S LINE=$E($T(IDTABLE+IDX),4,999) Q:$L(LINE)<1  D
        . S CODE=$E(LINE,1,3),LINE=$E(LINE,5,99)
        . S IDINFO(LINE)=CODE,IDX=IDX+1
        Q
        ;
HASCODE(CODE)   ; scans data for code
        N RESULT,IDX,LINE S IDX="",RESULT=0
        F  S IDX=$O(ORDATA(IDX)) Q:IDX=""  D  Q:IDX=""
        . S LINE=ORDATA(IDX)
        . I $E(LINE)="~" D
        . . S LINE=$P(LINE,U,3)
        . . I LINE=CODE S RESULT=1,IDX=""
        Q RESULT
        ;
SUBID   ; SubID codes are used to change the form ID depending on depending on data
        ; Data below is FormID;SubID.list of ID codes in order of use
        ; SubID's are used to change the FormID depending on data values.
        Q
SUBID01 ; Generic Meds dialog
        N INPT,COMPLEX
        S INPT=$$HASCODE("NOW"),COMPLEX=$$HASCODE("DAYS")
        I INPT D  I 1
        . I COMPLEX S FORMID="INX",SUBFORM=$G(FORMINFO("MDX"))
        . E  S FORMID="INP"
        E  I COMPLEX S FORMID="OPX",SUBFORM=$G(FORMINFO("MDX"))
        Q
SUBID02 ; IV Meds
        S SUBFORM=$G(FORMINFO("IVL"))
        Q
SUBID03 ; Delphi code adds URGENCY prompt that does not exist in dialog on M side
        I '$$HASCODE("URGENCY") D
        . N X
        . S X=$O(ORDATA(999999),-1)+1
        . S ORDATA(X)="~0^1^URGENCY"
        Q
SUBID04 ; Blood Bank will probably be wrong - quick orders not working in v26
        S SUBFORM=$G(FORMINFO("BBK"))
        S SUBFORM2=$G(FORMINFO("BBX"))
        Q
SUBID05 ; Diet
        I FORMID="117" S SUBFORM=$G(FORMINFO("DLN"))
        I FORMID="TBF" S SUBFORM=$G(FORMINFO("TBL"))
        Q
FORMTBL ; Form Table - Forms allowing personal quick orders, as of CPRS GUI v26 (OR*3*215)
        ;;Consult         ;110;CS2;00.ORD.CLS.URG.PLA.MSC.COD.PRV.COM.
        ;;                ;CS2;   ;00.ORD.CLS.URG.PLA.MSC.COD.COM.PRV.
        ;;Procedure       ;112;PR2;00.SER.ORD.CLS.URG.PLA.MSC.COD.PRV.COM.
        ;;                ;PR2;PR3;00.SER.ORD.COM.CLS.URG.PLA.MSC.COD.PRV.
        ;;                ;PR3;   ;00.SER.ORD.CLS.URG.PLA.MSC.COD.COM.PRV.
        ;;Diet            ;117;TBF;05.STT.STP.ZZZ.COM.DEL.CAN.
        ;;                ;TBF;OPM;05.ZZZ.COM.CAN.
        ;;                ;OPM;   ;00.ORD.MEL.STT.STP.SCH.COM.DEL.
        ;;                ;DLN;   ;00.ORD.
        ;;                ;TBL;   ;00.ORD.STR.INS.
        ;;Lab             ;120;   ;00.ORD.SAM.SPE.URG.COM.COL.STT.SCH.DAY.
        ;;Blood Bank      ;125;BB2;04.ZZZ.DTE.COL.URG.COM.STT.MSC.REA.YN0.XXX.LAB.
        ;;                ;BB2;   ;04.ZZZ.URG.COM.COL.DTE.MSC.REA.YN0.STT.XXX.
        ;;                ;BBK;   ;00.ORD.QTY.MDF.SPC.
        ;;                ;BBX;   ;00.RES.
        ;;Inpatient Meds  ;130;   ;00.ORD.DRG.INS.ROU.SCH.URG.COM.SCT.ADM
        ;;Generic Meds    ;135;   ;01.ORD.INS.DRG.DOS.STR.NAM.ROU.SCH.URG.COM.SUP.QTY.REF.SC0.PCK.PI0.SIG.
        ;;                ;INP;   ;00.ORD.INS.DRG.DOS.STR.NAM.ROU.SCH.URG.COM.NOW.SIG.
        ;;                ;OPX;   ;00.ORD.STR.NAM.DRG.ZZZ.URG.COM.SUP.QTY.REF.SC0.PCK.PI0.SIG.
        ;;                ;INX;   ;00.ORD.STR.NAM.DRG.ZZZ.URG.COM.NOW.SIG.
        ;;                ;MDX;   ;00.INS.DOS.ROU.SCH.DAY.CNJ.
        ;;Outpatient Meds ;140;   ;00.ORD.DRG.INS.MSC.ROU.SCH.QTY.REF.PCK.URG.COM.SC0.
        ;;Non-VA Meds     ;145;   ;03.ORD.INS.DRG.DOS.STR.NAM.ROU.SCH.URG.COM.STT.STA.NOW.SIG.
        ;;Radiology       ;160;   ;00.ORD.STT.URG.MOD.CLS.IML.PRG.YN0.PRE.COM.MDF.PRV.CON.RSH.LOC.
        ;;IV Meds         ;180;   ;02.ZZZ.RAT.URG.DAY.COM.SCH.TYP.ADM
        ;;                ;IVL;   ;00.ORD.VOL.ADD.STR.UNT.
        ;;
IDTABLE ; ID table - returns codes used in the form table IDINFO("LONGNAME")=SHORNAME
        ;;ADD;ADDITIVE
        ;;ADM:ADMIN
        ;;CAN;CANCEL
        ;;CLS;CLASS
        ;;COD;CODE
        ;;COL;COLLECT
        ;;COM;COMMENT
        ;;CNJ;CONJ
        ;;CON;CONTRACT
        ;;DTE;DATETIME
        ;;DAY;DAYS
        ;;DEL;DELIVERY
        ;;DOS;DOSE
        ;;DRG;DRUG
        ;;IML;IMLOC
        ;;INS;INSTR
        ;;ISO;ISOLATION
        ;;LAB;LAB
        ;;LOC;LOCATION
        ;;MEL;MEAL
        ;;MSC;MISC
        ;;MOD;MODE
        ;;MDF;MODIFIER
        ;;NAM;NAME
        ;;NOW;NOW
        ;;ORD;ORDERABLE
        ;;PI0;PI
        ;;PCK;PICKUP
        ;;PLA;PLACE
        ;;PRG;PREGNANT
        ;;PRE;PREOP
        ;;PRV;PROVIDER
        ;;QTY;QTY
        ;;RAT;RATE
        ;;REA;REASON
        ;;REF;REFILLS
        ;;RSH:RESEARCH
        ;;RES;RESULTS
        ;;ROU;ROUTE
        ;;SAM;SAMPLE
        ;;SC0;SC
        ;;SCH;SCHEDULE
        ;;SCT:SCHTYPE
        ;;SER;SERVICE
        ;;SIG;SIG
        ;;SPE;SPECIMEN
        ;;SPC;SPECSTS
        ;;STT;START
        ;;STA;STATEMENTS
        ;;STP;STOP
        ;;STR;STRENGTH
        ;;SUP;SUPPLY
        ;;TIM;TIME
        ;;TYP:TYPE
        ;;UNT;UNITS
        ;;URG;URGENCY
        ;;VIS;VISITSTR
        ;;VOL;VOLUME
        ;;XFU;XFUSION
        ;;YN0;YN
        ;;XXX;XXX
        ;;ZZZ;ZZZ
        ;;
