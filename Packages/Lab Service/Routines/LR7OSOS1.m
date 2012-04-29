LR7OSOS1 ;slc/dcm - Lab order status for OE/RR ;8/11/97
 ;;5.2;LAB SERVICE;**229**;Sep 27, 1994
EN(OMEGA,ALPHA) ;
 N LRODT,LRSN,LREND
 S LRODT=$S($G(ALPHA):ALPHA,1:""),LREND=0
 F  S LRODT=$O(^LRO(69,"D",LRDFN,LRODT),-1) Q:LRODT<1!(LRODT<OMEGA)  D ENTRY Q:LREND
 Q
ENTRY D HED
 S LRSN=0
 F  S LRSN=$O(^LRO(69,"D",LRDFN,LRODT,LRSN)) Q:LRSN<1  D ORDER,HED:$Y>(GIOSL-3) Q:LREND
 Q
ORDER ;call with LRODT,LRSN
 N LROD0,LROD1,LROD3,X,LRDOC,X4,I,LRACN,LRACN0
 K D,LRTT
 Q:'$D(^LRO(69,LRODT,1,LRSN,0))
 S LROD0=^LRO(69,LRODT,1,LRSN,0),LROD1=$S($D(^(1)):^(1),1:""),LROD3=$S($D(^(3)):^(3),1:"")
 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(2,CCNT,"Lab Order # "_$S($D(^LRO(69,LRODT,1,LRSN,.1)):^(.1),1:""))
 S X=$P(LROD0,U,6)
 D DOC^LRX
 S ^(0)=^TMP("ORDATA",$J,1,GCNT,0)_$$S^LR7OS(45,CCNT,"Provider: "_$E(LRDOC,1,25))
 S X=$P(LROD0,U,3),X=$S(X:$S($D(^LAB(62,+X,0)):$P(^(0),U),1:""),1:""),X4=""
 I $D(^LRO(69,LRODT,1,LRSN,4,1,0)),+^(0) S X4=+^(0),X4=$S($D(^LAB(61,X4,0)):$P(^(0),U),1:"")
 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(2,CCNT,X_"  ")
 I X'[X4 S ^(0)=^TMP("ORDATA",$J,1,GCNT,0)_$$S^LR7OS(CCNT,CCNT,X4)
 S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,6,I)) Q:I<1  D LN S X=^(I,0),^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(5,CCNT,": "_X)
 S LRACN=0 F  S LRACN=$O(^LRO(69,LRODT,1,LRSN,2,LRACN)) Q:LRACN<1  I $D(^(LRACN,0))#2 S LRACN0=^(0) D TEST
 Q
TEST ;
 N LRY,LRURG,LRROD,Y,LRLL,LROT,LROS,LROOS,LROSD,LRURG,X3,X,X1,X2,LRACD,LRACC,LRTSTS
 S LRROD=$P(LRACN0,U,6),(Y,LRLL,LROT,LROS,LROSD,LRURG)="",X3=0
 I $P(LRACN0,"^",11) G CANC
 S X=$P(LROD0,U,4),LROT=$S(X="WC":"Requested (WARD COL)",X="SP":"Requested (SEND PATIENT)",X="LC":"Requested (LAB COL)",X="I":"Requested (IMM LAB COL)",1:"undetermined")
 S X=$P(LROD1,U,4),(LROOS,LROS)=$S(X="C":"Collected",X="U":"Uncollected, cancelled",1:"On Collection List")
 S:X="C" LROT=""
 I '(+LRACN0) D LINE,LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(1,CCNT,"BAD ORDER "_LRSN) D LINE Q
 G NOTACC:LROD1=""
TST1 S X1=+$P(LRACN0,U,4),X2=+$P(LRACN0,U,3),X3=+$P(LRACN0,U,5)
 G NOTACC:'$D(^LRO(68,X1,1,X2,1,X3,0)),NOTACC:'$D(^(3)) S LRACD=$S($D(^(9)):^(9),1:"")
 I '$D(LRTT(X1,X2,X3)) S LRTT(X1,X2,X3)="",I=0 F  S I=$O(^LRO(68,X1,1,X2,1,X3,4,I)) Q:I<.5  S LRACC=^(I,0),LRTSTS=+LRACC D TST2
 I $L($P(LROD1,U,6)) D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(20,CCNT,$P(LROD1,U,6))
 Q
TST2 ;
 N I,LRURG,LROT,LROS,LRLL,Y,LROSD
 S LRURG=+$P(LRACC,U,2)
 I LRURG>49 Q
 I 'LRTSTS D LINE,LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(1,CCNT,"BAD ACCESSION TEST POINTER: "_LRTSTS) Q
 S LROT="",LROS=LROOS,LRLL=$P(LRACC,U,3),Y=$P(LRACC,U,5)
 I Y S LROS="Test Complete" D DATE S LROSD=Y D WRITE,COM(1) Q
 S Y=$P(LROD3,U)
 D DATE
 S LROSD=Y
 I LRLL S LROS="Testing In Progress"
 I $P(LROD1,"^",4)="U" S (LROS,LROOS)=""
 D WRITE,COM(1)
 Q
