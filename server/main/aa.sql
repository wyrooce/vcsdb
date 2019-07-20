
  CREATE OR REPLACE FUNCTION "PRAGG"."GET_QUERY_GAP" ( INPAR_REF_REQ_ID IN NUMBER ) RETURN VARCHAR2 AS 
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/18-16:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query shekaf ra bar migardanad
  */
/*------------------------------------------------------------------------------*/

 VAR_REF_REPORT_ID        NUMBER;
 VAR_REF_LEDGER_PROFILE   NUMBER;
 VAR_TIMING               VARCHAR2(1000);
 VAR_TIMING1              VARCHAR2(1000);
 VAR_HID_LEDGER_PROFILE   NUMBER;
BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
  /****** peyda kardane gozaresh entekhab shode ******/
 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane profile daftarkol ******/

 SELECT
  REF_LEDGER_PROFILE
 INTO
  VAR_REF_LEDGER_PROFILE
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;
 /****** peyda kardane id asli profile daftarkol entekhab shode ******/

 SELECT
  H_ID
 INTO
  VAR_HID_LEDGER_PROFILE
 FROM TBL_LEDGER_PROFILE
 WHERE ID   = VAR_REF_LEDGER_PROFILE;
  /****** peyda kardane gozaresh entekhab shode ******/

 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane profile zamani entekhab shode baraye select nahaee ******/

 SELECT
  WMSYS.WM_CONCAT( (
   SELECT
    ID ||
    ' AS "x' ||
    REPLACE(ID,' ','_') ||
    '"'
   FROM DUAL
  ) )
 INTO
  VAR_TIMING
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane esme profile zamani entekhab shode baraye select nahaee ******/

 SELECT
  WMSYS.WM_CONCAT( (
   SELECT
    '  "x' ||
    REPLACE(ID,' ','_') ||
    '"'
   FROM DUAL
  ) )
 INTO
  VAR_TIMING1
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REQ_ID;
 /****** ijad kardane select nahaee az TBL_REPVAL ******/

 RETURN '
select  ' ||
 VAR_TIMING1 ||
 ' from
