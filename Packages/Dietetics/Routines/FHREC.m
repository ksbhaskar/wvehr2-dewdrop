FHREC ; HISC/REL - Recipe Management ;2/13/95  14:29
 ;;5.5;DIETETICS;;Jan 28, 2005
EN1 ; Enter/Edit Recipes
 S (DIC,DIE)="^FH(114,",DIC(0)="AEQLM",DIC("DR")=".01",DLAYGO=114 W ! D ^DIC K DIC,DLAYGO G KIL:U[X!$D(DTOUT),EN1:Y<1
 S DA=+Y,DR="[FHINPR]" S:$D(^XUSEC("FHMGR",DUZ)) DIDEL=114 D ^DIE
 I $D(DA) S REC=DA D ANAL^FHREC5
 D KIL G EN1
EN3 ; Enter/Edit Recipe Categories
 S (DIC,DIE)="^FH(114.1,",DIC(0)="AEQLM",DIC("DR")=".01",DLAYGO=114.1 W ! D ^DIC K DIC,DLAYGO G KIL:"^"[X!$D(DTOUT),EN3:Y<1
 S DA=+Y,DR=".01:99" S:$D(^XUSEC("FHMGR",DUZ)) DIDEL=114.1 D ^DIE,KIL G EN3
EN4 ; List Recipe Categories
 W ! S L=0,DIC="^FH(114.1,",FLDS="[FHRECC]",BY="2,.01"
 S FR="@",TO="",DHD="RECIPE CATEGORIES" D EN1^DIP,RSET Q
EN5 ; Enter/Edit Serving Utensils
 S (DIC,DIE)="^FH(114.3,",DIC(0)="AEQLM",DIC("DR")=".01",DLAYGO=114.3 W ! D ^DIC K DIC,DLAYGO G KIL:"^"[X!$D(DTOUT),EN5:Y<1
 S DA=+Y,DR=".01:99" S:$D(^XUSEC("FHMGR",DUZ)) DIDEL=114.3 D ^DIE,KIL G EN5
EN6 ; List Serving Utensils
 W ! S L=0,DIC="^FH(114.3,",FLDS="NAME",BY="NAME"
 S (FR,TO)="",DHD="SERVING UTENSILS" D EN1^DIP,RSET Q
EN7 ; Enter/Edit Equipment
 S (DIC,DIE)="^FH(114.4,",DIC(0)="AEQLM",DIC("DR")=".01",DLAYGO=114.4 W ! D ^DIC K DIC,DLAYGO G KIL:"^"[X!$D(DTOUT),EN7:Y<1
 S DA=+Y,DR=".01:99" S:$D(^XUSEC("FHMGR",DUZ)) DIDEL=114.4 D ^DIE,KIL G EN7
EN8 ; List Equipment
 W ! S L=0,DIC="^FH(114.4,",FLDS="NAME",BY="NAME"
 S (FR,TO)="",DHD="EQUIPMENT" D EN1^DIP,RSET Q
EN9 ; Enter/Edit Preparation Areas
 S (DIC,DIE)="^FH(114.2,",DIC(0)="AEQLM",DIC("DR")=".01",DLAYGO=114.2 W ! D ^DIC K DIC,DLAYGO G KIL:U[X!$D(DTOUT),EN9:Y<1
 S DA=+Y,DR=".01:99" S:$D(^XUSEC("FHMGR",DUZ)) DIDEL=114.2 D ^DIE,KIL G EN9
EN10 ; List Preparation Areas
 W ! S L=0,DIC="^FH(114.2,",FLDS="[FHPROP]",BY="PRINT ORDER,NAME"
 S FR="@",TO="",DHD="PREPARATION AREAS" D EN1^DIP,RSET Q
RSET K %ZIS S IOP="" D ^%ZIS
KIL G KILL^XUSCLEAN
