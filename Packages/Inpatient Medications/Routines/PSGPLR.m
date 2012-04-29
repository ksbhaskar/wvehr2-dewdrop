PSGPLR  ;BIR/CML3-PRINTS PICK LIST REPORT ; 6/15/07 1:12pm
        ;;5.0; INPATIENT MEDICATIONS ;**10,50,67,119,129,191**;16 DEC 97;Build 9
        ;
        ; Reference to ^PS(55 is supported by DBIA# 2191.
        ; Reference to ^PS(59.7 is supported by DBIA# 2181.
        ; Reference to ^PSDRUG is supported by DBIA# 2192.
        ; Reference to ^%DTC is supported by DBIA# 10000.
        ; Reference to ^VADPT is supported by DBIA# 10061.
        ;
        N PSGY,OLDWARD,STPDT D NOW^%DTC S PSGDT=+$E(%,1,12),PPLD=$$ENDTC^PSGMI(PSGDT),$P(OLINE,"-",75)="",PSGPLXR=$S($G(PSGPLUPF)=1:"AU",1:"AC")
        S PGN=0,(FACL,LINE)="",$P(LINE,"-",81)="",$P(FACL,"_",31)="",TND=$G(^PS(53.5,PSGPLG,0)),PSD=$P(TND,"^",3),PFD=$P(TND,"^",4),WSF=$P(TND,"^",7),WGPN=$S('$D(^PS(57.5,PSGPLWG,0)):"N/F",$P(^(0),"^")]"":$P(^(0),"^"),1:"N/F")
        S FFF=$S($P(PSGPLWGP,"^",4):2,$P(PSGPLWGP,"^",5):1,1:0),CML=IO'=IO(0)!($E(IOST,1,2)'="C-")
        F X="PSD","PFD" S @X=$$ENDTC^PSGMI(@X)
        U IO
        I '$D(^PS(53.5,$S($D(PSGPLUPF):"AU",1:"AC"),PSGPLG)) S NPLF=0 D HEADER W !!?25,"*** No orders to fill ***" W:(IO'=IO(0)!(IOST'["C-"))&($Y) @IOF G DONE
        ;
BEGIN   ;
        I '$$LOCK^PSGPLUTL(PSGPLG,"PSGPLR") H 60 G BEGIN
        S NPLF=1,TM=0 F  S TM=$O(^PS(53.5,PSGPLXR,PSGPLG,TM)) Q:TM=""!(TM["~")  S (DDRG,PDRG,PN,PST,RM,WDN)="" D HEADER:'FFF,^PSGPLR0 I CML,'FFF D PAGECK W !!?25,"FILLED BY: ",FACL,!!?25,"CHECKED BY: ",FACL
        I CML,FFF D PAGECK W !!?25,"FILLED BY: ",FACL,!!?25,"CHECKED BY: ",FACL W:$Y @IOF
        ;
DONE    ;
        D UNLOCK^PSGPLUTL(PSGPLG,"PSGPLR")
        K AT,ATC,CML,DDRG,DIS,DND,DO,DR,DRN,DRG,FACL,FD,FFF,FQC,LINE,ND,ND0,ND1,ND2,ND6,NEED,NPLF,OLINE,PSGPLDC,PSGPLXR,PSGPLXRX
        K PSJJORD,PSJORDN,PFD,PGN,PN,POP,PPLD,PPN,PRM,PSD,PSGID,PSGOD,PSGP,PST,PW,RM,RTE,SCH,SD,SM,PSSN,TD,TM,TND,WDN,WL,WG,WSF,WGPN,X
        Q
        ;
DD      ;
        N PSJRNW,CNT
        I $D(PSGPLREN("B",$G(PSGP),$G(PSJJORD))),$G(PSGPLUP) D
        .N OSTOP,DRGND S (DDRG,OLDWARD)="" S DRGND=$O(PSGPLREN("B",PSGP,PSJJORD,0)) Q:'DRGND  S OSTOP=PSGPLREN("B",PSGP,PSJJORD,DRGND) Q:'OSTOP
        .N ST,TMPDRG S CNT=0,ST=$P(ND0,"^",7) S TMPDRG=0 S TMPDRG=$O(PSGPLREN("B",PSGP,PSJJORD,TMPDRG)) S TMPDRG=$P(DRG,"^")_"^"_TMPDRG
        .F PSGPLXRX="AU","AC" Q:CNT  F I=0:1 S DDRG=$O(PSGPLREN(53.5,PSGPLXRX,PSGPLG,TM,WDN,RM,PN,PST,TMPDRG,DDRG)) Q:(DDRG="")!(DDRG="NO DISPENSE DRUG")  D
        ..S X=$G(PSGPLREN(53.5,PSGPLG,1,PSGP,1,+DRGND,1,$P(DDRG,"^",2),0)) S DR=+X,DND=$P(X,U,2,4) Q:'X
        ..S DRN=$G(^PS(55,PSGP,5,PSJJORD,1,DR,0)),DR=$$ENDDN^PSGMI($P(DRN,"^")) I DND?7N1"DI" S DND=$E($$ENDTC^PSGMI(+DND),1,8)
        ..S DIS=$P(DND,"^",2),NEED=$S($P(DND,"^")]"":$P(DND,"^"),1:0)
        ..;GMZ;PSJ*5*191;Allow for Multiple Dispensed Drug units needed
        ..S PSJRNW(I)=1_"^"_+NEED
        ..Q
        .K PSGPLREN("B",PSGP,PSJJORD),PSGPLREN(53.5,PSGPLG,1,PSGP,1,+DRGND) W !!
        ;
        S CNT=0
        S (DDRG,OLDWARD)="" N ST S ST=$P(ND0,"^",7) F  S DDRG=$O(^PS(53.5,PSGPLXR,PSGPLG,TM,WDN,RM,PN,PST,DRG,DDRG)) Q:(DDRG="")!(DDRG="NO DISPENSE DRUG")  S X=$G(^PS(53.5,PSGPLG,1,+$P(PN,U,2),1,+$P(DRG,U,2),1,+$P(DDRG,U,2),0)),DR=+X,DND=$P(X,U,2,4) D
        .S DRN=$G(^PS(55,PSGP,5,PSJJORD,1,DR,0)),DR=$$ENDDN^PSGMI($P(DRN,"^")) I DND?7N1"DI" S DND=$E($$ENDTC^PSGMI(+DND),1,8) W !?6,DR,?48,ST,?51,"(DI "_DND_")",?66,"Returns: ____" Q
        .S UD=$P(DRN,"^",2),ATC=$P($G(^PSDRUG(+DRN,8.5)),"^",2)]"" S:ATC ATC=$D(^(212,"AC",PSGPLWG))
        .S DIS=$P(DND,"^",2),NEED=$S($P(DND,"^")]"":$P(DND,"^"),1:0) I ATC S ATCFF=+$P($G(^PS(59.7,1,26)),"^",7),ATC=$S(ATCFF:NEED,UD#1:0,DIS]"":+DIS,1:NEED) I ATC,$S(ATC<1:1,ATC'?1.3N:1,1:ATC#1) S ATC=0
        .I ATC S X=0,X=$O(^PS(59.7,X)) I $P($G(^(X,26)),U,2)=1,PST="OC" S ATC=0
        .S UD=$S('UD:1,UD=.5:"1/2",UD=.25:"1/4",UD<1:"0"_UD,1:UD)
        .I $D(PSJRNW) D
        ..I 'CNT W !?35,"**** RENEWAL ****"
        ..S NEED=NEED-$P(PSJRNW(CNT),"^",2) S:NEED<0 NEED=0 S CNT=CNT+1
        .W !?6,DR,?48,ST W:(ATC)&(NEED>0) ?57,"ATC" W ?61,$J(UD,4),?68,$J(NEED,4),?75,$S(DIS]"":$J(DIS,4),1:"____")
        .S:ST="DISCONTINUED" OLDWARD=1 S ST=""
        I DDRG="NO DISPENSE DRUG" W !?6,PDRG,?48,ST,?57,"OI" S:ST="DISCONTINUED" OLDWARD=1 S ST=""
        N GIVSTR S GIVSTR=$S(DO]"":DO_" ",1:"")_RTE_" "_SCH D
        .N MARX,I,Y,X D TXT^PSGMUTL(GIVSTR,60)
        .F I=1:1:MARX W:I=1 !?10,"Give: ",MARX(1) W:I>1 !?16,MARX(I)
        D:OLDWARD WARDCHK W:AT]"" !,?65-$L(AT),AT W !?7,"Start: ",SD,?37,"Stop: ",FD
        I Y]"" W !?10 F Q=1:1:$L(Y," ") S X=$P(Y," ",Q) W:$X+$L(X)>65 !?10 W X_" "
        K ST
        Q
        ;