(
select  REF_REPPER_ID,sum(value) as VALUE from tbl_repval where PARENT_CODE = ' ||
 VAR_HID_LEDGER_PROFILE ||
 ' and ref_repreq_id =' ||
 INPAR_REF_REQ_ID ||
 ' 
group by REF_REPPER_ID  )
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN (' ||
 VAR_TIMING ||
 '))';


END GET_QUERY_GAP;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_PERCENT2            IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_CAR_FINAL_REPORT (
 INPAR_REF_REPORT   IN NUMBER
 ,INPAR_REF_REPREQ   IN NUMBER
);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_CAR_FINAL_REPORT (
 INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE         IN NUMBER
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_PERCENT2            IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_CAR_FINAL_REPORT (
 INPAR_REF_REPORT   IN NUMBER
 ,INPAR_REF_REPREQ   IN NUMBER
);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_CAR_FINAL_REPORT (
 INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE         IN NUMBER
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TYPE
   ,'car'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
   UPDATE TBL_REPORT
    SET
     H_ID =  ID
     where 
  H_ID is null and upper(type) = 'CAR';
  commit;
 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
  ,INPAR_PERCENT2            IN VARCHAR2

 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_CAR_REP_PROFILE_DETAIL (
    REF_REP_ID
   ,NAME
   ,PROFILE_ID
   ,PERCENT
   ,IS_STANDARD
   ,TYPE
   ,percent2
   ) VALUES (
    INPAR_REF_REP_ID
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_PERCENT
   ,INPAR_IS_STANDARD
   ,INPAR_TYPE
   ,INPAR_PERCENT2
   );

   COMMIT; 
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_CAR_REP_PROFILE_DETAIL*/
/*   WHERE REF_REP_ID   = INPAR_REF_REP_ID;*/
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_CAR_REP_PROFILE_DETAIL
   WHERE ID   = (
     SELECT
      MAX(ID)
     FROM TBL_CAR_REP_PROFILE_DETAIL
    );

  ELSE
   UPDATE TBL_CAR_REP_PROFILE_DETAIL
    SET
     REF_REP_ID = INPAR_REF_REP_ID
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,PERCENT = INPAR_PERCENT
    ,IS_STANDARD = INPAR_IS_STANDARD
    ,TYPE = INPAR_TYPE
    ,percent2 = INPAR_PERCENT2
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_CAR_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
  ,INPAR_REF_REPREQ   IN NUMBER
 )
  AS
 BEGIN
 
-- DELETE FROM TBL_CAR_FINAL_REPORT
--  WHERE ref_report = INPAR_REF_REPORT; 
--  commit; 
--  
  FOR I IN (
   SELECT
    TCP.ID
   ,TC.ID AS ID_DATE
   ,TCP.REF_REP_ID
   ,TC.CAR_DATE
   ,TCP.NAME
   ,TCP.PROFILE_ID
   ,TCP.PERCENT * TCP.PERCENT2 as PERCENT
   ,TCP.TYPE
   FROM TBL_CAR_DATE TC
   ,    TBL_CAR_REP_PROFILE_DETAIL TCP
   WHERE TC.REF_REP_ID    = TCP.REF_REP_ID
    AND
     TCP.REF_REP_ID   = INPAR_REF_REPORT
  ) LOOP
   IF
    ( I.TYPE IN (
      1,2
     )
    )
   THEN
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ,REF_REPREQ
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,to_char(PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     ))
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    ,INPAR_REF_REPREQ
    );

    COMMIT;
   ELSE
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
     ,REF_REPREQ
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,to_char(PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     )) * I.PERCENT / 100
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    ,INPAR_REF_REPREQ
    );

    COMMIT;
   END IF;

   COMMIT;
   UPDATE TBL_CAR_FINAL_REPORT
    SET
     BALANCE = (
      SELECT  /*+   PARALLEL(auto) */
       SUM(CURRENT_AMOUNT)
      FROM AKIN.TBL_LOAN
      WHERE LON_ID IN (
        SELECT
         REF_LON_ID
        FROM AKIN.TBL_LOAN_PAYMENT
        WHERE DUE_DATE >= I.CAR_DATE + 1800
        GROUP BY
         REF_LON_ID
       )
     )
   WHERE REPORT_DATE   = I.CAR_DATE
    AND
     TYPE          = 4;

   COMMIT;
  END LOOP;

  END PRC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_REP_PROFILE_DETAIL WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_FINAL_REPORT WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_CAR_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER  /*if inpar_insert_or_update-1==> insert   else  ==>update*/
 ,INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 )
  AS
 BEGIN
 /*
  Programmer Name: sobhan
  Release Date/Time:1396/07/15
  Version: 1.0
  Category:
  Description:
  */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN
   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  ELSE
   DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_REF_REP_ID;

   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  END IF;

  OUTPUT   := NULL;
 END PRC_CAR_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
  VAR_PARTITION VARCHAR2(200) := 'P'||TO_CHAR(INPAR_DATE,'J');

 BEGIN
  SELECT
   '
  SELECT /*+   PARALLEL(auto) */ 
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT /*+   PARALLEL(auto) */ 
     ''(''||DG.BALANCE ||'')''||
     A.SPLIT_SING AS V
    FROM (  WITH T AS (
    select /*+   PARALLEL(auto) */   
     fnc_agg_formula_for_report_map (' ||
   INPAR_ID ||
   ' ) as STR from dual
   ) SELECT  
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive PARTITION ('||VAR_PARTITION||') DG
    WHERE DG.LEDGER_CODE   = to_char(A.SPLIT_VALUES)
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   ''')))
 '
  INTO
   VAR
  FROM DUAL;
 -- RETURN VAr;
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN to_char(SUBSTR(
    VAR3
    ,-1
    )) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;


--var2:='select ' ||
-- case when var is null then '0' else var end ||
--  ' from dual';

DBMS_OUTPUT.PUT_LINE(var);

  EXECUTE IMMEDIATE 'select ' ||
 case when var is null then '0' else var end ||
  ' from dual' INTO
   VAR2;
 
  --RETURN (to_number(VAR2));
  RETURN VAR2;
 END FNC_CAR_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''CAR''';
  RETURN VAR2;
 END FNC_CAR_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR           VARCHAR2(10000);
  VAR_TIMING    VARCHAR2(1000);
  VAR_TIMING1   VARCHAR2(1000);
    VAR_TIMING3    VARCHAR2(1000);
  VAR_TIMING4   VARCHAR2(1000);
  var_report number;
 BEGIN
 
 select ref_report_id into var_report from TBL_REPREQ where id = INPAR_REF_REPREQ;
  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     ID ||
     ' AS "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING1
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;
  
 

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  sum("x' ||
     REPLACE(ID,' ','_') ||
     '") as    "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING4
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;

  IF
   INPAR_TYPE = 4
  THEN
   VAR   := '
 SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type" FROM
(
SELECT
    REF_CAR_DATE,
    BALANCE,
    NAME,type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPREQ =' ||
   INPAR_REF_REPREQ ||
   '
    and TBL_CAR_FINAL_REPORT.type in (1,2,4)
)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
)
union    
    SELECT  name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type"  FROM
(
SELECT
    max(REF_CAR_DATE) as REF_CAR_DATE,
    sum(BALANCE) as BALANCE,
    ''جمع دارايي هاي موزون شده به ريسک'' as NAME,
      max(type) as type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPREQ =' ||
   INPAR_REF_REPREQ ||
   '
    and TBL_CAR_FINAL_REPORT.type   in (3)
group by REPORT_DATE)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)
order by "type"';
  END IF;

  IF INPAR_TYPE IN (
    3
   )
  THEN
   VAR   := '    SELECT max(name)  as "des",percent,' ||
   VAR_TIMING4 ||
   ', 1 "indent" FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME,
    percent
FROM
    TBL_CAR_FINAL_REPORT
    where type = 3 and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
) group by percent ';
  END IF;

  IF INPAR_TYPE IN (
    1
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type = ' ||
   INPAR_TYPE ||
   ' and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    2
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type in (2,4) and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  RETURN VAR;
 END FNC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where type=1 and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where  type in (2,4) and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select name as "des",PERCENT as "zarib" from TBL_CAR_REP_PROFILE_DETAIL where type=3
 and IS_STANDARD=1 and REF_REP_ID is null'
;
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR      VARCHAR2(2000);
  OUTPUT   VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'SELECT /*+ parallel(auto) */ distinct LISTAGG("date", '','') WITHIN GROUP (ORDER BY "date") AS "date"
FROM   (
select /*+ parallel(auto) */ distinct(TO_char(EFF_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from TBL_LEDGER_ARCHIVE
)';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId" ,IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=1   and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type in (2,4)  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",PERCENT as "zarib",PERCENT2 as "zarib2",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=3
  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  
 BEGIN

  OUTPUT   := 'select (TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from tbl_CAR_DATE where ref_rep_id =' || INPAR_REPORT
|| '';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  var_report number;
 BEGIN
 
 select ref_report_id into var_report from tbl_repreq where id = INPAR_REPORT;
 
 
  OUTPUT   := 'select  ''x''||ID AS "value",(TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "header" from tbl_CAR_DATE where ref_rep_id ='
|| var_report || '';
  RETURN OUTPUT;
 END FNC_CAR_GET_DATE_ID;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/


END PKG_CAR;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_PERCENT2            IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_CAR_FINAL_REPORT (
 INPAR_REF_REPORT   IN NUMBER
 ,INPAR_REF_REPREQ   IN NUMBER
);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_CAR_FINAL_REPORT (
 INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE         IN NUMBER
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_PERCENT2            IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_CAR_FINAL_REPORT (
 INPAR_REF_REPORT   IN NUMBER
 ,INPAR_REF_REPREQ   IN NUMBER
);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_CAR_FINAL_REPORT (
 INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE         IN NUMBER
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TYPE
   ,'car'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
   UPDATE TBL_REPORT
    SET
     H_ID =  ID
     where 
  H_ID is null and upper(type) = 'CAR';
  commit;
 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
  ,INPAR_PERCENT2            IN VARCHAR2

 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_CAR_REP_PROFILE_DETAIL (
    REF_REP_ID
   ,NAME
   ,PROFILE_ID
   ,PERCENT
   ,IS_STANDARD
   ,TYPE
   ,percent2
   ) VALUES (
    INPAR_REF_REP_ID
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_PERCENT
   ,INPAR_IS_STANDARD
   ,INPAR_TYPE
   ,INPAR_PERCENT2
   );

   COMMIT; 
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_CAR_REP_PROFILE_DETAIL*/
/*   WHERE REF_REP_ID   = INPAR_REF_REP_ID;*/
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_CAR_REP_PROFILE_DETAIL
   WHERE ID   = (
     SELECT
      MAX(ID)
     FROM TBL_CAR_REP_PROFILE_DETAIL
    );

  ELSE
   UPDATE TBL_CAR_REP_PROFILE_DETAIL
    SET
     REF_REP_ID = INPAR_REF_REP_ID
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,PERCENT = INPAR_PERCENT
    ,IS_STANDARD = INPAR_IS_STANDARD
    ,TYPE = INPAR_TYPE
    ,percent2 = INPAR_PERCENT2
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_CAR_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
  ,INPAR_REF_REPREQ   IN NUMBER
 )
  AS
 BEGIN
 
-- DELETE FROM TBL_CAR_FINAL_REPORT
--  WHERE ref_report = INPAR_REF_REPORT; 
--  commit; 
--  
  FOR I IN (
   SELECT
    TCP.ID
   ,TC.ID AS ID_DATE
   ,TCP.REF_REP_ID
   ,TC.CAR_DATE
   ,TCP.NAME
   ,TCP.PROFILE_ID
   ,TCP.PERCENT * TCP.PERCENT2 as PERCENT
   ,TCP.TYPE
   FROM TBL_CAR_DATE TC
   ,    TBL_CAR_REP_PROFILE_DETAIL TCP
   WHERE TC.REF_REP_ID    = TCP.REF_REP_ID
    AND
     TCP.REF_REP_ID   = INPAR_REF_REPORT
  ) LOOP
   IF
    ( I.TYPE IN (
      1,2
     )
    )
   THEN
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ,REF_REPREQ
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,to_char(PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     ))
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    ,INPAR_REF_REPREQ
    );

    COMMIT;
   ELSE
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
     ,REF_REPREQ
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,to_char(PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     )) * I.PERCENT / 100
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    ,INPAR_REF_REPREQ
    );

    COMMIT;
   END IF;

   COMMIT;
   UPDATE TBL_CAR_FINAL_REPORT
    SET
     BALANCE = (
      SELECT  /*+   PARALLEL(auto) */
       SUM(CURRENT_AMOUNT)
      FROM AKIN.TBL_LOAN
      WHERE LON_ID IN (
        SELECT
         REF_LON_ID
        FROM AKIN.TBL_LOAN_PAYMENT
        WHERE DUE_DATE >= I.CAR_DATE + 1800
        GROUP BY
         REF_LON_ID
       )
     )
   WHERE REPORT_DATE   = I.CAR_DATE
    AND
     TYPE          = 4;

   COMMIT;
  END LOOP;

  END PRC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_REP_PROFILE_DETAIL WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_FINAL_REPORT WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_CAR_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER  /*if inpar_insert_or_update-1==> insert   else  ==>update*/
 ,INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 )
  AS
 BEGIN
 /*
  Programmer Name: sobhan
  Release Date/Time:1396/07/15
  Version: 1.0
  Category:
  Description:
  */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN
   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  ELSE
   DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_REF_REP_ID;

   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  END IF;

  OUTPUT   := NULL;
 END PRC_CAR_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN clob AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
  VAR_PARTITION VARCHAR2(200) := 'P'||TO_CHAR(INPAR_DATE,'J');

 BEGIN
  SELECT
   '
  SELECT /*+   PARALLEL(auto) */ 
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT /*+   PARALLEL(auto) */ 
     ''(''||DG.BALANCE ||'')''||
     A.SPLIT_SING AS V
    FROM (  WITH T AS (
    select /*+   PARALLEL(auto) */   
     fnc_agg_formula_for_report_map (' ||
   INPAR_ID ||
   ' ) as STR from dual
   ) SELECT  
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive PARTITION ('||VAR_PARTITION||') DG
    WHERE DG.LEDGER_CODE   = to_char(A.SPLIT_VALUES)
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   ''')))
 '
  INTO
   VAR
  FROM DUAL;
 -- RETURN VAr;
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN to_char(SUBSTR(
    VAR3
    ,-1
    )) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;


--var2:='select ' ||
-- case when var is null then '0' else var end ||
--  ' from dual';

DBMS_OUTPUT.PUT_LINE(var);

  EXECUTE IMMEDIATE 'select ' ||
 case when var is null then '0' else var end ||
  ' from dual' INTO
   VAR2;
 
  --RETURN (to_number(VAR2));
  RETURN VAR2;
 END FNC_CAR_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''CAR''';
  RETURN VAR2;
 END FNC_CAR_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REF_REPREQ   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR           VARCHAR2(10000);
  VAR_TIMING    VARCHAR2(1000);
  VAR_TIMING1   VARCHAR2(1000);
    VAR_TIMING3    VARCHAR2(1000);
  VAR_TIMING4   VARCHAR2(1000);
  var_report number;
 BEGIN
 
 select ref_report_id into var_report from TBL_REPREQ where id = INPAR_REF_REPREQ;
  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     ID ||
     ' AS "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING1
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;
  
 

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  sum("x' ||
     REPLACE(ID,' ','_') ||
     '") as    "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING4
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = var_report;

  IF
   INPAR_TYPE = 4
  THEN
   VAR   := '
 SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type" FROM
(
SELECT
    REF_CAR_DATE,
    BALANCE,
    NAME,type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPREQ =' ||
   INPAR_REF_REPREQ ||
   '
    and TBL_CAR_FINAL_REPORT.type in (1,2,4)
)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
)
union    
    SELECT  name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type"  FROM
(
SELECT
    max(REF_CAR_DATE) as REF_CAR_DATE,
    sum(BALANCE) as BALANCE,
    ''جمع دارايي هاي موزون شده به ريسک'' as NAME,
      max(type) as type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPREQ =' ||
   INPAR_REF_REPREQ ||
   '
    and TBL_CAR_FINAL_REPORT.type   in (3)
group by REPORT_DATE)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)
order by "type"';
  END IF;

  IF INPAR_TYPE IN (
    3
   )
  THEN
   VAR   := '    SELECT max(name)  as "des",percent,' ||
   VAR_TIMING4 ||
   ', 1 "indent" FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME,
    percent
FROM
    TBL_CAR_FINAL_REPORT
    where type = 3 and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
) group by percent ';
  END IF;

  IF INPAR_TYPE IN (
    1
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type = ' ||
   INPAR_TYPE ||
   ' and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    2
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type in (2,4) and REF_REPREQ = ' ||
   INPAR_REF_REPREQ ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  RETURN VAR;
 END FNC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where type=1 and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where  type in (2,4) and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select name as "des",PERCENT as "zarib" from TBL_CAR_REP_PROFILE_DETAIL where type=3
 and IS_STANDARD=1 and REF_REP_ID is null'
;
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR      VARCHAR2(2000);
  OUTPUT   VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'SELECT /*+ parallel(auto) */ distinct LISTAGG("date", '','') WITHIN GROUP (ORDER BY "date") AS "date"
FROM   (
select /*+ parallel(auto) */ distinct(TO_char(EFF_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from TBL_LEDGER_ARCHIVE
)';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId" ,IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=1   and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type in (2,4)  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",PERCENT as "zarib",PERCENT2 as "zarib2",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=3
  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  
 BEGIN

  OUTPUT   := 'select (TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from tbl_CAR_DATE where ref_rep_id =' || INPAR_REPORT
|| '';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  var_report number;
 BEGIN
 
 select ref_report_id into var_report from tbl_repreq where id = INPAR_REPORT;
 
 
  OUTPUT   := 'select  ''x''||ID AS "value",(TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "header" from tbl_CAR_DATE where ref_rep_id ='
|| var_report || '';
  RETURN OUTPUT;
 END FNC_CAR_GET_DATE_ID;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/


END PKG_CAR;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LIQUIDITY_RATES" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_result  (
 
 inpar_date    IN varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2
 ,outpar_id out varchar2)  ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_notif(inpar_date  IN date)   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end pkg_liquidity_rates;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LIQUIDITY_RATES" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_result  (
 
 inpar_date    IN varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2
 ,outpar_id out varchar2)  ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_notif(inpar_date  IN date)   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end pkg_liquidity_rates;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LIQUIDITY_RATES" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_liquidity_rates_result  (
 
 inpar_date     in varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) return varchar2 as
 
    VAR_PARTITION1 VARCHAR2(200) := 'P'||TO_CHAR(to_date(INPAR_DATE,'yyyy-mm-dd'),'J');
    
 VAR_CASH_MONEY                   VARCHAR2(1000) := '100000000 ,200000000';   /*VARCHAR2(1000);*/
 VAR_TRANSACTION_SECURITIES       VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_INVESTMENT        VARCHAR2(1000) := '200000000';
 VAR_TOTAL_DEPOSIT                VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_BANK_EXPOSURES    VARCHAR2(1000) := '200000000';
 VAR_RESOURCES_ABSORBED           VARCHAR2(1000) := '200000000';
 VAR_LOST_ASSETS                  VARCHAR2(1000) := '200000000';
 VAR_REMOVABLE_FUNDS              VARCHAR2(1000) := '200000000';
 VAR_EQUITY                       VARCHAR2(1000) := '200000000';
 VAR_INVESTING_IN_COMPANIES       VARCHAR2(1000) := '200000000';
 VAR_VISIBLE_ASSETS               VARCHAR2(1000) := '200000000';
 VAR_INTANGIBLE_ASSETS            VARCHAR2(1000) := '200000000';
 VAR_DEPOSIT                      VARCHAR2(1000) := '200000000';
 VAR_LOAN                         VARCHAR2(1000) := '200000000';
 VAR_CASH_ASSETS                  VARCHAR2(1000) := '200000000';
 VAR_HIGH_LIQUIDITY_CASH          VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_DEBT              VARCHAR2(1000) := '200000000';
 VAR_NET_CASH                     VARCHAR2(1000) := '200000000';
 VAR_BONDS                        VARCHAR2(1000) := '200000000';
 VAR_CASH_INVENTORY               VARCHAR2(1000) := '200000000';
 VAR_CASH_FLOWS_INPUT_PREDIC      VARCHAR2(1000) := '200000000';
 VAR_CASH_FLOWS_OUTPUT_PREDIC     VARCHAR2(1000) := '200000000';
 VAR_TOTAL_ESCAPE_DEPOSIT         VARCHAR2(1000) := '200000000';
 VAR_TOTAL_CASH_BALANCE           VARCHAR2(1000) := '200000000';
 VAR_TOTAL_BALANCE                VARCHAR2(1000) := '200000000';
 VAR_ALL_BANK_RESOURCES           VARCHAR2(1000) := '200000000';
 VAR_CASH_CURRENCY                VARCHAR2(1000) := '200000000';
 VAR_TOTAL_CURRENCY               VARCHAR2(1000) := '200000000';
 VAR_LONG_TERM_INVESTMENT         VARCHAR2(1000) := '200000000';
 VAR_TOTAL_BANK_ASSETS            VARCHAR2(1000) := '200000000';
 VAR_visitor_deposit              VARCHAR2(1000) := '300000000,200000000,100000000';
 VAR_long_term_deposit            VARCHAR2(1000) := '200000000';
 /***************************************************************************************************************************/
 CASH_MONEY                       NUMBER;
 TRANSACTION_SECURITIES           NUMBER;
 SHORT_TERM_INVESTMENT            NUMBER;
 TOTAL_DEPOSIT                    NUMBER;
 SHORT_TERM_BANK_EXPOSURES        NUMBER;
 RESOURCES_ABSORBED               NUMBER;
 LOST_ASSETS                      NUMBER;
 REMOVABLE_FUNDS                  NUMBER;
 EQUITY                           NUMBER;
 INVESTING_IN_COMPANIES           NUMBER;
 VISIBLE_ASSETS                   NUMBER;
 INTANGIBLE_ASSETS                NUMBER;
 DEPOSIT                          NUMBER;
 LOAN                             NUMBER;
 CASH_ASSETS                      NUMBER;
 HIGH_LIQUIDITY_CASH              NUMBER;
 SHORT_TERM_DEBT                  NUMBER;
 NET_CASH                         NUMBER;
 BONDS                            NUMBER;
 CASH_INVENTORY                   NUMBER;
 CASH_FLOWS_INPUT_PREDIC          NUMBER;
 CASH_FLOWS_OUTPUT_PREDIC         NUMBER;
 TOTAL_ESCAPE_DEPOSIT             NUMBER;
 TOTAL_CASH_BALANCE               NUMBER;
 TOTAL_BALANCE                    NUMBER;
 ALL_BANK_RESOURCES               NUMBER;
 CASH_CURRENCY                    NUMBER;
 TOTAL_CURRENCY                   NUMBER;
 LONG_TERM_INVESTMENT             NUMBER;
 TOTAL_BANK_ASSETS                NUMBER;
 visitor_deposit              NUMBER;
 long_term_deposit            NUMBER;
 VAR                              VARCHAR2(30000);
 /*************************************************************************************************/
 VAR_DEPENDENCE_ON_DEPOSITS       NUMBER;
 VAR_REL_TO_FINANCIAL_INSTIT      NUMBER;
 VAR_LIQUIDITY_VULNERABLE_RATIO   NUMBER;
 VAR_BANK_INVSET_COVER_RATIO      NUMBER;
 VAR_LOAN_COVER_BY_DEP_RATIO      NUMBER;
 VAR_DEBT_COVER_BY_CASH_RATIO     NUMBER;
 VAR_CASHMEREABILITY_RATIO        NUMBER;
 VAR_COMMER_NONCOMMER_TO_ASSETS   NUMBER;
 VAR_CASH_RATIO                   NUMBER;
 VAR_FLOW_COVERAGE_RATIO          NUMBER;
 VAR_COVERAGE_FLUCTUATION_RATIO   NUMBER;
 VAR_SHORT_TERM_DEBT_RATIO        NUMBER;
 VAR_CASH_TO_TOTAL_RES_RATIO      NUMBER;
 VAR_TOTAL_BAL_TO_RES_RATIO       NUMBER;
 EXCHANGE_RATE_RATIO              NUMBER;
 DEBT_COVERAGE_RATIO              NUMBER;
 var_visitor_dep_to_total_dep     number;
 var_long_term_dep_to_total_dep   number;
    
   


 /******************************************************************************************************/
