SR160UT0 ;BIR/ADM - SR*3*160 UTILITY, CONTINUED ;01/18/07
 ;;3.0; Surgery ;**160**;24 Jun 93;Build 7
 Q
PEX F SRJ=0:1 S SRLIST=$P($T(LIST+SRJ),";;",2) Q:SRLIST=""  F SRI=1:1 S SRX=$P(SRLIST,",",SRI) Q:SRX=""  I $D(^ICPT("B",SRX)) D
 .S SRY=0,SRY=$O(^ICPT("B",SRX,SRY)) Q:SRY=""
 .K DA,DIC,DD,DO,DINUM S (DINUM,X)=SRY,DIC="^SRO(137,",DIC(0)="L" D FILE^DICN
 Q
LIST ;;36247,36248,36260,36261,36262,36299,36400,36405,36406,36410,36415,36416,36420,36425,36430
 ;;36440,36450,36455,36460,36468,36469,36470,36471,36481,36488,36489,36490,36491,36493,36500
 ;;36510,36511,36512,36513,36514,36515,36516,36520,36522,36530,36531,36532,36533,36534,36535
 ;;36536,36537,36540,36550,36555,36556,36557,36558,36559,36560,36561,36563,36565,36566,36568
 ;;36569,36570,36571,36575,36576,36577,36578,36580,36581,36582,36583,36584,36585,36589,36590
 ;;36595,36596,36597,36600,36620,36625,36640,36660,36680,36800,36810,36815,36820,36821,36822
 ;;36823,36825,36830,36831,36832,36833,36835,36870,37183,37195,37200,37205,37206,37207,37208
 ;;37209,37215,37216,37250,37251,37501,37609,37620,37785,38200,38204,38205,38206,38207,38208
 ;;38209,38210,38211,38212,38213,38214,38215,38221,38240,38241,38242,38500,38505,38510,38520
 ;;38525,38530,38790,38792,38794,40490,40799,40806,40808,40831,41010,41015,41100,41105,41108
 ;;41115,41250,41251,41252,41510,41520,41800,41805,41870,41872,41874,41877,41899,42000,42100
 ;;42180,42182,42280,42281,42310,42400,42405,42600,42650,42660,42800,42802,42804,42806,42820
 ;;42821,42825,42826,42830,42831,42835,42836,42860,42970,42971,43200,43201,43202,43204,43205
 ;;43215,43216,43217,43219,43220,43226,43227,43228,43231,43232,43234,43235,43236,43237,43238
 ;;43239,43240,43241,43242,43243,43244,43245,43246,43247,43248,43249,43250,43251,43255,43256
 ;;43257,43258,43259,43260,43261,43262,43263,43264,43265,43267,43268,43269,43271,43272,43450
 ;;43453,43456,43458,43460,43499,43600,43653,43750,43752,43760,43761,43830,44015,44100,44132
 ;;44133,44135,44136,44137,44201,44300,44360,44361,44363,44364,44365,44366,44369,44370,44372
 ;;44373,44376,44377,44378,44379,44380,44382,44383,44385,44386,44388,44389,44390,44391,44392
 ;;44393,44394,44397,44500,44715,44720,44721,44901,45100,45300,45303,45305,45307,45308,45309
 ;;45315,45317,45320,45321,45327,45330,45331,45332,45333,45334,45335,45337,45338,45339,45340
 ;;45341,45342,45345,45355,45378,45379,45380,45381,45382,45383,45384,45385,45386,45387,45500
 ;;45520,45900,45915,45990,46050,46070,46080,46083,46200,46210,46211,46220,46221,46230,46250
 ;;46255,46257,46258,46260,46261,46262,46270,46275,46280,46285,46288,46320,46500,46505,46600
 ;;46604,46606,46608,46610,46611,46612,46614,46615,46754,46900,46910,46916,46917,46922,46934
 ;;46935,46936,46937,46938,46945,46946,47000,47011,47100,47133,47135,47136,47140,47141,47142
 ;;47143,47144,47145,47146,47147,47490,47500,47505,47510,47511,47525,47530,47552,47553,47554
 ;;47555,47556,47701,47801,48102,48400,48550,48551,48552,48554,48556,49041,49180,49320,49400
 ;;49419,49420,49421,49422,49423,49424,49427,49428,49429,49491,49492,49495,49496,49500,49501
 ;;50040,50080,50081,50200,50300,50320,50323,50325,50327,50328,50329,50390,50392,50393,50394
 ;;50398,50547,50551,50553,50555,50557,50559,50561,50562,50570,50572,50574,50575,50576,50578
 ;;50580,50590,50592,50600,50605,50684,50686,50688,50690,50951,50953,50955,50957,50959,50961
 ;;50970,50972,50974,50976,50978,50980,51000,51005,51010,51600,51605,51610,51700,51701,51702
 ;;51703,51705,51710,51715,51720,51725,51726,51736,51741,51772,51784,51785,51792,51795,51797
 ;;51798,52000,52001,52005,52007,52010,52204,52214,52224,52250,52260,52265,52270,52275,52276
 ;;52277,52281,52282,52283,52285,52290,52300,52301,52305,52310,52315,52317,52318,52327,52332
 ;;52334,52335,52336,52337,52338,52339,52343,52351,52352,52353,52354,52355,53020,53025,53060
 ;;53200,53270,53275,53600,53601,53620,53621,53660,53661,53670,53850,54000,54001,54055,54056
 ;;54060,54100,54105,54150,54152,54160,54161,54162,54200,54230,54231,54235,54240,54250,54400
 ;;54401,54402,54405,54406,54407,54408,54409,54410,54415,54416,54450,54500,54505,54510,54512
 ;;54520,54530,54535,54700,54800,54820,54830,55000,55250,55300,55400,55500,55520,55559,55700
 ;;55705,55859,55870,56300,56301,56302,56346,56347,56351,56360,56361,56362,56363,56605,56606
 ;;56700,56820,57020,57022,57023,57100,57105,57150,57160,57170,57180,57287,57410,57420,57421
 ;;57452,57454,57456,57500,57510,57511,57513,57520,57700,58100,58300,58301,58321,58322,58323
 ;;58340,58345,58346,58353,58545,58546,58550,58551,58553,58555,58558,58559,58560,58561,58562
 ;;58563,58660,58661,58662,58670,58671,58672,58673,58679,58823,58900,58970,58974,58976,59000
 ;;59001,59012,59015,59020,59025,59030,59050,59051,59070,59072,59074,59076,59100,59160,59200
 ;;59300,59320,59325,59400,59409,59410,59412,59414,59425,59426,59430,59510,59514,59515,59525
 ;;59561,59610,59612,59614,59618,59840,59841,59850,59851,59852,59855,59856,59857,59866,59870
 ;;59871,59897,59899,60001,60100,61001,61026,61050,61055,61070,61140,61623,61720,61735,61770
 ;;61790,61791,61793,61868,62140,62141,62142,62143,62146,62147,62163,62201,62223,62252,62263
 ;;62264,62268,62269,62270,62272,62273,62274,62275,62276,62277,62278,62279,62280,62281,62282
 ;;62284,62286,62287,62288,62289,62290,62291,62292,62294,62310,62311,62318,62319,62355,62367
 ;;63600,63610,63615,63650,64400,64402,64405,64408,64410,64412,64413,64415,64416,64417,64418
 ;;64420,64421,64425,64430,64435,64445,64446,64447,64448,64449,64450,64470,64472,64475,64476
 ;;64479,64480,64483,64484,64505,64508,64510,64517,64520,64530,64550,64553,64555,64560,64561
 ;;64565,64577,64580,64600,64605,64610,64612,64613,64614,64620,64622,64623,64626,64627,64630
 ;;64640,64680,64681,64716,64718,64719,64721,64732,64734,64736,64738,64740,64742,64744,64746
 ;;64752,64755,64760,64761,64763,64766,64771,64772,64774,64776,64778,64782,64783,64784,64786
 ;;64787,64788,64790,64792,64795,64820,64822,64823,64999,65091,65093,65101,65103,65105,65110
 ;;65112,65114,65125,65130,65135,65140,65150,65155,65175,65205,65210,65220,65222,65235,65260
 ;;65265,65270,65272,65273,65275,65280,65285,65286,65290,65400,65410,65420,65426,65430,65435
 ;;65436,65450,65600,65710,65730,65750,65755,65760,65765,65767,65770,65771,65772,65775,65800
 ;;65805,65810,65815,65820,65850,65855,65860,65865,65870,65875,65880,65900,65920,65930,66020
 ;;66030,66130,66150,66155,66160,66165,66170,66172,66180,66185,66220,66225,66250,66500,66505
 ;;66600,66605,66625,66630,66635,66680,66682,66700,66710,66720,66740,66761,66762,66770,66820
 ;;66821,66825,66830,66840,66850,66852,66920,66930,66940,66982,66983,66984,66985,66986,66990
 ;;66999,67005,67010,67015,67025,67027,67028,67030,67031,67036,67038,67039,67040,67101,67105
 ;;67107,67108,67109,67110,67112,67115,67120,67121,67141,67145,67208,67210,67218,67220,67221
 ;;67225,67227,67228,67250,67255,67299,67311,67312,67314,67316,67318,67320,67331,67332,67334
 ;;67335,67340,67343,67345,67350,67399,67400,67405,67412,67413,67414,67415,67420,67430,67440
 ;;67445,67450,67500,67505,67515,67550,67560,67570,67599,67700,67710,67715,67800,67801,67805
 ;;67808,67810,67820,67825,67830,67835,67840,67850,67875,67880,67882,67900,67901,67902,67903
 ;;67904,67906,67908,67909,67911,67912,67914,67915,67916,67917,67921,67922,67923,67924,67930
 ;;67935,67938,67950,67961,67966,67971,67973,67974,67975,67999,68020,68040,68100,68110,68115
 ;;68130,68135,68200,68320,68325,68326,68328,68330,68335,68340,68360,68362,68371,68399,68400
 ;;68420,68440,68500,68505,68510,68520,68525,68530,68540,68550,68700,68705,68720,68745,68750
 ;;68760,68761,68770,68800,68801,68810,68811,68815,68820,68825,68830,68840,68850,68899,69000
 ;;69005,69020,69090,69100,69105,69110,69120,69140,69145,69150,69155,69200,69205,69210,69220
 ;;69222,69300,69310,69320,69399,69400,69401,69405,69410,69420,69421,69424,69433,69436,69440
 ;;69450,69501,69502,69505,69511,69530,69535,69540,69550,69552,69554,69601,69602,69603,69604
 ;;69605,69610,69620,69631,69632,69633,69635,69636,69637,69641,69642,69643,69644,69645,69646
 ;;69650,69660,69661,69662,69666,69667,69670,69676,69700,69710,69711,69720,69725,69740,69745
 ;;69799,69801,69802,69805,69806,69820,69840,69905,69910,69915,69930,69949,69950,69955,69960
 ;;69970,69979
