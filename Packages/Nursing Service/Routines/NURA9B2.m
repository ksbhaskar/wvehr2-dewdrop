NURA9B2 ;HIRMFO/RM/YH,FT-AGE REPORT BY LOCATION BY POSITION ;3/27/97  10:02
 ;;4.0;NURSING SERVICE;**13**;Apr 25, 1997
 Q:'$D(^DIC(213.9,1,"OFF"))  Q:$P(^DIC(213.9,1,"OFF"),"^",1)=1
 S (NURQUIT,NURQUEUE,NUROUT)=0
 D EN1^NURSAUTL G QUIT:$G(NUROUT)
 I NURMDSW S DIC(0)="AEQZ",NURPLSCR=1 D EN5^NURSAGSP G:$G(NUROUT) QUIT
 I NURMDSW=0,NURPLSW=1 S NURPLSCR=1 D PRD^NURSAGSP K NURPLSCR I $G(NUROUT) G QUIT
 W ! D EN1^NURSAGSP G:$G(NUROUT) QUIT
 W ! D EN2^NURSAGSP G:$G(NUROUT) QUIT
 D EN3^NURSAGP0 W ! G QUIT:$G(NUROUT)
 S ZTDESC="Nursing Age Report by Location& Position",ZTRTN="START^NURA9B2" D EN7^NURSUT0 I POP!($D(ZTSK)) G QUIT
START ;
 K ^TMP("NURA",$J),^TMP($J),^TMP("NURLOC",$J) S NSEL="WS",(NURQUIT,NURSW1,NURSW1(1),NURPAGE,NTCT)=0,(NURNL1,NCATPOS)=""
 D SORT G:$G(NUROUT) QUIT U IO D NPRINT,FINCAT^NURAGE
QUIT K ^TMP("NURA",$J),^TMP($J) D CLOSE^NURSUT1,^NURAKILL
 Q
NPRINT F NURI=1:1:8 S (NURSMOLD(NURI),NURSPOLD(NURI),NURSOLD(NURI),NURSFOLD(NURI),NURSWOLD(NURI))=0
 S NURFAC="" F  S NURFAC=$O(^TMP($J,"L",NURFAC)) Q:NURFAC=""  D NL Q:NURQUIT  D:NURMDSW FSUBTL^NURAGE Q:NURQUIT
 Q
NL S NURSPROG="" F  S NURSPROG=$O(^TMP($J,"L",NURFAC,NURSPROG)) Q:NURSPROG=""  D NM  Q:NURQUIT  D:NURPLSW PSUBTL^NURAGE Q:NURQUIT
 Q
NM S NURNL1="" F  S NURNL1=$O(^TMP($J,"L",NURFAC,NURSPROG,NURNL1)) Q:NURNL1=""  D HDGING^NURAGE Q:NURQUIT  D NN Q:NURQUIT  D WRTWARD^NURAGE Q:NURQUIT
 Q
NN S NPRI="" F  S NPRI=$O(^TMP($J,"L",NURFAC,NURSPROG,NURNL1,NPRI)) Q:NPRI=""  D NR Q:NURQUIT
 Q
NR S NCATPOS="" F  S NCATPOS=$O(^TMP($J,"L",NURFAC,NURSPROG,NURNL1,NPRI,NCATPOS)) Q:NCATPOS=""  S NURSORT=$G(^(NCATPOS)) I NURSORT D:NURSW1 HDGBYP^NURAGE D NO Q:NURQUIT  D WRTCAT^NURAGE Q:NURQUIT
 Q
NO S NURDOB="" F  S NURDOB=$O(^TMP($J,"L1",NURSORT,NURDOB)) Q:NURDOB=""  D NP Q:NURQUIT
 Q
NP S NURN1="" F  S NURN1=$O(^TMP($J,"L1",NURSORT,NURDOB,NURN1)) Q:NURN1=""  D NQ Q:NURQUIT
 Q
NQ S DA="" F  S DA=$O(^TMP($J,"L1",NURSORT,NURDOB,NURN1,DA)) Q:DA=""  D ^NURAGE Q:NURQUIT
 Q
SORT W ! S NRPT=7 D EN4^NURAAGS0
 I $O(^TMP($J,""))="",'$D(NURSNLOC) S NUROUT=1 S NURSPROG=$S($G(NURSPROG)=0:NURSPROG(1),1:" BLANK"),NURFAC=$S($G(NURFAC)=0:NURFAC(1),1:" BLANK") D HDGING^NURAGE W !!,"THERE IS NO DATA FOR THIS REPORT"
 I $O(^TMP($J,""))="",$D(NURSNLOC) S NUROUT=1,NURSPROG=$S($G(NURSPROG)=0:NURSPROG(1),1:" BLANK"),NURFAC=$S($G(NURFAC)=0:NURFAC(1),1:" BLANK") D HDGING^NURAGE S NURNL1="" F  S NURNL1=$O(NURSNLOC(NURNL1)) Q:NURNL1=""  S NL1=NURNL1 D NODATA^NURSUT1
 I $O(^TMP($J,""))'="",$D(NURSNLOC) D  I NURSW1=1 D ENDPG^NURSUT1 S NURSW1=0
 .  S (NURY,NURZ,NURX)="" F  S NURY=$O(^TMP($J,"L",NURY)) Q:NURY=""  F  S NURZ=$O(^TMP($J,"L",NURY,NURZ)) Q:NURZ=""  F  S NURX=$O(^TMP($J,"L",NURY,NURZ,NURX)) Q:NURX=""  S ^TMP("NURLOC",$J,NURX)=""
 .  S NURNL1="" F  S NURNL1=$O(NURSNLOC(NURNL1)) Q:NURNL1=""  I '$D(^TMP("NURLOC",$J,NURNL1)) D
 .  .  S NURSPROG=$S($G(NURSPROG)=0:NURSPROG(1),1:" BLANK"),NURFAC=$S($G(NURFAC)=0:NURFAC(1),1:" BLANK") D:NURSW1=0 HDGING^NURAGE S NL1=NURNL1 D NODATA^NURSUT1
 .  .  Q
 .  Q
 Q