BEGIN

if(inpar_cur = 4)
then
 VAR   := '
  SELECT  /*+   PARALLEL(auto) */ 
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_MONEY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TRANSACTION_SECURITIES ||
 ') then  BALANCE end),
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_BANK_EXPOSURES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_RESOURCES_ABSORBED ||
 ') then  BALANCE end) ,
 
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOST_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_REMOVABLE_FUNDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_EQUITY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INVESTING_IN_COMPANIES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_VISIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INTANGIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOAN ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_HIGH_LIQUIDITY_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_DEBT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_NET_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_BONDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_INVENTORY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_INPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_OUTPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_ESCAPE_DEPOSIT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CASH_BALANCE ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BALANCE ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_ALL_BANK_RESOURCES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_CURRENCY ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CURRENCY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LONG_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BANK_ASSETS ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_visitor_deposit ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_long_term_deposit ||
 ') then  BALANCE end) 
  
  
   FROM TBL_LEDGER_BRANCH PARTITION ('||VAR_PARTITION1||') where eff_date = TRUNC(TO_DATE('''||inpar_date||''',''yyyy-mm-dd''))  AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',inpar_BRANCH)
        || ') AND REF_CUR_ID= 4' ;
  else
  
  
   VAR   := '
  SELECT  /*+   PARALLEL(auto) */ 
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_MONEY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TRANSACTION_SECURITIES ||
 ') then  BALANCE end),
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_BANK_EXPOSURES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_RESOURCES_ABSORBED ||
 ') then  BALANCE end) ,
 
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOST_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_REMOVABLE_FUNDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_EQUITY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INVESTING_IN_COMPANIES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_VISIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INTANGIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOAN ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_HIGH_LIQUIDITY_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_DEBT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_NET_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_BONDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_INVENTORY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_INPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_OUTPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_ESCAPE_DEPOSIT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CASH_BALANCE ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BALANCE ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_ALL_BANK_RESOURCES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_CURRENCY ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CURRENCY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LONG_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BANK_ASSETS ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_visitor_deposit ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_long_term_deposit ||
 ') then  BALANCE end) 
  
  
  
   FROM TBL_LEDGER_BRANCH PARTITION ('||VAR_PARTITION1||') where eff_date = TRUNC(TO_DATE('''||inpar_date||''',''yyyy-mm-dd''))  AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',inpar_BRANCH)
        || ') AND REF_CUR_ID <> 4' ;
  
  end if;
 
 EXECUTE IMMEDIATE VAR INTO
  CASH_MONEY,TRANSACTION_SECURITIES,SHORT_TERM_INVESTMENT,TOTAL_DEPOSIT,SHORT_TERM_BANK_EXPOSURES,RESOURCES_ABSORBED,LOST_ASSETS,REMOVABLE_FUNDS
