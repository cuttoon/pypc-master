CREATE TABLE SAI_CATEGORIA (
  id int NOT NULL,
  category_name varchar(255)NOT NULL,
  category_slug varchar(50) DEFAULT NULL,
  category_status int NOT NULL,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT NULL,
  CONSTRAINT PK_SAI_CATEGORIA PRIMARY KEY (id)
); 

CREATE TABLE SAI_TIPO_AUDITORIA (
  id int NOT NULL,
  type_report_name varchar(255) NOT NULL,
  type_report_slug varchar(50) DEFAULT NULL,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT NULL,
  CONSTRAINT PK_SAI_TIPO_AUDITORIA PRIMARY KEY (id)
);

CREATE TABLE SAI_ODS (
  id int NOT NULL,
  ods_slug varchar(255) NOT NULL,
  ods_name varchar(255)  NOT NULL,
  ods_year INT DEFAULT NULL,
  ods_description VARCHAR2(255) ,
  created_at timestamp  DEFAULT NULL,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_ODS PRIMARY KEY (id)
);

RENAME SAI_PAISES TO SAI_EFS;

ALTER TABLE SAI_EFS RENAME CONSTRAINT PK_SAI_PAISES to PK_SAI_EFS;

CREATE TABLE SAI_AMBITO (
  id int  NOT NULL ,
  group_name varchar(255)  NOT NULL,
  group_slug varchar(255)  NOT NULL,
  created_at timestamp  DEFAULT NULL,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_AMBITO PRIMARY KEY (id)
);

CREATE TABLE SAI_PAIS (
  id int NOT NULL,
  country_name varchar(255) NOT NULL,
  code varchar(50) DEFAULT NULL,
  created_at timestamp  DEFAULT NULL,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_PAIS PRIMARY KEY (id)
);

CREATE TABLE SAI_PARAMETRO (
  id int NOT NULL,
  table_name varchar(255) NOT NULL,
  code int DEFAULT NULL,
  value_name varchar(255) NOT NULL,
  created_at timestamp  DEFAULT NULL,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_PARAMETRO PRIMARY KEY (id,code)
);

CREATE TABLE SAI_IDIOMA (
  id int NOT NULL,
  language_name varchar(255)  NOT NULL,
  language_slug varchar(255)  NOT NULL,
  language_color varchar(255) NOT NULL,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT NULL,
  CONSTRAINT PK_SAI_IDIOMA PRIMARY KEY (id)
);


CREATE TABLE SAI_TAG (
  id int NOT NULL ,
  name varchar(255) NOT NULL,
  normalized varchar(255)  NOT NULL,
  created_at timestamp  DEFAULT NULL,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_TAG PRIMARY KEY (id)
);

CREATE TABLE SAI_AUDITORIA (
  id int  NOT NULL ,
  report_title varchar(255)  NOT NULL,
  rerpor_objetive VARCHAR(255),
  report_abstract VARCHAR(255) ,
  category_id int  NOT NULL,
  type_report_id int  NOT NULL,
  report_scope_start date DEFAULT NULL,
  report_scope_end date DEFAULT NULL,
  report_image varchar(255)  DEFAULT NULL,
  created_at timestamp DEFAULT SYSDATE,
  updated_at timestamp  DEFAULT NULL,
  CONSTRAINT PK_SAI_AUDITORIA PRIMARY KEY (id),
  CONSTRAINT FK_SAI_CATEGORIA FOREIGN KEY (category_id) REFERENCES SAI_CATEGORIA(ID),
  CONSTRAINT FK_SAI_TIPO_AUDITORIA FOREIGN KEY (type_report_id) REFERENCES SAI_TIPO_AUDITORIA(ID)
);

CREATE TABLE SAI_AUDITORIA_ODS (
  id int NOT NULL,
  report_id int NOT NULL,
  ods_id int NOT NULL,
  CONSTRAINT PK_SAI_AUDITORIA_ODS PRIMARY KEY (id),
  CONSTRAINT FK_SAI_AUDITORIA FOREIGN KEY (REPORT_id) REFERENCES SAI_AUDITORIA(ID),
  CONSTRAINT FK_SAI_ODS FOREIGN KEY (ODS_id) REFERENCES SAI_ODS(ID)
);


CREATE TABLE SAI_AUDITORIA_MOSCU (
  id int NOT NULL,
  report_id int NOT NULL,
  declaration_moscu_id int NOT NULL,
  CONSTRAINT PK_SAI_AUDITORIA_MOSCU PRIMARY KEY(id),
  CONSTRAINT FK_SAI_AUDITORIA_ID FOREIGN KEY (REPORT_id) REFERENCES SAI_AUDITORIA(ID),
  CONSTRAINT FK_SAI_DECLARACION_MOSCU FOREIGN KEY (declaration_moscu_id) REFERENCES SAI_DECLARACION_MOSCU(ID)
);

CREATE TABLE SAI_AUDITORIA_TAG (
  id int NOT NULL ,
  report_id int NOT NULL,
  tag_id int NOT NULL,
  CONSTRAINT PK_SAI_AUDITORIA_TAG PRIMARY KEY (id),
  CONSTRAINT FK_SAI_AUDITORIA_TAG_ID FOREIGN KEY (REPORT_id) REFERENCES SAI_AUDITORIA(ID),
  CONSTRAINT FK_SAI_TAG_ID FOREIGN KEY (TAG_id) REFERENCES SAI_TAG(ID)
);


