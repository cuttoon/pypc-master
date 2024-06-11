const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

async function connect(){
  let com;

  try {
    com = await oracledb.getConnection({
      user: "hr",
      password: "hr",
      connectionString: "localhost/orci"
    });

    const data = await com.execute(
    `SELECT`
    )
  } catch (error) {
    
  }
}