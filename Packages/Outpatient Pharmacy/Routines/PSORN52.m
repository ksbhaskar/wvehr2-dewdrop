PSORN52 ;BIR/DSD - files renewal entries in prescription file ;9:38 AM  27 Feb 2011
        ;;7.0;OUTPATIENT PHARMACY;**1,11,27,37,46,79,71,100,117,157,143,219,148,239,201,225,303**;DEC 1997;Build 58;WorldVistA 30-June-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;Ext ref to ^PS(55 sup by DBIA 2228
        ;Ext ref to PSOUL^PSSLOCK sup by DBIA 2789
        ;Ext ref to ^VA(200 sup by DBIA 10060
        ;Ext ref to SWSTAT^IBBAPI sup by DBIA 4663
EN(PSOX)        ;EP
START   ;
        D:$D(XRTL) T0^%ZOSV ; Start RT Mon
        N PSOIBHLD,PSOSCOTH,PSOSCOTX S (PSOSCOTH,PSOSCOTX)=0 S PSOIBHLD="" I $G(PSOFDR),$G(ORD) D
        .S PSOIBHLD=$S($P($G(^PS(52.41,ORD,0)),"^",16)="SC":1,$P($G(^(0)),"^",16)="NSC":0,1:"")
        .I '$$DT^PSOMLLDT Q
        .N PSOIBHLX S PSOIBHLX=$G(^PS(52.41,ORD,"IBQ"))
        .S PSOIBHLD=PSOIBHLD_"^"_$S($P(PSOIBHLX,"^")=1:1,$P(PSOIBHLX,"^")=0:0,1:"")_"^"_$S($P(PSOIBHLX,"^",2)=1:1,$P(PSOIBHLX,"^",2)=0:0,1:"")_"^"_$S($P(PSOIBHLX,"^",3)=1:1,$P(PSOIBHLX,"^",3)=0:0,1:"")
        .S PSOIBHLD=PSOIBHLD_"^"_$S($P(PSOIBHLX,"^",4)=1:1,$P(PSOIBHLX,"^",4)=0:0,1:"")_"^"_$S($P(PSOIBHLX,"^",5)=1:1,$P(PSOIBHLX,"^",5)=0:0,1:"")_"^"_$S($P(PSOIBHLX,"^",6)=1:1,$P(PSOIBHLX,"^",6)=0:0,1:"")
        .S PSOIBHLD=PSOIBHLD_"^"_$S($P(PSOIBHLX,"^",7)=1:1,$P(PSOIBHLX,"^",7)=0:0,1:"")
        .I $P(PSOIBHLX,"^")=1!($P(PSOIBHLX,"^",2)=1)!($P(PSOIBHLX,"^",3)=1)!($P(PSOIBHLX,"^",4)=1)!($P(PSOIBHLX,"^",5)=1)!($P(PSOIBHLX,"^",6)=1)!($P(PSOIBHLX,"^",7)=1) S PSOSCOTH=1
        I $G(PSOSCOTH)!($G(PSORX("SC"))="SC")!($G(PSORX("SC"))="NSC") S PSOSCOTX=1
        S PSOANSQ("SC>50")="" D SCP^PSORN52D
        I $G(PSOFDR),$G(ORD) I $D(^PS(52.41,ORD,"ICD")) S FILE=52.41 D GET^PSORN52D
        ;Set ans to renew from Rx, only if no ans from Pend file
        I $G(PSORENW("OIRXN")) D
        .N PSOLDIBQ S PSOLDIBQ=$G(^PSRX(PSORENW("OIRXN"),"IBQ"))
        .I $P(PSOIBHLD,"^")="" D
        ..I $P($G(^PSRX(PSORENW("OIRXN"),"IB")),"^")=2 S $P(PSOIBHLD,"^")=0
        .I '$$DT^PSOMLLDT Q
        .I PSOLDIBQ="" Q
        .D IBHLD^PSORN52A
        D INIT G:PSORN52("QFLG") END D FILE^PSORN52A
        S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV ; Stop RT Mon
        K PSOANSQ,PSOANSQD,PSONEWFF
        I $G(PSOIBHLD)'="" D
        .;Set answers based on Pend Renew, prior to Phar call
        .Q:'$G(PSOX("IRXN"))
        .I $P(PSOIBHLD,"^")=1!($P(PSOIBHLD,"^")=0) S PSOANSQ("SC")=$P(PSOIBHLD,"^")
        .I '$$DT^PSOMLLDT Q
        .I $P(PSOIBHLD,"^",2)=1!($P(PSOIBHLD,"^",2)=0) S PSOANSQ(PSOX("IRXN"),"MST")=$P(PSOIBHLD,"^",2)
        .I $P(PSOIBHLD,"^",3)=1!($P(PSOIBHLD,"^",3)=0) S PSOANSQ(PSOX("IRXN"),"VEH")=$P(PSOIBHLD,"^",3)
        .I $P(PSOIBHLD,"^",4)=1!($P(PSOIBHLD,"^",4)=0) S PSOANSQ(PSOX("IRXN"),"RAD")=$P(PSOIBHLD,"^",4)
        .I $P(PSOIBHLD,"^",5)=1!($P(PSOIBHLD,"^",5)=0) S PSOANSQ(PSOX("IRXN"),"PGW")=$P(PSOIBHLD,"^",5)
        .I $P(PSOIBHLD,"^",6)=1!($P(PSOIBHLD,"^",6)=0) S PSOANSQ(PSOX("IRXN"),"HNC")=$P(PSOIBHLD,"^",6)
        .I $P(PSOIBHLD,"^",7)=1!($P(PSOIBHLD,"^",7)=0) S PSOANSQ(PSOX("IRXN"),"CV")=$P(PSOIBHLD,"^",7)
        .I $P(PSOIBHLD,"^",8)=1!($P(PSOIBHLD,"^",8)=0) S PSOANSQ(PSOX("IRXN"),"SHAD")=$P(PSOIBHLD,"^",8)
        K PSOIBHLD
        I '$G(PSOFDR) I $G(PSORENW("OIRXN")) S FILE=52 D GET^PSORN52D
        S PSONEW("NEWCOPAY")=""
        I (PSOSCP<50&('$P($G(^PS(53,+$P(^PSRX(PSOX("IRXN"),0),"^",3),0)),"^",7))),$G(DUZ("AG"))="V" S PSOFLAG=0 D COPAY^PSOCPB
        ;I PSOSCP>49!($P($G(^PS(53,+$P(^PSRX(PSOX("IRXN"),0),"^",3),0)),"^",7)=1) S PSOFLAG=0 D SC^PSOMLLD2
        ;Begin WorldVistA change; PSO*7*208
        I $G(PSOAFYN)="Y" G AFIN ;vfah
        ;End WorldVistA chnage
        I PSOSCA&(PSOSCP>49)!((PSOSCA!(PSOBILL=2))&($P($G(^PS(53,+$P(^PSRX(PSOX("IRXN"),0),"^",3),0)),"^",7)=1)) S PSOFLAG=0 D SC^PSOMLLD2
        I $$DT^PSOMLLDT D
        .I $D(PSOIBQS(PSODFN,"CV")) D MESS D CV^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"CV")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"VEH")) D MESS D VEH^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"VEH")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"RAD")) D MESS D RAD^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"RAD")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"PGW")) D MESS D PGW^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"PGW")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"SHAD")) D MESS D SHAD^PSOMLLD2 I $G(PSOANSQ(PSOX("IRXN"),"SHAD")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"MST")) D MESS D MST^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"MST")) K PSONEW("NEWCOPAY")
        .I $D(PSOIBQS(PSODFN,"HNC")) D MESS D HNC^PSOMLLDT I $G(PSOANSQ(PSOX("IRXN"),"HNC")) K PSONEW("NEWCOPAY")
        K PSOSCOTH,PSOSCOTX
        I $G(PSONEW("NEWCOPAY")) S ^PSRX(PSOX("IRXN"),"IB")=PSONEW("NEWCOPAY")
        ;
        ;Begin WorldVistA change; PSO*7*208
