PSORN52A        ;IHS/DSD/JCM/SAB/FLS-Break up of PSORN52 ;08/09/93
        ;;7.0;OUTPATIENT PHARMACY;**157,148,268,225,306**;DEC 1997;Build 3
        Q  ; Call from tag
        ;
IBHLD   ;
        I $P(PSOIBHLD,"^",2)="" S $P(PSOIBHLD,"^",2)=$S($P(PSOLDIBQ,"^",2)=1:1,$P(PSOLDIBQ,"^",2)=0:0,1:"")
        I $P(PSOIBHLD,"^",3)="" S $P(PSOIBHLD,"^",3)=$S($P(PSOLDIBQ,"^",3)=1:1,$P(PSOLDIBQ,"^",3)=0:0,1:"")
        I $P(PSOIBHLD,"^",4)="" S $P(PSOIBHLD,"^",4)=$S($P(PSOLDIBQ,"^",4)=1:1,$P(PSOLDIBQ,"^",4)=0:0,1:"")
        I $P(PSOIBHLD,"^",5)="" S $P(PSOIBHLD,"^",5)=$S($P(PSOLDIBQ,"^",5)=1:1,$P(PSOLDIBQ,"^",5)=0:0,1:"")
        I $P(PSOIBHLD,"^",6)="" S $P(PSOIBHLD,"^",6)=$S($P(PSOLDIBQ,"^",6)=1:1,$P(PSOLDIBQ,"^",6)=0:0,1:"")
        I $P(PSOIBHLD,"^",7)="" S $P(PSOIBHLD,"^",7)=$S($P(PSOLDIBQ,"^",7)=1:1,$P(PSOLDIBQ,"^",7)=0:0,1:"")
        I $P(PSOIBHLD,"^",8)="" S $P(PSOIBHLD,"^",8)=$S($P(PSOLDIBQ,"^",8)=1:1,$P(PSOLDIBQ,"^",8)=0:0,1:"")
        Q
        ;
