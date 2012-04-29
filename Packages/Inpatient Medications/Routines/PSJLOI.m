PSJLOI ;BIR/MV-PRINT ACKNOWLEGED PENDING LABELS ;16 DEC 97 / 9:32 AM
 ;;5.0; INPATIENT MEDICATIONS ;**28,54**;16 DEC 97
 ;
 ; Reference to ^PS(55 supported by DBIA #2191.
 ; Reference to ^DPT supported by DBIA #10035.
 ; Reference to ^%DTC supported by DBIA #10000.
 ;
 ;Queue MAR labels for Acknowleged pending orders.
EN(DFN,ON)         ;
 N P,X,Y,PSGTOL,PSGUOW,PSGP,PSGTOO,DA
 S PSGP=DFN
 Q:'$D(^DPT(PSGP,.1))  N PSJACPF,PSJACNWP S PSJACPF=11 D ENCV^PSGSETU S Y=DFN D CHK^PSGP Q:'PSJSYSL
 S DA=+ON
 S ND0=^PS(53.1,DA,0)
 S PSGTOL=2,PSGUOW=DUZ,PSGTOO=2
 S X=$P(PSJSYSW0,U,2) I X="" S X=1
 S Y=$P($G(^PS(53.1,DA,8)),U),Y=$S(Y="A":4,Y="H":5,Y="C":6,1:1)
 I X=1!($P(ND0,U,4)'="U"&(X[Y!(Y=1)))!($P(ND0,U,4)="U"&(X=2)) D
 . D NOW^%DTC S PSGDT=% D ENL^PSGVDS
 S ^PS(53.1,DA,7)=PSGDT_U_"N"
 I $P(PSJSYSL,U,2)]"" S PSGOP=DFN D ^PSGLW
 Q
 ;
EN2(DFN,ON)     ;
 N PSGTOL,PSGUOW,PSGP,PSGTOO,DA
 S PSGP=DFN
 Q:'$D(^DPT(PSGP,.1))  N PSJACPF,PSJACNWP S PSJACPF=11 D ENCV^PSGSETU S Y=DFN D CHK^PSGP Q:'PSJSYSL
 S DA=+ON
 S PSGTOL=2,PSGUOW=DUZ,PSGTOO=1
 I +PSJSYSL>1 S $P(^PS(55,PSGP,5,DA,7),U)=PSGDT S:$P(^(7),U,2)="" $P(^(7),U,2)="N"_$S($P(^PS(55,PSGP,5,DA,0),U,24)="E":"E",1:"") S PSGOP=DFN D ^PSGLW
 Q