,EQUITY,INVESTING_IN_COMPANIES,VISIBLE_ASSETS,INTANGIBLE_ASSETS,DEPOSIT,LOAN,CASH_ASSETS,HIGH_LIQUIDITY_CASH,SHORT_TERM_DEBT,NET_CASH
,BONDS,CASH_INVENTORY,CASH_FLOWS_INPUT_PREDIC,CASH_FLOWS_OUTPUT_PREDIC,TOTAL_ESCAPE_DEPOSIT,TOTAL_CASH_BALANCE,TOTAL_BALANCE,ALL_BANK_RESOURCES
,CASH_CURRENCY,TOTAL_CURRENCY,LONG_TERM_INVESTMENT,TOTAL_BANK_ASSETS,visitor_deposit,long_term_deposit;

 VAR_DEPENDENCE_ON_DEPOSITS       := (cash_money +transaction_securities +short_term_investment )/(total_deposit);
 VAR_REL_TO_FINANCIAL_INSTIT       := (cash_money +transaction_securities +short_term_bank_exposures)/(resources_absorbed);
 VAR_LIQUIDITY_VULNERABLE_RATIO    :=(lost_assets)/(removable_funds);
 VAR_BANK_INVSET_COVER_RATIO       :=(equity)/(investing_in_companies+visible_assets+intangible_assets);
 VAR_LOAN_COVER_BY_DEP_RATIO       := (deposit)/(loan);
 VAR_DEBT_COVER_BY_CASH_RATIO      := (high_liquidity_cash)/(short_term_debt);
 VAR_CASHMEREABILITY_RATIO         := (net_cash)/(cash_assets);
 VAR_COMMER_NONCOMMER_TO_ASSETS    :=(bonds)/(cash_assets);
 VAR_CASH_RATIO                    := (cash_inventory)/(total_deposit);
 VAR_FLOW_COVERAGE_RATIO           := (cash_flows_input_predic)/(cash_flows_output_predic) ;
 VAR_COVERAGE_FLUCTUATION_RATIO    := (cash_assets)/(total_escape_deposit);
 VAR_SHORT_TERM_DEBT_RATIO         := (cash_assets)/(short_term_debt);
 VAR_CASH_TO_TOTAL_RES_RATIO       := (total_cash_balance)/(all_bank_resources);
 VAR_TOTAL_BAL_TO_RES_RATIO        :=(total_balance)/(all_bank_resources);
 EXCHANGE_RATE_RATIO               :=(cash_currency)/(total_currency);
 DEBT_COVERAGE_RATIO               :=(long_term_investment)/(total_bank_assets);
 var_visitor_dep_to_total_dep      :=  (visitor_deposit)/(total_deposit);
 var_long_term_dep_to_total_dep    :=  (long_term_deposit)/(total_deposit);
 


 return 'select /*+   PARALLEL(auto) */   round( regexp_substr('''   ||
 VAR_DEPENDENCE_ON_DEPOSITS      ||  ',' ||       
 VAR_REL_TO_FINANCIAL_INSTIT     ||  ',' ||
 VAR_LIQUIDITY_VULNERABLE_RATIO  ||  ',' ||
 VAR_BANK_INVSET_COVER_RATIO     ||  ',' ||
 VAR_LOAN_COVER_BY_DEP_RATIO     ||  ',' ||
 VAR_DEBT_COVER_BY_CASH_RATIO    ||  ',' ||
 VAR_CASHMEREABILITY_RATIO       ||  ',' ||
 VAR_COMMER_NONCOMMER_TO_ASSETS  ||  ',' ||
 VAR_CASH_RATIO                  ||  ',' ||
 VAR_FLOW_COVERAGE_RATIO         ||  ',' ||
 VAR_COVERAGE_FLUCTUATION_RATIO  ||  ',' ||
 VAR_SHORT_TERM_DEBT_RATIO       ||  ',' ||
 VAR_CASH_TO_TOTAL_RES_RATIO     ||  ',' ||
 VAR_TOTAL_BAL_TO_RES_RATIO      ||  ',' ||
 EXCHANGE_RATE_RATIO             ||  ',' ||
 DEBT_COVERAGE_RATIO             ||  ',' ||
 var_visitor_dep_to_total_dep    ||  ',' ||
 var_long_term_dep_to_total_dep
 ||
 ''',''[^,]+'',1,level),2) as "value",level as "id" from dual
     connect by regexp_substr('''   ||
 VAR_DEPENDENCE_ON_DEPOSITS      ||  ',' ||
 VAR_REL_TO_FINANCIAL_INSTIT     ||  ',' ||
 VAR_LIQUIDITY_VULNERABLE_RATIO  ||  ',' ||
 VAR_BANK_INVSET_COVER_RATIO     ||  ',' ||
 VAR_LOAN_COVER_BY_DEP_RATIO     ||  ',' ||
 VAR_DEBT_COVER_BY_CASH_RATIO    ||  ',' ||
 VAR_CASHMEREABILITY_RATIO       ||  ',' ||
 VAR_COMMER_NONCOMMER_TO_ASSETS  ||  ',' ||
 VAR_CASH_RATIO                  ||  ',' ||
 VAR_FLOW_COVERAGE_RATIO         ||  ',' ||
 VAR_COVERAGE_FLUCTUATION_RATIO  ||  ',' ||
 VAR_SHORT_TERM_DEBT_RATIO       ||  ',' ||
 VAR_CASH_TO_TOTAL_RES_RATIO     ||  ',' ||
 VAR_TOTAL_BAL_TO_RES_RATIO      ||  ',' ||
 EXCHANGE_RATE_RATIO             ||  ',' ||
 DEBT_COVERAGE_RATIO             ||  ',' ||
 var_visitor_dep_to_total_dep    ||  ',' ||
 var_long_term_dep_to_total_dep
 ||
 ''',''[^,]+'',1,level) is not null';
 

END;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/        
    
    
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2
 
 as
 
 begin 
 
 return '
select /*+   PARALLEL(auto) */  regexp_substr(''نسبت وابستگي به سپرده ها,
نسبت وابستگي به موسسات مالي,
نسبت آسيب پذيري نقدينگي,
نسبت پوشش سرمايه گذاري بانک,
نسبت پوشش تسهيلات توسط سپرده ها,
نسبت پوشش بدهي هاي کوتاه مدت توسط دارايي هاي نقد,
نسبت قابليت نقد شوندگي,
نسبت اوراق بهادار تجاري و غير تجاري به دارايي هاي نقد,
نسبت وجه نقد,
نسبت پوشش جريان نقد,
نسبت پوشش نوسانات,
نسبت پوشش بدهي کوتاه مدت,
نسبت موجودي نقد به کل منابع,
نسبت موجودي نقد و موجودي نزد بانک ها به کل منابع,
نسبت نقد ارز,
نسبت پوشش بدهي,
نسبت سپرده هاي ديداري به کل سپرده ها,
نسبت سپردهاي بلند مدت به جمع سپردها'',

''[^,]+'', 1, level) 

as "name",level as "id" from dual
connect by regexp_substr(''نسبت وابستگي به سپرده ها,
نسبت وابستگي به موسسات مالي,
نسبت آسيب پذيري نقدينگي,
نسبت پوشش سرمايه گذاري بانک,
نسبت پوشش تسهيلات توسط سپرده ها,
نسبت پوشش بدهي هاي کوتاه مدت توسط دارايي هاي نقد,
نسبت قابليت نقد شوندگي,
نسبت اوراق بهادار تجاري و غير تجاري به دارايي هاي نقد,
نسبت وجه نقد,
نسبت پوشش جريان نقد,
نسبت پوشش نوسانات,
نسبت پوشش بدهي کوتاه مدت,
نسبت موجودي نقد به کل منابع,
نسبت موجودي نقد و موجودي نزد بانک ها به کل منابع,
نسبت نقد ارز,
نسبت پوشش بدهي,
نسبت سپرده هاي ديداري به کل سپرده ها,
نسبت سپردهاي بلند مدت به جمع سپردها'',

''[^,]+'', 1, level) is not null
  ';
end;
 
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/    
FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2 
 as
 
 begin
 
 return 'SELECT  RATE_ID as "id", MINVAL as "minValue", MAXVAL as "maxValue",mincolor as "minColor",maxcolor as "maxColor" FROM TBL_LIQUIDITY_RATES_LIMIT order by ID ';
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2 ,outpar_id out varchar2)  
 as
 begin
 UPDATE TBL_LIQUIDITY_RATES_LIMIT
SET minval       =inpar_minval
,
maxval =inpar_max_val
,
MINCOLOR = inpar_mincolor
,
MAXCOLOR = inpar_maxcolor
WHERE 
RATE_ID = INPAR_rate_id
;
commit;
outpar_id :=1;
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/    
  FUNCTION FNC_LIQUIDITY_RATES_NOTIF ( INPAR_DATE IN DATE ) RETURN VARCHAR2 AS
 VAR_DATE           VARCHAR2(100);
 VAR_SELECT         VARCHAR2(30000);
 VAR_FINAL_SELECT   VARCHAR2(30000);
 PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
 SELECT
  TO_CHAR(INPAR_DATE,'yyyy-mm-dd')
 INTO
  VAR_DATE
 FROM DUAL;

 SELECT
  PKG_LIQUIDITY_RATES.FNC_LIQUIDITY_RATES_RESULT(VAR_DATE,NULL,4)
 INTO
  VAR_SELECT
 FROM DUAL;
 delete from TBL_NOTIFICATIONS where TYPE = 'liquidity-reports';
commit;
 VAR_FINAL_SELECT   := '
  INSERT
INTO TBL_NOTIFICATIONS
  (
 
    TITLE, --toozih -> for example ;  nesbate X bishtar az hade mojaz ast
    TYPE, --esme gozaresh (nesbat haE naghdinegi)
    START_TIME, --tarikh shoroE 
    END_TIME, --tarikh payan
    STATUS, -- finished
    DESCRIPTION --description
  )
  SELECT case when less_more= 1 then "name"||'' کمتر از حد مجاز است'' else  "name"||'' بيشتر از حد مجاز است''  end,  ''liquidity-reports'',sysdate,sysdate,''finished'','''' from (
 SELECT a."id",a."value",case when a."value" <b.minval then 1 when a."value" >b.maxval then 2 else 0 end as less_more,C."name" FROM (
 '
|| VAR_SELECT || ' )a,
 ( select * from TBL_LIQUIDITY_RATES_LIMIT)b,
 (
 '||PKG_LIQUIDITY_RATES.FNC_liquidity_return_var_name||'
 )c
 where 
 a."id" = b.rate_id
 and (a."value" > b.maxval
 or 
 a."value"<b.minval
)  and c."id" = a."id");
 
 '
;
EXECUTE IMMEDIATE 'begin ' ||VAR_FINAL_SELECT || 'end;';
commit;
 RETURN 1;
END;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    
    

