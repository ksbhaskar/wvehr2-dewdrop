ORDV06  ; slc/dkm - OE/RR Report Extracts ;10/8/03  11:17
        ;;3.0;ORDER ENTRY RESULTS REPORTING;**109,118,167,208,215,274,243**;Dec 17, 1997;Build 242
        ;Pharmacy Extracts
RXA(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)     ;Active Outpatient Pharmacy
        ;Call to PSOHCSUM
        ;
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END,MAX
        . S BEG=0,END=9999999,MAX=9999
        . D GCPR^OMGCOAS1(DFN,"RXA",BEG,END,MAX)
        ;
        N ORRXSTAT,GO,PSOACT
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S PSOACT=1,ORRXSTAT="^ACTIVE^ACTIVE/SUSP^"
        D GET
        Q
RXOP(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)    ;All Outpatient Pharmacy
        ;Call to PSOHCSUM
        ;
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END,MAX
        . S BEG=0,END=9999999,MAX=9999
        . D GCPR^OMGCOAS1(DFN,"RXOP",BEG,END,MAX)
        ;
        N ORRXSTAT,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORRXSTAT=""
        D GET
        Q
GET     N J,ORDT,ORI,ORDRGIEN,ORDRG,ORRXNO,ORSTAT,ORQTY,OREXP,ORISSUE,ORLAST,ORREF,ORPRVD,ORCOST,ORSIG
        N ECD,GMR,GMW,IX,PSOBEGIN,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        S PSOBEGIN=0
        K ^TMP("ORDATA",$J)
        I '$L($T(GCPR^OMGCOAS1)) D
        . K ^TMP("PSOO",$J)
        . D @GO
        S (ORDT,ORI)=0
        F  S ORDT=$O(^TMP("PSOO",$J,ORDT)) Q:(ORDT'>0)  S ORX0=$G(^(ORDT,0)) I ORX0'="" D
        . I $L(ORRXSTAT),ORRXSTAT'[(U_$P($P(ORX0,U,5),";",2)) Q  ;Check status
        . S ORI=ORI+1
        . S SITE=$S($L($G(^TMP("PSOO",$J,ORDT,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORDT,"WP",1)="1^"_SITE ;Station ID
        . S ^TMP("ORDATA",$J,ORDT,"WP",2)="2^"_$P($P(ORX0,U,3),";",2) ;Drug Name
        . S ^TMP("ORDATA",$J,ORDT,"WP",3)="3^"_$P($P(ORX0,U,3),";") ;Drug IEN
        . S ^TMP("ORDATA",$J,ORDT,"WP",4)="4^"_$P(ORX0,U,6) ;RX #
        . S ^TMP("ORDATA",$J,ORDT,"WP",5)="5^"_$P($P(ORX0,U,5),";",2) ;Status
        . S ^TMP("ORDATA",$J,ORDT,"WP",6)="6^"_$P(ORX0,U,7) ;Quantity
        . S ^TMP("ORDATA",$J,ORDT,"WP",7)="7^"_$$DATE^ORDVU($P(ORX0,U,11)) ;Exp/Cancel Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",8)="8^"_$$DATE^ORDVU($P(ORX0,U)) ;Issue Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",9)="9^"_$$DATE^ORDVU($P(ORX0,U,2)) ;Last Fill Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",10)="10^"_$P(ORX0,U,8) ;#Refills
        . S ^TMP("ORDATA",$J,ORDT,"WP",11)="11^"_$P($P(ORX0,U,4),";",2) ;Provider
        . S ^TMP("ORDATA",$J,ORDT,"WP",12)="12^"_$P(ORX0,U,10) ;Cost-fill
        . S ^TMP("ORDATA",$J,ORDT,"WP",15)="15^"_$P(ORX0,U,9) ;PharmID
        . S ^TMP("ORDATA",$J,ORDT,"WP",16)="16^"_$P(ORX0,U,11) ;Order Number
        . S J=0
        . F  S J=$O(^TMP("PSOO",$J,ORDT,J)) Q:'J  D
        ..S X=^(J,0),^TMP("ORDATA",$J,ORDT,"WP",14,J)="14^"_X
        K ^TMP("PSOO",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RXAV(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)    ;Active IV Pharmacy
        ;Call to ENHS^PSJEEU0
        N ORIVSTAT,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORIVSTAT="^ACTIVE^"
        D GET1
        Q
RXIV(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)    ;  All IV Pharmcy
        ;Call to ENHS^PSJEEU0
        N ORIVSTAT,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORIVSTAT=""
        D GET1
        Q
GET1    N ORDT,ORI,ORX0,ORIDRG,ORDRGIEN,ORDRG,ORDOSE,ORREC,ORSTAT,ORSTRTDT,ORSTOPDT,ORROUT,ORSIG,ORWII,ORMORE
        N GMI,GMTSIDT,MAX,ON,PS,PSIVREA,PSJEDT,PSJNKF,PSJPFWD,TN,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        S PSJEDT=1,PSJNKF=1
        K ^TMP("ORDATA",$J),^UTILITY("PSG",$J),^UTILITY("PSIV",$J)
        D @GO
        S ORDT=-9999999,ORI=0
        F  S ORDT=$O(^UTILITY("PSIV",$J,ORDT)) Q:(ORDT="")  S ORX0=$G(^(ORDT,0)) I ORX0'="" D
        . I $L(ORIVSTAT),ORIVSTAT'[(U_$P($P(ORX0,U,4),";",2)_U) Q  ;Check status
        . S ORMORE=0,SITE=$S($L($G(^UTILITY("PSIV",$J,ORDT,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORDT,"WP",1)="1^"_SITE  ;Station ID
        . S ^TMP("ORDATA",$J,ORDT,"WP",6)="6^"_$$DATE^ORDVU($P(ORX0,U))  ;Start Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",7)="7^"_$$DATE^ORDVU($P(ORX0,U,2))  ;Stop Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",4)="4^"_$P(ORX0,U,5)  ;Rate
        . S ^TMP("ORDATA",$J,ORDT,"WP",5)="5^"_$P(ORX0,U,6)  ;Schedule JEH
        . S ORIDRG=0
        . F  S ORIDRG=$O(^UTILITY("PSIV",$J,ORDT,"A",ORIDRG)) Q:'ORIDRG  S ORREC=$G(^(ORIDRG)) S:ORIDRG>1 ORMORE=1 D  ;Additives
        .. S ^TMP("ORDATA",$J,ORDT,"WP",2,ORIDRG)="2^"_$P($P(ORREC,U),";",2)_"  "_$P(ORREC,U,2) ;Additive  Dose
        . S ORIDRG=0
        . F  S ORIDRG=$O(^UTILITY("PSIV",$J,ORDT,"S",ORIDRG)) Q:'ORIDRG  S ORREC=$G(^(ORIDRG)) S:ORIDRG>1 ORMORE=1 D  ;Solutions
        .. S ^TMP("ORDATA",$J,ORDT,"WP",3,ORIDRG)="3^"_$P($P(ORREC,U),";",2)_"  "_$P(ORREC,U,2) ;Solution  Dose
        . I ORMORE S ^TMP("ORDATA",$J,ORDT,"WP",8)="8^[+]" ;flag for detail
        K ^UTILITY("PSG",$J),^UTILITY("PSIV",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RXUD(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)    ;  Get Unit Dose Pharmacy Component
        ;Call to ENHS^PSJEEU0
        N J,ORDT,ORI,ORX0,ORDRGIEN,ORDRG,ORDOSE,ORSTAT,ORSTRTDT,ORSTOPDT,ORROUT,ORSIG,GO
        N GMI,IX,MAX,ON,PS,PSIVREA,PSJEDT,PSJNKF,PSJPFWD,GMR,TN,UDS,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        S PSJEDT=1,PSJNKF=1
        K ^TMP("ORDATA",$J),^UTILITY("PSG",$J),^UTILITY("PSIV",$J)
        D @GO
        S ORDT=-9999999,ORI=0
        F  S ORDT=$O(^UTILITY("PSG",$J,ORDT)) Q:(ORDT="")  S ORX0=$G(^(ORDT)) I ORX0'="" D
        . S SITE=$S($L($G(^UTILITY("PSG",$J,ORDT,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORDT,"WP",1)="1^"_SITE  ;Station ID
        . S ^TMP("ORDATA",$J,ORDT,"WP",2)="2^"_$P($P(ORX0,U,3),":")  ;DRUG IEN
        . S ^TMP("ORDATA",$J,ORDT,"WP",3)="3^"_$P($P(ORX0,U,3),";",2)  ;Drug Name
        . S ^TMP("ORDATA",$J,ORDT,"WP",4)="4^"_$P(ORX0,U,6)  ;Dose
        . S ^TMP("ORDATA",$J,ORDT,"WP",5)="5^"_$P($P(ORX0,U,5),";",2)  ;Status
        . S ^TMP("ORDATA",$J,ORDT,"WP",6)="6^"_$$DATE^ORDVU($P(ORX0,U))  ;START Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",7)="7^"_$$DATE^ORDVU($P(ORX0,U,2))  ;Stop Date
        . S ^TMP("ORDATA",$J,ORDT,"WP",8)="8^"_$P($P(ORX0,U,7),";",3)  ;Route
        . S ^TMP("ORDATA",$J,ORDT,"WP",9)="9^"_$P(ORX0,U,8)  ;SIG
        K ^UTILITY("PSG",$J),^UTILITY("PSIV",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
