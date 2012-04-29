GMRYRP2 ;HIRMFO/YH-TMP FOR PATIENT INTAKE/OUTPUT REPORTS-2 ;2/28/91
 ;;4.0;Intake/Output;;Apr 25, 1997
SETARRY ;
 S DA(1)=$O(^GMR(126,"B",DFN,0)) K ^TMP($J,"GMRY")
 I $D(^GMR(126,"B",DFN)) F II="IN","OUT" D SAVE
 D:$D(^GMR(126,"B",DFN)) SAVEIV
 K GLEFT,GTOTAL Q
SAVE ;
 I '$D(^GMR(126,DA(1),II,"TYP")) Q
 S GINDT=0,GDAY=0 D NEXT^GMRYRP1 F JJ=0:0 S GINDT=$O(^GMR(126,DA(1),II,"TYP",GINDT)) Q:GINDT'>0  S GMRINDT=9999999-GINDT Q:GMRINDT<GMRSTRT  I GMRINDT'>GMRFIN D SETSIFT D GETTYP
 Q
GETTYP ;
 S GTYP=0 F KK=0:0 S GTYP=$O(^GMR(126,DA(1),II,"TYP",GINDT,GTYP)) Q:GTYP'>0  D GETDA
 Q
GETDA ;
 S DA=0 F KK=0:0 S DA=$O(^GMR(126,DA(1),II,"TYP",GINDT,GTYP,DA)) Q:DA'>0  D GETAMT S ^TMP($J,"GMRY",$P(GDSHFT,"."),GSHIFT,II,GMRINDT,GTYP,GSUB)=GAMOUNT_"^"_GTEXT_"^"_GITEM_"^"_$S(II="OUT":$P(^GMR(126,DA(1),II,DA,0),"^",3),1:"")
 Q
GETAMT ;
 S GSUB=+$P(^GMR(126,DA(1),II,DA,0),"^",3) S:GSUB=0 GSUB=99
 S GITEM="" I II="IN" S GAMOUNT=$P(^GMR(126,DA(1),II,DA,0),"^",5),GTEXT=$P(^(0),"^",6)_"^"_$P(^(0),"^",7) D ITEM^GMRYRP1 Q
 I II="OUT" D  S GTEXT=GTEXT(1)_GTEXT Q
 . S GAMOUNT=$P(^GMR(126,DA(1),II,DA,0),"^",4)
 . I GAMOUNT'>0,GAMOUNT'?1.3N N GI S GI=$$UP^XLFSTR($E(GAMOUNT)),GAMOUNT=$S(GI="S":"Small",GI="M":"Medium",GI="L":"Large",GI="*":"*",1:"")
 . S GTEXT="^"_$P(^GMR(126,DA(1),II,DA,0),"^",6),GTEXT(1)=$P(^(0),"^",5)
 . Q
 S GAMOUNT=0,GTEXT=""
 Q
SETSIFT ;
 I GDAY=0 D SETDT
CHECKD I GMRINDT<GNSHFT D SETSFTD G CHECKD
 I GMRINDT<GDSHFT S GSHIFT="SH-1" Q
 I GMRINDT<GESHFT S GSHIFT="SH-2" Q
 I GMRINDT<GNXNSF S GSHIFT="SH-3" Q
 S GSHIFT="BLANK" Q
SETSFTD ;
 S GDAY=GDAY+1
 S X1=GDTSTRT,X2=-1 D C^%DTC K %DT S GDTSTRT=X
 S X1=GDTFIN,X2=-1 D C^%DTC K %DT S GDTFIN=X
 S X1=GLASTDT,X2=-1 D C^%DTC K %DT S GLASTDT=X
 S X1=GNXNSF,X2=-1 D C^%DTC K %DT S GNXNSF=X
SETDT ;
 S GNSHFT=GDTSTRT_"."_GMRNIT,GDSHFT=GDTFIN_"."_GMRDAY,GESHFT=GDTFIN_"."_GMREVE,GNXNSF=GNXTDT_"."_GMRNIT
 Q
SAVEIV ;SET ^TMP($J,"GMRY" FOR IV INTAKE
 I '$D(^GMR(126,DA(1),"IV","TYP")) Q
 S GIVSTRT=0 F JJ=0:0 S GIVSTRT=$O(^GMR(126,DA(1),"IV","TYP",GIVSTRT)) Q:GIVSTRT'>0  D IVTYP
 Q
IVTYP ;
 S GIVTYP="" F KK=0:0 S GIVTYP=$O(^GMR(126,DA(1),"IV","TYP",GIVSTRT,GIVTYP)) Q:GIVTYP=""  S DA=0 F  S DA=$O(^GMR(126,DA(1),"IV","TYP",GIVSTRT,GIVTYP,DA)) Q:DA'>0  Q:'$D(^GMR(126,DA(1),"IV",DA,0))  D IVDA
 Q
IVDA ;
 D IVINTK^GMRYUT8 S GSITE=$P(^GMR(126,DA(1),"IV",DA,0),"^",2),GSTRT=$P(^(0),"^")
 I GRPT>7 D STRTIV,TITR
 Q:'$D(^GMR(126,DA(1),"IV",DA,"IN",0))
 S (GINDT,GDAY)=0 D NEXT^GMRYRP1 F LL=0:0 S GINDT=$O(^GMR(126,DA(1),"IV",DA,"IN","C",GINDT)) Q:GINDT'>0  S GMRINDT=9999999-GINDT Q:GMRINDT<GMRSTRT  I GMRINDT'>GMRFIN D SETSIFT D IVAMNT
 Q
IVAMNT ;
 I GIVTYP'="L" S ^TMP($J,"GMRY",$P(GDSHFT,"."),GSHIFT,"IV",GMRINDT,GSTRT,GIVTYP,DA,2)=$P(GIN(GMRINDT),"^",2)_"^"_GIVTYP_"^"_GSITE_"^"_$P(GIN(GMRINDT),"^",3)_"^"_$P(GIN(GMRINDT),"^",4)_"^"_$P(GIN(GMRINDT),"^")_"^"_DA
 Q
STRTIV ;SET ^TMP($J,"GMRY") FOR IV STARTING INFORMATION
 S GMRINDT=GSTRT,GDAY=0 D NEXT^GMRYRP1 Q:GMRINDT<GMRSTRT!(GMRINDT>GMRFIN)
 D SETSIFT S ^TMP($J,"GMRY",$P(GMRINDT,"."),GSHIFT,"IV",GMRINDT,GSTRT,GIVTYP,DA,1)=^GMR(126,DA(1),"IV",DA,0)
 Q
TITR ;
 Q:'$D(^GMR(126,DA(1),"IV",DA,"TITR",0))
 S (GINDT,GDAY)=0 D NEXT^GMRYRP1 F LL=0:0 S GINDT=$O(^GMR(126,DA(1),"IV",DA,"TITR","C",GINDT)) Q:GINDT'>0  S GDA=$O(^(GINDT,0)),GMRINDT=9999999-GINDT Q:GMRINDT<GMRSTRT  I GMRINDT'>GMRFIN D SETSIFT D
 .S ^TMP($J,"GMRY",$P(GDSHFT,"."),GSHIFT,"IV",GMRINDT,GSTRT,GIVTYP,DA,3)=$P(^GMR(126,DA(1),"IV",DA,"TITR",GDA,0),"^",2,3)_"^"_GDA_"^"_$P(^GMR(126,DA(1),"IV",DA,0),"^",2,3)_"^"_$P(^GMR(126,DA(1),"IV",DA,"TITR",GDA,0),"^",5)
 Q