end pkg_liquidity_rates;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LIQUIDITY_RATES" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_result  (
 
 inpar_date    IN varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2
 ,outpar_id out varchar2)  ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_notif(inpar_date  IN date)   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end pkg_liquidity_rates;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LIQUIDITY_RATES" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_result  (
 
 inpar_date    IN varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2
 ,outpar_id out varchar2)  ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_liquidity_rates_notif(inpar_date  IN date)   RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end pkg_liquidity_rates;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LIQUIDITY_RATES" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Bank:        "توسعه صادرات"
  Description: "گزارش نسبت هاي نقدينگي براي بانک توسعه صادرات"
    */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_liquidity_rates_result  (
 
 inpar_date     in varchar,
 inpar_BRANCH   IN varchar,
  inpar_CUR   IN varchar
 
 ) return varchar2 as
 
    VAR_PARTITION1 VARCHAR2(200) := 'P'||TO_CHAR(to_date(INPAR_DATE,'yyyy-mm-dd'),'J');
    
 VAR_CASH_MONEY                   VARCHAR2(1000) := '100000000 ,200000000';   /*VARCHAR2(1000);*/
 VAR_TRANSACTION_SECURITIES       VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_INVESTMENT        VARCHAR2(1000) := '200000000';
 VAR_TOTAL_DEPOSIT                VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_BANK_EXPOSURES    VARCHAR2(1000) := '200000000';
 VAR_RESOURCES_ABSORBED           VARCHAR2(1000) := '200000000';
 VAR_LOST_ASSETS                  VARCHAR2(1000) := '200000000';
 VAR_REMOVABLE_FUNDS              VARCHAR2(1000) := '200000000';
 VAR_EQUITY                       VARCHAR2(1000) := '200000000';
 VAR_INVESTING_IN_COMPANIES       VARCHAR2(1000) := '200000000';
 VAR_VISIBLE_ASSETS               VARCHAR2(1000) := '200000000';
 VAR_INTANGIBLE_ASSETS            VARCHAR2(1000) := '200000000';
 VAR_DEPOSIT                      VARCHAR2(1000) := '200000000';
 VAR_LOAN                         VARCHAR2(1000) := '200000000';
 VAR_CASH_ASSETS                  VARCHAR2(1000) := '200000000';
 VAR_HIGH_LIQUIDITY_CASH          VARCHAR2(1000) := '200000000';
 VAR_SHORT_TERM_DEBT              VARCHAR2(1000) := '200000000';
 VAR_NET_CASH                     VARCHAR2(1000) := '200000000';
 VAR_BONDS                        VARCHAR2(1000) := '200000000';
 VAR_CASH_INVENTORY               VARCHAR2(1000) := '200000000';
 VAR_CASH_FLOWS_INPUT_PREDIC      VARCHAR2(1000) := '200000000';
 VAR_CASH_FLOWS_OUTPUT_PREDIC     VARCHAR2(1000) := '200000000';
 VAR_TOTAL_ESCAPE_DEPOSIT         VARCHAR2(1000) := '200000000';
 VAR_TOTAL_CASH_BALANCE           VARCHAR2(1000) := '200000000';
 VAR_TOTAL_BALANCE                VARCHAR2(1000) := '200000000';
 VAR_ALL_BANK_RESOURCES           VARCHAR2(1000) := '200000000';
 VAR_CASH_CURRENCY                VARCHAR2(1000) := '200000000';
 VAR_TOTAL_CURRENCY               VARCHAR2(1000) := '200000000';
 VAR_LONG_TERM_INVESTMENT         VARCHAR2(1000) := '200000000';
 VAR_TOTAL_BANK_ASSETS            VARCHAR2(1000) := '200000000';
 VAR_visitor_deposit              VARCHAR2(1000) := '300000000,200000000,100000000';
 VAR_long_term_deposit            VARCHAR2(1000) := '200000000';
 /***************************************************************************************************************************/
 CASH_MONEY                       NUMBER;
 TRANSACTION_SECURITIES           NUMBER;
 SHORT_TERM_INVESTMENT            NUMBER;
 TOTAL_DEPOSIT                    NUMBER;
 SHORT_TERM_BANK_EXPOSURES        NUMBER;
 RESOURCES_ABSORBED               NUMBER;
 LOST_ASSETS                      NUMBER;
 REMOVABLE_FUNDS                  NUMBER;
 EQUITY                           NUMBER;
 INVESTING_IN_COMPANIES           NUMBER;
 VISIBLE_ASSETS                   NUMBER;
 INTANGIBLE_ASSETS                NUMBER;
 DEPOSIT                          NUMBER;
 LOAN                             NUMBER;
 CASH_ASSETS                      NUMBER;
 HIGH_LIQUIDITY_CASH              NUMBER;
 SHORT_TERM_DEBT                  NUMBER;
 NET_CASH                         NUMBER;
 BONDS                            NUMBER;
 CASH_INVENTORY                   NUMBER;
 CASH_FLOWS_INPUT_PREDIC          NUMBER;
 CASH_FLOWS_OUTPUT_PREDIC         NUMBER;
 TOTAL_ESCAPE_DEPOSIT             NUMBER;
 TOTAL_CASH_BALANCE               NUMBER;
 TOTAL_BALANCE                    NUMBER;
 ALL_BANK_RESOURCES               NUMBER;
 CASH_CURRENCY                    NUMBER;
 TOTAL_CURRENCY                   NUMBER;
 LONG_TERM_INVESTMENT             NUMBER;
 TOTAL_BANK_ASSETS                NUMBER;
 visitor_deposit              NUMBER;
 long_term_deposit            NUMBER;
 VAR                              VARCHAR2(30000);
 /*************************************************************************************************/
 VAR_DEPENDENCE_ON_DEPOSITS       NUMBER;
 VAR_REL_TO_FINANCIAL_INSTIT      NUMBER;
 VAR_LIQUIDITY_VULNERABLE_RATIO   NUMBER;
 VAR_BANK_INVSET_COVER_RATIO      NUMBER;
 VAR_LOAN_COVER_BY_DEP_RATIO      NUMBER;
 VAR_DEBT_COVER_BY_CASH_RATIO     NUMBER;
 VAR_CASHMEREABILITY_RATIO        NUMBER;
 VAR_COMMER_NONCOMMER_TO_ASSETS   NUMBER;
 VAR_CASH_RATIO                   NUMBER;
 VAR_FLOW_COVERAGE_RATIO          NUMBER;
 VAR_COVERAGE_FLUCTUATION_RATIO   NUMBER;
 VAR_SHORT_TERM_DEBT_RATIO        NUMBER;
 VAR_CASH_TO_TOTAL_RES_RATIO      NUMBER;
 VAR_TOTAL_BAL_TO_RES_RATIO       NUMBER;
 EXCHANGE_RATE_RATIO              NUMBER;
 DEBT_COVERAGE_RATIO              NUMBER;
 var_visitor_dep_to_total_dep     number;
 var_long_term_dep_to_total_dep   number;
    
   


 /******************************************************************************************************/
BEGIN

