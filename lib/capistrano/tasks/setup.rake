namespace :setup do

  desc "Upload wp config file."
  task :upload_yml do
    on roles(:app) do
      #execute :echo, "\"#{fetch(:current_revision)}\" >> REVISION"
      execute :echo, "+++++++++++++++++++++++++++++++++++++++++++ #{release_path} ++++++++++++++++++++"
      execute "rm -rf #{shared_path}/.htaccess"
      rewrite_this_wp_config_file()
      upload! StringIO.new(File.read("config/files/wp-config.php.rb")), "#{release_path}/wp-config.php"
      upload! StringIO.new(File.read("config/files/.htaccess")), "#{shared_path}/.htaccess"
      execute "chmod 644 #{release_path}/wp-config.php"
      execute "chmod 755 -R #{release_path}/wp-content"
    end
  end

  desc "Symlinks config files for wp-config."
  task :symlink_config do
    on roles(:app) do
      # execute "ln -nfs #{shared_path}/wp-config.php #{release_path}/wp-config.php"
      execute "ln -nfs #{shared_path}/.htaccess #{current_path}/.htaccess"
   end
  end

  def rewrite_this_wp_config_file()

    file_names = ['config/files/wp-config.php']

    file_names.each do |file_name|
      text = File.read(file_name)
      # new_contents = text.gsub(/search_regexp/, "replacement string")

      replacements = [ ['#{db_name}',fetch(:server_wp_db_name).to_s], ['#{db_user}',fetch(:server_wp_db_user).to_s], ['#{db_passwd}',fetch(:server_wp_db_password).to_s], ['#{db_host}',fetch(:server_wp_db_hsot).to_s]]
      replacements.each {|replacement| text.gsub!(replacement[0], replacement[1])}

      File.write('config/files/wp-config.php.rb', text)
    end
  end

end
