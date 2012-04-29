RMPOBILU ;EDS/MDB,RVD - HOME OXYGEN BILLING TRANSACTIONS ;8/7/98  10:58
 ;;3.0;PROSTHETICS;**29,43,44,77**;Feb 09, 1996
 ;RVD 3/18/03 patch #77 - don't allow future billing month creation
 ;
 Q
VDRSCRN ; SCREEN
 Q
 I '$D(RMPOXITE) D  Q
 . W !,$C(7)_"RMPOXITE NOT DEFINED!"
 . S DIC("S")="I 0"
 S DIC("S")="I $D(^RMPR(669.9,RMPOXITE,""RMPOVDR"",Y,0))"
 Q
XFRM1 ; INPUT XFORM FOR BILLING MONTH, FILE 665.72
 S %DT(0)=-DT
 S %DT="E" D ^%DT S X=Y I Y<0 K X Q
 S (DINUM,X)=$E(X,1,5)_"00"
 Q
2319 ; -- Display 2319
 N RMPRNAM,RMPRDOB,RMPRSSN,RMPRDFN
 S (DFN,RMPRDFN)=RMPODFN D DEM^VADPT
 S RMPRNAM=VADM(1)
 S RMPRDOB=+VADM(3)
 S RMPRSSN=+VADM(2)
 S $P(RMPR("L"),"-",80)=""
 S RMPRBAC1=1
 D ^RMPRPAT
 K RMPRBAC1
 Q
ACCEPT ; ACCEPT TRX
 D SAME S DR="2///Y" D ^DIE
 Q
UNACCEPT ; UNACCEPT TRX
 D SAME S DR="2///N" D ^DIE
 Q
SAME ;
 K DIE,DA,DR
 S DA=RMPODFN,DA(1)=RMPOVDR,DA(2)=RMPORVDT,DA(3)=RMPOXITE
 S DIE="^RMPO(665.72,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",""V"","
 Q
FCP(FCP) ;
 ;
 ; PASS:
 ; -- AS PARAMETER
 ;  FCP = FREE-TEXT FUND CONTROL POINT NAME
 ; -- AS VARIABLES
 ;  RMPOXITE = SITE #
 ;  RMPODATE = BILLING MONTH
 ;  RMPOVDR = VENDOR IEN (IF TYPE = 'PURCHASE CARD')
 ;
 ; RETURNS:
 ; TYPE ^ 442 IEN ^ REF # ^ AMOUNT ^ IEN
 ;   TYPE = PAYMENT TYPE (1 = 1358, 'P' = PURCHASE CARD)
 ;   442 IEN = POINTER TO FILE 442, USED FOR POSTING
 ;   REF # = C# FOR 1358, PCO# FOR PURCHASE CARD
 ;   AMOUNT = TOTAL AMOUNT POSTED SO FAR (PURCHASE CARD ONLY)
 ;   IEN = IEN OF 'FCP' RECORD IN FILE 665.72, USED FOR UPDATING TOTALS
 ;
 N FOUND,DATA,RVDT,IEN,TMP,SITE,FN,TYPE
 S QUIT=0,DATA="",FN=665.72
 I '$D(RMPOXITE) W !,"SITE NOT DEFINED!" Q -1
 I '$D(^RMPO(FN,RMPOXITE)) W !,"SITE NOT FOUND!" Q -1
 S SITE=RMPOXITE
 I '$D(RMPODATE) W !,"BILLING MONTH NOT DEFINED!" Q -1
 S RVDT=RMPODATE
 I '$D(^RMPO(FN,SITE,1,RVDT)) D  Q -1
 . W !,"BILLING MONTH NOT DEFINED!"
 ;
 D FCP4 Q:FOUND DATA
 D FCP1 Q:(Y="")!$$QUIT -1
 S TYPE=Y
 D FCP2:TYPE=1,FCP3:TYPE="P" Q:($G(Y)<0)!QUIT -1
 Q DATA
 Q