if(inpar_cur = 4)
then
 VAR   := '
  SELECT  /*+   PARALLEL(auto) */ 
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_MONEY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TRANSACTION_SECURITIES ||
 ') then  BALANCE end),
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_BANK_EXPOSURES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_RESOURCES_ABSORBED ||
 ') then  BALANCE end) ,
 
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOST_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_REMOVABLE_FUNDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_EQUITY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INVESTING_IN_COMPANIES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_VISIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INTANGIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOAN ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_HIGH_LIQUIDITY_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_DEBT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_NET_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_BONDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_INVENTORY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_INPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_OUTPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_ESCAPE_DEPOSIT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CASH_BALANCE ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BALANCE ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_ALL_BANK_RESOURCES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_CURRENCY ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CURRENCY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LONG_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BANK_ASSETS ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_visitor_deposit ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_long_term_deposit ||
 ') then  BALANCE end) 
  
  
   FROM TBL_LEDGER_BRANCH PARTITION ('||VAR_PARTITION1||') where eff_date = TRUNC(TO_DATE('''||inpar_date||''',''yyyy-mm-dd''))  AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',inpar_BRANCH)
        || ') AND REF_CUR_ID= 4' ;
  else
  
  
   VAR   := '
  SELECT  /*+   PARALLEL(auto) */ 
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_MONEY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TRANSACTION_SECURITIES ||
 ') then  BALANCE end),
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_BANK_EXPOSURES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_RESOURCES_ABSORBED ||
 ') then  BALANCE end) ,
 
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOST_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_REMOVABLE_FUNDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_EQUITY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INVESTING_IN_COMPANIES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_VISIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_INTANGIBLE_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_DEPOSIT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LOAN ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_ASSETS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_HIGH_LIQUIDITY_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_SHORT_TERM_DEBT ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_NET_CASH ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_BONDS ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_INVENTORY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_INPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_FLOWS_OUTPUT_PREDIC ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_ESCAPE_DEPOSIT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CASH_BALANCE ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BALANCE ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_ALL_BANK_RESOURCES ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_CASH_CURRENCY ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_CURRENCY ||
 ') then  BALANCE end) ,
  SUM(case when LEDGER_CODE in (' ||
 VAR_LONG_TERM_INVESTMENT ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_TOTAL_BANK_ASSETS ||
 ') then  BALANCE end) ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_visitor_deposit ||
 ') then  BALANCE end)  ,
    SUM(case when LEDGER_CODE in (' ||
 VAR_long_term_deposit ||
 ') then  BALANCE end) 
  
  
  
   FROM TBL_LEDGER_BRANCH PARTITION ('||VAR_PARTITION1||') where eff_date = TRUNC(TO_DATE('''||inpar_date||''',''yyyy-mm-dd''))  AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',inpar_BRANCH)
        || ') AND REF_CUR_ID <> 4' ;
  
  end if;
 
 EXECUTE IMMEDIATE VAR INTO
  CASH_MONEY,TRANSACTION_SECURITIES,SHORT_TERM_INVESTMENT,TOTAL_DEPOSIT,SHORT_TERM_BANK_EXPOSURES,RESOURCES_ABSORBED,LOST_ASSETS,REMOVABLE_FUNDS
,EQUITY,INVESTING_IN_COMPANIES,VISIBLE_ASSETS,INTANGIBLE_ASSETS,DEPOSIT,LOAN,CASH_ASSETS,HIGH_LIQUIDITY_CASH,SHORT_TERM_DEBT,NET_CASH
,BONDS,CASH_INVENTORY,CASH_FLOWS_INPUT_PREDIC,CASH_FLOWS_OUTPUT_PREDIC,TOTAL_ESCAPE_DEPOSIT,TOTAL_CASH_BALANCE,TOTAL_BALANCE,ALL_BANK_RESOURCES
,CASH_CURRENCY,TOTAL_CURRENCY,LONG_TERM_INVESTMENT,TOTAL_BANK_ASSETS,visitor_deposit,long_term_deposit;

 VAR_DEPENDENCE_ON_DEPOSITS       := (cash_money +transaction_securities +short_term_investment )/(total_deposit);
 VAR_REL_TO_FINANCIAL_INSTIT       := (cash_money +transaction_securities +short_term_bank_exposures)/(resources_absorbed);
 VAR_LIQUIDITY_VULNERABLE_RATIO    :=(lost_assets)/(removable_funds);
 VAR_BANK_INVSET_COVER_RATIO       :=(equity)/(investing_in_companies+visible_assets+intangible_assets);
 VAR_LOAN_COVER_BY_DEP_RATIO       := (deposit)/(loan);
 VAR_DEBT_COVER_BY_CASH_RATIO      := (high_liquidity_cash)/(short_term_debt);
 VAR_CASHMEREABILITY_RATIO         := (net_cash)/(cash_assets);
 VAR_COMMER_NONCOMMER_TO_ASSETS    :=(bonds)/(cash_assets);
 VAR_CASH_RATIO                    := (cash_inventory)/(total_deposit);
 VAR_FLOW_COVERAGE_RATIO           := (cash_flows_input_predic)/(cash_flows_output_predic) ;
 VAR_COVERAGE_FLUCTUATION_RATIO    := (cash_assets)/(total_escape_deposit);
 VAR_SHORT_TERM_DEBT_RATIO         := (cash_assets)/(short_term_debt);
 VAR_CASH_TO_TOTAL_RES_RATIO       := (total_cash_balance)/(all_bank_resources);
 VAR_TOTAL_BAL_TO_RES_RATIO        :=(total_balance)/(all_bank_resources);
 EXCHANGE_RATE_RATIO               :=(cash_currency)/(total_currency);
 DEBT_COVERAGE_RATIO               :=(long_term_investment)/(total_bank_assets);
 var_visitor_dep_to_total_dep      :=  (visitor_deposit)/(total_deposit);
 var_long_term_dep_to_total_dep    :=  (long_term_deposit)/(total_deposit);
 


 return 'select /*+   PARALLEL(auto) */   round( regexp_substr('''   ||
 VAR_DEPENDENCE_ON_DEPOSITS      ||  ',' ||       
 VAR_REL_TO_FINANCIAL_INSTIT     ||  ',' ||
 VAR_LIQUIDITY_VULNERABLE_RATIO  ||  ',' ||
 VAR_BANK_INVSET_COVER_RATIO     ||  ',' ||
 VAR_LOAN_COVER_BY_DEP_RATIO     ||  ',' ||
 VAR_DEBT_COVER_BY_CASH_RATIO    ||  ',' ||
 VAR_CASHMEREABILITY_RATIO       ||  ',' ||
 VAR_COMMER_NONCOMMER_TO_ASSETS  ||  ',' ||
 VAR_CASH_RATIO                  ||  ',' ||
 VAR_FLOW_COVERAGE_RATIO         ||  ',' ||
 VAR_COVERAGE_FLUCTUATION_RATIO  ||  ',' ||
 VAR_SHORT_TERM_DEBT_RATIO       ||  ',' ||
 VAR_CASH_TO_TOTAL_RES_RATIO     ||  ',' ||
 VAR_TOTAL_BAL_TO_RES_RATIO      ||  ',' ||
 EXCHANGE_RATE_RATIO             ||  ',' ||
 DEBT_COVERAGE_RATIO             ||  ',' ||
 var_visitor_dep_to_total_dep    ||  ',' ||
 var_long_term_dep_to_total_dep
 ||
 ''',''[^,]+'',1,level),2) as "value",level as "id" from dual
     connect by regexp_substr('''   ||
 VAR_DEPENDENCE_ON_DEPOSITS      ||  ',' ||
 VAR_REL_TO_FINANCIAL_INSTIT     ||  ',' ||
 VAR_LIQUIDITY_VULNERABLE_RATIO  ||  ',' ||
 VAR_BANK_INVSET_COVER_RATIO     ||  ',' ||
 VAR_LOAN_COVER_BY_DEP_RATIO     ||  ',' ||
 VAR_DEBT_COVER_BY_CASH_RATIO    ||  ',' ||
 VAR_CASHMEREABILITY_RATIO       ||  ',' ||
 VAR_COMMER_NONCOMMER_TO_ASSETS  ||  ',' ||
 VAR_CASH_RATIO                  ||  ',' ||
 VAR_FLOW_COVERAGE_RATIO         ||  ',' ||
 VAR_COVERAGE_FLUCTUATION_RATIO  ||  ',' ||
 VAR_SHORT_TERM_DEBT_RATIO       ||  ',' ||
 VAR_CASH_TO_TOTAL_RES_RATIO     ||  ',' ||
 VAR_TOTAL_BAL_TO_RES_RATIO      ||  ',' ||
 EXCHANGE_RATE_RATIO             ||  ',' ||
 DEBT_COVERAGE_RATIO             ||  ',' ||
 var_visitor_dep_to_total_dep    ||  ',' ||
 var_long_term_dep_to_total_dep
 ||
 ''',''[^,]+'',1,level) is not null';
 

END;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/        
    
    
 FUNCTION FNC_liquidity_return_var_name RETURN VARCHAR2
 
 as
 
 begin 
 
 return '
select /*+   PARALLEL(auto) */  regexp_substr(''نسبت وابستگي به سپرده ها,
نسبت وابستگي به موسسات مالي,
نسبت آسيب پذيري نقدينگي,
نسبت پوشش سرمايه گذاري بانک,
نسبت پوشش تسهيلات توسط سپرده ها,
نسبت پوشش بدهي هاي کوتاه مدت توسط دارايي هاي نقد,
نسبت قابليت نقد شوندگي,
نسبت اوراق بهادار تجاري و غير تجاري به دارايي هاي نقد,
نسبت وجه نقد,
نسبت پوشش جريان نقد,
نسبت پوشش نوسانات,
نسبت پوشش بدهي کوتاه مدت,
نسبت موجودي نقد به کل منابع,
نسبت موجودي نقد و موجودي نزد بانک ها به کل منابع,
نسبت نقد ارز,
نسبت پوشش بدهي,
نسبت سپرده هاي ديداري به کل سپرده ها,
نسبت سپردهاي بلند مدت به جمع سپردها'',

''[^,]+'', 1, level) 

as "name",level as "id" from dual
connect by regexp_substr(''نسبت وابستگي به سپرده ها,
نسبت وابستگي به موسسات مالي,
نسبت آسيب پذيري نقدينگي,
نسبت پوشش سرمايه گذاري بانک,
نسبت پوشش تسهيلات توسط سپرده ها,
نسبت پوشش بدهي هاي کوتاه مدت توسط دارايي هاي نقد,
نسبت قابليت نقد شوندگي,
نسبت اوراق بهادار تجاري و غير تجاري به دارايي هاي نقد,
نسبت وجه نقد,
نسبت پوشش جريان نقد,
نسبت پوشش نوسانات,
نسبت پوشش بدهي کوتاه مدت,
نسبت موجودي نقد به کل منابع,
نسبت موجودي نقد و موجودي نزد بانک ها به کل منابع,
نسبت نقد ارز,
نسبت پوشش بدهي,
نسبت سپرده هاي ديداري به کل سپرده ها,
نسبت سپردهاي بلند مدت به جمع سپردها'',

''[^,]+'', 1, level) is not null
  ';
end;
 
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/    
FUNCTION FNC_liquidity_rates_limit   RETURN VARCHAR2 
 as
 
 begin
 
 return 'SELECT  RATE_ID as "id", MINVAL as "minValue", MAXVAL as "maxValue",mincolor as "minColor",maxcolor as "maxColor" FROM TBL_LIQUIDITY_RATES_LIMIT order by ID ';
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_liquidity_update_limit ( INPAR_rate_id IN NUMBER ,inpar_minval in number,inpar_max_val in number,inpar_mincolor in varchar2, inpar_maxcolor in varchar2 ,outpar_id out varchar2)  
 as
 begin
 UPDATE TBL_LIQUIDITY_RATES_LIMIT
SET minval       =inpar_minval
,
maxval =inpar_max_val
,
MINCOLOR = inpar_mincolor
,
MAXCOLOR = inpar_maxcolor
WHERE 
RATE_ID = INPAR_rate_id
;
commit;
outpar_id :=1;
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/    
  FUNCTION FNC_LIQUIDITY_RATES_NOTIF ( INPAR_DATE IN DATE ) RETURN VARCHAR2 AS
 VAR_DATE           VARCHAR2(100);
 VAR_SELECT         VARCHAR2(30000);
 VAR_FINAL_SELECT   VARCHAR2(30000);
 PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
 SELECT
  TO_CHAR(INPAR_DATE,'yyyy-mm-dd')
 INTO
  VAR_DATE
 FROM DUAL;

 SELECT
  PKG_LIQUIDITY_RATES.FNC_LIQUIDITY_RATES_RESULT(VAR_DATE,NULL,4)
 INTO
  VAR_SELECT
 FROM DUAL;
 delete from TBL_NOTIFICATIONS where TYPE = 'liquidity-reports';
commit;
 VAR_FINAL_SELECT   := '
  INSERT
INTO TBL_NOTIFICATIONS
  (
 
    TITLE, --toozih -> for example ;  nesbate X bishtar az hade mojaz ast
    TYPE, --esme gozaresh (nesbat haE naghdinegi)
    START_TIME, --tarikh shoroE 
    END_TIME, --tarikh payan
    STATUS, -- finished
    DESCRIPTION --description
  )
  SELECT case when less_more= 1 then "name"||'' کمتر از حد مجاز است'' else  "name"||'' بيشتر از حد مجاز است''  end,  ''liquidity-reports'',sysdate,sysdate,''finished'','''' from (
 SELECT a."id",a."value",case when a."value" <b.minval then 1 when a."value" >b.maxval then 2 else 0 end as less_more,C."name" FROM (
 '
|| VAR_SELECT || ' )a,
 ( select * from TBL_LIQUIDITY_RATES_LIMIT)b,
 (
 '||PKG_LIQUIDITY_RATES.FNC_liquidity_return_var_name||'
 )c
 where 
 a."id" = b.rate_id
 and (a."value" > b.maxval
 or 
 a."value"<b.minval
)  and c."id" = a."id");
 
 '
;
EXECUTE IMMEDIATE 'begin ' ||VAR_FINAL_SELECT || 'end;';
commit;
 RETURN 1;
END;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    
    

end pkg_liquidity_rates;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CUSTOMER_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req              IN VARCHAR2
  
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    FUNCTION fnc_customer_conc_final_result (
 inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CUSTOMER_CONC;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CUSTOMER_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req              IN VARCHAR2
  
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    FUNCTION fnc_customer_conc_final_result (
 inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CUSTOMER_CONC;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CUSTOMER_CONC" AS
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 ) 
 as
 begin
 
     DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;
     OUTPAR:= INPAR_ID;
    COMMIT;
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value
   
   as
   begin
   EXECUTE IMMEDIATE 'truncate table TBL_CUSTOMER_CONS_VALUE ';

INSERT  /*+ append  PARALLEL(auto)   */
INTO TBL_CUSTOMER_CONS_VALUE
  (
    REF_CUSTOMER,
    RATE,
    BALANCE,
    TYPE
  )
  
  select /*+  PARALLEL(auto)   */ REF_CUSTOMER,rate,sum(balance),case when ref_deposit_type = 1000123 then 2 
when ref_deposit_type = 1000124 then 4 else   MODALITY_TYPE end modality from AKIN.TBL_DEPOSIT 
group by REF_CUSTOMER,rate,case when ref_deposit_type = 1000123 then 2 
when ref_deposit_type = 1000124 then 4 else   MODALITY_TYPE end;
commit;
   end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/



   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req                 IN VARCHAR2
  
 )
 as

 begin
 
PRC_customer_conc_REPORT_value;

INSERT
  /*+parallel(auto)*/
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    CATEGORY,
    BALANCE,
    BALANCE_TAJAMOE,
    SHARE_OF_TOTAL_BAL,
    SHARE_OF_TOTAL_BAL_TAJAMOE,
    CUSTOMER_COUNT,
    CUSTOMER_COUNT_TAJAMOE,
    SHARE_OF_TOTAL_CUS,
    SHARE_OF_TOTAL_CUS_TAJAMOE
    ,eff_date
    ,TYPE
  )
SELECT
  /*+parallel(auto)*/
     10,
    11,
  1 AS radif ,
   SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE
  ,trunc(sysdate)
  ,1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  2,
   SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  3,
   SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  4,
   SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  5,
   SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  6,
   SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  7,
   SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)           AS balance,
  SUM( balance ) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)         /SUM(balance)*100 AS sahm_az_kol,
  SUM( balance)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)           AS tedad_moshtari,
  COUNT(balance) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)          /COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  COUNT(balance)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1;

