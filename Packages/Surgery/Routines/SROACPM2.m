SROACPM2        ;BIR/MAM - LAB INFO ;03/29/04
        ;;3.0; Surgery ;**125,153,174**;24 Jun 93;Build 8
        F SHEMP=201,202,202.1 S SRA(SHEMP)=$G(^SRF(SRTN,SHEMP))
        S SHEMP=$P(SRA(201),"^",21),SRAO(1)=SHEMP_"^^457^457.1" S X=$P(SRA(202),"^",21) I X="NS" S $P(SRAO(1),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(1),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",25),SRAO(2)=SHEMP_"^^461^461.1" S X=$P(SRA(202),"^",25) I X="NS" S $P(SRAO(2),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(2),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",26),SRAO(3)=SHEMP_"^^462^462.1" S X=$P(SRA(202),"^",26) I X="NS" S $P(SRAO(3),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(3),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",22),SRAO(4)=SHEMP_"^^458^458.1" S X=$P(SRA(202),"^",22) I X="NS" S $P(SRAO(4),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(4),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",23),SRAO(5)=SHEMP_"^^459^459.1" S X=$P(SRA(202),"^",23) I X="NS" S $P(SRAO(5),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(5),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",24),SRAO(6)=SHEMP_"^^460^460.1" S X=$P(SRA(202),"^",24) I X="NS" S $P(SRAO(6),"^",2)="NS"
        I X D DATE S SHEMP="("_Y_")",$P(SRAO(6),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",4),SRAO(7)=SHEMP_"^^223^290" S X=$P(SRA(202),"^",4) I X D DATE S SHEMP="("_Y_")",$P(SRAO(7),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",8),SRAO(8)=SHEMP_"^^225^292" S X=$P(SRA(202),"^",8) I X D DATE S SHEMP="("_Y_")",$P(SRAO(8),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",20),SRAO(9)=SHEMP_"^^219^239" S X=$P(SRA(202),"^",20) I X D DATE S SHEMP="("_Y_")",$P(SRAO(9),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",28),SRAO(10)=SHEMP_"^^504^504.1" S X=$P(SRA(202.1),"^") I X D DATE S SHEMP="("_Y_")",$P(SRAO(10),"^",2)=SHEMP
        S SHEMP=$P(SRA(201),"^",29),SRAO(11)=SHEMP_"^^507^507.1" S X=$P(SRA(202.1),"^",2) I X D DATE S SHEMP="("_Y_")",$P(SRAO(11),"^",2)=SHEMP
        K SRA
        Q
DATE    S Y=X X ^DD("DD")
        Q
