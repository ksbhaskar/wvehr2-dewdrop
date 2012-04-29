LEX2047B ; ISL/KER - Post Install LEX*2.0*47 (part 2)  ; 02/05/2007
 ;;2.0;LEXICON UTILITY;**47**;Sep 23, 1996;Build 5
 ;
 ; Global Variables
 ;    ^ICPT(           DBIA 4489
 ;    ^LEX(757.01      N/A
 ;    ^LEX(757.02      N/A
 ;    ^DIC(81.3,       DBIA 4492
 ;
 ; External References
 ;    FILE^DIE         DBIA 2053
 ;    UPDATE^DIE       DBIA 2053
 ;    ^DIK             DBIA 10013
 ;    IX1^DIK          DBIA 10013
 ;    $$IENS^DILF      DBIA 2054
 ;    MES^XPDUTL       DBIA 10141
 ;
EN ; Main Entry Point
 D C6,C7,C8,C9,C10,C11
 Q
C6 ;   161266 Canalith (HCPCS S9092) is misspelled
 D IND(" "),REMI("CANALITH (S9092) is misspelled","HD0000000 161266")
 D IND("    S9092 - Change CANOLITH to CANALITH")
 N IENS,IENA,IENB,IEN,LEXDA,DA,DIK,DIE
 K IENS,FDA S (IEN,DA)=329685,IENS=IEN_",",FDA(757.01,IENS,.01)="Canalith Repositioning, per visit" D FILE^DIE("","FDA") S DIK="^LEX(757.01," D IX1^DIK
 S (IEN,DA(1),LEXDA(1))=107092,(IENA,LEXDA,DA)=$O(^ICPT(IEN,61,"B",3030101,0)) I +IEN>0,+IENA>0 D
 . K IENS,FDA S IENS=$$IENS^DILF(.LEXDA),FDA(81.061,IENS,1)="CANALITH REPOSITIONING" K IENR,MSG D UPDATE^DIE("","FDA","IENR","MSG")
 S (IEN,DA(1),LEXDA(1))=107092,(IENA,LEXDA,DA)=$O(^ICPT(IEN,62,"B",3030101,0)) I +IEN>0,+IENA>0 D
 . K IENS,FDA N DA,I S DA(2)=LEXDA(1),DA(1)=LEXDA S I=0  F  S I=$O(^ICPT(DA(2),62,DA(1),1,I)) Q:+I'>0  D
 . . S DA=I Q:$G(^ICPT(DA(2),62,DA(1),1,DA,0))'["CANOLITH REPOSITIONING, PER VISIT"  N LEXDA S LEXDA(2)=DA(2),LEXDA(1)=DA(1),LEXDA=DA
 . . S IENS=$$IENS^DILF(.LEXDA),FDA(81.621,IENS,.01)="CANALITH REPOSITIONING, PER VISIT" K IENR,MSG D UPDATE^DIE("","FDA","IENR","MSG")
 I $D(^ICPT(107092,"D",1,0)) D
 . Q:$G(^ICPT(107092,"D",1,0))'["CANOLITH REPOSITIONING, PER VISIT"
 . S ^ICPT(107092,"D",1,0)="CANALITH REPOSITIONING, PER VISIT" K ^ICPT(107092,"D","B") S ^ICPT(107092,"D","B","CANALITH REPOSITIONING, PER VI",1)=""
 K IENS,DA,FDA S DA=IEN S FDA(81,IEN_",",2)="CANALITH REPOSITIONING" D FILE^DIE("","FDA") S DA=IEN,DIK="^ICPT(" D IX1^DIK
 Q
C7 ;   166892 CPT J0585 Botulinum Toxin Quantity
 D IND(" "),REMI("Botulinum Toxin Quantity (J0585)","HD0000000 166892")
 K IENS,FDA S (IEN,LEXDA,DA)=320347 S FDA(757.01,IEN_",",.01)="Botulinum toxin type A, per unit"
 D FILE^DIE("","FDA") S DA=IEN,DIK="^LEX(757.01," D IX1^DIK
 Q
C8 ;   168449 Lookup 038.9 returns 995.91
 D IND(" "),REMI("Lookup ICD 038.9 returns 995.91","HD0000000 168449")
 D REMI("Lookup ICD 038.9 returns 995.91 (dupe)","HD0000000 171316")
 N FDA,DA,DIK S DA=330020
 K FDA S FDA(757.02,(DA_","),6)=0 D FILE^DIE("","FDA")
 K FDA S FDA(757.02,(DA_","),4)=0 D FILE^DIE("","FDA") S DA=324672
 K FDA S FDA(757.02,(DA_","),6)=1 D FILE^DIE("","FDA")
 K FDA S FDA(757.02,(DA_","),4)=1 D FILE^DIE("","FDA")
 K FDA S FDA(757.02,(DA_","),5)="" D FILE^DIE("","FDA")
 S DA(1)=324672,DA=2 I $D(^LEX(757.02,DA(1),4,DA,0)) D
 . S DIK="^LEX(757.02,"_DA(1)_",4," D ^DIK
 K DA S DIK="^LEX(757.02,",DA=330020 D IX1^DIK S DA=324672 D IX1^DIK
 Q
C9 ;   174410 New dental code D2970
 D IND(" "),REMI("New Dental Code D2970","HD0000000 174410")
 N ACT,CPIEN,DA,DIC,DIE,DIK,EFF,EXIEN,EXIST,EXP,FDA,I,IEN,IENS,MSG,SOIEN,TXT S EXIEN=318447,IENS=EXIEN_","
 S EXP="Temporary Crown (Fractured Tooth), usually a preformed artificial Crown, fitted over a damaged tooth as an immediate protective device.  (not to be used as a temporization during crown fabrication)"
 K FDA S FDA(757.01,IENS,.01)=EXP D FILE^DIE("","FDA") K DA S DA=EXIEN,DIK="^LEX(757.01," D IX1^DIK
 K DA,DIK,DIC,FDA,IENS,ACT S SOIEN=254,ACT=3,EFF=3070101,IENS="+"_ACT_","_SOIEN_","
 S EXIST=$O(^LEX(757.02,SOIEN,4,"B",EFF,0)),EXIST=$P($G(^LEX(757.02,SOIEN,4,+EXIST,0)),"^",2)
 S FDA(757.28,IENS,.01)=EFF,FDA(757.28,IENS,1)=1 I '$L(EXIST)!(+EXIST'>0) D UPDATE^DIE("S","FDA",,("MSG("_SOIEN_")"))
 K DA,DIK,DIC,FDA,IENS,ACT S CPIEN=100384,EFF=3070101
 S IENS=CPIEN_",",FDA(81,IENS,2)="TEMPORARY CROWN (FX TOOTH)",FDA(81,IENS,5)="",FDA(81,IENS,7)=""
 S FDA(81,IENS,8)=EFF D UPDATE^DIE("S","FDA",,("MSG("_CPIEN_")"))
 K DA,DIK,DIC,FDA,IENS,ACT S ACT=3,IENS="+"_ACT_","_CPIEN_","
 S EXIST=$O(^ICPT(CPIEN,60,"B",EFF,0)),EXIST=$P($G(^ICPT(CPIEN,60,+EXIST,0)),"^",2)
 S FDA(81.02,IENS,.01)=EFF,FDA(81.02,IENS,.02)=1
 I '$L(EXIST)!(+EXIST'>0) D UPDATE^DIE("S","FDA",,("MSG("_CPIEN_")"))
 K DA,DIK,DIC,FDA,IENS,ACT,TXT S ACT=2,IENS="+"_ACT_","_CPIEN_",",TXT="TEMPORARY CROWN (FX TOOTH)"
 S EXIST=$O(^ICPT(CPIEN,61,"B",EFF,0)),EXIST=$P($G(^ICPT(CPIEN,61,+EXIST,0)),"^",2)
 S FDA(81.061,IENS,.01)=EFF,FDA(81.061,IENS,1)=TXT
 I '$L(EXIST) D UPDATE^DIE("S","FDA",,("MSG("_CPIEN_")"))
 K DA,DIK,DIC,FDA,IENS,ACT,TXT,IEN S ACT=2,IENS="+"_ACT_","_CPIEN_",",IEN=0
 S TXT(1)="TEMPORARY CROWN (FRACTURED TOOTH), USUALLY A PREFORMED ARTIFICIAL CROWN,"
 S TXT(2)="FITTED OVER A DAMAGED TOOTH AS AN IMMEDIATE PROTECTIVE DEVICE.  (NOT TO"
 S TXT(3)="BE USED AS A TEMPORIZATION DURING CROWN FABRICATION)"
 S EXIST=$O(^ICPT(CPIEN,62,"B",EFF,0)),EXIST=$P($G(^ICPT(CPIEN,62,+EXIST,0)),"^",1)
 S FDA(81.062,IENS,.01)=EFF I '$L(EXIST)!(EXIST'=EFF) D UPDATE^DIE("S","FDA",,("MSG("_CPIEN_")"))
 S IEN=$O(^ICPT(CPIEN,62,"B",EFF,0)) I +IEN>0 D
 . N DA,DIK,I S DA(2)=CPIEN,DA(1)=IEN S I=0 F  S I=$O(^ICPT(DA(2),62,DA(1),1,I)) Q:+I'>0  D
 . . S DIK="^ICPT("_DA(2)_",62,"_DA(1)_",1,",DA=I D ^DIK
 . S DA(2)=CPIEN,DA(1)=IEN S I=0 F  S I=$O(TXT(I)) Q:+I'>0  D
 . . Q:'$L($G(TXT(I)))  S ^ICPT(DA(2),62,DA(1),1,I,0)=$G(TXT(I))
 . . S DIK="^ICPT("_DA(2)_",62,"_DA(1)_",1,",DA=I D:+($G(CPIEN))>0&(+($G(IEN))>0)&(+($G(I))>0) IX1^DIK
 K DA,DIK S DA(1)=CPIEN,DA=IEN,DIK="^ICPT("_DA(1)_",62," D:+($G(CPIEN))>0&(+($G(IEN))>0) IX1^DIK
 Q
C10 ;   162142 - 63044 with RT
 ;   169057 - 63043-63044 with RT
 D IND(" "),REMI("CPT Modifier Ranges Added for RT/LT","HD0000000 161142")
 D REMI("CPT Modifier Ranges Added for RT/LT (similar)","HD0000000 169057")
 D IND("    CPT Range 63040")
 N MIEN,RIEN,VAL,NIEN
 S VAL="63040^63040^3070101^",MIEN=83,RIEN=0 F  S RIEN=$O(^DIC(81.3,MIEN,10,RIEN)) Q:+RIEN'>0  D
 . Q:$G(^DIC(81.3,MIEN,10,RIEN,0))'=VAL
 . N DA,DIK S DA(1)=MIEN,DA=RIEN,DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK K ^DIC(81.3,MIEN,10,RIEN,0)
 I '$D(^DIC(81.3,MIEN,"M",63040)) D
 . N NIEN S NIEN=$O(^DIC(81.3,MIEN,10," "),-1)+1,^DIC(81.3,MIEN,10,NIEN,0)=VAL,DA=MIEN,DIK="^DIC(81.3," D IX1^DIK
 S VAL="63042^63044^3070101^",MIEN=83,RIEN=0 F  S RIEN=$O(^DIC(81.3,MIEN,10,RIEN)) Q:+RIEN'>0  D
 . Q:$G(^DIC(81.3,MIEN,10,RIEN,0))'=VAL
 . N DA,DIK S DA(1)=MIEN,DA=RIEN,DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK K ^DIC(81.3,MIEN,10,RIEN,0)
 I '$D(^DIC(81.3,MIEN,"M",63042)) D
 . N NIEN S NIEN=$O(^DIC(81.3,MIEN,10," "),-1)+1,^DIC(81.3,MIEN,10,NIEN,0)=VAL,DA=MIEN,DIK="^DIC(81.3," D IX1^DIK
 D IND("    CPT Range 63042-63044")
 S VAL="63040^63040^3070101^",MIEN=109,RIEN=0 F  S RIEN=$O(^DIC(81.3,MIEN,10,RIEN)) Q:+RIEN'>0  D
 . Q:$G(^DIC(81.3,MIEN,10,RIEN,0))'=VAL
 . N DA,DIK S DA(1)=MIEN,DA=RIEN,DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK K ^DIC(81.3,MIEN,10,RIEN,0)
 I '$D(^DIC(81.3,MIEN,"M",63040)) D
 . N NIEN S NIEN=$O(^DIC(81.3,MIEN,10," "),-1)+1,^DIC(81.3,MIEN,10,NIEN,0)=VAL,DA=MIEN,DIK="^DIC(81.3," D IX1^DIK
 S VAL="63042^63044^3070101^",MIEN=109,RIEN=0 F  S RIEN=$O(^DIC(81.3,MIEN,10,RIEN)) Q:+RIEN'>0  D
 . Q:$G(^DIC(81.3,MIEN,10,RIEN,0))'=VAL
 . N DA,DIK S DA(1)=MIEN,DA=RIEN,DIK="^DIC(81.3,"_DA(1)_",10," D ^DIK K ^DIC(81.3,MIEN,10,RIEN,0)
 I '$D(^DIC(81.3,MIEN,"M",63042)) D
 . N NIEN S NIEN=$O(^DIC(81.3,MIEN,10," "),-1)+1,^DIC(81.3,MIEN,10,NIEN,0)=VAL,DA=MIEN,DIK="^DIC(81.3," D IX1^DIK
 Q
C11 ;   173816 - Re-Code Hyperglycemia as ICD 790.29
 D IND(" "),REMI("Re-Code ""Hyperglycemia"" as ICD Code 790.29","HD0000000 173816")
 N DA,DIE,DIK,EFF,EXIST,FDA,IEN,IENE,IENS,TXT
 K FDA,IENS,IEN,DA,DIK S IEN=63620,IENS=IEN_","
 S FDA(757.02,IENS,1)=790.29 D FILE^DIE("","FDA") S DA=IEN,DIK="^LEX(757.02," D IX1^DIK
 K FDA,IENS,IEN,DA,DIK S IEN=329955,IENS=IEN_","
 S FDA(757.01,IENS,.01)="Abnormal Glucose" D FILE^DIE("","FDA") S DA=IEN,DIK="^LEX(757.01," D IX1^DIK
 Q
 ;
 ; Miscellaneous
REMI(X,Y) ;   Remedy Ticket - Indented
 N I S X=$G(X),Y=$G(Y) Q:'$L(X)
 I $L(Y) S X="    "_X F  Q:$L(X)>54  S X=X_" "
 S X=X_" "_Y S:$E(X,1)'=" " X="    "_X D MES^XPDUTL(X) Q
IND(X) ;   Indent Text
 N I S X=$G(X) Q:'$L(X)  S X="    "_X D MES^XPDUTL(X) Q