commit;

INSERT
  /*+parallel(auto)*/
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    CATEGORY,
    BALANCE,
    BALANCE_TAJAMOE,
    SHARE_OF_TOTAL_BAL,
    SHARE_OF_TOTAL_BAL_TAJAMOE,
    CUSTOMER_COUNT,
    CUSTOMER_COUNT_TAJAMOE,
    SHARE_OF_TOTAL_CUS,
    SHARE_OF_TOTAL_CUS_TAJAMOE
    ,eff_date
    ,TYPE
  )
  SELECT
  /*+parallel(auto)*/
     10,
    11,
  1 AS radif ,
   SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE
  ,trunc(sysdate)
  ,3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  2,
   SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  3,
   SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  4,
   SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  5,
   SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  6,
   SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  7,
   SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)           AS balance,
  SUM( balance ) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)         /SUM(balance)*100 AS sahm_az_kol,
  SUM( balance)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)           AS tedad_moshtari,
  COUNT(balance) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)          /COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  COUNT(balance)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3;
commit;



INSERT
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    BALANCE,
    REGION_NAME,
    CUSTOMER_COUNT,
    TYPE,
    EFF_DATE
    
  )
 
select /*+  PARALLEL(30) */ 10,11, sum(balance) as mablagh ,max(REGION_NAME) as name , count(1) as tedad,4,trunc(sysdate)  from AKIN.TBL_DEPOSIT where REF_DEPOSIT_TYPE in (1000124) group by REGION_ID;
commit;



INSERT
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    BALANCE,
    REGION_NAME,
    CUSTOMER_COUNT,
    TYPE,
    EFF_DATE
    
  )
 
select /*+  PARALLEL(30) */ 10,11, sum(balance) as mablagh ,max(REGION_NAME) as name , count(1) as tedad,2,trunc(sysdate)  from AKIN.TBL_DEPOSIT where REF_DEPOSIT_TYPE in (1000123) group by REGION_ID;
commit;





 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   FUNCTION fnc_customer_conc_final_result (
inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2
 as
 begin
 
 
 if(inpar_type in (1,3))
 then
 return 'SELECT 
  CATEGORY as "category",
  
  
  case when CATEGORY = 1 then ''0-1'' when CATEGORY = 2 then ''1-5''
  
  when CATEGORY = 3 then ''5-10''
  when CATEGORY = 4 then ''10-50''
  when CATEGORY = 5 then ''50-100''
  when CATEGORY = 6 then ''100-500''
  when CATEGORY = 7 then ''بيشتر از 500''
  
  end as "name",
  
    BALANCE as "balance",
  round(SHARE_OF_TOTAL_BAL,5) as "shareOfTotalBalance",
  CUSTOMER_COUNT as "customerCount",
   round(SHARE_OF_TOTAL_CUS,5) as "shareOfTotalCustomer",
  
    BALANCE_tajamoe as "balanceTajamoe",
  round(SHARE_OF_TOTAL_BAL_tajamoe,5) as "shareOfTotalBalanceTajamoe",
  CUSTOMER_COUNT_tajamoe as "customerCountTajamoe",
  round(SHARE_OF_TOTAL_CUS_tajamoe,5) as "shareOfTotalCustomerTajamoe"

FROM TBL_CUSTOMER_CONC_FINAL_RESULT 
where eff_date = to_date(''' ||
 INPAR_DATE ||
 ''',''yyyy-mm-dd'')
 and 
 type = '||inpar_type||'';
 
 
 else
 
 return 'SELECT

  BALANCE as "balance",
  CUSTOMER_COUNT as "customerCount",
  

  REGION_NAME as "regionName"
FROM TBL_CUSTOMER_CONC_FINAL_RESULT 
where eff_date = to_date(''' ||
 INPAR_DATE ||
 ''',''yyyy-mm-dd'')
 and 
 type = '||inpar_type||'';
 
 
 
 end if;
 
 
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2
    as
    begin
    
    return 'select   WMSYS.Wm_Concat(to_char(  eff_date,''yyyy-mm-dd'' , ''nls_calendar= persian'')) as "date" from ( select distinct eff_date from TBL_CUSTOMER_CONC_FINAL_RESULT)';
    
    
    end;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CUSTOMER_CONC;

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CUSTOMER_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req              IN VARCHAR2
  
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    FUNCTION fnc_customer_conc_final_result (
 inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CUSTOMER_CONC;


  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CUSTOMER_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req              IN VARCHAR2
  
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    FUNCTION fnc_customer_conc_final_result (
 inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CUSTOMER_CONC;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CUSTOMER_CONC" AS
/*---------------------------------------------------------------------------------------------*/
/*-----------تمرکز مشتري*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 PROCEDURE PRC_cus_conc_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 ) 
 as
 begin
 
     DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;
     OUTPAR:= INPAR_ID;
    COMMIT;
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   PROCEDURE PRC_customer_conc_REPORT_value
   
   as
   begin
   EXECUTE IMMEDIATE 'truncate table TBL_CUSTOMER_CONS_VALUE ';

INSERT  /*+ append  PARALLEL(auto)   */
INTO TBL_CUSTOMER_CONS_VALUE
  (
    REF_CUSTOMER,
    RATE,
    BALANCE,
    TYPE
  )
  
  select /*+  PARALLEL(auto)   */ REF_CUSTOMER,rate,sum(balance),case when ref_deposit_type = 1000123 then 2 
when ref_deposit_type = 1000124 then 4 else   MODALITY_TYPE end modality from AKIN.TBL_DEPOSIT 
group by REF_CUSTOMER,rate,case when ref_deposit_type = 1000123 then 2 
when ref_deposit_type = 1000124 then 4 else   MODALITY_TYPE end;
commit;
   end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/



   PROCEDURE PRC_customer_conc_final_result (
  INPAR_report              IN VARCHAR2
 ,INPAR_rep_req                 IN VARCHAR2
  
 )
 as

 begin
 
PRC_customer_conc_REPORT_value;

INSERT
  /*+parallel(auto)*/
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    CATEGORY,
    BALANCE,
    BALANCE_TAJAMOE,
    SHARE_OF_TOTAL_BAL,
    SHARE_OF_TOTAL_BAL_TAJAMOE,
    CUSTOMER_COUNT,
    CUSTOMER_COUNT_TAJAMOE,
    SHARE_OF_TOTAL_CUS,
    SHARE_OF_TOTAL_CUS_TAJAMOE
    ,eff_date
    ,TYPE
  )
SELECT
  /*+parallel(auto)*/
     10,
    11,
  1 AS radif ,
   SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE
  ,trunc(sysdate)
  ,1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  2,
   SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  3,
   SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  4,
   SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  5,
   SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  6,
   SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  7,
   SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)           AS balance,
  SUM( balance ) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)         /SUM(balance)*100 AS sahm_az_kol,
  SUM( balance)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)           AS tedad_moshtari,
  COUNT(balance) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)          /COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  COUNT(balance)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),1
FROM TBL_CUSTOMER_CONS_VALUE where type = 1;

commit;