FILE    ; - Filling ^PSRX and ^PS(55 entries
        S PSOX("NRX0")=PSORENW("RX0"),PSOX("NRX2")=PSORENW("RX2"),PSOX("NRX3")=PSORENW("RX3"),$P(PSOX("NRX3"),"^",5)=""
        S $P(PSOX("NRX0"),"^")=PSOX("NRX #") S:$G(PSOX("PROVIDER"))]"" $P(PSOX("NRX0"),"^",4)=PSOX("PROVIDER")
        I $G(PSORNSPD),$G(PSOX("PATIENT STATUS")),$G(PSOX("PATIENT STATUS"))?.N S $P(PSOX("NRX0"),"^",3)=PSOX("PATIENT STATUS")
        S:$G(PSOX("COSIGNING PROVIDER"))]"" $P(PSOX("NRX3"),"^",3)=PSOX("COSIGNING PROVIDER")
        S $P(PSOX("NRX0"),"^",5)=PSOX("CLINIC"),$P(PSOX("NRX0"),"^",9)=PSOX("# OF REFILLS")
        I $G(PSOX("DAYS SUPPLY")) S $P(PSOX("NRX0"),"^",8)=PSOX("DAYS SUPPLY")
        I $G(PSOX("QTY")) S $P(PSOX("NRX0"),"^",7)=PSOX("QTY")
        S $P(PSOX("NRX0"),"^",11)=$S(PSOX("FILL DATE")>DT&($P(PSOPAR,"^",6)):"M",$D(PSOX("MAIL/WINDOW")):PSOX("MAIL/WINDOW"),1:$P(PSOX("NRX0"),"^",11))
        S $P(PSOX("NRX0"),"^",13)=PSOX("ISSUE DATE"),$P(PSOX("STA"),"^")=PSOX("STATUS"),$P(PSOX("NRX0"),"^",16)=$S($G(PSOX("CLERK CODE"))]"":PSOX("CLERK CODE"),1:DUZ)
        S $P(PSOX("NRX0"),"^",17)=$G(PSODRUG("COST"))
        S $P(PSOX("NRX2"),"^")=PSOX("LOGIN DATE"),$P(PSOX("NRX2"),"^",2)=PSOX("FILL DATE"),$P(PSOX("NRX2"),"^",3)="",$P(PSOX("NRX2"),"^",4)="",$P(PSOX("NRX2"),"^",5)=PSOX("DISPENSED DATE")
        S $P(PSOX("NRX2"),"^",6)=PSOX("STOP DATE"),$P(PSOX("NRX2"),"^",7)=$S($G(PSOX("NDC"))]"":PSOX("NDC"),1:$G(PSODRUG("NDC")))
        S $P(PSOX("NRX2"),"^",8)=$S($G(PSOX("MANUFACTURER"))]"":PSOX("MANUFACTURER"),1:$G(PSODRUG("MANUFACTURER")))
        S $P(PSOX("NRX2"),"^",9)=+PSOSITE,$P(PSOX("NRX2"),"^",10)=""
        S $P(PSOX("NRX2"),"^",11)=$S($G(PSOX("EXPIRATION DATE"))]"":PSOX("EXPIRATION DATE"),1:$G(PSODRUG("EXPIRATION DATE")))
        S:$G(PSOX("GENERIC PROVIDER"))]"" $P(PSOX("NRX2"),"^",12)=PSOX("GENERIC PROVIDER")
        S $P(PSOX("NRX2"),"^",13)="",$P(PSOX("NRX2"),"^",15)="",$P(PSOX("NRX3"),"^",4)=$P(PSOX("NRX3"),"^")
        S $P(PSOX("EPH"),"^")=$S($G(PSOX("DAW"))]"":PSOX("DAW"),1:$G(PSODRUG("DAW")))
        ;S PSOX("LAST DISPENSED DATE")=$P(PSOX("NRX3"),"^")
        S PSOX("LAST DISPENSED DATE")=PSOX("DISPENSED DATE")
        S $P(PSOX("NRX3"),"^")=PSOX("LAST DISPENSED DATE")
        S:$G(PSOX("NEXT POSSIBLE REFILL"))]"" $P(PSOX("NRX3"),"^",2)=PSOX("NEXT POSSIBLE REFILL")
        S:'$P(^VA(200,$P(PSOX("NRX0"),"^",4),"PS"),"^",7) $P(PSOX("NRX3"),"^",3)=""
        S:$G(PSOX("REMARKS"))']"" PSOX("REMARKS")="RENEWED FROM RX # "_$P(PSOX("RX0"),"^")
        S $P(PSOX("NRX3"),"^",7)=PSOX("REMARKS"),$P(PSOX("NRX3"),"^",8)=""
        ;
        ; - File OTHER PATIENT INSTRUCTIONS into ^PSRX
        I $G(PSOFXRNX) S PSOFXRN=1
        D ^PSORN52C,FILE^PSORN52D
        I $G(^PSRX(PSOX("OIRXN"),"INSS"))]"" S ^PSRX(PSOX("IRXN"),"INSS")=^PSRX(PSOX("OIRXN"),"INSS") K PSOX1 G F55
        I $G(PSOX("SINS"))]"" S ^PSRX(PSOX("IRXN"),"INSS")=PSOX("SINS")
        K PSOX1
        ;
        ; - File data into ^PS(55)
F55     L +^PS(55,PSODFN,"P"):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) S:'$D(^PS(55,PSODFN,"P",0)) ^(0)="^55.03PA^^"
        F PSOX1=$P(^PS(55,PSODFN,"P",0),"^",3):1 Q:'$D(^PS(55,PSODFN,"P",PSOX1))
        S PSOX("55 IEN")=PSOX1
        S ^PS(55,PSODFN,"P",PSOX1,0)=PSOX("IRXN"),$P(^PS(55,PSODFN,"P",0),"^",3,4)=PSOX1_"^"_($P(^PS(55,PSODFN,"P",0),"^",4)+1)
        S ^PS(55,PSODFN,"P","A",PSOX("STOP DATE"),PSOX("IRXN"))=""
        L -^PS(55,PSODFN,"P")
        K PSOX1
        ;
        ; - Patient Counseling questions
        I $G(OR0) D FULL^VALM1,COUN^PSONEW S PSONOOR=""
        I $D(^XUSEC("PSORPH",DUZ)) S DA=PSOX("IRXN"),DIE=52,DR="41////"_PSOCOU_";S:'X Y=""@1"";42////"_PSOCOUU_";@1" D ^DIE K DIE,DR
        ;
        ; - Re-indexing file 52 entry
        K DIK,DA S DIK="^PSRX(",DA=PSOX("IRXN") D IX1^DIK K DIK
        S DA=PSOX("IRXN") D ORC^PSORN52C
        Q
