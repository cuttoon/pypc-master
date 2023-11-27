const oracledb = require("oracledb");
const db = require("../../Settings/Database/database");

module.exports = {
  createTag: async (data) => {
    const options = {
      autoCommit: true,
      batchErrors: true,
    };

    const tag = {
      report_id: data.report_id,
      tag_id: data.tag_id,
    };
    const ods = await db.insertRow("SCAI_AUDITORIA_TAG", tag, options);
    return ods;
  },
  deleteTag: async (ids) => {
    const options = {
      autoCommit: true,
      batchErrors: true,
    };

    const whereClause = `report_id= :ids`;
    const parameters = [ids];
    const result = await db.simpleExecute('SCAI_AUDITORIA_TAG', whereClause, options);
    return result;
  },
  getTag: async (req) => {
    const cursor = await db.procedureExecuteCursor(
      `BEGIN PG_SCAI_CONSULTA.PA_SCAI_GENERIC_SELECT_EXECUTE(:sql_stmt,:cursor); END;`,
      {
        sql_stmt: `SELECT ntag_id, ctag_name, ctag_normalized  AS DESCRIPTION FROM SCAI_TAG ORDER BY ntag_id `,
        cursor: { type: oracledb.CURSOR, dir: oracledb.BIND_OUT },
      }
    );

    return cursor.cursor;
  },

  newTag: async (data) => {
    var element = [];
    element.push({
      nombre: data.nombre,
      normalizado: data.normalizado,
    });

    const options = {
      autoCommit: true,
      batchErrors: true,
      bindDefs: {
        nombre: { type: oracledb.STRING, maxSize: 255 },
        normalizado: { type: oracledb.STRING, maxSize: 255 },
        ids: { type: oracledb.NUMBER, dir: oracledb.BIND_OUT },
      },
    };
    const tag = await db.manyExecute(
      `INSERT INTO SCAI_TAG(ctag_name, ctag_normalized)
         VALUES (:nombre,:normalizado) RETURNING ntag_id INTO :ids `,
      element,
      options
    );

    return tag;
  },
};
