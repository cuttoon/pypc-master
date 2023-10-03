alter table sai_auditoria add id_user int;

ALTER TABLE sai_auditoria ADD CONSTRAINT FK_USER FOREIGN KEY(ID_USER) REFERENCES sai_usuarios(ID);