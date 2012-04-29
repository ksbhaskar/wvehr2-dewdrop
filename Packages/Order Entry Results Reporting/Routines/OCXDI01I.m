OCXDI01I ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI01J
 ;
 Q
 ;
DATA ;
 ;
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC NUMERIC EQUALS
 ;;R^"863.7:",.01,"E"
 ;;D^GCC NUMERIC EQUALS
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^EQ^OCXF20
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC NUMERIC INCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC NUMERIC INCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^INCL^OCXF20
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON LOW VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;R^"863.7:","863.74:3",.01,"E"
 ;;D^COMPARISON HIGH VALUE
 ;;R^"863.7:","863.74:3",1.1,"E"
 ;;D^3
 ;;EOR^
 ;;KEY^863.7:^GCC NUMERIC EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC NUMERIC EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^EXCL^OCXF20
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON LOW VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;R^"863.7:","863.74:3",.01,"E"
 ;;D^COMPARISON HIGH VALUE
 ;;R^"863.7:","863.74:3",1.1,"E"
 ;;D^3
 ;;EOR^
 ;;KEY^863.7:^GCC DATE/TIME INCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC DATE/TIME INCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^DINCL^OCXF21
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON LOW VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;R^"863.7:","863.74:3",.01,"E"
 ;;D^COMPARISON HIGH VALUE
 ;;R^"863.7:","863.74:3",1.1,"E"
 ;;D^3
 ;;EOR^
 ;;KEY^863.7:^GCC DATE/TIME EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC DATE/TIME EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^DEXCL^OCXF21
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON LOW VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;R^"863.7:","863.74:3",.01,"E"
 ;;D^COMPARISON HIGH VALUE
 ;;R^"863.7:","863.74:3",1.1,"E"
 ;;D^3
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT ENDS WITH
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT ENDS WITH
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^END^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT MATCHES PATTERN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT MATCHES PATTERN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^PAT^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT PRECEDES ALPHABETICALLY
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT PRECEDES ALPHABETICALLY
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^PREC^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT FOLLOWS ALPHABETICALLY
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT FOLLOWS ALPHABETICALLY
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^FOLLOW^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT INCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT INCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^AINCL^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;;R^"863.7:","863.74:1",1.1,"E"
 ;;D^1
 ;;R^"863.7:","863.74:2",.01,"E"
 ;;D^COMPARISON LOW VALUE
 ;;R^"863.7:","863.74:2",1.1,"E"
 ;;D^2
 ;;R^"863.7:","863.74:3",.01,"E"
 ;;D^COMPARISON HIGH VALUE
 ;;R^"863.7:","863.74:3",1.1,"E"
 ;;D^3
 ;;EOR^
 ;;KEY^863.7:^GCC FREE TEXT EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.01,"E"
 ;;D^GCC FREE TEXT EXCLUSIVELY BETWEEN
 ;;R^"863.7:",.02,"E"
 ;;D^EXTRINSIC FUNCTION
 ;;R^"863.7:",3,"E"
 ;;D^AEXCL^OCXF22
 ;;R^"863.7:","863.74:1",.01,"E"
 ;;D^PRIMARY DATA FIELD
 ;1;
 ;
