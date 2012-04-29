PSOHLNE1        ;BIR/RTR-Parsing out segments from OERR ;01/20/95
        ;;7.0;OUTPATIENT PHARMACY;**1,9,46,71,98,111,117,131,157,181,143,235,239,225**;DEC 1997;Build 29
        ;External reference to EN^ORERR supported by DBIA 2187
        ;External reference to PS(50.607 supported by DBIA 2221
        ;External reference to OR(100 supported by DBIA 2219
        ;External reference to PSDRUG( supported by DBIA 221
        ;External reference VADPT supported by DBIA 10061
        ;
EN      ;ORC segment
        N Q1,Q2,Q3,Q4,Q5,Q6,Q7,PSOPOSSD
        K PSOLQ1I,PSOLQ1II,PSOLQ1IX
        I '$O(MSG(ZZ,0)) D
        .S PSOOC="NW",PLACER=+$P(PSOSEG,"|",2),PLACERXX=+$P($P(PSOSEG,"|",2),";",2),ENTERED=$P(PSOSEG,"|",10),PROV=$P(PSOSEG,"|",12)
        .S X=$P(PSOSEG,"|",15) S EFFECT=$$HL7TFM^XLFDT(X) K X
        .D NOW^%DTC S PSOLOG=% K %
        .;S RSN=$P(PSOSEG,"|",16)
        .S ORCSEG=$P(PSOSEG,"|",7),QCOUNT=1 Q:$G(ORCSEG)'["~"
        .F JJ=1:1:$L(ORCSEG) S:$E(ORCSEG,JJ)="~" QCOUNT=QCOUNT+1
        I '$O(MSG(ZZ,0)) D  Q
        .F JJJ=1:1:QCOUNT S QQQ=$P(ORCSEG,"~",JJJ) D:QQQ'=""
        ..S PSOPOSSD=$S($P($P(QQQ,"^"),"&"):1,1:0) ;PSOPOSSD=1 if possible dose
        ..S Q1I(JJJ)=$S(PSOPOSSD:$P(QQQ,"^"),1:$P(QQQ,"^",8)),PSOLQ1IX(JJJ)=$P($P(QQQ,"^"),"&",5) S PSOLQ1I(JJJ)=$P(QQQ,"^",8),PSOLQ1II(JJJ)=PSOPOSSD ;ORC piece 1 if Possible Dosage, ORC piece 8 if Local Possible Dosage
        ..S Q1(JJJ)=$P(QQQ,"^",2) ;schedule
        ..S Q2(JJJ)=$P(QQQ,"^",3) ;duration
        ..S Q3(JJJ)=$P(QQQ,"^",4) I Q3(JJJ) S X=Q3(JJJ) S Q3(JJJ)=$$HL7TFM^XLFDT(X) K X ;start date
        ..S Q4(JJJ)=$P(QQQ,"^",5) ;end date
        ..S:$G(PRIOR)="" PRIOR=$P(QQQ,"^",6)
        ..S Q6(JJJ)=$P(QQQ,"^",9) ;conjunction
        ..S Q7(JJJ)=$P(QQQ,"^",10) ;sequencing
        ..S QTARRAY(JJJ)=Q1(JJJ)_"^"_Q2(JJJ)_"^"_Q3(JJJ)_"^"_Q4(JJJ)_"^^"_Q6(JJJ)_"^"_Q7(JJJ)
        ..S QTARRAY2(JJJ)=$S(PSOPOSSD:$P(Q1I(JJJ),"&"),1:Q1I(JJJ))_"^"_$S(PSOPOSSD:$P(Q1I(JJJ),"&",3),1:"")
        ..I PSOPOSSD S $P(QTARRAY(JJJ),"^",5)=$P(Q1I(JJJ),"&",4)
        ..I PSOPOSSD S PSOUNN=$P(Q1I(JJJ),"&",2) I PSOUNN'="" S PSOUNN=$O(^PS(50.607,"B",PSOUNN,0)) S $P(QTARRAY(JJJ),"^",9)=$G(PSOUNN)
        ..K PSOUNN
        ;For multiple ORC subscripts
        S (POVAR,POVAR1)="",(NNCK,NNN,NNNN)=0,PSOIII=1,MSG(ZZ,0)=$E(MSG(ZZ),5,$L(MSG(ZZ)))
        S AAA="" F  S AAA=$O(MSG(ZZ,AAA)) Q:AAA=""  S NNN=0 F OOO=1:1:$L(MSG(ZZ,AAA)) S NNN=NNN+1 D  D:$G(POVAR1)="~"&(NNNN=6) PARSE D:$G(POVAR1)="|" PARSE
        .I $E(MSG(ZZ,AAA),OOO)="|" S NNNN=NNNN+1
        .S POVAR1=$E(MSG(ZZ,AAA),OOO)
        .S POLIM=POVAR
        .S POVAR=$S(POVAR="":POVAR1,1:POVAR_POVAR1)
        .;I NNNN=6 I $G(POVAR1)="~"!($G(POVAR1)="|")
END     ;16 OF ORC?
        ;I $G(POVAR)'="" I NNNN=14!(NNNN=15) S EFFECT=$G(POVAR)
        S QCOUNT=0 F JJJ=0:0 S JJJ=$O(QTVAR(JJJ)) Q:'JJJ  I $L($G(QTVAR(JJJ))) S QCOUNT=QCOUNT+1 D
        .S PSOPOSSD=$S($P($P(QTVAR(JJJ),"^"),"&"):1,1:0) ;PSOPOSSD =1 if possible dose
        .S Q1I(JJJ)=$S(PSOPOSSD:$P(QTVAR(JJJ),"^"),1:$P(QTVAR(JJJ),"^",8)),PSOLQ1IX(JJJ)=$P($P(QTVAR(JJJ),"^"),"&",5) S PSOLQ1I(JJJ)=$P(QTVAR(JJJ),"^",8),PSOLQ1II(JJJ)=PSOPOSSD ;piece 1 if possible dose, piece 8 if not
        .S Q1(JJJ)=$P(QTVAR(JJJ),"^",2)
        .S Q2(JJJ)=$P(QTVAR(JJJ),"^",3)
        .;S Q2(JJJ)=$S($E($P(QTVAR(JJJ),"^",3)):"D"_$P(QTVAR(JJJ),"^",3),$E($P(QTVAR(JJJ),"^",3))=0:"D"_$P(QTVAR(JJJ),"^",3),1:$P(QTVAR(JJJ),"^",3))
        .S Q3(JJJ)=$P(QTVAR(JJJ),"^",4) I Q3(JJJ) S X=Q3(JJJ) S Q3(JJJ)=$$HL7TFM^XLFDT(X) K X
        .S Q4(JJJ)=$P(QTVAR(JJJ),"^",5)
        .S:$G(PRIOR)="" PRIOR=$P(QTVAR(JJJ),"^",6)
        .S Q6(JJJ)=$P(QTVAR(JJJ),"^",9)
        .S Q7(JJJ)=$P(QTVAR(JJJ),"^",10)
        .S QTARRAY(JJJ)=Q1(JJJ)_"^"_Q2(JJJ)_"^"_Q3(JJJ)_"^"_Q4(JJJ)_"^^"_Q6(JJJ)_"^"_Q7(JJJ)
        .S QTARRAY2(JJJ)=$S(PSOPOSSD:$P(Q1I(JJJ),"&"),1:Q1I(JJJ))_"^"_$S(PSOPOSSD:$P(Q1I(JJJ),"&",3),1:"")
        .I PSOPOSSD S $P(QTARRAY(JJJ),"^",5)=$P(Q1I(JJJ),"&",4)
        .I PSOPOSSD S PSOUNN=$P(Q1I(JJJ),"&",2) I PSOUNN'="" S PSOUNN=$O(^PS(50.607,"B",PSOUNN,0)) S $P(QTARRAY(JJJ),"^",9)=$G(PSOUNN)
        .K PSOUNN
        I $G(EFFECT) S X=EFFECT S EFFECT=$$HL7TFM^XLFDT(X) K X
        D NOW^%DTC S PSOLOG=% S:'$G(EFFECT) EFFECT=% K %
        K MSG(ZZ,0)
        Q
PARSE   I NNNN=1 S PSOOC="NW" G SET
        I NNNN=2 S PLACER=+$G(POLIM),PLACERXX=+$P($G(POLIM),";",2) G SET
        I NNNN=3!(NNNN=4)!(NNNN=5) G SET
        I NNNN=6,$G(POVAR1)="~" S NNCK=NNCK+1,QTVAR(NNCK)=$G(POLIM) G SET
        I NNNN=7 S NNCK=NNCK+1 S QTVAR(NNCK)=$G(POLIM) G SET
        I NNNN=8!(NNNN=9) G SET
        I NNNN=10 S ENTERED=$G(POLIM) G SET
        I NNNN=11 G SET
        I NNNN=12 S PROV=$G(POLIM) G SET
        I NNNN=13!(NNNN=14) G SET
        I NNNN=15 S EFFECT=$G(POLIM)
SET     S (POVAR,POLIM)="" Q
        ;
EXP     ;
        ;Q:'$G(OR("PLACE"))
        Q:'$G(PSOFILNM)
        S PSOMSORR=1
        N PSOSSMES S PSOSSMES="CPRSUP"
        I $G(PSOFILNM),$G(PSOFILNM)["S" S LL=+$G(PSOFILNM) I $D(^PS(52.41,LL,0)),$P($G(^(0)),"^",3)'="RF" G EXPEN
        S LL=$G(PSOFILNM) I 'LL!('$D(^PSRX(+$G(LL),0))) S COMM="Order was not located by Pharmacy" D EN^ORERR(COMM,.MSG) D  G EXPQ
        .F EER=0:0 S EER=$O(MSG(EER)) Q:'EER  S:$P(MSG(EER),"|")="PV1" PSERRPV1=MSG(EER) S:$P(MSG(EER),"|")="PID" PSERRPID=MSG(EER) S:$P(MSG(EER),"|")="ORC"&($G(PSERRORC)="") PSERRORC=MSG(EER)
        .N MSG,PSOHINST D INIT^PSOHLSN S MSG(2)=$G(PSERRPID),MSG(3)=$G(PSERRPV1),MSG(4)="ORC|DE|"_$G(OR("PLACE"))_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"_"|"_$S($P($G(PSERRORC),"|",4)'="":$P(PSERRORC,"|",4),1:"") S:$G(COMM)'="" MSG(5)="NTE|16||"_COMM
        .D SEND^PSOHLSN
        Q:'$D(^PSRX(LL,0))
        I +$P($G(^PSRX(LL,2)),"^",6)<DT D
        .;Reset PSOSSMES if status changes, so HDR gets updated in PSOHLSN1
        .I +$P($G(^PSRX(LL,"STA")),"^")<12!($P($G(^("STA")),"^")=16) S $P(^PSRX(LL,"STA"),"^")=11 D ECAN^PSOUTL(LL) S PSOSSMES="CPRSVDEF"
        S GG=+$P($G(^PSRX(LL,"STA")),"^")
        ;S AA=$S(GG=3:"OH",GG=12:"OD",GG=13:"OC",GG=14:"OD",GG=15:"OD",GG=16:"OH",1:"SC"),AAA=$S(GG=0:"CM",GG=1:"IP",GG=4:"IP",GG=5:"ZS",GG=11:"ZE",1:"")
        S AA="SC",AAA=$S(GG=0:"CM",GG=2:"CM",GG=1:"IP",GG=4:"IP",GG=5:"ZS",GG=3:"HD",GG=16:"HD",GG=11:"ZE",1:"DC")
        D EN^PSOHLSN1(LL,AA,AAA,"")
        K PSOSSMES
EXPQ    K LL,GG,AA,AAA,PSOMSORR Q
EXPEN   ;SS on Pending orders
        S AA=$P($G(^PS(52.41,LL,0)),"^",3)
        S AAA=$S(AA="DC"!(AA="DE"):"DC",AA="HD":"HD",1:"IP")
        D EN^PSOHLSN(OR("PLACE"),"SC",AAA)
        G EXPQ
        ;
OID     ;Check for 1 to 1 match from Dispense Drug to Orderable Item
        N PSOCDD,PSOCDDI,PSOCDDIZ
        Q:'$G(PSORDITE)
        K PSOCDDIZ
        S (PSOCDD,PSOCDDI)=0
        F  S PSOCDD=$O(^PSDRUG("ASP",PSORDITE,PSOCDD)) Q:'PSOCDD  I $S('$P($G(^PSDRUG(PSOCDD,"I")),"^"):1,DT'>$P($G(^("I")),"^"):1,1:0),$P($G(^PSDRUG(PSOCDD,2)),"^",3)["O" S PSOCDDI=PSOCDDI+1,PSOCDDIZ=PSOCDD
        I PSOCDDI'=1 Q
        S PSOQWX=$G(PSOCDDIZ)
        Q
CP      ;ZSC segment (replaced by ZCL segment)
        S SERV=$S($P(PSOSEG,"|")=1:"SC",$P(PSOSEG,"|")=0:"NSC",1:$P(PSOSEG,"|"))
        S PSOIBY=$P(PSOSEG,"|",2)_"^"_$P(PSOSEG,"|",3)_"^"_$P(PSOSEG,"|",4)_"^"_$P(PSOSEG,"|",5)_"^"_$P(PSOSEG,"|",6)_"^"_$P(PSOSEG,"|",7)_"^"_$P(PSOSEG,"|",8)
        Q
        ;
ZCL     ;ZCL segment - SC/EI related to ICDs
        N SEQ,SEQ2,SEQ3 S SEQ3=$P(PSOSEG,"|",2),SEQ2=$P(PSOSEG,"|",1)
        S:'$D(PSOICD(SEQ2)) PSOICD(SEQ2)=""
        S $P(PSOICD(SEQ2),"^",(SEQ3+1))=$P(PSOSEG,"|",3)  ;set sc/ei for ICD node
        D SCP^PSORN52D K PSOSCA
        S:'$D(PSOIBY) PSOIBY=""
        I PSOSCP<50 D  ;set IBQ node variables if <50% SC
        . Q:$P(PSOIBY,U,$S(SEQ3=1:2,SEQ3=2:3,SEQ3=4:4,SEQ3=5:1,SEQ3=6:5,SEQ3=7:6,SEQ3=8:7,1:""))>0
        . S:SEQ3=1 $P(PSOIBY,U,2)=$P(PSOSEG,"|",3) ;AO
        . S:SEQ3=2 $P(PSOIBY,U,3)=$P(PSOSEG,"|",3) ;IR
        . S:SEQ3=3 SERV=$S($P(PSOSEG,"|",3)=1:"SC",$P(PSOSEG,"|",3)=0:"NSC",1:$P(PSOSEG,"|",3))           ;SC
        . S:SEQ3=4 $P(PSOIBY,U,4)=$P(PSOSEG,"|",3) ;EC
        . S:SEQ3=5 $P(PSOIBY,U,1)=$P(PSOSEG,"|",3) ;MST
        . S:SEQ3=6 $P(PSOIBY,U,5)=$P(PSOSEG,"|",3) ;HNC
        . S:SEQ3=7 $P(PSOIBY,U,6)=$P(PSOSEG,"|",3) ;CV
        . S:SEQ3=8 $P(PSOIBY,U,7)=$P(PSOSEG,"|",3) ;SHAD
        Q
MISX    ;Mismatch patient on CPRS New Order
        S RCOMM="Patient mismatch on New Order from CPRS." D EN^ORERR(RCOMM,.MSG) S NWFLAG=1 D RERROR^PSOHLSN D KL^PSOHLSIH
        Q
MISRN   ;Mismatch on CPRS renewal
        N PSOCINV
        I $G(PDFN)'=$P($G(^PSRX(+$G(PREV),0)),"^",2) D  S PSOMO=1 Q
        .S RCOMM="Patient mismatch on CPRS Renewal." D EN^ORERR(RCOMM,.MSG) S PSOXRP=1 D RERROR^PSOHLSN D KL^PSOHLSIH
        S PSOCINV=+$P($G(^OR(100,+$G(PLACER),3)),"^",5)
        I PSOCINV'=$P($G(^PSRX(+$G(PREV),"OR1")),"^",2) D  S PSOMO=1 Q
        .S RCOMM="Order mismatch on CPRS Renewal." D EN^ORERR(RCOMM,.MSG) S PSOCVI=1 D RERROR^PSOHLSN D KL^PSOHLSIH
        Q
ZRX     ;Process ZRX segment
        I $P(PSOSEG,"|",3)="R" S PSOOC="RNW",PSRNFLAG=1
        S PREV=$S(+$P(PSOSEG,"|"):+$P(PSOSEG,"|"),1:"")
        I $P(PSOSEG,"|")["P"!($P(PSOSEG,"|")["S") S PFLAG=1
        S NATURE=$P(PSOSEG,"|",2)
        S PSORSO=$P(PSOSEG,"|",3)
        S ROUTING=$P(PSOSEG,"|",4)
        I ROUTING="" S ROUTING="M"
        I $P(PSOSEG,"|",7) S DSIG=1
        Q
CHCS    ;Replace CHCS number with CPRS number in .01 field
        N PSOHTMP
        I $G(PDFN),PDFN'=+$P($G(^PS(52.41,+$G(PSOCHFFL),0)),"^",2) S COMM="Patient does not match" D EN^ORERR(COMM,.MSG) K PSOPLC,PSOFFL,PSOSND Q
        I '$D(^PS(52.41,+$G(PSOCHFFL),0)) S COMM="Order was not located by Pharmacy" D EN^ORERR(COMM,.MSG) K PSOPLC,PSOFFL,PSOSND Q
        S PSOHTMP=$P($G(^PS(52.41,+$G(PSOCHFFL),0)),"^")
        I PSOHTMP'="" K ^PS(52.41,"B",PSOHTMP,+$G(PSOCHFFL))
        S $P(^PS(52.41,+$G(PSOCHFFL),0),"^")=PSOPLC,^PS(52.41,"B",PSOPLC,+$G(PSOCHFFL))=""
        S $P(^PS(52.41,+$G(PSOCHFFL),"EXT"),"^",2)=1
        Q
CNT     ;
        S TAC=0 F TACA=0:0 S TACA=$O(^PSRX(PREV,"A",TACA)) Q:'TACA  S TAC=TACA
        S PAC=0 F PACA=0:0 S PACA=$O(^PSRX(PREV,1,PACA)) Q:'PACA  S PAC=PACA
        D NOW^%DTC S TAC=TAC+1,^PSRX(PREV,"A",0)="^52.3DA^"_TAC_"^"_TAC,^PSRX(PREV,"A",TAC,0)=%_"^"_"C"_"^"_$S(+$G(PROV):$G(PROV),1:+$G(ENTERED))_"^"_PAC_"^"_"Discontinued due to CPRS edit"
        K TAC,PAC,TACA,PACA
        Q
NTE     ;
        S WPCT=1,WORDP=$S($P(MSG(LL),"|",2):$P(MSG(LL),"|",2),1:$P(MSG(LL),"|",3)) S:$P(MSG(LL),"|",4)'="" WPARRAY(WORDP,WPCT)=$P(MSG(LL),"|",4) S:$P(MSG(LL),"|",4)'="" WPCT=WPCT+1 F LLL=0:0 S LLL=$O(MSG(LL,LLL)) Q:'LLL  D
        .I $G(MSG(LL,LLL))'="" S WPARRAY(WORDP,WPCT)=$G(MSG(LL,LLL)),WPCT=WPCT+1
        Q
