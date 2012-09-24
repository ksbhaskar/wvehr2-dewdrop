SROATM1 ;BIR/MAM - NON CARDIAC TRANSMISSION ;05/28/10
        ;;3.0; Surgery ;**27,38,47,60,62,81,88,93,95,125,153,160,166,174**;24 Jun 93;Build 8
        ;** NOTICE: This routine is part of an implementation of a nationally
        ;**         controlled procedure. Local modifications to this routine
        ;**         are prohibited.
        ;
        ; Reference to ^DIC(45.3 supported by DBIA #218
        ;
        N SRINTUB,SRDTH,SRPID,SRCDT,SRCREQ F I=0,200,200.1,206 S SRA(I)=$G(^SRF(SRTN,I))
        S DFN=$P(SRA(0),"^") N I D DEM^VADPT S SRANAME=VADM(1),SEX=$P(VADM(5),"^"),Z=$P(VADM(3),"^"),SRSDATE=$E($P(SRA(0),"^",9),1,12),Y=$E(SRSDATE,1,7),AGE=$E(Y,1,3)-$E(Z,1,3)-($E(Y,4,7)<$E(Z,4,7))
        S SRPID=VA("PID"),SRPID=$TR(SRPID,"-","") ; remove hyphens from PID
        S X=$$SITE^SROUTL0(SRTN),SRDIV=$S(X:$P(^SRO(133,X,0),"^"),1:""),SRDIV=$S(SRDIV:$$GET1^DIQ(4,SRDIV,99),1:SRASITE)
        S X=$P($G(^SRF(SRTN,205)),"^",3),SRDTH=$S(X:X,1:$P(VADM(6),"^"))
        S SRCDT=$P($G(^SRF(SRTN,209)),"^",15),SRCREQ=$P($G(^SRF(SRTN,209)),"^",17)
        S SHEMP=">"_$J(SRASITE,3)_$J(SRTN,7)_"  1"_DT_$J(AGE,3)_$J(SEX,1)_$J(SRSDATE,12)_$J(SRPID,20)_$J(SRDIV,6)_$J(SRDTH,12)_$J(SRCDT,7)_$J(SRCREQ,7)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_"  2",SRACNT=SRACNT+1
        S NYUK=$P(SRA(200),"^",2) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",3) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",4) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200.1),"^",2) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",6) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",7) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",8) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",10) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",11) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",12) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200.1),"^",6) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",15) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",16) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",17) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",31) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",32) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",33) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",34) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",35) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",36) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",38) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",39) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",41) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",42) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",43) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",19) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",20) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",21) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",22) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",23) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",24) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",25) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",26) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",27) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",28) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",29) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",45) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",46) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",47) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",48) D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P(SRA(200),"^",49) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200),"^",50) D ONE S SHEMP=SHEMP_MOE,NYUK=$P(SRA(200.1),"^",3),SHEMP=SHEMP_$J(NYUK,2)
        S NYUK=$P(SRA(0),"^",4) S:NYUK NYUK=$E($P(^DIC(45.3,$P(^SRO(137.45,NYUK,0),"^",2),0),"^"),1,3) S SHEMP=SHEMP_$J(NYUK,3)
        S NYUK=$P(SRA(200),"^",52),SHEMP=SHEMP_$J(NYUK,2),X=$P(SRA(0),"^",10),NYUK=$S(X="EM":"Y",1:"N") D ONE S SHEMP=SHEMP_MOE
        S NYUK=$P($G(^SRF(SRTN,"1.0")),"^",8),SHEMP=SHEMP_$J(NYUK,2),NYUK=$P(SRA(200),"^",53) D ONE S SHEMP=SHEMP_MOE
        S SRASA="",Y=$P($G(^SRF(SRTN,1.1)),"^",3) S:Y X=$P($G(^SRO(132.8,Y,0)),"^"),SRASA=X S NYUK=$E(SRASA,1,1) D ONE S SHEMP=SHEMP_MOE
        K SRTECH,SRZ,SRTRAUMA S SRT=0 F  S SRT=$O(^SRF(SRTN,6,SRT)) Q:'SRT  D ^SROPRIN Q:$D(SRZ)
        I $D(SRTECH) S SRTRAUMA=$P(^SRF(SRTN,6,SRT,0),"^",14),SRINTUB=$P($G(^SRF(SRTN,6,SRT,8)),"^",2)
        I '$D(SRTECH) S (SRTECH,SRTRAUMA,SRINTUB)=""
        S SHEMP=SHEMP_$J(SRTECH,1)_$J($E(SRASA,2),1)_$J(SRINTUB,1)_$J($P(SRA(200.1),"^",8),1)
        S NYUK=$P(SRA(206),"^"),SHEMP=SHEMP_$J(NYUK,4),NYUK=$P(SRA(206),"^",2),SHEMP=SHEMP_$J(NYUK,4)
        S ^TMP("SRA",$J,SRAMNUM,SRACNT,0)=SHEMP,SHEMP=$E(SHEMP,1,11)_"  3",SRACNT=SRACNT+1
        D ^SROATM2
        Q
ONE     S MOE=$S(NYUK="NS":"S",NYUK="":" ",1:NYUK)
        Q