FCP4 ; LOOK FOR EXISTING PAYMENT TYPE
 S FOUND=0,DATA=""
 Q:'$D(^RMPO(FN,SITE,1,RVDT,2,"B",FCP))
 K DIC S DA(1)=RVDT,DA(2)=SITE
 S DIC("A")="Select Fund Control Point: "
 S DIC="^RMPO(FN,"_DA(2)_",1,"_DA(1)_",2,",DIC(0)="AMQEZ"
 S DIC("S")="S Z=^(0) I $P(Z,U)=FCP,$S($P(Z,U,2):1,($P(Z,U,2)=""P"")&"
 S DIC("S")=DIC("S")_"($P(Z,U,5)=DUZ)&($P(Z,U,6)=RMPOVDR):1,1:0),"
 S DIC("S")=DIC("S")_"$P(Z,U,8)="""""
 S DIC("W")="W ?35,$P(^(0),U,4)"
 S DIC("W")=DIC("W")_" I $P(^(0),U,2) W ?55,"
 S DIC("W")=DIC("W")_"$J($$BAL^RMPOPST1($P(^(0),U,3)),10,2)"
 D ^DIC
 Q:(Y<0)!$$QUIT
 K RMPOZ M RMPOZ=Y
 K DIR S DIR(0)="Y"
 S RMZ=^RMPO(FN,SITE,1,RVDT,2,+Y,0)
 S RMZ=$P(RMZ,U,4)
 S DIR("A")="Are you sure you want "_RMZ
 S DIR("B")="NO" D ^DIR G:(Y=0) FCP4 Q:(Y'=1)!$$QUIT
 K Y M Y=RMPOZ
 I $P(Y(0),U,2) S DATA=$P(Y(0),U,2,4)_U_U_(+Y),FOUND=1 Q
 S DATA=$P(Y(0),U,2)_U_$P(Y(0),U,3)_U
 S DATA=DATA_$P(Y(0),U,4)_U_$P(Y(0),U,7)_U_(+Y),FOUND=1
 Q
FCP2 ; 1358
 S PRC("SITE")=RMPRS,PRC("CP")=FCP
 S PRCS("A")="Select Obligation Number: "
 D EN1A^PRCS58 Q:(Y<0)!$$QUIT
 K RMPOZ M RMPOZ=Y
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you sure" D ^DIR Q:(Y<1)!$$QUIT
 K Y M Y=RMPOZ D FCPSET
 K PRC,PRCS
 Q
FCPSET ; SET ENTRY IN RMPO
 S DATA=TYPE_U_$P(Y,U,1,2)_U_U  ; SETUP RETURN VALUE
 ;Check if selected IFCAP order exist in file 665.72
 S Y=$$FCPCHK(.DATA) I Y Q
 K DIC,DIE,DA,DR,DD,DO
 S DA(2)=SITE,DA(1)=RVDT
 S DIC="^RMPO(665.72,"_DA(2)_",1,"_DA(1)_",2,"
 S DIC("P")=$P(^DD(665.723,2,0),U,2)
 S DIC(0)="L",X=FCP D FILE^DICN I Y<0 S DATA=-1 Q
 S DIE=DIC,DA=+Y,DATA=DATA_DA
 S DR="1////"_TYPE
 S DR=DR_";2////"_$P(DATA,U,2)
 S DR=DR_";3///"_$P(DATA,U,3)
 S DR=DR_";4////"_DUZ
 S:TYPE="P" DR=DR_";5////"_RMPOVDR
 D ^DIE
 S Z1=$P(DATA,U,2)
 S Z2=$P(DATA,U,3)
 S $P(^RMPO(665.72,DA(2),1,DA(1),2,DA,0),U,3,4)=Z1_U_Z2
 Q
FCPCHK(DATA) ;CHECK IF FCP ALREADY EXIST IN FILE 665.72
 N IEN,FDT,FPT,FOUND
 S (IEN,FOUND)=0
 F  S IEN=$O(^RMPO(FN,SITE,1,RVDT,2,"B",FCP,IEN)) Q:IEN=""  D  Q:FOUND
 . S FDT=^RMPO(FN,SITE,1,RVDT,2,IEN,0),FPT=$P(FDT,U,2)
 . I $P(FDT,U,8)>0 Q  ; closed flag
 . I FPT=TYPE,$P(DATA,U,2)=$P(FDT,U,3),$P(DATA,U,3)=$P(FDT,U,4) D
 . . I TYPE=1 S DATA=DATA_IEN,FOUND=1 Q
 . . I $P(FDT,U,5)=DUZ,$P(FDT,U,6)=RMPOVDR D
 . . . S $P(DATA,U,4)=$P(FDT,U,7),DATA=DATA_IEN,FOUND=1
 Q FOUND
FCP3 ; PURCHASE CARD
 N PRCA
 I '$D(^PRC(440.5,"H",DUZ)) D  S Y=-1 Q
 . W !!,"You are not an authorized Purchase Card User, CONTACT FISCAL!"
 S PRCA=RMPRS_U_RMPOVDR
 D ADD^PRCH7D(.PRCA) S Y=PRCA Q:(Y<0)!(Y="^")!$$QUIT
 K RMPOZ M RMPOZ=Y
 K DIR S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure"
 D ^DIR Q:(Y<1)!$$QUIT
 K Y M Y=RMPOZ D FCPSET
 Q
FCP1 ; PAYMENT TYPE
 K DIR,DA
 S DIR(0)="665.7232,1" D ^DIR
 Q
GETFCP(DFCP) ; Return FCP from file 420 (External value only)
 ; Pass - DFCP = Default FCP [optional]
 ;
 N DIC,DA
 S:$D(DFCP) DIC("B")=DFCP
 S DA(1)=RMPOXITE,DIC("A")="Select FUND CONTROL POINT: "
 S DIC="^RMPR(669.9,"_DA(1)_",""RMPOFCP"",",DIC(0)="AEQMZ" D ^DIC
 I Y<0!$$QUIT Q Y
 Q Y_U_Y(0,0)
QUIT() S QUIT=$D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q QUIT
EQUIT() S QUIT=$D(DTOUT)!$D(Y) Q QUIT
LJ(S,W,C) ; Left justify S in a field W wide padding with char F
 ;
 S C=$G(C," ")   ; Default pad char is space
 S $P(S,C,W-$L(S)+$L(S,C))=""
 Q $E(S,1,W)
 Q
ENC(X,X1,X2) ;Encrypt
 ;Variable X  = string to encrypt
 ;         X1 = DUZ
 ;         X2 = FCP IEN of file 665.72
 D EN^XUSHSHP
 Q X
DEC(X,X1,X2) ;Decrypt
 ;Variable X  = encrypted string
 ;         X1 = DUZ
 ;         X2 = FCP IEN of file 665.72
 D DE^XUSHSHP
 Q X
