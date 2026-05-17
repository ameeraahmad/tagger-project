const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

const dbPath = path.join(__dirname, 'database.sqlite');
const outputPath = path.join(__dirname, 'tagger-next', 'd1_seed.sql');

const db = new sqlite3.Database(dbPath, sqlite3.OPEN_READONLY, (err) => {
  if (err) {
    console.error('Error opening database:', err.message);
    process.exit(1);
  }
});

db.serialize(() => {
  // Query all tables
  db.all("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'SequelizeMeta'", [], (err, tables) => {
    if (err) {
      console.error('Error fetching tables:', err.message);
      process.exit(1);
    }

    let sqlDump = "PRAGMA foreign_keys = OFF;\n\n";
    let processed = 0;
    
    if (tables.length === 0) {
      console.log('No tables found to dump.');
      db.close();
      process.exit(0);
    }

    tables.forEach((table) => {
      const tableName = table.name;
      db.all(`SELECT * FROM "${tableName}"`, [], (err, rows) => {
        if (err) {
          console.error(`Error reading table ${tableName}:`, err.message);
          processed++;
          return;
        }

        if (rows.length > 0) {
          sqlDump += `-- Dumping data for table ${tableName}\n`;
          rows.forEach((row) => {
            const columns = Object.keys(row).map(c => `"${c}"`).join(', ');
            const values = Object.values(row).map(val => {
              if (val === null || val === undefined) {
                return 'NULL';
              }
              if (typeof val === 'string') {
                // Escape single quotes for SQL compatibility
                return `'${val.replace(/'/g, "''")}'`;
              }
              if (typeof val === 'boolean') {
                return val ? 1 : 0;
              }
              return val;
            }).join(', ');

            sqlDump += `INSERT INTO "${tableName}" (${columns}) VALUES (${values});\n`;
          });
          sqlDump += "\n";
        }

        processed++;
        if (processed === tables.length) {
          sqlDump += "PRAGMA foreign_keys = ON;\n";
          // Write to file
          fs.writeFileSync(outputPath, sqlDump);
          console.log(`🎉 SQL seed file generated successfully with ${tables.length} tables at: ${outputPath}`);
          db.close();
        }
      });
    });
  });
});
