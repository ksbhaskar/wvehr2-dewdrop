SROAUTL ;BIR/ADM - RISK ASSESSMENT UTILITY ;03/03/08
        ;;3.0; Surgery ;**38,46,47,63,81,88,95,112,100,125,134,142,153,160,166**;24 Jun 93;Build 7
        I $G(SRSUPCPT)=2 G NCODE
        N SRCMOD,SRCOMMA,X K SRHDR S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S SRHDR=VADM(1)_" ("_VA("PID")_")      Case #"_SRTN
        S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) X ^DD("DD") S SRSDATE=Y
        S X=^SRF(SRTN,"OP"),SROPER=$P(X,"^"),Y=$P(X,"^",2),SRCPT=$S(Y:$P($$CPT^ICPTCOD(Y),"^",2),1:"CPT MISSING") I SRCPT,$O(^SRF(SRTN,"OPMOD",0)) D
        .S (SRCOMMA,SRI)=0,SRCMOD="",SRCPT=SRCPT_"-" F  S SRI=$O(^SRF(SRTN,"OPMOD",SRI)) Q:'SRI  D
        ..S SRM=$P(^SRF(SRTN,"OPMOD",SRI,0),"^"),SRCMOD=$P($$MOD^ICPTMOD(SRM,"I"),"^",2)
        ..S SRCPT=SRCPT_$S(SRCOMMA:",",1:"")_SRCMOD,SRCOMMA=1
        S SRCPT=$S($G(SRSUPCPT)=1:"",1:"("_SRCPT_")")
        S SROPER=SROPER_" "_SRCPT D LOOP S SRHDR(1)=SRSDATE_"   "_SRHDR(1)
        Q
NCODE   N SRCMOD,SRCOMMA,X K SRHDR S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S SRHDR=VADM(1)_" ("_VA("PID")_")        Case #"_SRTN
        S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) X ^DD("DD") S SRSDATE=Y
        S X=^SRF(SRTN,"OP"),SROPER=$P(X,"^"),Y=$P($G(^SRO(136,SRTN,0)),"^",2),SRCPT=$S(Y:$P($$CPT^ICPTCOD(Y),"^",2),1:"CPT MISSING") I SRCPT,$O(^SRO(136,SRTN,1,0)) D
        .S (SRCOMMA,SRI)=0,SRCMOD="",SRCPT=SRCPT_"-" F  S SRI=$O(^SRO(136,SRTN,1,SRI)) Q:'SRI  D
        ..S SRM=$P(^SRO(136,SRTN,1,SRI,0),"^"),SRCMOD=$P($$MOD^ICPTMOD(SRM,"I"),"^",2)
        ..S SRCPT=SRCPT_$S(SRCOMMA:",",1:"")_SRCMOD,SRCOMMA=1
        S SRCPT="(CPT Code: "_SRCPT_")"
        S SROPER=SROPER_" "_SRCPT D LOOP S SRHDR(1)=SRSDATE_"   "_SRHDR(1)
        Q
LOOP    I $L(SROPER)<68 S SRHDR(1)=SROPER Q
        I $L(SROPER)>67 S X=SROPER,K=1 F  D  I $L(X)<68 S SRHDR(K)=X Q
        .F I=0:1:66 S J=67-I,Y=$E(X,J) I Y=" " S SRHDR(K)=$E(X,1,J-1),X=$E(X,J+1,$L(X)) S K=K+1 Q
        Q
HDR     ; print screen header
        W @IOF,!,SRHDR W:$G(SRPAGE)'="" ?(79-$L(SRPAGE)),SRPAGE
        S I=0 F  S I=$O(SRHDR(I)) Q:'I  W !,SRHDR(I) I I=.5,$L($G(SRCSTAT)) W ?(79-$L(SRCSTAT)),SRCSTAT
        W:$D(SRCSTAT)&'$D(SRHDR(.5)) !,SRCSTAT
        K SRHDR(.5),SRCSTAT,SRPAGE W ! F I=1:1:80 W "-"
        W !
        Q