WRITE ;
 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(2,CCNT,$S($D(^LAB(60,+LRTSTS,0)):$P(^(0),U),1:"BAD TEST POINTER"))
 I CCNT>20 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=""
 S ^TMP("ORDATA",$J,1,GCNT,0)=^TMP("ORDATA",$J,1,GCNT,0)_$$S^LR7OS(20,CCNT,$S($D(^LAB(62.05,+LRURG,0)):$P(^(0),U),1:"")_" ")
 I CCNT>28 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=""
 S ^(0)=^TMP("ORDATA",$J,1,GCNT,0)_$$S^LR7OS(28,CCNT,LROT_" "_LROS)_$$S^LR7OS(48,CCNT,LROSD)
 I X3 S ^TMP("ORDATA",$J,1,GCNT,0)=^TMP("ORDATA",$J,1,GCNT,0)_$$S^LR7OS(62,CCNT,"  "_$S($D(^LRO(68,X1,1,X2,1,X3,.2)):^(.2),1:""))
 I LRROD D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(46,CCNT,"  See order: "_LRROD)
 Q
COM(COMNODE) ;Write comment
 ;COMNODE=Comment node to write
 S:'$G(COMNODE) COMNODE=1
 I LRTSTS=+LRACN0 S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,2,LRACN,COMNODE,I)) Q:I<1  D LN S X=^(I,0),^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(3,CCNT,": "_X)
 Q
NOTACC I LROD3="" S LROS="" G NO2
 I $P(LROD3,U,2)'="" S LROS=" ",Y=$P(LROD3,U,2) G NO2
 S Y=$P(LROD3,U) S LROS=" "
NO2 ;
 S:'Y Y=$P(LROD0,U,8)
 S Y=$S(Y:Y,+LROD3:+LROD3,+LROD1:+LROD1,1:LRODT)
 D DATE
 S LROSD=Y,LRTSTS=+LRACN0,LRURG=$P(LRACN0,U,2),LROS=$S(LRROD:"Combined",1:LROS)
 S:LROS="" LROS="for: "
 D WRITE:LRTSTS,COM(1)
 I $L($P(LROD1,U,6)) D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(20,CCNT,$P(LROD1,U,6))
 Q
DATE S Y=$$FMTE^XLFDT($P(Y,"."),"5Z")_$S(Y#1:" "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"") Q
HED ;
 I $O(^LRO(69,"D",LRDFN,LRODT,0)) D LINE,LN S Y=LRODT D DD^LRX S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(1,CCNT,"Orders for date: "_Y)
 D LN S ^TMP("ORDATA",$J,1,GCNT,0)=$$S^LR7OS(1,CCNT,"  Test")_$$S^LR7OS(20,CCNT,"Urgency")_$$S^LR7OS(30,CCNT,"Status")_$$S^LR7OS(64,CCNT,"Accession")
 Q
CANC ;For Canceled tests
 N LRTSTS
 S LRTSTS=+LRACN0,LROT="Canceled by: "_$P(^VA(200,$P(LRACN0,"^",11),0),"^")
 D WRITE:LRTSTS,COM(1.1),COM(1) ;second call for backward compatibility - can be removed in future years (1/98)
 Q
TST ;Test call
 D EN1(.Y,"38;DPT(",2981101,$$NOW^XLFDT)
 Q
EN1(Y,ORVP,START,END,DTRANGE) ;Broker compatible entry point
 S Y=$NA(^TMP("ORDATA",$J,1))
 Q:'$G(ORVP)
 I $L($G(DTRANGE)),'$G(START) S START=$$FMADD^XLFDT(DT,-DTRANGE),END=$$NOW^XLFDT
 S:'$G(START) START=0
 S:'$G(END) END=$$NOW^XLFDT
 N GIOSL,GIOM,GCNT,CCNT,DFN,LRDFN,LRDPF,LRDT0,VA200
 S GIOSL=9999999,GIOM=80,GCNT=0,CCNT=1
 K ^TMP("ORDATA",$J)
 S DFN=+ORVP,LRDPF=+$P(@("^"_$P(ORVP,";",2)_"0)"),"^",2)_"^"_$P(ORVP,";",2),LRDFN=$$LRDFN^LR7OR1(DFN)
 I 'LRDFN S Y=$NA(^TMP("ORDATA",$J,1)) Q
 D EN(START,END)
 S Y=$NA(^TMP("ORDATA",$J,1))
 Q
LN ;Increment counts
 S GCNT=GCNT+1,CCNT=1
 Q
OUT ;Show output
 Q:'$D(^TMP("ORDATA",$J))
 N I
 S I=0
 F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:'I  W !,^(I,0)
 Q
LINE ;Fill in the global with blank lines
 N X
 D LN S X="",$P(X," ",GIOM)="",^TMP("ORDATA",$J,1,GCNT,0)=X
 Q
