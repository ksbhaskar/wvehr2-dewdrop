LBRYHIS0 ;ISC2/DJM-HISTORY OF CHECK-IN OUTPUT MSG ;[ 06/26/96  12:05 PM ]
 ;;2.5;Library;**2**;Mar 11, 1996
 ;
START F I=1:1:7 S LS(I)=""
 S XT1=$S($D(^LBRY(680,DA,16,0)):1,1:0),XT2=$S($D(A(E0-1)):1,1:0),XT3=$S($D(A(E1+1)):1,1:0),XT4=$S($D(A(1)):1,1:0),LS(1)="Choose: " S:XT4 LS(2)=$C(34)_"ID NUM"_$C(34)_" to see history of check-in"
 S:XT1 LS(5)="see check-in (N)otes" S:XT2 LS(6)="(B)ackup" S:XT3 LS(7)="(F)orward"
 S (LINE1,LINE2)="" F I=1:1:7 Q:$L(LINE1)+$L(LS(I))'<78  S:LS(I)]"" LINE1=LINE1_LS(I) K LS(I) I I>1&($D(LS(I+1))) S:LS(I+1)]"" LINE1=LINE1_", "
 I '$D(LS(7)) S LINE1=LINE1_"." G PRINT
 F J=I:1:7 S:LS(J)]"" LINE2=LINE2_LS(J) K LS(J) I J<7&($D(LS(J+1))) S:LS(J+1)]"" LINE2=LINE2_", "
 S LINE2=LINE2_"."
PRINT W !!,LINE1,! W:$D(LINE2) LINE2,! W "Exit// "
EXIT K LINE1,LINE2,I,J Q
 ;LIBRARY SERIALS WHAT-TO-DO PROMPT (FROM LBRYHIS)
ASK3 S DTOUT=0 R X:DTIME E  W $C(7) S DTOUT=1 G ^LBRYHIS
 I X="" G ^LBRYHIS
 I X=" " S:$D(^TMP("LBRY",DUZ,4)) X=^(4)
 I X="??" S XQH="LBRY SERIALS VIEW" D EN^XQH G DISPLAY^LBRYHIS
 I X="^" G ^LBRYHIS
 I $D(A(E0-1)),"Bb"[$E(X,1) D BACKUP^LBRYCK0 G DISPLAY^LBRYHIS
 I $D(A(E1+1)),"Ff"[$E(X,1) D FORWARD^LBRYCK0 G DISPLAY^LBRYHIS
 I $D(^LBRY(680,DA,16,0)),"Nn"[X D UTIL,^LBRYHIS2 G DISPLAY^LBRYHIS
ASK2 I $D(A(X)) D UTIL G ^LBRYHIS1
WRONG S E=0,XTA="",XTB="",XTC="",XTD="",XTE="" S:$D(A(1)) XTA="a number under heading "_$C(34)_"ID NUM"_$C(34)
 S XTC=$S(XT1&((XT2)!(XT3)):", N",1:""),XTD=$S(XT2&(XT3):", B or F.",XT2!(XT3):" or ",1:".") G:XTD["." WRONG1
 S XTE=$S(XT2:"B.",XT3:"F.",1:"")
WRONG1 W !!,"Enter "_XTA_XTB_XTC_XTD_XTE,!,"Enter '??' for more help.",!!,"Choose: Exit// " D MORE^LBRYHIS G ASK3
UTIL K ^TMP("LBRY",DUZ,4) S ^(4)=X Q
