RCXVDC7 ;TJK/ALBANY OI @ALTOONA, PA-AR Data Extraction Data Creation ;02-JUL-03
 ;;4.5;Accounts Receivable;**228,243**;Mar 20, 1995
 ;
 ; IB Bill/Claims Prosthetics File (362.5)
 Q
D3625 ;
 NEW RCIBD,RCT,RCXVDA,RCNT,RCBILL,RCPDATA,RCPDATE
 Q:'$G(RCXVD0)
 S RCIBD="" S RCIBD=$$IBAREXT^IBRFN4(RCXVD0,.RCIBD)
 S (RCT,RCNT)=0 F  S RCT=$O(RCIBD("PRD",RCT)) Q:'RCT  D
 . S RCPDATA=RCIBD("PRD",RCT)
 . S RCPDATE=$P(RCPDATA,U,2)
 . S RCPDATE=$E($$HLDATE^HLFNC(RCPDATE),1,8)
 . S RCBILL=$P(RCPDATA,U,3),RCBILL=$P($G(^DGCR(399,RCBILL,0)),U)
 . S RCXVDA=RCBILL_RCXVU_$P(RCPDATA,U)_RCXVU_RCPDATE ;BILL#,ITEM,DATE
 . S RCNT=RCNT+1
 . S ^TMP($J,RCXVBLN,"7-362.5A",RCNT)=RCXVDA
 . Q
 Q
 ;
