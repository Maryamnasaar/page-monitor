require 'sqlite3'

db = SQLite3::Database.new "perf.db"

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS perf_logs (
    page_url TEXT PRIMARY KEY,
    page_size INTEGER,
    dom_ready_time INTEGER,
    full_load_time INTEGER
  );
SQL
