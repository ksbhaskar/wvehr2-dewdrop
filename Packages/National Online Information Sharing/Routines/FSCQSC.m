FSCQSC ;SLC/STAFF-NOIS Query Search Contains ;4/22/94  11:58
 ;;1.1;NOIS;;Sep 06, 1998
 ;
CON ; from FSCQS
 S VALUE=$$UP^XLFSTR(VALUE)
 I LIST=1 D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S CVALUE=$P($G(^FSCD("CALL",CALL,NODE)),U,PIECE) I $L(CVALUE),$$UP^XLFSTR(CVALUE)[VALUE X ACTION
 I LIST=0 D  Q
 .S CVALUE="" F  S CVALUE=$O(^FSCD("CALL",INDEX,CVALUE)) Q:CVALUE=""  I $$UP^XLFSTR(CVALUE)[VALUE D
 ..S CALL=0 F  S CALL=$O(^FSCD("CALL",INDEX,CVALUE,CALL)) Q:CALL<1  D
 ...I $D(^TMP("FSC USELIST",$J,CALL)) X ACTION
 I LIST="" D  Q
 .S CVALUE="" F  S CVALUE=$O(^FSCD("CALL",INDEX,CVALUE)) Q:CVALUE=""  I $$UP^XLFSTR(CVALUE)[VALUE D
 ..S CALL=0 F  S CALL=$O(^FSCD("CALL",INDEX,CVALUE,CALL)) Q:CALL<1  X ACTION
 Q
NCON ; from FSCQS
 S VALUE=$$UP^XLFSTR(VALUE)
 I LIST=1 D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S CVALUE=$P($G(^FSCD("CALL",CALL,NODE)),U,PIECE) I $L(CVALUE),$$UP^XLFSTR(CVALUE)'[VALUE X ACTION
 I LIST=0 D  Q
 .S CVALUE="" F  S CVALUE=$O(^FSCD("CALL",INDEX,CVALUE)) Q:CVALUE=""  I $$UP^XLFSTR(CVALUE)'[VALUE D
 ..S CALL=0 F  S CALL=$O(^FSCD("CALL",INDEX,CVALUE,CALL)) Q:CALL<1  D
 ...I $D(^TMP("FSC USELIST",$J,CALL)) X ACTION
 I LIST="" D  Q
 .S CVALUE="" F  S CVALUE=$O(^FSCD("CALL",INDEX,CVALUE)) Q:CVALUE=""  I $$UP^XLFSTR(CVALUE)'[VALUE D
 ..S CALL=0 F  S CALL=$O(^FSCD("CALL",INDEX,CVALUE,CALL)) Q:CALL<1  X ACTION
 Q
