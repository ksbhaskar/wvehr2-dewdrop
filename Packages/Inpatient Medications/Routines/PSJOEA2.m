PSJOEA2 ;BIR/MLM-INPATIENT ORDER ENTRY ; 5/11/09 7:50am
        ;;5.0; INPATIENT MEDICATIONS ;**127,133,200**;16 DEC 97;Build 14
        ;
        ; Reference to ^PS(55 is supported by DBIA #2191.
        ; Reference to ^PSSLOCK is supported by DBIA #2789.
        ;
CHK     ;Check to be sure all the orders in the complex order series are completed, continued.
        I 'PSJCOMV,'$G(COMQUIT) N PSJO S PSJO=0 F  S PSJO=$O(^TMP("PSJCOM",$J,PSJO)) Q:'PSJO  S PSGORD=+PSJO_"P",PSGND=$G(^PS(53.1,+PSJO,0)) D
        .S PSGP=$P(PSGND,"^",15)
        .I $P(PSGND,U,4)="U",$P(PSGND,U,9)="A",($P(PSGND,U,24)'="R") D ^PSGOT D  Q
        ..M ^PS(55,PSGP,5,+PSGORD,4)=^PS(53.1,PSJO,4)
        ..N PSGND2P5 S PSGND2P5=$G(^PS(53.1,+PSJO,2.5)),DUR=$P(PSGND2P5,"^",2) I $G(DUR)]"" N DA,DR,DIE S DIE="^PS(55,"_PSGP_",5,",DA(1)=PSGP,DA=+PSGORD,DR="126////"_$G(DUR) D ^DIE
        ..D ACTLOG^PSJOEA(PSJO,PSGP,PSGORD)
        ..S VND4=$G(^PS(55,PSGP,5,+PSGORD,4))
        ..I PSJSYSL>1 S $P(^PS(55,PSGP,5,+PSGORD,7),U)=PSGDT S:$P(^(7),U,2)="" $P(^(7),U,2)="N"_$S($P(^PS(55,PSGP,5,+PSGORD,0),"^",24)="E":"E",1:"") S PSGTOL=2,PSGUOW=DUZ,PSGTOO=1,DA=+PSGORD D ENL^PSGVDS
        ..S:$P(VND4,"^",15)&'$P(VND4,"^",16) $P(VND4,"^",15)="" S:$P(VND4,"^",18)&'$P(VND4,"^",19) $P(VND4,"^",18)="" S:$P(VND4,"^",22)&'$P(VND4,"^",23) $P(VND4,"^",22)="" S $P(VND4,"^",PSJSYSU,PSJSYSU+1)=DUZ_"^"_PSGDT
        ..; Set PV and NV flag according to PSJSYSU  (PSJ*5*200)
        ..S $P(VND4,"^",+PSJSYSU=1+9)=1 S:'$P(VND4,U,+PSJSYSU=3+9) $P(VND4,U,+PSJSYSU=3+9)=+$P(VND4,U,+PSJSYSU=3+9) S ^PS(55,PSGP,5,+PSGORD,4)=VND4
        ..I '$P(VND4,U,10) S ^PS(55,"ANV",PSGP,+PSGORD)=""
        ..I $P(VND4,U,9) K ^PS(55,"APV",PSGP,+PSGORD)
        ..I $P(VND4,U,10) K ^PS(55,"ANV",PSGP,+PSGORD)
        ..S:+PSJSYSU=3 ^PS(55,"AUE",PSGP,+PSGORD)=""
        ..S PSJCOM=$P($G(^PS(55,PSGP,5,+PSGORD,.2)),"^",8) I PSJCOM]"" K ^PS(53.1,"ACX",PSJCOM,PSJO) ;S $P(^PS(55,PSGP,5,+PSGORD,4),"^",9)=1
        ..D EN1^PSJHL2(PSGP,$S(+PSJSYSU=3:"SC",+PSJSYSU=1:"SC",1:"XX"),+PSGORD_"U")     ; allow status change to be sent for pharmacists & nurses
        ..D:+PSJSYSU=1 EN1^PSJHL2(PSGP,"ZV",+PSGORD_"U") L -^PS(55,PSGP,5,+PSGORD)
        ..S PSJPREX=1 D CMPLX2^PSJCOM1(PSGP,PSJORD,PSGORD) K PSJPREX
        .I $P(PSGND,U,4)'="U",$P(PSGND,U,9)="A" D GT531^PSIVORFA(PSGP,PSJO_"P") D  Q
        ..S ON55="" I $P(PSGND,"^",24)="R" S ON55=$P(PSGND,"^",25) D
        ...N PND0,PSGORDR S PND0=^PS(53.1,+PSJO,0),PSGORDR=$P(PND0,U,25)
        ...Q:'$$LS^PSSLOCK(PSGP,PSGORDR)
        ...N OEORD,OOEORD,FILE55,FILE55N0,PNDP2 S PNDP2=^PS(53.1,+PSJO,.2),FILE55="^PS(55,"_DFN_",""IV"",",FILE55N0=FILE55_+PSGORDR_",0)"
        ...S OEORD=$P(PND0,U,21) I PSGORDR S OOEORD=$P(@FILE55N0,"^",21) I OEORD'=OOEORD D EXPOE^PSGOER(DFN,+PSJO_"P",+$$LASTREN^PSJLMPRI(DFN,+PSJO_"P"))
        ...S PSGORDP=PSJO,DIE="^PS(53.1,",DA=+PSJO,DR="28////A;104////@" W "." D ^DIE
        ...Q:'$G(OEORD)  K DA,DR,DIE S DA(1)=DFN,DA=+PSGORDR,DIE=FILE55,DR=110_"////"_+OEORD
        ...S:$P(PNDP2,U,8) DR=DR_";150////"_$P(PNDP2,U,8) D ^DIE S DIE=FILE55_+PSGORDR_",0)",$P(@DIE,U,21)=OEORD
        ...D EN1^PSJHL2(DFN,"SC",PSGORDR),UNL^PSSLOCK(PSGP,PSGORDR)
        ..I 'ON55 D SETNEW^PSIVORFB
        ..S (P("NEWON"),ON)=ON55,PSGP=$P(PSGND,U,15)
        ..S VND4=$G(^TMP("PSJCOM",$J,+PSJO,4)) D
        ...N PSJRN,PSJRNDT,PSJRPH,PSJRPHD,PSJPVFL,PSJNVFL,DR,DIE,DA
        ...S (PSJPVFL,PSJNVFL)=""
        ...S PSJRN=$P(VND4,U,1),PSJRNDT=$P(VND4,U,2),PSJRPH=$P(VND4,U,3),PSJRPHD=$P(VND4,U,4),PSJPVFL=$P(VND4,U,16) S:PSJRN]"" PSJNVFL=1
        ...S DR="16////"_PSJRN_";17////"_PSJRNDT_";140////"_PSJRPH_";141////"_PSJRPHD_";142////"_PSJPVFL_";143////"_PSJNVFL
        ...S DA(1)=PSGP,DA=+ON55,DIE="^PS(55,"_PSGP_",""IV""," D ^DIE
        ..D:P("RES")="R" RUPDATE^PSIVOREN(PSGP,ON,P(2))
        ..I +PSJSYSU=3 K OD D ^PSIVORE1 ;LABEL STUFF
        ..I $G(P("PACT"))]"",+$P(P("PACT"),U,2),+$P(P("PACT"),U,3) D  Q
        ...NEW DIC,DA,X,Y,XX D NAME^PSJBCMA1($P(P("PACT"),U,2),.XX)
        ...S DIC(0)="L",DA(1)=DFN,DA(2)=+ON55,X=1
        ...S DIC="^PS(55,"_DA(1)_",""IV"","_DA(2)_",""A"","
        ...S DIC("DR")=".02////F;.03////"_XX_";.04////"_$P($G(^PS(53.3,+$P(P("PACT"),U,3),0)),U)_";.05////"_$P(P("PACT"),U)_";.06////"_$P(P("PACT"),U,2)
        ...K DO D FILE^DICN K DO
        ...N DIK,DA,PSIVACT S DIK="^PS(55,"_DFN_",""IV"",",DA=+ON,PSIVACT="" S:$G(DFN) DA(1)=DFN D IX^DIK K DIK,DA
        ...S PSJCOM=$P($G(^PS(55,DFN,"IV",+ON,.2)),"^",8) I PSJCOM]"" K ^PS(53.1,"ACX",PSJCOM,PSJO)
        ...D EN1^PSJHL2(DFN,"SC",ON)
        ...D:+PSJSYSU=1 EN1^PSJHL2(DFN,"ZV",ON) L -^PS(55,DFN,"IV",+ON) I $G(ON55) L -^PS(55,DFN,"IV",+ON55)
        ..L -^PS(55,DFN,"IV",+ON) I $G(ON55) L -^PS(55,DFN,"IV",+ON55)
        .I $P(PSGND,U,4)="U",$P(PSGND,U,9)="DE",$D(^TMP("PSJCOM2",$J,PSJO,0)),$P(^TMP("PSJCOM2",$J,PSJO,0),"^",9)="A",$P(^TMP("PSJCOM2",$J,PSJO,0),"^",4)="U" S PSGP=$P(PSGND,U,15) D UD^PSJOEA
        .I $P(PSGND,U,4)'="U",$P(PSGND,U,9)="DE",$D(^TMP("PSJCOM2",$J,PSJO,0)),$P(^TMP("PSJCOM2",$J,PSJO,0),"^",9)="A",$P(^TMP("PSJCOM2",$J,PSJO,0),"^",4)="U" S PSGP=$P(PSGND,U,15) D UD^PSJOEA
        .I $P(PSGND,U,4)'="U",$P(PSGND,U,9)="DE",$D(^TMP("PSJCOM2",$J,PSJO,0)),$P(^TMP("PSJCOM2",$J,PSJO,0),"^",4)'="U",$P(^TMP("PSJCOM2",$J,PSJO,0),"^",17)="A" S DFN=$S($G(PSGP)]"":PSGP,1:$P(PSGND,U,15)) D IV^PSJOEA
        .I $P(PSGND,U,4)="U",$P(PSGND,U,9)="DE",$D(^TMP("PSJCOM2",$J,PSJO,0)),$P(^TMP("PSJCOM2",$J,PSJO,0),"^",4)'="U",$P(^TMP("PSJCOM2",$J,PSJO,0),"^",17)="A" S DFN=$S($G(PSGP)]"":PSGP,1:$P(PSGND,U,15)) D IV^PSJOEA
        K ^TMP("PSJCOM",$J),^TMP("PSJCOM2",$J),PSJOWALL
        Q
