import mysql from 'mysql2/promise';

const getConnection = async () => {
  const connection = await mysql.createConnection({
    port: 3306,
    host: process.env.DB_HOST, // địa chỉ host của database
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  });

  // A simple SELECT query
  try {
    const [results, fields] = await connection.query(
      'SELECT * FROM `users`'
    );
    console.log(results); // results contains rows returned by server
    console.log(fields); // fields contains extra meta data about results, if available
  } catch (err) {
    console.log(err);
  }

  return connection;
}

export { getConnection };
