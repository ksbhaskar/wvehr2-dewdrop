RMPRU99 ;HINCIO/HNC - HISTORICAL ITEM TRIGGER; 9/28/04 12:27pm
 ;;3.0;PROSTHETICS;**99**,FEB 09,1996
EN ;
 ;X=ien 661, DA=ien 660
 N RMPRITE,RMPR441
 S RMPR441=$P($G(^RMPR(661,X,0)),U,1)
 I RMPR441="" S X="" Q
 S RMPRITE=$P($G(^PRC(441,RMPR441,0)),U,2)
 S X=RMPRITE
 Q
DEL ;
 Q
XREF ;
 W !!,"Setting Cross Reference..."
 S DIK="^RMPR(660,",DIK(1)="4" D ENALL^DIK
 ;END
