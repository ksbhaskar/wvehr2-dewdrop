ICD1834A ;ALB/MJB - ADD NON CC CODE ; 06/11/08 4:07pm
 ;;18.0;DRG Grouper;**34**;Oct 20, 2000;Build 4
 Q
POST ;entry point to add CODE NOT CC WITH 303.00 to 291.81
 ; and code 428.0 to code 425.4
 N SDA,ICDFLG
 N SDA
 S SDA(1)="",SDA(2)=" Adding CODE NOT CC WITH(#80.03) in the "
 S SDA(3)=" ICD DIAGNOSIS file (# 80)for codes 291.81/425.4"  D ATADDQ
 ;
 N ICDA
 S ICDA=0,ICDFLG=0
 F  S ICDA=$O(^ICD9("ACC",13227,ICDA)) Q:ICDFLG!(ICDA="")  D
 .I ICDA=8814 D ICDADDQ S ICDFLG=1 Q
 ;
EN ;start update
 N DIC,X,DA
 S DIC="^ICD9(13227,"_"2,",DA(1)=2,X=8814,DIC(0)="X"
 I '$D(^ICD9("ACC",13227,X)) D
 . D FILE^DICN
 .S ^ICD9("ACC",13227,X)=""
 .N SDA
 .S SDA(1)="",SDA(2)="    CODE ADDED.....",SDA(3)="" D ATADDQ
 .Q
 ;
EN1 ;start update
 N ICDA
 S ICDA=0,ICDFLG=0
 F  S ICDA=$O(^ICD9("ACC",2535,ICDA)) Q:ICDFLG!(ICDA="")  D
 .I ICDA=9061 D ICDADDQ S ICDFLG=1 Q
 ;
 N DIC,X,DA
 S DIC="^ICD9(2535,"_"2,",DA(1)=2,X=9061,DIC(0)="X"
 I '$D(^ICD9("ACC",2535,X)) D
 . D FILE^DICN
 .S ^ICD9("ACC",2535,X)=""
 .N SDA
 .S SDA(1)="",SDA(2)="    CODE ADDED.....",SDA(3)="" D ATADDQ
 .Q
 Q
ICDADDQ ;
 N SDA
 S SDA(1)="",SDA(2)=" DUPLICATE CODE - CODE NOT ADDED" D ATADDQ
ATADDQ ;
 D MES^XPDUTL(.SDA) K SDA
 Q
 ;
