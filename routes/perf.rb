require 'sqlite3'
require 'json'

class App
  hash_branch 'perf' do |r|
    r.on 'page' do

      # GET: return performance data
      r.get do
        url = r.params['url']
        db = SQLite3::Database.new("perf.db")
        db.results_as_hash = true

        logs =
          if url && !url.strip.empty?
            db.execute("SELECT * FROM perf_logs WHERE page_url = ?", [url])
          else
            db.execute("SELECT * FROM perf_logs")
          end

        db.close
        logs.to_json
      end

      # POST: save performance data
      r.post do
        data = JSON.parse(r.body.read)
        page_url  = data["pageUrl"]
        page_size = data["pageSize"]
        dom_ready = data["domReady"]
        full_load = data["loadTime"]

        db = SQLite3::Database.new("perf.db")
        db.results_as_hash = true

        db.execute(
          "INSERT INTO perf_logs (page_url, page_size, dom_ready_time, full_load_time)
           VALUES (?, ?, ?, ?)
           ON CONFLICT(page_url) DO UPDATE SET
             page_size      = excluded.page_size,
             dom_ready_time = excluded.dom_ready_time,
             full_load_time = excluded.full_load_time",
          [page_url, page_size, dom_ready, full_load]
        )

        db.close
        { status: "ok", message: "Performance data saved" }.to_json
      end

    end
  end
end
