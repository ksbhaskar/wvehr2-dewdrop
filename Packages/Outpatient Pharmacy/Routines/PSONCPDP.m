PSONCPDP ;BHAM-ISC/EJW - POPULATE NCPDP NUMBER IN FILE 59 ;08/31/05
 ;;7.0;OUTPATIENT PHARMACY;**216**;DEC 1997
 ;POPULATE THE NEW NCPDP FIELD ONE TIME ONLY
 S ZTDTH=""
 I $D(ZTQUEUED) S ZTDTH=$H
 I ZTDTH="" D
 .D BMES^XPDUTL("Populate NCPDP number field")
 .D BMES^XPDUTL("Queuing background job")
 S ZTDTH=$H
 S ZTRTN="EN^PSONCPDP",ZTIO="",ZTDESC="Background job to populate NCPDP NUMBER field" D ^%ZTLOAD K ZTDTH,ZTRTN,ZTIO,ZTDESC
 W:$D(ZTSK)&('$D(ZTQUEUED)) !!,"Task queued !",!
 Q
EN ;
 I '$G(DT) S DT=$$DT^XLFDT
 N PSODIV,SITE,INACT,PSONCP,II,DIVNAM,PSOPOP,PSONAM,NCPDP
 K ^TMP($J,"PSONCP")
 F II=1:1 S NCPDP=$P($T(NCPDP+II),";;",2) Q:NCPDP=""  S SITE=$P(NCPDP,";",2),PSONAM=$P(NCPDP,";",3),PSONCP=$P(NCPDP,";",4) D
 .I PSONCP'?7N Q
 .S ^TMP($J,"PSONCP",SITE)=PSONAM_"^"_PSONCP
 S PSODIV=0 F  S PSODIV=$O(^PS(59,PSODIV)) Q:'PSODIV  D
 .S INACT=$$GET1^DIQ(59,PSODIV,2004,"I") I INACT,DT>INACT Q
 .S DIVNAM=$$GET1^DIQ(59,PSODIV,.01,"I") I DIVNAM="" S DIVNAM=PSODIV
 .S SITE=$$GET1^DIQ(59,PSODIV,.06,"I") I SITE="" S PSOPOP(DIVNAM,"NO SITE NUMBER FOUND")="" Q
 .S PSONCP=$$GET1^DIQ(59,PSODIV,1008,"I") I PSONCP'="" S PSOPOP(DIVNAM,SITE)=PSONCP Q
 .S PSONCP=$P($G(^TMP($J,"PSONCP",SITE)),"^",2) I PSONCP="" S PSOPOP(DIVNAM,SITE)="NO NUMBER FOUND" Q
 .S DIE="^PS(59,",DA=PSODIV,DR="1008///"_PSONCP D ^DIE K DIE,DA,DR S PSOPOP(DIVNAM,SITE)=PSONCP
 K ^TMP($J,"PSONCP")
 D MAIL
 Q
 ;
MAIL    ;
 S XMDUZ="Patch PSO*7*216",XMY(DUZ)="",XMSUB="NCPDP NUMBER POPULATION"
 F PSOCXPDA=0:0 S PSOCXPDA=$O(^XUSEC("PSORPH",PSOCXPDA)) Q:'PSOCXPDA  S XMY(PSOCXPDA)=""
 K PSOTEXT
 N COUNT,DIVMAX,PSOTEXT
 S PSOTEXT(1)="Patch PSO*7*216 - POPULATE NCPDP NUMBER FIELD POST-INSTALL"
 S PSOTEXT(2)="This message is being sent to the installer of the patch and holders of"
 S PSOTEXT(3)="the PSORPH key."
 S PSOTEXT(4)=" "
 S PSOTEXT(5)="Please validate that the NCPDP number is correct for each active DIVISION and"
 S PSOTEXT(6)="SITE NUMBER. If missing or incorrect, enter the correct number using the"
 S PSOTEXT(7)="Site Parameter Enter/Edit option."
 S PSOTEXT(8)=" "
 S COUNT=8,DIVMAX=1
 S DIVNAM="" F  S DIVNAM=$O(PSOPOP(DIVNAM)) Q:DIVNAM=""  S:$L(DIVNAM)>DIVMAX DIVMAX=$L(DIVNAM)
 S DIVNAM="" F  S DIVNAM=$O(PSOPOP(DIVNAM)) Q:DIVNAM=""  D
 .S SITE="" F  S SITE=$O(PSOPOP(DIVNAM,SITE)) Q:SITE=""  S COUNT=COUNT+1 D
 ..S PSOTEXT(COUNT)="DIVISION: "_$J(DIVNAM,DIVMAX)_"  SITE NUMBER: "_$J(SITE,4)_"  NCPDP NUMBER: "_$J(PSOPOP(DIVNAM,SITE),7)
 S XMTEXT="PSOTEXT(" N DIFROM D ^XMD
 Q
 ;
NCPDP ;;VISN;SITE#;SITE NAME;NCPDP#
 ;;1;402;Togus VAMC & ROC;2006965
 ;;1;405;White River Junction VAMC;4704044
 ;;1;518;Bedford VAMC;2233548
 ;;1;523;Boston VAMC;2235100
 ;;1;523A4;West Roxbury VAMC;2231594
 ;;1;523A5;Brockton VAMC;2240214
 ;;1;523BY;Lowell CBOC;2240238
 ;;1;523BZ;Boston -Causeway CBOC;2240202
 ;;1;523GB;Worcester CBOC;2240226
 ;;1;608;Manchester VAMC;3005255
 ;;1;631;Northampton VAMC;2240240
 ;;1;650;Providence VAMC;4106349
 ;;1;689;West Haven VAMC;0719584
 ;;1;689A4;Newington VAMC;0719596
 ;;2;528;Syracuse VAMC;3337448
 ;;2;528A7;Western NY HCS - Buffalo;3345990
 ;;2;528A4;Batavia VAMC;3346017
 ;;2;528A5;Canandaigua VAMC;3334163
 ;;2;528A6;Bath VAMC;3350458
 ;;2;528A8;Albany VAMC;3338349
 ;;3;526;Bronx VAMC;3336725
 ;;3;561;East Orange VAMC;3145388
 ;;3;561A4;Lyons VAMC;3138749
 ;;3;620;Montrose VAMC;3330925
 ;;3;620A4;Castle Point VAMC;3330925
 ;;3;630;New York VAMC;3304449
 ;;3;630A4;Brooklyn VAMC;3330773
 ;;3;630A5;St. Albans VAMC;3330785
 ;;3;632;Northport VAMC;3322687
 ;;4;460;Wilmington VAMC;0803177
 ;;4;503;Altoona VAMC;3973004
 ;;4;529;Butler VAMC;3964295
 ;;4;540;Clarksburg VAMC;5004875
 ;;4;542;Coatesville VAMC;3981897
 ;;4;562;Erie VAMC;3981900
 ;;4;595;Lebanon VAMC;3981912
 ;;4;642;Philadelphia VAMC;3921904
 ;;4;646;Pittsburgh VA HCS;3982508
 ;;4;646A4;Aspinwall VAMC;3981936
 ;;4;693;Wilkes-Barre VAMC;3969269
 ;;4;693B4;Allentown OPC;3982293
 ;;5;512;Baltimore VAMC;2122036
 ;;5;512A5;Perry Point VAMC;2119952
 ;;5;613;Martinsburg VAMC;5005423
 ;;5;688;Washington DC VAMC;0904260
 ;;6;637;Asheville VAMC;3412222
 ;;6;517;Beckley VAMC;5005497
 ;;6;558;Durham VAMC;3432717
 ;;6;565;Fayetteville (NC) VAMC;3429417
 ;;6;590;Hampton VAMC;4836992
 ;;6;652;Richmond VAMC;4837944
 ;;6;658;Salem VAMC;4829125
 ;;6;659;Salisbury VAMC;3429556
 ;;7;508;Atlanta VAMC;1119672
 ;;7;509;Augusta VAMC;1147912
 ;;7;521;Birmingham VAMC;0131829
 ;;7;534;Charleston VAMC;4224628
 ;;7;544;Columbia (SC) VAMC;4223260
 ;;7;557;Dublin VAMC;1151478
 ;;7;619;Montgomery VAMC;0126842
 ;;7;619A4;Tuskegee VAMC;0132667
 ;;7;679;Tuscaloosa VAMC;0125787
 ;;8;516;Bay Pines VAMC;1098981
 ;;8;546;Miami VAMC;1074715
 ;;8;548;West Palm Beach VAMC;1098234
 ;;8;573;Gainesville VAMC;1098993
 ;;8;573A4;Lake City VAMC;1081354
 ;;8;573BY;Jacksonville CBOC;1099008
 ;;8;573BZ;"William V. Chappell, Jr., VA OPC";1009213
 ;;8;573GF;Tallahassee CBOC;1007120
 ;;8;672;San Juan VAMC;4024030
 ;;8;672BO;Ponce VA Clinic;4024016
 ;;8;672BZ;Mayaguez VA Clinic;4024028
 ;;8;673;Tampa VAMC;1073371
 ;;8;673BY;Orlando VAHC;1099010
 ;;8;673BZ;New Port Richey CBOC;1099022
 ;;8;673GA;Viera CBOC;1099060
 ;;9;626;Tennessee Valley Healthcare System;4436552
 ;;9;626A4;Murfreesboro VAMC;4429583
 ;;9;581;Huntington VAMC;5004673
 ;;9;596;Lexington VAMC;1822990
 ;;9;603;Louisville VAMC;1827243
 ;;9;614;Memphis VAMC;4436538
 ;;9;621;Mountain Home VAMC;4436540
 ;;10;538;Chillicothe VAMC;3660683
 ;;10;539;Cincinnati VAMC;3636098
 ;;10;541;Cleveland VAMC;3660671
 ;;10;552;Dayton VAMC;3664085
 ;;10;757;Columbus VAOPC;3664162
 ;;11;506;Ann Arbor VAMC;2358162
 ;;11;515;Battle Creek VAMC;2354621
 ;;11;515BY;VA Grand Rapids OPC;2366462
 ;;11;550;Danville VAMC;1466134
 ;;11;550BY;Peoria CBOC;1476313
 ;;11;553;Detroit VAMC;2359063
 ;;11;583;Indianapolis VAMC;1516206
 ;;11;610;Northern Indiana VAMC;1519377
 ;;11;610A4;Fort Wayne VAMC;1510735
 ;;11;655;Saginaw VAMC;2354671
 ;;12;695;Milwaukee VAMC;5121950
 ;;12;537;Chicago VAMC;1467869
 ;;12;537A4;Chicago Lake Side VAMC;1473242
 ;;12;537BY;Crown Point CBOC;1535244
 ;;12;556;North Chicago VAMC;1473329
 ;;12;578;Hines VAMC;1475145
 ;;12;585;Iron Mountain VAMC;2350192
 ;;12;607;Madison VAMC;5123322
 ;;12;676;Tomah VAMC;5123182
 ;;15;589;VA Heartland West/ Kansas City VAMC;2614522
 ;;15;589A4;Columbia (MO) VAMC;2614825
 ;;15;589A5;Topeka VAMC ;1712884
 ;;15;589A6;Leavenworth VAMC;1712911
 ;;15;589A7;Wichita VAMC;1712923
 ;;15;657;VA Heartland East/ St. Louis VAMC;2629509
 ;;15;657A4;Popular Bluff VAMC;2616805
 ;;15;657A5;Marion VAMC;1469471
 ;;16;635;Oklahoma City VAMC;3706972
 ;;16;502;Alexandria VAMC;1914717
 ;;16;520;Biloxi VAMC;2517350
 ;;16;541A32;Gulfport VAMC;2521474
 ;;16;541A33;"Pensacola, FL CBOC";1099072
 ;;16;541A34;"Mobile, AL CBOC";0131881
 ;;16;564;Fayetteville (AR) VAMC;0420466
 ;;16;580;Houston VAMC;4541149
 ;;16;586;Jackson VAMC;2508995
 ;;16;598A;North Little Rock VAMC;0420339
 ;;16;598B;Central Arkansas VA HCS;0421785
 ;;16;623;Muskogee VAMC;3710933
 ;;16;629;New Orleans VAMC;1913652
 ;;16;629BY;Baton Rouge Outpatient Clinic;1917698
 ;;16;667;Shreveport VAMC;1913462
 ;;17;541A48;Kerrville VAMC;4593693
 ;;17;549;Dallas VAMC;4539055
 ;;17;549A4;Bonham VAMC;4539447
 ;;17;549BY;Fort Worth Outpatient Clinic;4518316
 ;;17;671;San Antonio VAMC;4537809
 ;;17;671BZ;Corpus Christi VA Outpatient Pharmacy;4532138
 ;;17;671BO;McAllen VA Outpatient Pharmacy;4532001
 ;;17;671BY;Frank M. Tejeda VA Outpatient Clinic Pharmacy;4532087
 ;;17;674;Temple VAMC;4545274
 ;;17;674A4;Waco VAMC;4538445
 ;;17;674BY;Austin VAMC;4529117
 ;;18;501;Albuquerque VAMC;3208899
 ;;18;504;Amarillo VAMC;4525690
 ;;18;504BY;Lubbock VAMC;4530336
 ;;18;519;Big Spring VAMC;4594190
 ;;18;644;Phoenix VAMC;0327204
 ;;18;649;Prescott VAMC;0327280
 ;;18;678;Tucson VAMC;0321783
 ;;18;756;El Paso VAMC;4519469
 ;;19;436;Fort Harrison VAMC;2706553
 ;;19;436DT;Columbia Falls CBOC;2764339
 ;;19;436GH;Billings CBOC;2764555
 ;;19;436GJ;Miles City CBOC;2764442
 ;;19;442;Cheyenne VAMC;5203651
 ;;19;554;Denver VAMC;0617766
 ;;19;575;Grand Junction VAMC;0617728
 ;;19;660;Salt Lake City VAMC;4608658
 ;;19;666;Sheridan VAMC;5203702
 ;;20;463;Anchorage VAOPC;0225842
 ;;20;531;Boise VAMC;1305766
 ;;20;648;Portland VAMC;3804007
 ;;20;653;Roseburg VAMC;3811862
 ;;20;663;VA Puget Sound - Seattle;4913136
 ;;20;663 A;VA Puget Sound - Tacoma;4912398
 ;;20;663A;VA Puget Sound - Tacoma;4912398
 ;;20;668;Spokane VAMC;4912792
 ;;20;687;Walla Walla VAMC;4912653
 ;;20;692;White City VAMC;3812206
 ;;21;358;Manila ;N/A
 ;;21;459;Honolulu VAMC;1204419
 ;;21;570;Fresno VAMC;0550207
 ;;21;612;Martinez VAMC;0575576
 ;;21;640XX;Redding VAOPC;0575603
 ;;21;640;Palo Alto VA HCS;0592534
 ;;21;640A0;Menlo Park VAMC;5600196
 ;;21;640A4;Livermore VAMC;0529783
 ;;21;640BY;San Jose CBOC;5600209
 ;;21;640HC;Monterey CBOC;5600211
 ;;21;654;Reno VAMC;2905466
 ;;21;662;San Francisco VAMC;0575641
 ;;22;593;Las Vegas VAMC;2907092
 ;;22;600;Long Beach VAMC;0570855
 ;;22;605;Loma Linda VAMC;0569333
 ;;22;664;San Diego VAMC;0574978
 ;;22;691;West LA VAMC - Methadone Pharmacy;0521965
 ;;22;691;Greater Los Angeles VA HCS;0577621
 ;;22;691A95;Sepulveda VAMC;0514237
 ;;22;691A96;Los Angeles East Temple - Methadone Pharmacy;0539152
 ;;22;691A96;Los Angeles East Temple - CBOC;0539152
 ;;22;691A97;Los Angeles Wilshire - Methadone Pharmacy;0569713
 ;;22;691A97;Los Angeles Whilshire CBOC;0569713
 ;;23;437;Fargo VAMC;3504063
 ;;23;438;Sioux Falls VAMC & ROC;4304616
 ;;23;541A101;Hot Springs VAMC;4352768
 ;;23;568;Fort Meade VAMC;4304806
 ;;23;618;Minneapolis VAMC;2411508
 ;;23;636;Omaha VAMC;2814564
 ;;23;636A4;Grand Island VAMC;2816924
 ;;23;636A5;Lincoln VAMC;2816912
 ;;23;636A6;Des Moines VAMC;1620043
 ;;23;636A7;Knoxville VAMC;1621615
 ;;23;636A8;Iowa City VAMC;1620663
 ;;23;656;St. Cloud VAMC;2408195
