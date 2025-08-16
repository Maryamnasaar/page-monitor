class App
  hash_branch 'mazo' do |r|
    r.on 'etghazo' do
      r.get do
        @title = "Mazo Page"
        view 'mazo'
      end
    end
  end

  hash_branch 'failure' do |r|
    r.on 'kheba' do
      r.get do
        @title = "ya lahwaaaaay!!!!"
        view 'index'
      end
    end
  end
end
