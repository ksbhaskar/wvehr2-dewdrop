RMPRESI ;PHX/JLT-ENTER/EDIT SITE PARAMETERS ROUTINE ;8/29/1994
        ;;3.0;PROSTHETICS;**51,55,62,90,125**;Feb 09, 1996;Build 21
        ;
        ; ODJ - patch 55 - 1/29/01 - Add prompt for field 34 in 669.9
        ;                            mail routing code (see AUG-1097-32118)
        ;
        ; RVD patch #62  - added PCE Hospital Location prompt
        ; SPS patch #125 - added PURCHASING AGENT multiple PHONE
        ;                        DVN IP ADDRESS
        ;                        DVN FILE NAME
        ;
DIR     K Y,DA,DIR S DIR(0)="FO^3:30",DIR("?")="^S X=""?"" D INS^RMPRESI",DIR("A")="Select PROSTHETICS SITE PARAMETER SITE NAME" D ^DIR G:$D(DIRUT)!$D(DTOUT) EXIT
        S DIC=669.9,DIC(0)="EMZ",RMPRX=X D ^DIC I +Y>0 S RMPRIEN=+Y G EDIT
        S X=RMPRX,DIC=4,DIC(0)="EQMZ" D ^DIC G:+Y'>0 DIR S SITE=+Y
START   S RMPRA=^DIC(4,SITE,0),RMPRB=$S($D(^DIC(4,SITE,1)):^(1),1:" "),SIG="",ST=$P(^DIC(4,SITE,0),U,2)
        S DIC=669.9,DIC(0)="EQZL",DLAYGO=669.9,X=$P($P(RMPRA,","),U)_" VAMC",DIC("DR")="1////^S X=SITE" D ^DIC K DLAYGO G:+Y'>0 DIR S RMPRIEN=+Y
        S STRT=$P(RMPRB,U,1)
        S CITY=$P(RMPRB,U,3),RIP=$P(RMPRB,U,4),ART=125,WCHR=100,BRSS=75,BAS=75,PG=90,COP=90,CDP=90
CON     S RMPRSITE=$O(^RMPR(669.9,0)),AIN=$P(^RMPR(669.9,RMPRSITE,0),U,3) I $D(^(2)) S SIG=$P(^(2),U,6),SBT=$P(^(2),U,1)
        S DA=RMPRIEN,DIE="^RMPR(669.9,"
        S DR="2////^S X=AIN;4////^S X=STRT;5////^S X=CITY;6////^S X=ST;7////^S X=RIP;8////^S X=SIG;8.5///^S X=SBT;11////^S X=99999999;15////^S X=ART;16////^S X=WCHR;17////^S X=BRSS;18////^S X=BAS;19////^S X=PG;20////^S X=COP;21////^S X=CDP" D ^DIE
EDIT    ;EDIT SITE PARAMENTERS
        ; Added fields 8.1 and 10 in patch 90
        ; Added fields (subfile 8.1 field 3,4) 12,13,14.
        S DIE="^RMPR(669.9,",DA=RMPRIEN,DR=".01;40;3;4;5;6;7;7.1;12;13;14;8;8.1;10;8.5;2;31;32;33;34;9;27;28;29;30;19;20;21;15;16;17;18;22;52" D ^DIE G DIR
EXIT    N RMPRSITE,RMPR D KILL^XUSCLEAN Q
INS     S RI="" F  S RI=$O(^RMPR(669.9,"B",RI)) Q:RI=""  S RRMPR=$O(^RMPR(669.9,"B",RI,0)),RRMPR=^RMPR(669.9,RRMPR,0) W !,?5,$P(RRMPR,U)," ",?50,$P(^DIC(4,$P(RRMPR,U,2),99),U)
        S DIC=4,DIC(0)="EQMZ" D ^DIC Q
        ;
        Q
A1      G A2
MGR(RESULTS)    ;RPC to display manger comment
A2      ;
        S RMPRS=0,RESULTS(0)=""
        F  S RMPRS=$O(^RMPR(669.9,RMPRS)) Q:RMPRS=""  D
        .S RESULTS(0)=RESULTS(0)_$P($G(^RMPR(669.9,RMPRS,6)),U,1)
        K RMPRS
        Q
