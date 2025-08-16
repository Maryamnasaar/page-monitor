require 'iodine'
# static file service
Iodine.listen(service: :http, port: 3000, public: './fashal/') {}
# for static file service, we only need a single thread and a single worker.
Iodine.threads = 1
Iodine.start
