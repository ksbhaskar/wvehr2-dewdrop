LR7OSMZU ;slc/dcm - Silent Micro rpt cont. ;8/11/97
 ;;5.2;LAB SERVICE;**121,244**;Sep 27, 1994
FH ;from LR7OSMZ1, LR7OSMZ2, LR7OSMZ5
 Q
FHR ;from LR7OSMZ1, LR7OSMZ2
 D REFS
 Q
REFS ;from LR7OSMZ1
 S B=1,LREF=0
 F  S LREF=$O(LRBUG(LREF)) Q:LREF=""  S LRIFN=LRBUG(LREF) D LIST Q:LREND
 K LRBUG
 Q
LIST Q:'$D(^LAB(61.2,LRIFN,"JR",0))
 S LRNUM=0
 F  S LRNUM=$O(^LAB(61.2,LRIFN,"JR",LRNUM)) Q:LRNUM=""  D WR Q:LREND
 Q
WR ;
 S X1=^LAB(61.2,LRIFN,"JR",LRNUM,0)
 Q:$P(X1,U,7)'=1
 I B=1 D LINE^LR7OSUM4,LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Reference(s): ")
 S B=0
 D LINE^LR7OSUM4,LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,$J(LREF,2)_". "_$P(X1,U,2))
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,$P(X1,U))
 D LINE^LR7OSUM4
 I $L($P(X1,U,3)) S ^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$P(^LAB(95,$P(X1,U,3),0),U)_" "_$P(X1,U,4)_":")
 S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$P(X1,U,5))
 I $L($P(X1,U,6)) S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,","_$E($P(X1,U,6),1,3)+1700)
 Q
HDR ;from LR7OSMZ1
 S LRPG=LRPG+1,LRJ02=1
 D LINE^LR7OSUM4
 S X=GIOM/2-(12/2+5),^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(X,CCNT,"---- MICROBIOLOGY ----")
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Accession: "_LRACC)_$$S^LR7OS(40,CCNT,"Received: "_LRRC)
 D LINE^LR7OSUM4
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Collection sample: "_LRCS)_$$S^LR7OS(40,CCNT,"Collection date: "_LRTK)
 I LRCS'=LRST,LRPG=1 D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Site/Specimen: "_LRST)
 I LRPG=1 D
 . D LINE^LR7OSUM4
 . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Provider: "_LRDOC)
 . D LINE^LR7OSUM4
 . I $L(LRCMNT) S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Comment on specimen: "_$S($L(LRCMNT)>58:"",1:LRCMNT)) D LINE^LR7OSUM4
 . I $L(LRCMNT)>58 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LRCMNT) D LINE^LR7OSUM4
 Q
PRE ;from LR7OSMZ2, LR7OSMZ3, LR7OSMZ4
 Q:LRTUS["F"&('$D(^XUSEC("LRLAB",DUZ))!$D(LRWRDVEW))
 I +$O(^LR(LRDFN,"MI",LRIDT,LRPRE,0)) D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Preliminary Comments: ") S J=0 D
 . F  S J=+$O(^LR(LRDFN,"MI",LRIDT,LRPRE,J)) Q:J<1  S X=^(J,0) D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,X)
 D LINE^LR7OSUM4
 Q