AFIN    ;vfah copay not evaluated by Autofinish,Rx
        D FINISH,ACP^PSOUTIL
        ;End WorldVistA change
        ;
        N PSOSCFLD S PSOSCFLD=$S(PSOSCP'="":$G(PSOANSQ("SC")),1:"")_"^"_$G(PSOANSQ(PSOX("IRXN"),"MST"))_"^"_$G(PSOANSQ(PSOX("IRXN"),"VEH"))_"^"_$G(PSOANSQ(PSOX("IRXN"),"RAD"))
        S PSOSCFLD=PSOSCFLD_"^"_$G(PSOANSQ(PSOX("IRXN"),"PGW"))_"^"_$G(PSOANSQ(PSOX("IRXN"),"HNC"))_"^"_$G(PSOANSQ(PSOX("IRXN"),"CV"))_"^"_$G(PSOANSQ(PSOX("IRXN"),"SHAD"))
        I PSOSCP<50&($TR(PSOSCFLD,"^")'="")&('$P($G(^PS(53,+$P(^PSRX(PSOX("IRXN"),0),"^",3),0)),"^",7)) S ^PSRX(PSOX("IRXN"),"IBQ")=PSOSCFLD K PSOSCFLD
        ;
        D FILE2^PSORN52D
        D:$$SWSTAT^IBBAPI() GACT^PSOPFSU0(PSOX("IRXN"),0)
        K PSONEW("NEWCOPAY"),PSOANSQ
END     D EOJ
        Q
INIT    S PSORN52("QFLG")=0 S:'$D(PSOX("DAYS SUPPLY")) PSOX("DAYS SUPPLY")=$P(PSOX("RX0"),"^",8)
        S:'$D(PSOX("# OF REFILLS")) PSOX("# OF REFILLS")=$P(PSOX("RX0"),"^",9) S:'$D(PSOX("ISSUE DATE")) PSOX("ISSUE DATE")=DT
        D INIT^PSON52 K PSON52
        Q
        ;
FINISH  ;
        G:PSOX("STATUS")=4 FINISHP
        I $D(PSORX("VERIFY")) D  G FINISHX
        .K DIC,DLAYGO,DINUM,DIADD,X,DD,DO S DIC="^PS(52.4,",DLAYGO=52.4,DINUM=PSOX("IRXN"),DIC(0)="ML"
        .S X=PSOX("IRXN") D FILE^DICN K DD,DO,DIC,DLAYGO,DINUM,X
        .S ^PS(52.4,PSOX("IRXN"),0)=PSOX("IRXN")_"^"_$P(PSOX("NRX0"),"^",2)_"^"_DUZ_"^"_$G(PSOX("OIRXN"))_"^"_$E(PSOX("LOGIN DATE"),1,7)_"^"_PSOX("IRXN")_"^"_PSOX("STOP DATE")
        .K DIK,DA S DIK="^PS(52.4,",DA=PSOX("IRXN") D IX^DIK K DIK,DA
        ;
        I $G(PSOX("QS"))="S",$G(PSOBARCD) S DA=PSOX("IRXN"),RXFL(PSOX("IRXN"))=0 D SUS^PSORXL K DA G FINISHX
        ;
        I PSOX("FILL DATE")>DT,$P(PSOPAR,"^",6) S DA=PSOX("IRXN"),RXFL(PSOX("IRXN"))=0 D SUS^PSORXL K DA G FINISHX
        ;
        ; - Submitting Rx to ECME for 3rd Party Billing
        N ACTION
        I $$SUBMIT^PSOBPSUT(PSOX("IRXN"),0) D  I ACTION="Q"!(ACTION="^") Q
        . S ACTION="" D ECMESND^PSOBPSU1(PSOX("IRXN"),0,PSOX("FILL DATE"),"RN")
        . I $$FIND^PSOREJUT(PSOX("IRXN"),0) D
        . . S ACTION=$$HDLG^PSOREJU1(PSOX("IRXN"),0,"79,88","RN","IOQ","Q")
        ;
        I $G(PSOX("QS"))="Q",$G(PSOBARCD) D  G FINISHX
        . N PSOFROM S PSOFROM="BATCH" I $G(PPL),$L(PPL_PSOX("IRXN")_",")>240 D TRI^PSOBBC D Q^PSORXL K PPL,RXFL
        .S RXFL(PSOX("IRXN"))=0
        . I $G(PPL) S PPL=PPL_PSOX("IRXN")_","
        . E  S PPL=PSOX("IRXN")_","
        . Q
FINISHP I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=PSOX("IRXN")_",",RXFL(PSOX("IRXN"))=0 G FINISHX
        F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(PSORX("PSOL",PSOX2))+$L(PSOX("IRXN"))<220 S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_PSOX("IRXN")_","
        E  S PSORX("PSOL",PSOX2+1)=PSOX("IRXN")_","
        S RXFL(PSOX("IRXN"))=0
FINISHX ;
        ;call to build bingo board Rx array
        S:'$G(PSORX("MAIL/WINDOW")) PSORX("MAIL/WINDOW")=$P(PSORENW("NRX0"),"^",11)
        I $G(PSORX("MAIL/WINDOW"))["W" S BINGCRT=1,BINGRTE="W",BBFLG=1 D BBRX^PSORN52C
        K PSOX1,PSOX2
        Q
EOJ     ;
        L -^PSRX("B",PSOX("IRXN")) K PSORN52,PSOX("INS"),PSORENW("INS"),PSORXED("INS"),PSONEW("ENT"),PSORXED("ENT"),OLENT,PSOIBHLD,PSOX("SINS"),PSORENW("SINS"),PSORXED("SINS"),FILE
        D PSOUL^PSSLOCK(PSOX("IRXN")) D PSOUL^PSSLOCK(PSOX("OIRXN"))
        Q
MESS    ;
        I $G(PSOSCOTX)=1&(PSOSCP<50) W:$G(PSODRUG("DEA"))'["S"&($G(PSODRUG("DEA"))'["I") !!,"This Rx has been flagged by the provider as: "_$S($G(PSOSCOTH):"NO COPAY",$G(PSORX("SC"))="SC":"NO COPAY",1:"COPAY"),! S PSOSCOTX=2
        Q
