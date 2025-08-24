require 'sqlite3'

db = SQLite3::Database.new "perf.db"

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS perf_logs (
    id INTEGER PRIMARY KEY,
    time INTEGER,
    page_url TEXT,
    page_size INTEGER,
    dom_ready_time INTEGER,
    full_load_time INTEGER
  );
SQL
