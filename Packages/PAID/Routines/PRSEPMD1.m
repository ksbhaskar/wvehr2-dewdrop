PRSEPMD1 ;HISC/GLB-INCOMPLETE NURSING MANDATORY INSERVICE CLASS DATA PART 2 OF 2 ;2/17/94  11:19
 ;;4.0;PAID;**20**;Sep 21, 1995
HDR ; PRINT REPORT HEARDER
 I NSW1,$E(IOST)="C" D ENDPG^PRSEUTL S PRSEOUT=+POUT Q:PRSEOUT
 S COUNT=COUNT+1,(HOLD,NSW1)=1,NSW2=0
 W:$E(IOST)="C"!(COUNT>1) @IOF W !,"INDIVIDUAL MANDATORY TRAINING DEFICIENCY REPORT FOR "_$S(TYP="C":"CY ",TYP="F":"FY ",1:" ")
 W $S(TYP="C"!(TYP="F"):$G(PYR),1:$G(YRST(1))_" - "_$G(YREND(1)))
 S Y=DT D:+Y D^DIQ
 I PRSE132 D
 . W ?101,Y,?121,"PAGE: ",COUNT
 . W !!,"NAME",?33,"SERVICE",?56,"DEFICIENT AS OF",?79,"CLASS"
 . Q
 E  D
 . W !?57,Y,?71,"PAGE: ",COUNT
 . W !!,"NAME",?20,"SERVICE",?37,"DEFICIENT",?55,"CLASS",!?37,"AS OF"
 . Q
 S $P(SE1,"-",$S(PRSE132:133,1:81))="" W !,SE1
 Q
