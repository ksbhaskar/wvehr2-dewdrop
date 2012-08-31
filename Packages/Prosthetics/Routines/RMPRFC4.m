RMPRFC4 ;HINES CIOFO/HNC - Create 668 Record; 2/06/09
        ;;3.0;PROSTHETICS;**83**;Feb 09, 1996;Build 20
        ;
        ;Helen Corkwell-new flow 3/9/05
        ;
        ; Patch 83 v18 - DC consult w/no 668 record error fixed
        ; Patch 83 v19 - DC consult properly display ****Discontinued**** in 668
        ;                NW no longer errors if there is no ICD9 data
        Q
EN      ;
        ;RMPRISIT is station ien to 4
        ;RMPR123A is consult ien to 123
        ;RMPRFORM is form type other
        ;RMPRTYPE is IFC new with patch
        ;RMPRSTAT is status, open
        ;RMPROPRO is ordering provider free text
        ;RMPRMPI is Master Patient Index
        ;RMPRDFN is DFN
        I RMPRST="NW" D
        .S RMPRMPI=$P($G(^TMP("RMPRIF",$J,"PID")),"|",2)
        .S RMPRDFN=$$GETDFN^MPIF001(RMPRMPI)
        I $D(^TMP("RMPRIF",$J,"OBX",1)) D
        . D TRIMWP^RMPRFC5($NA(^TMP("RMPRIF",$J,"OBX",1)),5)
        ;return sample
        ;^TMP("RMPRIF",570428439,"OBX",1,1) = Test #2
        ;
        ;ICD9
        I RMPRST="NW" D
        .S RMPRPD9=$P($G(^TMP("RMPRIF",$J,"OBX",2,1)),"|",5)
        .I RMPRPD9="" S RMPRICD9=""
        .I RMPRPD9'="" S RMPRICD9=$P(RMPRPD9,U,1)
        .I RMPRICD9="" S RMPRICD=""
        .I RMPRICD9'="" S RMPRICD=$$ICDDX^ICDCODE(RMPRICD9,DT)
        .;date rx written
        .S RMPRDRXW=$P($G(^TMP("RMPRIF",$J,"OBR")),"|",6)
        .I RMPRDRXW'="" S RMPRDRXW=$$FMDATE^HLFNC(RMPRDRXW)
        .;
        .S RMPRFORM=9
        .S RMPRTYPE=9
        .S RMPRSTAT="O"
        .S RMPROPRO=$P($G(^TMP("RMPRIF",$J,"OBR")),"|",16)
        .I RMPROPRO'="" S RMPROPRO=$P(RMPROPRO,U,1)_","_$P(RMPROPRO,U,2)_" "_$P(RMPROPRO,U,3)
        ;discontinued data from 1st 668 record
        I RMPRST="DC" D
        .S RMPR668=0
        .S RMPR668=$O(^RMPR(668,"D",RMPR123A,RMPR668))
        .I RMPR668="" S ^TMP("RMPRIF",$J,"RMPR668")="NOT DEFINED" Q
        .S RMPRICD=$P($G(^RMPR(668,RMPR668,8)),U,3)
        .S RMPRDIAG=$P($G(^RMPR(668,RMPR668,8)),U,2)
        .S RMPROPRO=$P($G(^RMPR(668,RMPR668,"IFC1")),U,3)
        .S RMPRDRXW=$P($G(^RMPR(668,RMPR668,0)),U,16)
        .S RMPRDFN=$P($G(^RMPR(668,RMPR668,0)),U,2)
        .; STATION NEEDS TO BE SAME AS ORIGINAL IFC, NOT WHAT IS IN ORC SEGMENT
        .S RMPRISIT=$P($G(^RMPR(668,RMPR668,0)),U,7)
        .S RMPRTYPE=10
        .S RMPRSTAT="O"
        .S RMPRFORM=9
        ;create new record
        ;
        I +$G(RMPRDFN)'>0 G EXIT  ;No patient
        ;
        I $D(^TMP("RMPRIF",$J,"RMPR668")) G EXIT
        D NOW^%DTC S X=%
        S DIC="^RMPR(668,",DIC(0)="L"
        K DD,DO D FILE^DICN
        S RMPRA=+Y
        ;
        S DA=+Y,DIE=DIC
        S DR="1////^S X=RMPRDFN;3////^S X=RMPRFORM;8////^S X=.5;2////^S X=RMPRISIT;9////^S X=RMPRTYPE;14////^S X=RMPRSTAT"
        D ^DIE
        ;
        ;check for discontinued or new
        ;
        I RMPRST="NW" D
        .S DR="27////^S X=RMPROPRO;20////^S X=RMPR123A;1.6////^S X=+RMPRICD;1.5////^S X=$P(RMPRPD9,U,2);22////^S X=RMPRDRXW"
        .D ^DIE
        ;
        I RMPRST="DC" D
        .S DR="27////^S X=RMPROPRO;20////^S X=RMPR123A;1.6////^S X=+RMPRICD;1.5////^S X=RMPRDIAG;22////^S X=RMPRDRXW"
        .D ^DIE
        ;
        ;for a new order
        ;Description of Item/Services
        I RMPRST="NW" D
        .S ^RMPR(668,RMPRA,2,0)="^^^"_DT_"^"
        .S RMPRL=0,RMPRLN=0
        .F  S RMPRL=$O(^TMP("RMPRIF",$J,"OBX",1,RMPRL)) Q:RMPRL=""  D
        .. S RMPRLN=RMPRLN+1,^RMPR(668,RMPRA,2,RMPRLN,0)=^TMP("RMPRIF",$J,"OBX",1,RMPRL)
        .S $P(^RMPR(668,RMPRA,2,0),"^",3)=RMPRLN
        ;
        I RMPRST="DC" D
        .S ^RMPR(668,RMPRA,2,0)="^^^"_DT_"^"
        .S ^RMPR(668,RMPRA,2,1,0)="****DISCONTINUED****"
        .S $P(^RMPR(668,RMPRA,2,0),"^",3)=1
        ;
EXIT    ;
        ;Clean up here
        K ^TMP("RMPRIF",$J)
        K RMPRST,RMPRA,RMPRLN,RMPRL
        K RMPR123,RMPR123A,RMPR123I,RMPRISIT
        K RMPRFORM,RMPRTYPE,RMPRSTAT,RMPROPRO,RMPRDFN,RMPRMPI,RMPRPD9,RMPRICD9
        K RMPRDRXW,RMPRDIAG,RMPR668,RMPRICD
        K RMPRDCIN,RMPRDPDC
        Q