FUNCT() ; called by screen on functional health status field (#240)
        N SRSCR S SRSCR="I 1"
        I $$CARD S SRSCR="I Y'=4"
        Q SRSCR
CARD()  ; is this a cardiac assessed case?
        N SRX S SRX=$S($D(SRTN):SRTN,$D(DA):DA,1:"") I 'SRX Q 0
        I $P($G(^SRF(SRX,"RA")),"^",2)="C" Q 1
        Q 0
NC      ; called from input transform to kill X if case is cardiac assessed
        I $$CARD,X="NA"!(X="NS") K X
        Q
DATE    ; called by output transform on several date fields
        I $D(Y),Y="NA"!(Y="NS") Q
        N SRY S SRY=Y D DD^%DT
        Q
INDX    ; set airway index
        S SRY=$S(SRI>4:5,SRI>3:4,SRI>2:3,SRI>0:2,1:1),$P(^SRF(DA,.3),"^",9)=SRY
        K SRI,SRMS,SROP,SRY
        Q
OP      ; set logic for AOP cross reference on Oral-Pharyngeal field (901.1)
        N SRI,SRMS,SRY S SRMS=$P(^SRF(DA,.3),"^",12) I SRMS'="" S SRMS=SRMS*.1,SRI=2.5*X-SRMS D INDX
        Q
MS      ; set logic for AMS cross reference on Mandibular Space field (901.2)
        N SRI,SRY,SRMS,SROP S SROP=$P(^SRF(DA,.3),"^",11) I SROP'="" S SRMS=X*.1,SRI=2.5*SROP-SRMS D INDX
        Q
K901    ; kill logic for AOP and AMS cross references
        S $P(^SRF(DA,.3),"^",9)=""
        Q
DUP     ; duplicate preop information from prior operation within 60 days
        S SR200=$G(^SRF(SRTN,200)) S NOGO="" F I=1,9,13,18,30,37,44 S X=$P(SR200,"^",I) I X'="" S NOGO=1 K SR200 Q
        S X=$P($G(^SRF(SRTN,200.1)),"^") I X'="" S NOGO=1
        I NOGO K NOGO Q
        K SRCASE S SR=^SRF(SRTN,0),DFN=$P(SR,"^"),(SRSDATE,X1)=$P(SR,"^",9),X2=-60 D C^%DTC S SRENDT=X,SRCASE=0 F  S SRCASE=$O(^SRF("B",DFN,SRCASE)) Q:'SRCASE  I SRCASE,SRCASE'=SRTN D
        .S SRX=$P(^SRF(SRCASE,0),"^",9) I SRX>SRSDATE!(SRX<SRENDT) Q
        .Q:$P($G(^SRF(SRCASE,"NON")),"^")="Y"!$P($G(^SRF(SRCASE,30)),"^")!$P($G(^SRF(SRCASE,31)),"^",8)!($P($G(^SRF(SRCASE,"CON")),"^")=SRTN)!'$P($G(^SRF(SRCASE,.2)),"^",12)
        .S SRX=9999999-SRX,SRCASE(SRX,SRCASE)=""
        K SRDT S (SRX,Y)=0 F  S SRX=$O(SRCASE(SRX)) Q:'SRX!$D(SRDT)  S SRCASE="" F  S SRCASE=$O(SRCASE(SRX,SRCASE)) Q:'SRCASE  S SR=$G(^SRF(SRCASE,"RA")) I $P(SR,"^",2)="N",$P(SR,"^",6)="Y" D  Q
        .S Y=$P(^SRF(SRCASE,0),"^",9) X ^DD("DD") S SRDT=Y K DIR
        .W !! S DIR("A",1)="This patient had a previous non-cardiac operation on "_SRDT_".",DIR("A",2)="",DIR("A",3)="Case #"_SRCASE_"  "_$P(^SRF(SRCASE,"OP"),"^")
        .S DIR("A",4)="",DIR("A",5)="Do you want to duplicate the preoperative information from the earlier",DIR("A")="assessment in this assessment? "
        .S DIR("B")="YES",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
        .D:Y STUFF
        Q
STUFF   ; stuff preop information from previous case
        I $$LOCK^SROUTL(SRCASE) D  D UNLOCK^SROUTL(SRCASE)
        .K DA,DIC,DIQ,DR,SRY S DIC="^SRF(",DA=SRCASE,DIQ="SRY",DIQ(0)="I" D PREHD D EN^DIQ1 K DA,DIC,DIQ,DR
        .S SRZ=0 F  S SRZ=$O(SRY(130,SRCASE,SRZ)) Q:'SRZ  S DIE=130,DA=SRTN,DR=SRZ_"////"_SRY(130,SRCASE,SRZ,"I") D ^DIE K DA,DIE,DR
        Q
CHK     ; check for missing non-cardiac assessment data items
        N SRSEP K SRX
        F SRC="PREOP","DEM" K DA,DIC,DIQ,DR,SRY S DIC="^SRF(",DA=SRTN,DIQ="SRY",DIQ(0)="I" D @SRC D EN^DIQ1 D ^SROAUTL1
        F SRC="LAB","REM" K DA,DIC,DIQ,DR,SRY S DIC="^SRF(",DA=SRTN,DIQ="SRY",DIQ(0)="I" D @SRC D EN^DIQ1 D ^SROAUTL2
OTH     K DA,DIC,DIQ,DR,SRY,SRZ D TECH^SROPRIN I SRTECH="NOT ENTERED" S SRX("ANESTHESIA TECHNIQUE")="Anesthesia Technique"
        ;D RELATE^SROAUTL2
OCC     D EN^SROCCAT S SRSDATE=$E($P(^SRF(SRTN,0),"^",9),1,7) K ^TMP("SROCC",$J),SRO
        S SRPO=0 F  S SRPO=$O(^SRF(SRTN,10,SRPO)) Q:'SRPO  S ^TMP("SROCC",$J,$P(^SRF(SRTN,10,SRPO,0),"^",2),SRSDATE)=""
        S SRPO=0 F  S SRPO=$O(^SRF(SRTN,16,SRPO)) Q:'SRPO  S SRDATE=$E($P(^SRF(SRTN,16,SRPO,0),"^",7),1,7) D
        .S SRSEP=$P(^SRF(SRTN,16,SRPO,0),"^",4)
        .I '$G(SRDATE) S SRDATE="NO DATE"
        .S ^TMP("SROCC",$J,$P(^SRF(SRTN,16,SRPO,0),"^",2),SRDATE)=SRSEP
        I '$D(^TMP("SROCC",$J)) D OCCEND Q
        S SRPO=0 F  S SRPO=$O(^TMP("SROCC",$J,SRPO)) Q:'SRPO  S SRDATE="" F  S SRDATE=$O(^TMP("SROCC",$J,SRPO,SRDATE)) Q:SRDATE  S SRX("POSTOP OCCURRENCE DATE"_SRPO)="Date Noted on "_$P(^SRO(136.5,SRPO,0),"^")_" (Postop Occurrence)" Q
        S SRDATE="",SRDATE=$O(^TMP("SROCC",$J,3,SRDATE)) Q:SRDATE=""  I ^TMP("SROCC",$J,3,SRDATE)="" S SRX("SEPSIS CATEGORY")="SEPSIS CATEGORY on SYSTEMIC SEPSIS (Postop Occurrence)"
OCCEND  K ^TMP("SROCC",$J)
        Q
PREOP   S DR="236;237;346;202;246;325;238;492;204;203;326;212;213;396;394;220;266;395;208;329;330;328;211;332;333;400;334;335;336;401;338;218;339;215;216;217;338.1;338.2;218.1;269"
        Q
DEM     S DR="413;.011;247;418;419;420;421;452;453;454;342;513;516"
        Q
LAB     S DR="270;304;224;291;223;290;225;292;228;295;227;294;229;296;230;297;234;301;231;298;233;300;232;299;487;487.1;274;305;405;407;275;306;406;408;277;308;278;309;279;310;280;311;281;312;283;314;455;455.1;456;456.1;444;444.1;445;445.1"
        Q
REM     S DR="214;.035;1.09;1.13;.22;.23;340;443;446;504;504.1"
        Q
PREHD   D PREOP S DR=DR_";402;241;244;242;243;210;245"
        Q
