create or replace PACKAGE PG_SAI_CONSULTA IS
    TYPE ccursor IS REF CURSOR;
PROCEDURE PA_SAI_TEMAS(c_temas OUT SYS_REFCURSOR);
PROCEDURE PA_SAI_TIPO_TEMAS(c_tipo_temas OUT SYS_REFCURSOR);
PROCEDURE PA_SAI_ODS(c_ods OUT SYS_REFCURSOR);
PROCEDURE PA_SAI_DECLARACION_MOSCU(c_moscu OUT SYS_REFCURSOR);
PROCEDURE PA_SAI_AMBITO(c_ambito OUT SYS_REFCURSOR);
PROCEDURE PA_SAI_PAIS(c_pais OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GENERIC_SELECT_EXECUTE(sql_stmt VARCHAR2,c_events OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_USUARIOS(c_users OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_AUDITORIA(c_auditoria OUT SYS_REFCURSOR);

PROCEDURE PAI_SAI_INSERT_AUDITORIA(
  categoria  INT      ,
 ffin       DATE     ,
 fini       DATE     ,
  ids        IN OUT INTEGER ,
 imagen     VARCHAR2 ,
 objetivo   VARCHAR2,
 resumen    VARCHAR2,
 tipo       INT      ,
titulo     VARCHAR2 ,
usuario int
);

PROCEDURE PAI_SAI_UPDATE_AUDITORIA(
  categoria  INT      ,
 ffin       DATE     ,
 fini       DATE     ,
  ids        IN OUT INTEGER ,
 imagen     VARCHAR2 ,
 objetivo   VARCHAR2,
 resumen    VARCHAR2,
 tipo       INT      ,
titulo     VARCHAR2 ,
usuario int
);


PROCEDURE PA_SAI_INSERT_USUARIO(
        apellido VARCHAR2,
        correo VARCHAR2, 
        sexo char,
        ids IN OUT INTEGER,
        nombre VARCHAR2,
        pais int,
        clave VARCHAR2,
        rol INT        
        );

PROCEDURE PA_SAI_UPDATE_USUARIO(
        apellido VARCHAR2,
        correo VARCHAR2, 
        sexo char,
        ids IN OUT INTEGER,
        nombre VARCHAR2,
        pais int,
        clave VARCHAR2,
        rol INT        
    );

PROCEDURE PA_SAI_GET_CLASIFICACIONES(auditoria_id NUMBER, c_ods OUT SYS_REFCURSOR, c_moscu OUT SYS_REFCURSOR, c_tag OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GET_PARTICIPANTES(auditoria_id NUMBER, c_participantes OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GET_INFORMES(auditoria_id NUMBER, c_informes OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GET_DETALLE_AUDITORIA(auditoria_id number, c_auditorias2 OUT SYS_REFCURSOR, c_ods2 OUT SYS_REFCURSOR, c_moscus2 OUT SYS_REFCURSOR, c_participantes2 OUT SYS_REFCURSOR, c_informes2 OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GET_AUDITORIA_GENERAL(buscar VARCHAR2:=NULL, c_auditorias OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_GET_AUDITORIA_ADVANCE(idiomas VARCHAR2:=NULL, ambito VARCHAR2:=NULL, pais VARCHAR2:=NULL,inicio VARCHAR2:=NULL, fin VARCHAR2:=NULL,tipo varchar2:=NULL, categoria varchar2:=NULL, ods VARCHAR2:=NULL, moscu varchar2:=NULL,anio VARCHAR2:=null,c_auditorias OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_POLAR_GRAPH(mes VARCHAR2:=NULL, categoria VARCHAR2:=NULL, ods VARCHAR2:=NULL,tipo VARCHAR2:=NULL, pais VARCHAR2:=NULL,anio varchar2:=NULL,c_auditorias OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_DATE_GRAPH(ambito VARCHAR2:=NULL, categoria VARCHAR2:=NULL, ods VARCHAR2:=NULL,tipo VARCHAR2:=NULL, pais VARCHAR2:=NULL,anio varchar2:=NULL,c_auditorias OUT SYS_REFCURSOR);

PROCEDURE PAI_SAI_INSERT_REPORT(
    publicacion DATE,
    idioma int,
    ids IN OUT INTEGER,
    imagen varchar2,
    informe INT,
    pais    int,
    report  INT,
    url varchar2   
);

PROCEDURE PAI_SAI_INSERT_PRACTICE(
    argumento VARCHAR2,
    detalle VARCHAR2,
    estado CHAR,
    ids IN OUT INTEGER,
    nivel VARCHAR2,
    nombre VARCHAR2,
    reporte INT
    );


END PG_SAI_CONSULTA;

/
create or replace PACKAGE BODY      PG_SAI_CONSULTA AS
 
PROCEDURE PA_SAI_GENERIC_SELECT_EXECUTE(sql_stmt VARCHAR2,c_events OUT SYS_REFCURSOR) AS 
BEGIN     
    open c_events for sql_stmt;
END;


PROCEDURE PA_SAI_PAIS(c_pais OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_pais FOR
       SELECT ID , COUNTRY_NAME  AS DESCRIPTION
         FROM SAI_PAIS
        ORDER BY ID;
END;

PROCEDURE PA_SAI_AMBITO(c_ambito OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_ambito FOR
       SELECT ID , GROUP_NAME  AS DESCRIPTION
         FROM SAI_AMBITO
        ORDER BY ID;
END;

PROCEDURE PA_SAI_DECLARACION_MOSCU(c_moscu OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_moscu FOR
       SELECT ID , DECLARATION_NAME  AS DESCRIPTION
         FROM SAI_DECLARACION_MOSCU
        ORDER BY ID;
END;

PROCEDURE PA_SAI_ODS(c_ods OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_ods FOR
       SELECT ID , ODS_NAME  AS DESCRIPTION
         FROM SAI_ODS
        ORDER BY ID;
END;


PROCEDURE PA_SAI_TIPO_TEMAS(c_tipo_temas OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_tipo_temas FOR
       SELECT ID , TYPE_REPORT_NAME  AS DESCRIPTION
         FROM SAI_TIPO_AUDITORIA
        ORDER BY TYPE_REPORT_NAME;
END;

PROCEDURE PA_SAI_TEMAS(c_temas OUT SYS_REFCURSOR)AS
BEGIN
       OPEN c_temas FOR
       SELECT ID  , CATEGORY_NAME AS DESCRIPTION
         FROM SAI_CATEGORIA
        WHERE CATEGORY_STATUS=1
        ORDER BY CATEGORY_NAME;
END;

PROCEDURE PA_SAI_USUARIOS(c_users OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_users FOR
         SELECT 
                U.ID USUARIO_ID,
                U.FIRST_NAME NOMBRE,
                U.LAST_NAME APELLIDO,
                U.EMAIL EMAIL,
                U.LAST_LOGIN LAST_LOGIN,
                U.NUM_LOGIN LOGINGS,
                U.IS_ACTIVE IS_ACTIVE,
                R.SLUG ROL,
                U.GENERO GENERO,
                P.ID PAIS_ID,
                P.SAI_NAME PAIS
                FROM SAI_USUARIOS U
                LEFT JOIN SAI_ROLES R ON R.ID = U.ROL_ID
                LEFT JOIN SAI_EFS P ON P.ID= U.PAIS_ID
                ORDER BY U.ID;   


    END;

PROCEDURE PA_SAI_AUDITORIA(c_auditoria OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_auditoria FOR
            SELECT 
                A.ID REPORT_ID,
                A.REPORT_TITLE,
                A.RERPOR_OBJETIVE,
                A.REPORT_ABSTRACT,
                A.CATEGORY_ID,
                C.CATEGORY_NAME,
                A.TYPE_REPORT_ID,
                T.TYPE_REPORT_NAME,
                A.REPORT_SCOPE_START,
                A.REPORT_SCOPE_END,
                A.REPORT_IMAGE
                FROM sai_auditoria A
                LEFT JOIN SAI_CATEGORIA C ON C.ID = A.CATEGORY_ID
                LEFT JOIN SAI_TIPO_AUDITORIA T ON T.ID= A.TYPE_REPORT_ID
                ORDER BY A.ID;   


    END;


PROCEDURE PAI_SAI_INSERT_AUDITORIA(
    categoria  INT      ,
 ffin       DATE     ,
 fini       DATE     ,
  ids        IN OUT INTEGER ,
 imagen     VARCHAR2 ,
 objetivo   VARCHAR2,
 resumen    VARCHAR2,
 tipo       INT      ,
titulo     VARCHAR2 ,
usuario int
)AS
BEGIN
        INSERT INTO SAI_AUDITORIA(   ID              ,     REPORT_TITLE     ,   RERPOR_OBJETIVE  ,
                                     REPORT_ABSTRACT ,     CATEGORY_ID      ,   TYPE_REPORT_ID   ,
                                     REPORT_SCOPE_START,   REPORT_SCOPE_END ,   
                                     REPORT_IMAGE     ,
                                     CREATED_AT       , ID_USER)
                        VALUES  (ids      , titulo     , objetivo   , resumen    , categoria        ,
                                 tipo     , fini       , ffin       ,
                                 imagen     , SYSDATE, usuario)
        RETURNING ID INTO ids;
        COMMIT;
END;

PROCEDURE PAI_SAI_UPDATE_AUDITORIA(
   categoria  INT      ,
 ffin       DATE     ,
 fini       DATE     ,
  ids        IN OUT INTEGER ,
 imagen     VARCHAR2 ,
 objetivo   VARCHAR2,
 resumen    VARCHAR2,
 tipo       INT      ,
titulo     VARCHAR2,
usuario int
)AS
BEGIN
        UPDATE SAI_AUDITORIA
            SET
                REPORT_TITLE=titulo,
                RERPOR_OBJETIVE=objetivo,
                REPORT_ABSTRACT=resumen,
                CATEGORY_ID=categoria,
                TYPE_REPORT_ID=tipo,
                REPORT_SCOPE_START=fini,
                REPORT_SCOPE_END=ffin,
                REPORT_IMAGE=imagen,
                UPDATED_AT=SYSTIMESTAMP,
                ID_USER =usuario
            WHERE ID = ids
            RETURNING ID INTO  ids;
        COMMIT;
END;


PROCEDURE PA_SAI_INSERT_USUARIO(
        apellido VARCHAR2,
        correo VARCHAR2, 
        sexo char,
        ids IN OUT INTEGER,
        nombre VARCHAR2,
        pais int,
        clave VARCHAR2,
        rol INT        
        ) AS 
    BEGIN     

        Insert into SAI_USUARIOS 
        (
            ID,EMAIL,FIRST_NAME,LAST_NAME,PASSWORD,NUM_LOGIN,CREATED_AT, is_active,ROL_ID, GENERO,PAIS_ID
        ) 
        values (
            ids,correo,nombre,apellido,clave,0,SYSTIMESTAMP,1,rol, sexo,pais
        )
        RETURNING ID INTO ids;
        --UPDATE SAI_USUARIOS SET NUSU_USER_CREATED = ids WHERE NUSU_ID= ids;
        COMMIT;
    END;


PROCEDURE PA_SAI_UPDATE_USUARIO(
        apellido VARCHAR2,
        correo VARCHAR2, 
        sexo char,
        ids IN OUT INTEGER,
        nombre VARCHAR2,
        pais int,
        clave VARCHAR2,
        rol INT        
        ) AS 
    BEGIN     
        IF(clave is NULL) THEN

        UPDATE SAI_USUARIOS
            SET
                EMAIL=correo,
                FIRST_NAME=nombre,
                LAST_NAME=apellido,
                --password=password,
                --LAST_LOGIN=to_date(D_LAST_LOGIN,'DD/MM/YYYY'),
                NUM_LOGIN=NUM_LOGIN+1,
                ROL_ID=rol,
                GENERO=sexo,
                PAIS_ID=pais,
                UPDATED_AT=SYSTIMESTAMP
            WHERE ID = ids
            RETURNING ID INTO  ids;
        ELSE

           UPDATE SAI_USUARIOS
            SET
                EMAIL=correo,
                FIRST_NAME=nombre,
                LAST_NAME=apellido,
                password=clave,
                --LAST_LOGIN=to_date(D_LAST_LOGIN,'DD/MM/YYYY'),
                NUM_LOGIN=NUM_LOGIN+1,
                ROL_ID=rol,
                GENERO=sexo,
                PAIS_ID=pais,
                UPDATED_AT=SYSTIMESTAMP
            WHERE ID = ids
            RETURNING ID INTO  ids;

        END IF;


        COMMIT;
    END;

    PROCEDURE PA_SAI_GET_CLASIFICACIONES(auditoria_id NUMBER, c_ods OUT SYS_REFCURSOR, c_moscu OUT SYS_REFCURSOR, c_tag OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_ods FOR 
            select 
            a.id , 
            a.report_id AUDITORIA_ID, 
            a.ods_id ODS_ID, 
            b.ods_name ODS_NOMBRE 
            from sai_auditoria_ods a
            left join sai_ods b
            on a.ods_id=b.id
            where A.REPORT_ID = auditoria_id;        

        OPEN c_moscu FOR
            select 
                a.id, 
                a.report_id AUDITORIA_ID, 
                a.declaration_moscu_id DECLARACION_MOSCU_ID, 
                b.DECLARATION_name DECLARACION_MOSCU
                from sai_auditoria_MOSCU a
            left join SAI_DECLARACION_MOSCU b
            on a.declaration_moscu_id=b.id
            where a.REPORT_ID= auditoria_id;

        OPEN c_tag FOR
            select 
                a.id, 
                a.report_id AUDITORIA_ID, 
                a.tag_id TAG_ID, 
                b.name TAG_NOMBRE
                from sai_auditoria_tag a
            left join SAI_TAG b
            on a.tag_id=b.id
            where a.REPORT_ID= auditoria_id;    

    END;

    PROCEDURE PA_SAI_GET_PARTICIPANTES(auditoria_id NUMBER, c_participantes OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_participantes FOR 
        SELECT 
            P.ID, P.REPORT_ID, P.AMBITO_ID,
            a.group_name AMBITO_NAME,P.PAIS_ID,
            PA.COUNTRY_NAME PAIS_NAME,P.ENTIDAD,
            P.OTRO_ID, O.VALUE_NAME OTRO_NAME,
            P.ROL_ID , R.VALUE_NAME ROL_NAME
        FROM SAI_PARTICIPANTE P
        LEFT JOIN SAI_AMBITO A
        ON P.AMBITO_ID=A.ID
        LEFT JOIN SAI_PAIS PA
        ON P.PAIS_ID=PA.ID
        LEFT JOIN SAI_PARAMETRO O
        ON P.OTRO_ID=O.CODE and O.id=3
        LEFT JOIN SAI_PARAMETRO R
        ON P.ROL_ID=R.CODE and R.id=2
        WHERE REPORT_ID = auditoria_id;        

    END;

    PROCEDURE PA_SAI_GET_INFORMES(auditoria_id NUMBER, c_informes OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN c_informes FOR 
        SELECT 
            I.ID, REPORT_ID, INFORME_ID, 
            FECHA_PUBLICACION, PAIS_ID, country_name PAIS_NAME, 
            IDIOMA_ID, '' IDIOMA_NAME, ARCHIVO,
            URL_VIDEO 
        FROM SAI_INFORME I
        LEFT JOIN SAI_PAIS P
        ON I.PAIS_ID=P.ID
        WHERE REPORT_ID=auditoria_id;


    END;    

    PROCEDURE PA_SAI_GET_DETALLE_AUDITORIA(auditoria_id number, c_auditorias2 OUT SYS_REFCURSOR, c_ods2 OUT SYS_REFCURSOR, c_moscus2 OUT SYS_REFCURSOR, c_participantes2 OUT SYS_REFCURSOR, c_informes2 OUT SYS_REFCURSOR) as
    BEGIN

    OPEN c_auditorias2 FOR 
        select 
        DISTINCT A.ID as NUMERO_AUDITORIA, A.REPORT_TITLE as TITULO,
        A.RERPOR_OBJETIVE as OBJETIVO, A.report_abstract as DESCRIPCION,
        A.category_id as ID_CATEGORIA, C.Category_name CATEGORIA, 
        A.type_report_id as ID_TIPO_AUDITORIA,TA.type_report_name TIPO_AUDITORIA, 
        A.REPORT_SCOPE_START as FECHA_INICIO, A.REPORT_SCOPE_END as FECHA_FIN,
        A.REPORT_IMAGE FOTO
        from sai_auditoria A
        left join sai_categoria C 
        on A.category_id = c.ID 
        left join sai_tipo_auditoria TA 
        on a.type_report_id = TA.ID
        WHERE A.ID = auditoria_id;

        OPEN c_ods2 FOR 
        SELECT REPORT_ID NUMERO_AUDITORIA, AO.ODS_id ID_ODS, O.ODS_NAME ODS from SAI_AUDITORIA_ODS AO 
        INNER JOIN SAI_ODS O
        ON AO.ODS_id= O.id AND REPORT_ID = auditoria_id;

        OPEN c_moscus2 FOR 
        SELECT REPORT_ID NUMERO_AUDITORIA, am.declaration_moscu_id ID_DECLARACION_MOSCU, dm.declaration_name DECLARACION_MOSCU from SAI_AUDITORIA_MOSCU AM 
        INNER JOIN SAI_DECLARACION_MOSCU DM
        ON am.declaration_moscu_id= dm.id AND REPORT_ID = auditoria_id;

        OPEN c_participantes2 FOR 
        SELECT DISTINCT P.REPORT_ID NUMERO_AUDITORIA, p.ambito_id ID_AMBITO, 
        A.GROUP_NAME AMBITO,P.PAIS_ID ID_PAIS,PA.COUNTRY_NAME PAIS,
        P.ENTIDAD INSTITUCION, P.TIPO_ENTIDAD_ID TIPO_ENTIDAD_ID,
        TE.VALUE_NAME TIPO_ENTIDAD,OTRO_ID ID_OTRO,OT.VALUE_NAME OTRO,
        ROL_ID ID_ROL, RO.VALUE_NAME ROL
        FROM sai_participante P
        LEFT JOIN SAI_AMBITO A
        ON p.ambito_id = a.id
        LEFT JOIN sai_PAIS PA
        ON p.pais_id = pa.id
        LEFT JOIN SAI_PARAMETRO TE
        ON P.TIPO_ENTIDAD_ID = TE.code AND
        TE.ID =1
        LEFT JOIN SAI_PARAMETRO OT
        ON p.otro_id = OT.code AND
        OT.ID =3
        LEFT JOIN SAI_PARAMETRO RO
        ON p.rol_id = RO.code AND
        RO.ID =2
        WHERE P.REPORT_ID=auditoria_id;

        OPEN c_informes2 FOR 
        SELECT REPORT_ID as NUMERO_AUDITORIA, INFORME_ID, FECHA_PUBLICACION, PAIS_ID AS ID_PAIS, p.country_name PAIS, IDIOMA_ID ID_IDIOMA, id.language_name IDIOMA, ARCHIVO, URL_VIDEO
        FROM SAI_INFORME I
        LEFT JOIN SAI_PAIS P
        ON i.pais_id = p.id
        LEFT JOIN SAI_IDIOMA ID
        ON i.idioma_id =id.id
        WHERE REPORT_ID = auditoria_id;


    END;

    PROCEDURE PA_SAI_GET_AUDITORIA_GENERAL(buscar VARCHAR2:=NULL, c_auditorias OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN c_auditorias FOR
        select 
            A.ID as NUMERO_AUDITORIA, A.REPORT_TITLE as TITULO, A.report_abstract as DESCRIPCION,
            A.category_id as ID_CATEGORIA, C.Category_name CATEGORIA, a.type_report_id as ID_TIPO_AUDITORIA,
            ta.type_report_name TIPO_REPORTE, a.REPORT_SCOPE_START as FECHA_INICIO, a.REPORT_SCOPE_END as FECHA_FIN,
            REPORT_IMAGE FOTO
        from sai_auditoria A
        left join sai_categoria C 
        on A.category_id = c.ID 
        left join sai_tipo_auditoria TA 
        on a.type_report_id = TA.ID 
        WHERE
        (
        buscar IS NULL OR
        EXISTS  (
                    SELECT * FROM sai_auditoria_TAG AT
                    LEFT JOIN SAI_TAG ST
                    ON AT.TAG_ID = ST.ID
                    WHERE UPPER(NAME) LIKE '%'|| UPPER(buscar) || '%'
                    AND AT.REPORT_ID   = A.ID
                )
        )         --Palabras claves
        OR 
        (buscar IS NULL OR UPPER(REPORT_ABSTRACT) LIKE '%'|| UPPER(buscar) || '%') -- Descripción
        OR
        (buscar IS NULL OR UPPER(REPORT_TITLE) LIKE '%'|| UPPER(buscar) || '%'); --Título
    END;

    PROCEDURE PA_SAI_GET_AUDITORIA_ADVANCE(idiomas VARCHAR2:=NULL, ambito VARCHAR2:=NULL, pais VARCHAR2:=NULL,inicio VARCHAR2:=NULL, fin VARCHAR2:=NULL,tipo varchar2:=NULL, categoria varchar2:=NULL, ods VARCHAR2:=NULL, moscu varchar2:=NULL, anio VARCHAR2:=null,c_auditorias OUT SYS_REFCURSOR) IS 
    sql_stmt varchar2(4000);
    sql_where varchar2(1000);
    BEGIN     
        sql_stmt := 'select 
            DISTINCT A.ID as NUMERO_AUDITORIA, A.REPORT_TITLE as TITULO, A.report_abstract as DESCRIPCION,
            A.category_id as ID_CATEGORIA, C.Category_name CATEGORIA, a.type_report_id as ID_TIPO_AUDITORIA,
            ta.type_report_name TIPO_REPORTE, a.REPORT_SCOPE_START as FECHA_INICIO, a.REPORT_SCOPE_END as FECHA_FIN,
            REPORT_IMAGE FOTO
        from sai_auditoria A
        left join sai_categoria C 
        on A.category_id = c.ID 
        left join sai_tipo_auditoria TA 
        on a.type_report_id = TA.ID 

        left join SAI_INFORME I
        on I.REPORT_ID = A.ID

        left join sai_participante P
        on P.REPORT_ID = A.ID

        left join sai_auditoria_ods AO
        on A.ID = AO.report_id 

        Left join sai_auditoria_moscu AM
        on A.ID = AM.report_id  
        ';

        sql_where:='';
        if (idiomas is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND I.idioma_id in (' || idiomas || ') ';
            else
                sql_where := sql_where||' I.idioma_id in (' || idiomas || ') ';
            end if;
        end if;

        if (ambito is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND P.ambito_id in (' || ambito || ') ';
            else
                sql_where := sql_where||' P.ambito_id in (' || ambito || ') ';
            end if;
        end if;

        if (pais is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND P.pais_id in (' || pais || ') ';
            else
                sql_where := sql_where|| ' P.pais_id in (' || pais || ') ';
            end if;
        end if;

        if (inicio is not null and fin is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND (a.report_scope_start >= TO_DATE(''' || inicio || ''', ''YYYYMMDD'')  AND a.report_scope_start <= TO_DATE(''' || fin || ''', ''YYYYMMDD'') or  a.report_scope_end >= TO_DATE(''' || inicio || ''', ''YYYYMMDD'')  AND a.report_scope_end <= TO_DATE(''' || fin || ''', ''YYYYMMDD'')) ';

            else
                sql_where := sql_where|| ' (a.report_scope_start >= TO_DATE(''' || inicio || ''', ''YYYYMMDD'')  AND a.report_scope_start <= TO_DATE(''' || fin || ''', ''YYYYMMDD'') or  a.report_scope_end >= TO_DATE(''' || inicio || ''', ''YYYYMMDD'')  AND a.report_scope_end <= TO_DATE(''' || fin || ''', ''YYYYMMDD''))  ';
            end if;
        end if;

        /*
        if (fin is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND a.created_at >= TO_DATE(''' || fin || ''', ''YYYYMMDD'')  AND a.created_at <= TO_DATE(''' || fin || ''', ''YYYYMMDD'')  ';
            else
                sql_where := sql_where|| ' a.created_at >= TO_DATE(''' || fin || ''', ''YYYYMMDD'')  AND a.created_at <= TO_DATE(''' || fin || ''', ''YYYYMMDD'')  ';
            end if;
        end if;
        */
        if (tipo is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND a.type_report_id in (' || tipo || ') ';
            else
                sql_where := sql_where||' a.type_report_id in (' || tipo || ') ';
            end if;
        end if;

        if (categoria is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND a.category_id in (' || categoria || ') ';
            else
                sql_where := sql_where||' a.category_id in (' || categoria || ') ';
            end if;
        end if;

         if (ods is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND ao.ods_id in (' || ods || ') ';
            else
                sql_where := sql_where||' ao.ods_id in (' || ods || ') ';
            end if;
        end if;

        if (moscu is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND am.declaration_moscu_id in (' || moscu || ') ';
            else
                sql_where := sql_where||' am.declaration_moscu_id in (' || moscu || ') ';
            end if;
        end if;

         if (anio is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND to_char(i.fecha_publicacion,''YYYY'') in (' || anio || ') ';
            else
                sql_where := sql_where||' to_char(i.fecha_publicacion,''YYYY'') in (' || anio || ') ';
            end if;
        end if;

        if LENGTH(sql_where)>0 then
            sql_stmt:= sql_stmt || ' where ' || sql_where;
        end if;

        dbms_output.put_line (sql_stmt);

        open c_auditorias for sql_stmt;
    END;
    
    PROCEDURE PA_SAI_POLAR_GRAPH(mes VARCHAR2:=NULL, categoria VARCHAR2:=NULL, ods VARCHAR2:=NULL,tipo VARCHAR2:=NULL, pais VARCHAR2:=NULL,anio varchar2:=NULL,c_auditorias OUT SYS_REFCURSOR) IS 
    sql_stmt varchar2(4000);
    sql_where varchar2(1000);
    BEGIN     
        sql_stmt := '
        select b.ambito_id AMBITO_ID, C.GROUP_NAME AMBITO, a.type_report_id TIPO_ID, d.type_report_name TIPO,count(a.id) CANTIDAD from sai_auditoria a 
right join sai_participante b
on a.id = b.report_id
left join sai_ambito c
on b.ambito_id = c.id
left join sai_tipo_auditoria d
on d.id = a.type_report_id
left join sai_auditoria_ods e
on a.id = e.report_id
        ';
        
        sql_where:='';
        if (mes is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where || ' AND ' || mes || ' between extract(month from a.report_scope_start) and  extract(month from a.report_scope_end) ';
            else
                sql_where := sql_where || ' ' || mes || ' between extract(month from a.report_scope_start) and  extract(month from a.report_scope_end) ';
            end if;
        end if;

        if (categoria is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND a.category_id in (' || categoria || ') ';
            else
                sql_where := sql_where||' a.category_id in (' || categoria || ') ';
            end if;
        end if;
        
        if (ods is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND e.ods_id  in (' || ods || ') ';
            else
                sql_where := sql_where|| ' e.ods_id  in (' || ods || ') ';
            end if;
        end if;

        if (tipo is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND a.type_report_id in (' || tipo || ') ';
            else
                sql_where := sql_where|| ' a.type_report_id in (' || tipo || ') ';
            end if;
        end if;
        
        if (pais is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND b.pais_id in (' || pais || ') ';
            else
                sql_where := sql_where|| ' b.pais_id in (' || pais || ') ';
            end if;
        end if;

        if (anio is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where || ' AND ' || anio || ' between extract(year from a.report_scope_start) and  extract(year from a.report_scope_end) ';
            else
                sql_where := sql_where || ' ' || anio || ' between extract(year from a.report_scope_start) and  extract(year from a.report_scope_end) ';
            end if;
        end if;

        if LENGTH(sql_where)>0 then
            sql_stmt:= sql_stmt || ' where ' || sql_where;
        end if;

        sql_stmt := sql_stmt || ' group by b.ambito_id , C.GROUP_NAME , a.type_report_id , d.type_report_name ';

        dbms_output.put_line (sql_stmt);

        open c_auditorias for sql_stmt;
    END;
    
    PROCEDURE PA_SAI_DATE_GRAPH(ambito VARCHAR2:=NULL, categoria VARCHAR2:=NULL, ods VARCHAR2:=NULL,tipo VARCHAR2:=NULL, pais VARCHAR2:=NULL,anio varchar2:=NULL,c_auditorias OUT SYS_REFCURSOR) IS 
    sql_stmt varchar2(4000);
    sql_where varchar2(1000);
    BEGIN     
        sql_stmt := '
        select 
UPPER(substr( to_char(a.report_scope_start, ''Month'',''nls_date_language=spanish''), 1,3)) MES,
extract(month from a.report_scope_start) MES_NUM,
a.type_report_id TIPO_ID, d.type_report_name TIPO,
count(a.id) CANTIDAD from sai_auditoria a 
right join sai_participante b
on a.id = b.report_id
right join sai_ambito c
on b.ambito_id = c.id
right join sai_tipo_auditoria d
on d.id = a.type_report_id
right join sai_auditoria_ods e
on a.id = e.report_id

        ';

        sql_where:='';
        if (ambito is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where || ' AND ' || ' b.ambito_id in ( ' || ambito || ' )';
            else
                sql_where := sql_where || ' b.ambito_id in ( ' || ambito || ' )';
            end if;
        end if;

        if (categoria is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where||' AND a.category_id in (' || categoria || ') ';
            else
                sql_where := sql_where||' a.category_id in (' || categoria || ') ';
            end if;
        end if;
        
        if (ods is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND e.ods_id  in (' || ods || ') ';
            else
                sql_where := sql_where|| ' e.ods_id  in (' || ods || ') ';
            end if;
        end if;

        if (tipo is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND a.type_report_id in (' || tipo || ') ';
            else
                sql_where := sql_where|| ' a.type_report_id in (' || tipo || ') ';
            end if;
        end if;
        
        if (pais is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where|| ' AND b.pais_id in (' || pais || ') ';
            else
                sql_where := sql_where|| ' b.pais_id in (' || pais || ') ';
            end if;
        end if;

        if (anio is not null) then
            if LENGTH(sql_where)>0 THEN
                sql_where := sql_where || ' AND ' || anio || ' between extract(year from a.report_scope_start) and  extract(year from a.report_scope_end) ';
            else
                sql_where := sql_where || ' ' || anio || ' between extract(year from a.report_scope_start) and  extract(year from a.report_scope_end) ';
            end if;
        end if;

        if LENGTH(sql_where)>0 then
            sql_stmt:= sql_stmt || ' where ' || sql_where;
        end if;

        sql_stmt := sql_stmt || ' group by UPPER(substr( to_char(a.report_scope_start, ''Month'',''nls_date_language=spanish''), 1,3)),extract(month from a.report_scope_start),a.type_report_id, d.type_report_name order by 2 asc ';

        dbms_output.put_line (sql_stmt);

        open c_auditorias for sql_stmt;
    END;
    


    PROCEDURE PAI_SAI_INSERT_REPORT(
    publicacion DATE,
    idioma int,
    ids IN OUT INTEGER,
    imagen varchar2,
    informe INT,
    pais    int,
    report  INT,
    url varchar2    
    )AS
    existe int:=0;
    BEGIN

    select count(1) into existe from sai_informe
    where id = ids;

    if (ids is null) then
        INSERT INTO SAI_INFORME(   
                                        REPORT_ID,INFORME_ID,FECHA_PUBLICACION,
                                        PAIS_ID,IDIOMA_ID,ARCHIVO,
                                        URL_VIDEO)
                                VALUES  (report      , informe     , publicacion,
                                pais,idioma,imagen,
                                     url)
                                     RETURNING ID INTO ids;
    else
        update SAI_INFORME
            set 
                REPORT_ID=report,
                INFORME_ID=informe,
                FECHA_PUBLICACION=publicacion,
                PAIS_ID= pais,
                IDIOMA_ID=idioma,
                ARCHIVO=imagen,
                URL_VIDEO=url
        where id = ids
        RETURNING ID INTO ids;
    end if;

    COMMIT;

    END;

    PROCEDURE PAI_SAI_INSERT_PRACTICE(
    argumento VARCHAR2,
    detalle VARCHAR2,
    estado CHAR,
    ids IN OUT INTEGER,
    nivel VARCHAR2,
    nombre VARCHAR2,
    reporte INT
    )AS
    existe int:=0;
    BEGIN

    select count(1) into existe from sai_practica
    where id = ids;

    if (ids is null) then
        INSERT INTO SAI_PRACTICA(   
                                        REPORT_ID,TITULO,ETAPA,
                                        CONTEXTO,DESCRIPCION,ACTIVO)
                                VALUES  (reporte, nombre, nivel,
                                        argumento,detalle,estado)
                                     RETURNING ID INTO ids;
    else
        update SAI_PRACTICA
            set 
                REPORT_ID=reporte,
                TITULO=nombre,
                ETAPA=nivel,
                CONTEXTO= argumento,
                DESCRIPCION=detalle,
                ACTIVO=estado
        where id = ids
        RETURNING ID INTO ids;
    end if;

    COMMIT;

    END;

END PG_SAI_CONSULTA;