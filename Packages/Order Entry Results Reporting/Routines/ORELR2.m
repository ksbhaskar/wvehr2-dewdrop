ORELR2  ; slc/dcm - Cross check file 100 with file 69 ;2/21/96  13:30 ;
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**20,42,169,323**;Dec 17, 1997;Build 10
A       ;Enter here
        N X,ORENT,ORSTS,ORX1,ORX,ORX3,ORSDT,ORITEM,ORX4,ORX6,ORDAD,ORX1,ORDFN,ORPCL,ORSTS,ORSTRT,ORENT,ORWHO,ORSIB,ORPSTS,LRDFN,LRODT,LRORD,LRSN,LRSTS
        S (ORENT,ORSTS,ORX1)=""
        I '$D(^OR(100,ORIFN,0)) D WRT(ORIFN,"No ^OR(100,ORIFN,0)") K:ORAFIX ^OR(100,ORIFN) Q
        I '$D(^OR(100,ORIFN,3)) D WRT(ORIFN,"No ^OR(100,ORIFN,3)") D:ORAFIX PURG^ORELR3(ORIFN) Q
        S ORX=^OR(100,ORIFN,0),ORX3=$G(^(3)),ORSDT=$P(ORX3,"^",6),ORITEM=$P(ORX3,"^",7),ORX4=$G(^(4)),ORX6=$G(^(6)),ORDAD=$O(^(2,0)),ORX1=$O(^OR(100,ORIFN,1,0)),ORX1=$E($G(^(+ORX1,0)),1,15),ORDFN=$P(ORX,"^",2)
        I '$P(ORX,"^",14) W ORIFN,! D WRT(ORIFN,"No package defined") D:ORAFIX PURG^ORELR3(ORIFN) Q
        Q:$P(ORX,"^",14)'=PKG
        Q:ORDFN'[";DPT("
        S ORPCL=$P(ORX3,"^",4),ORSTS=$P(ORX3,"^",3),ORSTRT=$P(ORX,"^",8),ORENT=$P(ORX,"^",7),ORWHO=$P(ORX,"^",6),ORSIB=$P(ORX3,"^",9)
        D NOW^%DTC
        I ORENT>+($E(%,1,10)-.01) Q
        I ORSTS=99 D WRT(ORIFN,"No Status",1) S NCNT=NCNT+1 Q
        I ORPCL,ORPCL[";ORD(101,",$D(^ORD(101,+ORPCL,0)),$P(^(0),"^")["ORGY " Q
        ;I $P(ORX3,"^",8),DT>$P(ORENT,".") D  ;DJE-VM *323 - it's not appropriate to purge unveiled orders since OR*3*282
        ;. I ORSTS=2,ORAFIX S $P(^OR(100,ORIFN,3),"^",8)="" Q  ;Unveil completed order
        ;. S VCNT=VCNT+1
        ;. D WRT(ORIFN,"Old Veiled order: ORPK="_ORX4)
        ;. D:ORAFIX PURG^ORELR3(ORIFN)
        I ORDAD S ORPSTS=ORSTS D DAD^ORELR3(ORIFN) Q
        I ORSIB D
        . I '$D(^OR(100,ORSIB)) S SIBCNT=SIBCNT+1 D WRT(ORIFN,"Child order with no parent") S:ORAFIX $P(^OR(100,ORIFN,3),"^",9)="" Q
        . I '$D(^OR(100,ORSIB,2,ORIFN)) S SIBPCNT=SIBPCNT+1 D WRT(ORIFN,"Child order with missing parent pointer") I ORAFIX S ^OR(100,ORSIB,2,ORIFN,0)=ORIFN
        I ORSTS=11,ORPENDT,ORSTRT<ORPENDT D DC^ORELR3 Q
        Q:$P(ORX3,"^",3)=11
        Q:$P(ORX3,"^",3)=10
        I $L($P(ORX4,"^",4,99)) Q:$P(ORX3,"^",3)=1  D  Q
        . I 'ORSTS S BSCNT=BSCNT+1 D WRT(ORIFN,"Bad package link, null status:"_ORX4) I '$P(ORX4,"^",4) D:ORAFIX PURG^ORELR3(ORIFN) Q
        . I ORSTS'=1 S UCCNT=UCCNT+1 D WRT(ORIFN,"Unrecognized package link:"_ORX4) D:ORAFIX STATUS^ORCSAVE2(ORIFN,1)
        I '$D(^OR(100,ORIFN,4)) D  Q
        . I ORSTS'=1,ORSTS'=2,'(ORSTS>8&(ORSTS<15)),$P(ORX3,"^",13)'=2 D WRT(ORIFN,"No package node") S UCCNT=UCCNT+1 D:ORAFIX STATUS^ORCSAVE2(ORIFN,1)
        I '$L(^OR(100,ORIFN,4)) D  Q
        . I ORSTS'=1,ORSTS'=2,'(ORSTS>8&(ORSTS<15)) D WRT(ORIFN,"Empty package node") S UCCNT=UCCNT+1 D:ORAFIX STATUS^ORCSAVE2(ORIFN,1)
        I ORX4["^" D  Q
        . I ORSTS=""!(ORSTS=1)!(ORSTS=2)!(ORSTS=14)!(ORSTS=12) Q
        . S UNCNT=UNCNT+1
        . I ORLRO,'$D(^LRO(69,+ORX4,1,$P(ORX4,"^",2),2,$P(ORX4,"^",3))) D WRT(ORIFN,"Didn't get converted, NOT IN 69") D:ORAFIX STATUS^ORCSAVE2(ORIFN,14) Q
        . I '$D(^LRO(69,+ORX4,1,+$P(ORX4,"^",2))) D WRT(ORIFN,"Didn't get converted") D:ORAFIX STATUS^ORCSAVE2(ORIFN,14) Q
        . S UNCNT=UNCNT-1
        I ORX4'[";" D  Q
        . I ORLRO,'$D(^LRO(69,"C",+ORX4)),ORSTS'=14,ORSTS'=1,ORSTS'=2 S NOCNT=NOCNT+1 D WRT(ORIFN,"ORD# not in 69:"_ORX4) D:ORAFIX STATUS^ORCSAVE2(ORIFN,14)
        S LRORD=+ORX4,LRODT=$P(ORX4,";",2),LRSN=$P(ORX4,";",3),LRSTS=""
        I 'LRORD!('LRODT)!('LRSN),ORSTS'=1,ORSTS'=14,ORSTS'=2 D WRT(ORIFN,"Invalid ORPK:"_LRORD_";"_LRODT_";"_LRSN) S IVCNT=IVCNT+1 D:ORAFIX STATUS^ORCSAVE2(ORIFN,14) Q
        I ORLRO,ORSTS'=1,ORSTS'=14,ORSTS'=2,LRODT,LRSN,'$D(^LRO(69,LRODT,1,LRSN,0)) S LCNT=LCNT+1 D WRT(ORIFN,"No entry in 69:"_LRODT_";"_LRSN) D:ORAFIX STATUS^ORCSAVE2(ORIFN,14) Q
        I ORDFN[";DPT(",LRODT,LRSN S LRDFN=+$G(^DPT(+ORDFN,"LR")),X=+$G(^LRO(69,LRODT,1,LRSN,0)) I X,X'=LRDFN S X="Wrong patient! OR:"_LRDFN_" LR:"_X_" ORPK:"_LRODT_";"_LRSN,DCNT=DCNT+1 D WRT(ORIFN,X,1) Q
        I 'ORWHO D WRT(ORIFN,"No 'Entered by'",1) S WICNT=WICNT+1
        I '$P(ORX,"^",4),LRODT,LRSN S PHCNT=PHCNT+1 D
        . S X=$P($G(^LRO(69,LRODT,1,LRSN,0)),"^",6)
        . D WRT(ORIFN,"No Physician in 100"_$S('X:" or 69",1:""),$S(X:"",1:1))
        . I X,ORAFIX S $P(^OR(100,ORIFN,0),"^",4)=X S:'$P(^(3),"^",7) $P(^(3),"^",7)=X
        I $D(^LRO(69,+LRODT,1,+LRSN,1)) S LRSTS=$P(^(1),"^",4)
        S I=0
        I LRSTS="",$D(^LRO(69,+LRODT,1,+LRSN,6)) S J=0 F  S J=$O(^LRO(69,LRODT,1,LRSN,6,J)) Q:J<1  I ^(J,0)["NO DRAW for test" S I=1 Q
        I I,ORSTS'=2,ORSTS'=1,ORSTS'=9 D WRT(ORIFN,"Active canceled order") S ACNT=ACNT+1 D:ORAFIX STATUS^ORCSAVE2(ORIFN,1)
        I ORSTS=9 S ICCNT=ICCNT+1 D WRT(ORIFN,"Incomplete should be Complete") D:ORAFIX STATUS^ORCSAVE2(ORIFN,2)
        I ORSTS'=1,ORSTS'=2,ORSTS'=9,$D(^LRO(69,+LRODT,1,+LRSN,3)),$P(^(3),"^",2) N LRTN S LRTN=0 F  S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,LRTN)) Q:'LRTN  S X=^(LRTN,0) I $P(X,"^",7)=ORIFN,$P(X,"^",3),$P(X,"^",4),$P(X,"^",5) D
        . S X1=$G(^LRO(68,$P(X,"^",4),1,$P(X,"^",3),1,$P(X,"^",5),4,+X,0))
        . I $P(X1,"^",5) D WRT(ORIFN,"Status should be Complete") S STCNT=STCNT+1 D:ORAFIX STATUS^ORCSAVE2(ORIFN,2)
        I ORSTS'=1,ORSTS'=2,ORSTS'=13,ORSTS'=14 N ORI,ORX S ORI=0 F  S ORI=$O(^OR(100,ORIFN,4.5,"ID","ORDERABLE",ORI)) Q:ORI<1  I $D(^OR(100,ORIFN,4.5,ORI,1)) S ORX=^(1) I $D(^ORD(101.43,+ORX,0)) S ORX=+$P(^(0),"^",2) I ORX D
        . I $D(^LRO(69,LRODT,1,LRSN,2,"B",ORX)) S ORX=$O(^(ORX,0)) I '$L($P(^LRO(69,LRODT,1,LRSN,2,ORX,0),"^",7)) D WRT(ORIFN,"Missing pointer to 100") S OCNT=OCNT+1 I ORAFIX S $P(^LRO(69,LRODT,1,LRSN,2,ORX,0),"^",7)=ORIFN
        D DC^ORELR3
        Q
WRT(ORIFN,TEXT,FIX)     ;Disp
        S CNT=CNT+1,TTCNT=TTCNT+1
        Q:$E(IOST,1,2)="P-"
        ;I CNT>100 W !!,"Continue" S %=1 D YN^DICN S CNT=0 I %=2 S END=1
        ;W !,ORIFN_"=>"_ORX1_"<"_$G(ORENT)_">"_$G(ORSTS)_"<"_TEXT_$S($G(FIX):">Not fixed",1:"")
        W "."
        Q