EXDD    ;
        W ! S (DDRG,OLDWARD)="" F  S DDRG=$O(^PS(53.5,PSGPLXR,PSGPLG,TM,WDN,RM,PN,PST,DRG,DDRG)) Q:(DDRG="")!(DDRG="NO DISPENSE DRUG")  S DND=^(DDRG) D
        .S DR=$P(DDRG,"^",2),DRN=$G(^PS(55,PSGP,5,PSJJORD,1,DR,0)),ID=$P(DRN,"^",3),DR=$$ENDDN^PSGMI($P(DRN,"^")) W !?6,DR,?48,DIS,?66,"Returns: ____" S:DIS="DISCONTINUED" OLDWARD=1 S DIS=""
        I DDRG="NO DISPENSE DRUG" S ND1=$G(^PS(55,PSGP,5,PSJJORD,.2)),PDRG=$$ENPDN^PSGMI($P(ND1,"^")) W !?6,PDRG,?48,DIS,?66,"Returns: ____" S:DIS="DISCONTINUED" OLDWARD=1 S DIS=""
        W !?10,"Give: ",$S(DO]"":DO_" ",1:""),RTE," ",SCH D:OLDWARD WARDCHK W !?7,"Start: ",SD,?37,"Stop: ",FD
        Q
        ;
