NURSUT4 ;HIRMFO/RM-UTILITIES FOR FILE 213.9 ;5/17/93
 ;;4.0;NURSING SERVICE;**20,22**;Apr 25, 1997
EN1 ; ENTRY FROM INPUT TRANSFORM FROM FIELDS 10.4 AND 10.5 ON FILE 213.9
 K:$L(X)>6!($L(X)<1)!'(X?1"T"!(X?1"N")!(X?1"T+"1.4N)!(X?1"T-"1.4N)!(X?1"N+"1.4N)!(X?1"N-"1.4N)) X
 Q
EN2 ; EXECUTABLE HELP FROM OPTION NURAAM-ACU GRADE/STEP CODE LOAD
 N DA,Y,X I $G(^NURSF(211.1,0))="" W !,$C(7),"NURS PAY SCALE FILE IS NOT RESIDENT CANNOT CONTINUE!!"
 K NUROUT,^TMP("NURCD",$J)
 D DISP
 W !!,"Enter Grade/Step Code",!,"examples: ",!,"R/E1/5 = Registered Nurse,ENTRY1,Step 5",!,"N/4/7 = Nursing Assistant,GS4,Step 7",!
QUIT K NURTAB,NURS,NURAQ,NUREND,NURP,NSCD,I,NURMAX,NCTR,NURI,NURMI
 Q
DISP ;
 K NURTAB,NSCD S NCTR=1,NSCD="",NURMAX=0
 F I=0:0 S NSCD=$O(^NURSF(211.1,"B",NSCD)) Q:NSCD=""  F DA=0:0 S DA=$O(^NURSF(211.1,"B",NSCD,DA)) Q:DA'>0  D
 .   S NURMAX=NURMAX+1,NSCD(NURMAX)=DA_"^"_NSCD
 .   Q
 S NURSTRT=1,(NUROUT,NURDONE)=0
 F  D DSP I $G(NURDONE)!$G(NUROUT) Q
 Q
DSP ;
 W @IOF S NURAQ=$Y
 F NURS=NURSTRT:3:NURMAX S NURI=NURS D  I $Y>(IOSL+NURAQ-10),NURS'=NURMAX S NURSTRT=NURS+3 Q
 .  Q:$D(NSCD(NURI))[0
 .  S NURI(0)=NURI+1,NURI(1)=NURI+2
 .   W ! W:$G(NSCD(NURI))'="" ?1,$J(NURI,2),". ",$P($G(NSCD(NURI)),U,2) W:$G(NSCD(NURI(0)))'="" ?26,$J(NURI(0),2),". ",$P($G(NSCD(NURI(0))),U,2) W:$G(NSCD(NURI(1)))'="" ?52,$J(NURI(1),2),". ",$P($G(NSCD(NURI(1))),U,2)
 .  Q
 S NURDONE=(NURS=NURMAX)!(NURS+2=NURMAX)
 I 'NURDONE W !,"<<More>>"
 W !,"Press the return key to continue or '^' to exit: " R NURX:DTIME I NURX="^" S NUROUT=1 Q
 G:NURDONE QUIT
 S:NURX["?" NURSTRT=1 G DSP:NURX["?"
 Q
EN3 ;INPUT TRANSFORM FOR FIELD 8 FILE 211.82
 K X W $C(7),!,"*** NOT YET IMPLEMENTED ***"
 Q
COMPDAT(D0) ; EXTRINSIC FUNCTION TO RETURN COMPUTED SERVICE COMPUTATION DATE
 ; FROM THE EMPLOYEE(#450) FILE
 N X,Y,NURY,NURX,NURZ
 S (NURCOMP,PRSPCDA)=0,NURX=+$G(^NURSF(210,+D0,0)),NURY=$P($G(^VA(200,+NURX,1)),U,9) S:NURY'="" PRSPCDA=$O(^PRSPC("SSN",NURY,0))
 S Y=$S(+PRSPCDA:$P($G(^PRSPC(PRSPCDA,0)),U,31),1:"")
 ;I +Y>0 S %DT="" D DD^%DT S NURCOMP=Y
 I +Y>0 S NURCOMP=Y
 S:NURCOMP=0 NURCOMP="" K PRSPCDA
 Q NURCOMP
VALENT ;
 S NURSBAD=0 F NURS1=1:1 S NURS2=$P(NURSX,",",NURS1) Q:NURS2=""  D VAL0 Q:NURSBAD
 Q
VAL0 I +NURS2>NURSMAX!(+NURS2<1) S NURSBAD=1
 I NURS2["-",$P(NURS2,"-")'?.N!($P(NURS2,"-",2)'?.N)!(+$P(NURS2,"-",2)>NURSMAX)!(+$P(NURS2,"-",2)<1)!(+NURS2>NURSMAX)!(+NURS2<1) S NURSBAD=1
 I NURS2'["-",NURS2'?.N!(+NURS2>NURSMAX)!(+NURS2<1) S NURSBAD=1
 I (NURSX["?"!(NURSBAD)) D  Q
 . W:NURSX'?2"?" !!,?5,$C(7),"Make a selection from the screen display, a range of numbers can be",!,?5,"selected by using a HYPHEN, multiple selections can be made by"
 . W !,?5,"separating them by COMMAS, ",$S($G(NURSNALL)'>0:"select ALL ",1:""),"or '^' to exit."
 . W:NURSX'?2"?" !,?15,"E.G. 1    1-2    1,3    1-2,4-5    1,3-4"
 . W:$G(NURSNALL)'>0 "    ALL"
 . W !,?22,"Are examples of valid selections" S:NURSX?2."?" NURSSTRT=1
 . Q
 Q
COMPDISP ; SERVICE COMP DATE DISPLAY
 N X,Y
 S Y=$$COMPDAT^NURSUT4(D0) D D^DIQ I Y'="" W ?$X+1,Y,?$X+1," (NO EDITING)"
 Q
