namespace :db do

  task :dumb_local_db do
    run_locally do 
      execute :echo, "************************************************************* starting to dumb the database ************************************************************* "
      execute "mysqldump --user='#{fetch(:mysql_db_user)}' --host='#{fetch(:mysql_db_host)}' --password='#{fetch(:mysql_db_password)}'  #{fetch(:mysql_db_name)} > config/files/#{fetch(:mysql_db_name)}.sql"
      execute :echo, "************************************************************* finishing to dumb the database ************************************************************* "
    end
  end

  task :sanitize_db do
    run_locally do 
      execute :echo, "*********************Now we will clean wordpress database s mess for hardcoded url This might take a while ************************************************************* "
      rewrite_this_shit(fetch(:mysql_db_name))
      execute :echo, fetch(:local_port)
    end
  end

  task :inject_my_db do 
    on roles(:app) do
      upload! StringIO.new(File.read("config/files/#{fetch(:mysql_db_name)}_dump.sql")), "#{shared_path}/#{fetch(:mysql_db_name)}.sql"
      # we first drop the old database
      # There is probably and definitly more beautifull to find it but that will do it
      replacements = [ ["-", ""], [":", ""] , [" ", ""] ]
      back_up_name = Time.new.to_s
      replacements.each {|replacement| back_up_name.gsub!(replacement[0], replacement[1])}
      back_up_name = back_up_name.split("+")[0]
      execute "cd #{release_path}/db_backup && mysqldump --user='#{fetch(:server_wp_db_user)}' --host='#{fetch(:server_wp_db_hsot)}' --password='#{fetch(:server_wp_db_password)}'  #{fetch(:server_wp_db_name)} > #{fetch(:server_wp_db_name)}_#{back_up_name}.sql"
      execute "mysql --user='#{fetch(:server_wp_db_user)}' --password='#{fetch(:server_wp_db_password)}' --host='#{fetch(:server_wp_db_hsot)}' --execute=\"DROP DATABASE #{fetch(:server_wp_db_name)};\""
      execute "mysql --user='#{fetch(:server_wp_db_user)}' --password='#{fetch(:server_wp_db_password)}' --host='#{fetch(:server_wp_db_hsot)}' --execute=\"CREATE DATABASE #{fetch(:server_wp_db_name)};\""
      execute "mysql --user='#{fetch(:server_wp_db_user)}' --password='#{fetch(:server_wp_db_password)}' --host='#{fetch(:server_wp_db_hsot)}' #{fetch(:server_wp_db_name)} < #{shared_path}/#{fetch(:server_wp_db_name)}.sql"
      sudo "chmod 755 -R #{release_path}"
      sudo "chown www-data:www-data -R #{release_path}"
    end
    run_locally do 
      execute :echo, "************************************************************* We remove useless files ************************************************************* "
      execute "rm -rf config/files/eic_ir_dump.sql && rm -rf config/files/investor_website.conf.rb && rm -rf config/files/wp-config.conf.rb"
    end
  end

  def rewrite_this_shit(file)

    file_names = ['config/files/' + file.to_s.to_s + '.sql']

    file_names.each do |file_name|
      text = File.read(file_name)
      # new_contents = text.gsub(/search_regexp/, "replacement string")

      replacements = [ [fetch(:my_local_address).to_s, fetch(:server_name).to_s], [":#{fetch(:local_port)}".to_s, fetch(:server_port).to_s ], ["%3A#{fetch(:local_port)}".to_s,""], [fetch(:relative_path_local).to_s,fetch(:relative_path_server).to_s],[fetch(:relative_path_local).to_s.gsub('/','%2F'),fetch(:relative_path_server).to_s.gsub('/','%2F')]]
      replacements.each {|replacement| text.gsub!(replacement[0], replacement[1])}

      File.write('config/files/' + file.to_s.to_s + '_dump.sql', text)
    end

  end

  # task :setup_config do
  #   on roles(:app) do
  #     execute :echo, "########### executing my db task"
  #   end
  # end

  # task :stop do
  #   on roles(:app) do
  #     execute :echo, "########### stopping my db task"
  #   end
  # end
end