FCL     ;
        I PGN,CML,$P(PSGPLWGP,"^",6) W !!?25,"FILLED BY: ",FACL,!!?25,"CHECKED BY: "_FACL
        ;
HEADER  ;
        S PGN=PGN+1 W:$Y @IOF
        W ?1,"(",PSGPLG,")",?$S($D(PSGPLUPF):27,1:32),"PICK LIST REPORT" W:$D(PSGPLUPF) " (UPDATE)" W ?64,PPLD,!,"Ward group: ",WGPN,?73-$L(PGN),"Page: ",PGN,!?18,"For ",PSD," through ",PFD W:NPLF !,"Team: ",$S(TM'["zz":TM,1:"** N/F **")
        W !!,$S($P(TND,"^",6)&'$P(TND,"^",8):"Bed-Room",1:"Room-Bed"),?15,"Patient",?67,"Units",?74,"Units",!?9,"Medication",?48,"ST",?62,"U/D",?66,"Needed",?74,"Disp'd",!,LINE Q
        ;
PAGECK  ;
        S PSGPY=$Y,PSGPY=$Y+4 I PSGPY+4>IOSL W @IOF
        Q
        ;
WARDCHK ;  if patient has discontinued orders from a different ward, print the ward and room/bed that the orders were discontinued from.
        Q:'$G(STPDT)
        S VAINDT=$$MINUTES(STPDT,5)
        S DFN=PSGP D INP^VADPT I PW'=$P(VAIN(4),"^",2) W ?48,$E("(from "_$P(VAIN(4),"^",2)_" "_VAIN(5)_")",1,31)
        S OLDWARD="" Q
        ;
MINUTES(STPDT,LESS)         ; pass in a FM date/time and the number of minutes (9 or less) to subtract from it
        S VAINDT=$S($E(STPDT,9,12)<LESS:($E(STPDT,1,7)-1)_"."_(($E(STPDT,9,12)+2360)-LESS),$E(STPDT,11,12)<5:$E(STPDT,1,8)_$S($E(STPDT,9,10)="10":"09",$E(STPDT,9,10)="20":"19",1:$E(STPDT,9)_($E(STPDT,10)-1))_(60+$E(STPDT,12)-LESS),1:STPDT-(LESS*.0001))
        Q VAINDT
