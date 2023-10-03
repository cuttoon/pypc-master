create or replace PACKAGE PG_SAI_CONSULTA IS
    TYPE ccursor IS REF CURSOR;

PROCEDURE PA_SAI_GENERIC_SELECT_EXECUTE(sql_stmt VARCHAR2,c_events OUT SYS_REFCURSOR);

PROCEDURE PA_SAI_USUARIOS(c_users OUT SYS_REFCURSOR);

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

END PG_SAI_CONSULTA;

/

create or replace PACKAGE BODY      PG_SAI_CONSULTA AS
 
PROCEDURE PA_SAI_GENERIC_SELECT_EXECUTE(sql_stmt VARCHAR2,c_events OUT SYS_REFCURSOR) AS 
BEGIN     
    open c_events for sql_stmt;
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
                LEFT JOIN SAI_PAISES P ON P.ID= U.PAIS_ID
                ORDER BY U.ID;   


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



END PG_SAI_CONSULTA;

/
