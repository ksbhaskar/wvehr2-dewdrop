ECKILL  ;BIR/MAM,RHK,JPW-Kill Local Variables ;13 Apr 95
        ;;2.0; EVENT CAPTURE ;**4,5,10,17,18,23,42,54,65,76**;8 May 96;Build 6
        K %,%DT,%ZIS,A,AA,B,CNT,CNT1,COUNT,D,D0,D1,DA,DATA,DATA0,DATE,DFN,DHD,DIC,DIE,DINUM,DIOEND,DIR,DIROUT,DIRUT,DISYS,DTOUT,DUOUT,DLAYGO
        K EC,EC1,EC2,EC23,EC7,ECA,ECAC,ECACA,ECACC,ECAD,ECADD,ECALL,ECANE,ECAT,ECB,ECBDH,ECBSZ,ECC,ECC1,ECCAC,ECCAT,ECCC
        K ECCD,ECCH,ECCLC,ECCN,ECCS,ECCSC,ECCSN,ECD,ECD0,ECDA,ECDAT,ECDATA,ECDATA1,ECDATE,ECDFN,ECDI,ECDIA,ECDICA,ECDIV,ECDN,ECDOC,ECDR,ECDRG,ECDS1,ECDT,ECDT1,ECDU,ECDUZ
        K ECEC,ECED,ECED1,ECEDH,ECEDN,ECEXT,ECF,ECFCP,ECFD,ECFILE,ECFN,ECGRP,ECH
        K ECHD,ECHEAD,ECHOICE,ECI,ECID,ECINC,ECINST,ECINZ,ECIOP,ECITEM,ECJLP,ECL,ECL1,ECL2,ECL3,ECL4,ECL5,ECL6,ECLALL,ECLDT,ECLDT1,ECLL,ECLN,ECLOC,ECLR,ECLRO
        K ECM,ECMAX,ECMESG,ECMESS,ECMG,ECMIN,ECMN,ECMNTH,ECMOD,ECMODS,ECMODF,ECMORE,ECMS,ECMSG,ECMSN,ECMW,ECN,ECNEW,ECNO,ECNODE,ECNR,ECNT
        K PA,PR,V,ECPCNT,ECELPT,ECPNAME,ECPRSL,VOL,ECPROCED,ECDTM,ECDSSU,ECDXO,ECYCLN
        ;
        ;- Kill ordering section default variables (ECODFN,ECOM)
        K ECO,ECO0,ECO1,ECO2,ECOB,ECOD0,ECODE,ECODE0,ECODFN,ECOLD,ECOM,ECON,ECOST,ECOUT
        ;
        ;- Kill procedure reason variables (ECPRPTR,ECPRSN,ECREAS)
        K ECP,ECP1,ECP2,ECPACK,ECPAD,ECPAT,ECPG,ECPIECE,ECPN,ECPO,ECPR,ECPRC,ECPRO,ECPROC,ECPROF,ECPROS,ECPRPTR,ECPRSN,ECPS,ECPT,ECPTF
        K ECQ,ECQTY,ECRAD0,ECRD,ECREAS,ECREDO,ECREPL,ECRFL,ECRL,ECRN,ECRPL1,ECRTN,ECRX,ECS,ECSA,ECSD,ECSD1,ECSDN,ECSEC,ECSECS,ECSN,ECSSN,ECST,ECSTAT,ECSU
        K ECT,ECTEMP,ECTEST,ECTR,ECTREAT,ECTRN,ECTWO,ECU,ECU2,ECU2A,ECU3,ECU3A,ECUCNT,ECUN,ECUN1,ECUN2,ECUN3,ECUNIT
        K ECUNM,ECURG,ECUSER,ECUSR,ECUT,ECUT2,ECUT3,ECUTN,ECUTN2,ECUTN3,ECV,ECWORD,ECX,ECXID,ECXMDA,ECXMDT,ECY,ECYN,ECYNZ,ECRY
        K FAC,FLDS,FR,I,IOP,J,JJ,K,LINE,LIST,LOC,LOS,MM,MSG,MSG1,MSG2,NODE,NODE1,OK,P1,P11,P2,P3,POP,Q,SC,SDATE,SSN,STC,SU,TEST,TIME,TO,TOTD,UNIT,USER,USRCNT,W,X,XMDUZ
        K X,XMDUZ,XMSUB,XMTEST,XMTEXT,XMY,Y,ECCNTCHK,ECP1N,ECPI,RK,ECPSYN,C,DI,DQ,DR,ECLINE,ECPIEN,ECSYN,MINCNT,MAXCNT,ECFLG,ECZ,ECPATN,ECFILN,ECPC,ECPF,ECPP,ECR,ECSUB,ECV1,ECVOL,ECDIR,EZCNT,ECERR
        K ECCODE,ECDDT,ECNATN,ECDONE,NATN,ECPSY,ECRDT,ECPG1,ECNOPE,SYN,ECOLD,ECOLDN,RK,ECOS,ECOSN,PRO,SS,ECPA,ANS
PCE     K ECAO,ECSC,ECZEC,ECIR,ECINP,ECID,EC4,EC4N,ECDX,ECDXN,ECVST,ECVV,ECZZ,LOCP,LOCPX,LOCX,PN,PNP,PNODE,ECMST,ECDXS,ECHNC,ECCV,ECSHAD
        K ECPCL,ECPCID,ECPCRD,ECPKG,ECCPT,EC725,ECONE,ECNODE2,ECCLFLDS,ECELANS,ECELCOD,ECELDSP,ECELIG,ECIOFLG,ECNEWDT,ECPTSTAT,VAEL,ECPTCD
        K ECP10,ECP11,ECP15,ECP17,ECP19,ECP2,ECP20,ECP3,ECP4,ECPCE,ECPP1,ECPP1A,ECPP2,ECPP3,ECPP4,ECPP5,ECPP6,ECPP9
        K ^TMP($J)
        Q