INSERT
  /*+parallel(auto)*/
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    CATEGORY,
    BALANCE,
    BALANCE_TAJAMOE,
    SHARE_OF_TOTAL_BAL,
    SHARE_OF_TOTAL_BAL_TAJAMOE,
    CUSTOMER_COUNT,
    CUSTOMER_COUNT_TAJAMOE,
    SHARE_OF_TOTAL_CUS,
    SHARE_OF_TOTAL_CUS_TAJAMOE
    ,eff_date
    ,TYPE
  )
  SELECT
  /*+parallel(auto)*/
     10,
    11,
  1 AS radif ,
   SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 1000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE
  ,trunc(sysdate)
  ,3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  2,
   SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 1000000000
    AND balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 5000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  3,
   SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 5000000000
    AND balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 10000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  4,
   SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 10000000000
    AND balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 50000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  5,
   SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 50000000000
    AND balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 100000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  6,
   SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN balance
    ELSE 0
  END)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance > 100000000000
    AND balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  SUM(
  CASE
    WHEN balance <= 500000000000
    THEN 1
    ELSE 0
  END)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3
UNION
SELECT
  /*+parallel(auto)*/
     10,
    11,
  7,
   SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)           AS balance,
  SUM( balance ) AS balance_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN balance
    ELSE 0
  END)         /SUM(balance)*100 AS sahm_az_kol,
  SUM( balance)/SUM(balance)*100 AS sahm_az_kol_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)           AS tedad_moshtari,
  COUNT(balance) AS tedad_moshtari_tajamoE,
  SUM(
  CASE
    WHEN balance >= 500000000000
    THEN 1
    ELSE 0
  END)          /COUNT(1) * 100 AS sahm_az_kol_moshtarian,
  COUNT(balance)/COUNT(1) * 100 AS sahm_az_kol_moshtarian_tajamoE ,trunc(sysdate),3
FROM TBL_CUSTOMER_CONS_VALUE where type = 3;
commit;



INSERT
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    BALANCE,
    REGION_NAME,
    CUSTOMER_COUNT,
    TYPE,
    EFF_DATE
    
  )
 
select /*+  PARALLEL(30) */ 10,11, sum(balance) as mablagh ,max(REGION_NAME) as name , count(1) as tedad,4,trunc(sysdate)  from AKIN.TBL_DEPOSIT where REF_DEPOSIT_TYPE in (1000124) group by REGION_ID;
commit;



INSERT
INTO TBL_CUSTOMER_CONC_FINAL_RESULT
  (
    REF_REPORT,
    REF_REPREQ,
    BALANCE,
    REGION_NAME,
    CUSTOMER_COUNT,
    TYPE,
    EFF_DATE
    
  )
 
select /*+  PARALLEL(30) */ 10,11, sum(balance) as mablagh ,max(REGION_NAME) as name , count(1) as tedad,2,trunc(sysdate)  from AKIN.TBL_DEPOSIT where REF_DEPOSIT_TYPE in (1000123) group by REGION_ID;
commit;





 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

   FUNCTION fnc_customer_conc_final_result (
inpar_date                 IN varchar2,
 inpar_type in varchar2
  
 )RETURN VARCHAR2
 as
 begin
 
 
 if(inpar_type in (1,3))
 then
 return 'SELECT 
  CATEGORY as "category",
  
  
  case when CATEGORY = 1 then ''0-1'' when CATEGORY = 2 then ''1-5''
  
  when CATEGORY = 3 then ''5-10''
  when CATEGORY = 4 then ''10-50''
  when CATEGORY = 5 then ''50-100''
  when CATEGORY = 6 then ''100-500''
  when CATEGORY = 7 then ''بيشتر از 500''
  
  end as "name",
  
    BALANCE as "balance",
  round(SHARE_OF_TOTAL_BAL,5) as "shareOfTotalBalance",
  CUSTOMER_COUNT as "customerCount",
   round(SHARE_OF_TOTAL_CUS,5) as "shareOfTotalCustomer",
  
    BALANCE_tajamoe as "balanceTajamoe",
  round(SHARE_OF_TOTAL_BAL_tajamoe,5) as "shareOfTotalBalanceTajamoe",
  CUSTOMER_COUNT_tajamoe as "customerCountTajamoe",
  round(SHARE_OF_TOTAL_CUS_tajamoe,5) as "shareOfTotalCustomerTajamoe"

FROM TBL_CUSTOMER_CONC_FINAL_RESULT 
where eff_date = to_date(''' ||
 INPAR_DATE ||
 ''',''yyyy-mm-dd'')
 and 
 type = '||inpar_type||'';
 
 
 else
 
 return 'SELECT

  BALANCE as "balance",
  CUSTOMER_COUNT as "customerCount",
  

  REGION_NAME as "regionName"
FROM TBL_CUSTOMER_CONC_FINAL_RESULT 
where eff_date = to_date(''' ||
 INPAR_DATE ||
 ''',''yyyy-mm-dd'')
 and 
 type = '||inpar_type||'';
 
 
 
 end if;
 
 
 end;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

    FUNCTION fnc_get_available_date RETURN VARCHAR2
    as
    begin
    
    return 'select   WMSYS.Wm_Concat(to_char(  eff_date,''yyyy-mm-dd'' , ''nls_calendar= persian'')) as "date" from ( select distinct eff_date from TBL_CUSTOMER_CONC_FINAL_RESULT)';
    
    
    end;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CUSTOMER_CONC;
Create View NVW_LEDGER As SELECT DISTINCT
  ( LEDGER_CODE ) AS "id"
 ,(
   SELECT DISTINCT
    ( MAX(DEPTH) )
   FROM TBL_LEDGER
  ) AS "maxlev"
 ,NAME ||' '||  LEDGER_CODE AS "text"
 ,PARENT_CODE AS "parent"
 ,DEPTH AS "level",
 to_char( nvl(case when length(LEDGER_CODE ) < 10 then substr(LEDGER_CODE,2) else
substr(LEDGER_CODE, 2,7)||'-'||substr(LEDGER_CODE, 10)
end,0) ) AS "id2"
 FROM TBL_LEDGER
 START WITH
  PARENT_CODE IS NULL
 CONNECT BY
  PRIOR LEDGER_CODE = PARENT_CODE
 ORDER BY LEDGER_CODE;
Create View NVW_LEDGER_TREE As SELECT
  PARENT_CODE "parent"
 ,NAME "text"
 ,DEPTH "level"
 ,LEDGER_CODE "id"
 ,BALANCE "value"
 FROM TBL_LEDGER_ARCHIVE;
Create View NVW_LOG_BRIEF As WITH TMP AS (
SELECT REF_LOG, 
SUM(CASE  WHEN NAM LIKE '%TIME%'  THEN ROUND(TO_NUMBER(MEGHDAR)/1000,1)  ELSE 0  END) ZAMAN_KOL,
SUM(CASE   WHEN NAM LIKE '%NEGASHT%'  THEN ROUND(TO_NUMBER(MEGHDAR)/1000,1)  ELSE 0 END) ZAMAN_NEGASHT,
MAX(CASE WHEN NAM LIKE 'TOTAL_CNT' THEN MEGHDAR ELSE NULL END) TEDAD_KOL
FROM TBL_LOG_DETAIL
GROUP BY REF_LOG
ORDER BY REF_LOG)
SELECT   T.REF_LOG,
               L.TARIKH_EJRA,
               L.NAM_BANK,
               TO_CHAR( T.TEDAD_KOL, '999,999,999,999') TEDAD_KOL,
               TO_CHAR(to_date(ROUND(T.ZAMAN_KOL,0),'SSSSS'),'HH24:MI:SS') ZAMAN_KOL, 
               TO_CHAR(to_date(ROUND(T.ZAMAN_NEGASHT,0),'SSSSS'),'HH24:MI:SS') ZAMAN_NEGHASHT,
               TO_CHAR(to_date(ROUND(T.ZAMAN_KOL - T.ZAMAN_NEGASHT,0),'SSSSS'),'HH24:MI:SS') ZAMAN_DIGAR 
FROM TMP T JOIN  TBL_LOG L ON T.REF_LOG = L.ID;
Create View NVW_com_excess_reserve As SELECT DISTINCT ref_branch,excess_reserve,eff_date from tbl_com_excess_reserve;
Create View NVW_COM_EX_RES_PREDICTION As SELECT REF_BRANCH,EXCESS_RESERVE,DU_PRIORITY,DURATION_TYPE,REF_DEPOSIT_TYPE
    FROM TBL_COM_EX_RES_PREDICTION , TBL_DEPOSIT_TYPE;
Create View NVW_COM_TRANS_TOTAL_DAILY As select sum(trans_num),eff_date from tbl_com_transaction group by eff_date;
Create View NVW_COM_preprediction As SELECT 2 AS "type_id",
    eff_date,
    amount
  FROM tbl_com_ledger_type_main
  WHERE type = 2
  
  UNION ALL
  
  SELECT 1 AS "type_id",
    eff_date,
    amount
  FROM tbl_com_ledger_type_main
  WHERE type = 1
  
  UNION ALL
  
  SELECT 5 AS "type_id",
    eff_date ,
    SUM(trans_num) AS "amount"
  FROM tbl_com_transaction
  GROUP BY eff_date
  
UNION ALL

select 3 as "type_id",
sysdate,
sum(balance) as "amount"
from akin.tbl_deposit


union all

select deposit_type as "type_id",--4
eff_date,
sum(excess_reserve) as "amount"
from tbl_com_excess_reserve
group by eff_date, DEPOSIT_TYPE;
Create View NVW_COM_ONLINE_preprediction As SELECT 6 AS "type_id",
  
    effdate,
    trans_num AS "amount"
  FROM tbl_com_trans_preprediction
  
  union all
            -- hajme type i
  select 7 as "type_id",
  effdate,
  balance as "amount"
  from TBL_COM_DEPOSIT_PREPREDICTION;
Create View EMP_PUBLIC_DATA As SELECT e.emp_id,
               e.emp_name,
               d.dept_name
        FROM employee e,
            department d;
Create View NVW_CURRENT_SQL As SELECT
--    x.sid,
--    x.serial#,
    x.username,
    x.sql_id,
--    x.sql_child_number,
    optimizer_mode,
--    hash_value,
--    address,
    sql_text
FROM
    v$sqlarea sqlarea,
    v$session x
WHERE
    x.sql_hash_value = sqlarea.hash_value
    AND x.sql_address = sqlarea.address
    AND x.username IS NOT NULL;
