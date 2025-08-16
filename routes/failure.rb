class App
  hash_branch 'failure' do |r|
    r.on 'kheba' do
      r.get do
        @title = "ya lahwaaaaay!!!!"
        view 'index'
      end
    end
  end
end
