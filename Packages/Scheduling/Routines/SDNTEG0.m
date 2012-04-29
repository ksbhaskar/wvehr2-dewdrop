SDNTEG0 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;AUG 13, 1993@12:51:49
 ;;5.3;Scheduling;;Aug 13, 1993
 ;;7.0;AUG 13, 1993@12:51:49
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
SDMULT ;;7484316
SDMULT0 ;;15841854
SDMULT1 ;;9609770
SDN ;;13190633
SDN0 ;;10745291
SDN1 ;;15925636
SDN2 ;;2148726
SDNACT ;;13249640
SDNACT1 ;;5666984
SDNDIS ;;8278294
SDNEXT ;;3901484
SDNOS ;;16972788
SDNOS0 ;;16880853
SDNOS1 ;;12327597
SDNOS1A ;;2101232
SDNOS2 ;;5107044
SDNP ;;3355964
SDONI001 ;;6235821
SDONI002 ;;5848496
SDONI003 ;;5872589
SDONI004 ;;6366190
SDONI005 ;;7545844
SDONI006 ;;8448875
SDONI007 ;;5917220
SDONI008 ;;7027147
SDONI009 ;;7223308
SDONI010 ;;7596385
SDONI011 ;;1869958
SDONIT ;;975625
SDONIT1 ;;1683550
SDONIT2 ;;82270
SDONIT3 ;;10576031
SDOPC ;;13893366
SDOPC0 ;;8303286
SDOPC1 ;;19561908
SDOPC2 ;;8401400
SDOPC3 ;;15775861
SDOPC4 ;;5237052
SDOPC5 ;;5436070
SDOPCDEL ;;7891083
SDOUTPUT ;;2244356
SDPARM ;;5249701
SDPARM1 ;;1553513
SDPARM2 ;;671202
SDPP ;;3034351
SDPPADD1 ;;4364131
SDPPALL ;;5112745
SDPPAPP1 ;;5177737
SDPPAPP2 ;;2219211
SDPPAT1 ;;7771900
SDPPAT2 ;;5274978
SDPPDIS1 ;;6965566
SDPPDIS2 ;;4256184
SDPPENR1 ;;3517678
SDPPHLP ;;5694325
SDPPMT1 ;;3905693
SDPPMT2 ;;4801073
SDPPSEL ;;3358971
SDPSDR ;;14768443
SDPSDR1 ;;15374612
SDPURG ;;11231352
SDPURG1 ;;11787942
SDPURG2 ;;5183530
SDREACT ;;13194688
SDREV ;;5852789
SDRFC ;;7940120
SDROUT ;;9180900
SDROUT0 ;;13234586
SDROUT1 ;;12264522
SDROUT2 ;;8476364
SDSCE ;;6418042
SDSCP ;;20087063
SDSCP1 ;;15494739
SDST ;;10694638
SDSTAT ;;6678622
SDSTP ;;7342317
SDSTP1 ;;5317060
SDSTP2 ;;6761871
SDSTP3 ;;4306362
SDSURMEN ;;1001315
SDTRAN ;;9494629
SDTRAN1 ;;8582962
SDTRAN3 ;;4915408
SDTRAN4 ;;6282195
SDTRAND1 ;;9304255
SDTRAND2 ;;11346585
SDTRANDV ;;3512495
SDUL ;;3945856
SDUL0 ;;6331480
SDUL1 ;;6667122
SDUL2 ;;3405578
SDUL4 ;;3922391
SDUL40 ;;3773937
SDUNC ;;14954499
SDUNC1 ;;3608531
SDUTL ;;5100474
SDUTL1 ;;4495031
SDUTL2 ;;1377730
SDV53PP ;;878308
SDV53PR ;;532938
SDV53PT ;;540485
SDVADAT ;;9027439
SDVADS ;;2822966
SDVER ;;306362
SDVLT ;;8167296
SDVPP ;;5092613
SDVPR ;;418341
SDVPT ;;10774005
SDVSIT ;;4191071
SDVSIT0 ;;2375396
SDVSIT2 ;;2433623
SDWARD ;;5293772
