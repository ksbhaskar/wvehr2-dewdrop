FSCRPCSF ;SLC/STAFF-NOIS RPC Static File ;2/21/97  17:31
 ;;1.1;NOIS;;Sep 06, 1998
 ;
FILE(IN,OUT) ; from FSCRPX (RPCStaticFile)
 N FILE,NUM
 S FILE=$P($G(^TMP("FSCRPC",$J,"INPUT",1)),U,1)
 I '$L(FILE) Q
 I FILE="SPEC" D SPEC Q
 I FILE="FORMAT_SORT" D SORT Q
 I FILE="FORMAT_DISPLAY" D DISPLAY Q
 I '$D(^FSC(FILE,0)) Q
 S NUM=0 F  S NUM=$O(^FSC(FILE,NUM)) Q:NUM<1  S ^TMP("FSCRPC",$J,"OUTPUT",NUM)=NUM_U_^(NUM,0)
 Q
 ;
SPEC ;
 N DATA,NUM,UNUM
 S NUM=0
 S UNUM=0 F  S UNUM=$O(^FSC("SPEC",UNUM)) Q:UNUM<1  S DATA=$G(^(UNUM,0)) I $L(DATA) D
 .S NUM=NUM+1
 .S ^TMP("FSCRPC",$J,"OUTPUT",NUM)=UNUM_U_$P($G(^VA(200,UNUM,0)),U)_$P(DATA,U,2,99)
 Q
 ;
SORT ;
 N DESCEND,FIELD,LINE,LINE1,NUM,SUBNUM
 S NUM=0 F  S NUM=$O(^FSC("FORMAT",NUM)) Q:NUM<1  S LINE=$G(^(NUM,0)) I $P(LINE,U,2)="S" D
 .S FIELD="",DESCEND=""
 .S SUBNUM=0 F  S SUBNUM=$O(^FSC("FORMAT",NUM,2,SUBNUM)) Q:SUBNUM<1  S LINE1=$G(^(SUBNUM,0)) D
 ..I +LINE1<1 Q
 ..S DESCEND=$P(LINE1,U,8) I 'DESCEND S DESCEND=0
 ..S FIELD=FIELD_$P(LINE1,U)_":"_DESCEND_";"
 .S ^TMP("FSCRPC",$J,"OUTPUT",NUM)=NUM_U_LINE S $P(^(NUM),U,7)=FIELD
 Q
 ;
DISPLAY ;
 N FIELD,LINE,LINE1,NUM,SUBNUM
 S NUM=0 F  S NUM=$O(^FSC("FORMAT",NUM)) Q:NUM<1  S LINE=$G(^(NUM,0)) I $P(LINE,U,2)="F" D
 .S FIELD=""
 .S SUBNUM=0 F  S SUBNUM=$O(^FSC("FORMAT",NUM,2,SUBNUM)) Q:SUBNUM<1  S LINE1=$G(^(SUBNUM,0)) D
 ..I +LINE1<1 Q
 ..S FIELD=FIELD_$P(LINE1,U)_";"
 .S ^TMP("FSCRPC",$J,"OUTPUT",NUM)=NUM_U_LINE S $P(^(NUM),U,7)=FIELD
 Q
