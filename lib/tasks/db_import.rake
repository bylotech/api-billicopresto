namespace :db do
  desc "Import production data"
  task :import_production_dump do

    raise "import_production_dump can only be done in development environment" unless Rails.env.development?

    puts "removing any old dump file"
    clean_dump_files
    puts "directory clean"

    puts "Running  heroku pg:backups:capture --app bylo"
    
    backup_capture_triggered = trigger_backup_capture

    raise "back up capture failed" unless backup_capture_triggered

    puts "Running  heroku pg:backups:download"

    retrieved_dump = retrieve_dump

    raise "dump download failed" unless retrieved_dump

    puts "Running pg_restore --verbose --clean --no-acl --no-owner -d api_billicopresto_development latest.dump"

    restored_data = restoring_data
    
    raise 'pd_restore failed' unless restored_data

    puts "removing dump file"
    clean_dump_files
    puts "directory clean"
  end 

  def clean_dump_files
    files = Dir.glob("latest.dump*")
    File.delete(*files)
  end

  def trigger_backup_capture
    system('heroku pg:backups:capture --app bylo')
  end

  def retrieve_dump
    system('heroku pg:backups:download')
  end

  def restoring_data
    system('pg_restore --verbose --clean --no-acl --no-owner -d api_billicopresto_development latest.dump')
  end

end