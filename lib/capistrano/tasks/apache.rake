namespace :apache do

  desc "make apache server settings."
  task :settings do
    on roles(:app) do
      if test("[ -f /etc/apache2/sites-available/000-default.conf ]")
        sudo "rm -rf /etc/apache2/sites-available/000-default.conf"
        sudo "a2dissite 000-default.conf"
      end
      rewrite_this_apache_conf_file()
      upload! StringIO.new(File.read("config/files/investor_website.conf.rb")), "#{shared_path}/investor_website.conf"
      sudo "mv #{shared_path}/investor_website.conf /etc/apache2/sites-available/investor_website.conf"
      sudo "a2enmod rewrite"
      sudo "a2ensite investor_website.conf"
      sudo "chmod 644 #{release_path}/.htaccess"
      sudo "chown #{fetch(:deploy_user)}:#{fetch(:deploy_user)} -R #{fetch(:folder_release)}"
      sudo "chmod 777 -R #{current_path}/wp-content/"
      sudo "service apache2 restart"
    end
  end

  def rewrite_this_apache_conf_file()

    file_names = ['config/files/investor_website.conf']

    file_names.each do |file_name|
      text = File.read(file_name)
      # new_contents = text.gsub(/search_regexp/, "replacement string")

      replacements = [ ['#{release_path}',fetch(:current_path).to_s + 'current'],['#{ip_address}',fetch(:server_ip).to_s],['#{server_name}',fetch(:server_name).to_s],['#{APACHE_LOG_DIR}',fetch(:shared_path).to_s + 'shared/log/']]
      replacements.each {|replacement| text.gsub!(replacement[0], replacement[1])}

      File.write('config/files/investor_website.conf.rb', text)
    end

  end

end