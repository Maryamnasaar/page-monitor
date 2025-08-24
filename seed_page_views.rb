require 'sqlite3'
require 'securerandom'

db = SQLite3::Database.new "perf.db"

10_000.times do
  timestamp = Time.now.to_i - rand(0..30*24*60*60) # random date in last 30 days
  slug = SecureRandom.hex(4)
  url  = "http://example.com/page/#{slug}"

  page_size = rand(500..5000)
  dom_ready = rand(10..200)
  full_load = dom_ready + rand(5..100)

  db.execute("INSERT INTO perf_logs (time, page_url, page_size, dom_ready_time, full_load_time)
              VALUES (?, ?, ?, ?, ?)", [timestamp, url, page_size, dom_ready, full_load])
end

puts "✅ Inserted 10,000 random page views."
