namespace :db do

  desc 'Dumps the entire database to an sql file.'
  task :dump => :environment do
    
    db_config = Rails.configuration.database_configuration
    user = db_config[Rails.env]['username']
    password = db_config[Rails.env]['password']
    host = db_config[Rails.env]['host']
    database = db_config[Rails.env]['database']
    
    filename = "dump-#{Rails.env}-#{Time.now.to_i}.sql"
    
    command = 'mysqldump'
    command += ' --add-drop-table'
    command += " -u #{user}"
    command += " -h #{host}" unless host.blank?
    command += " -p#{password}" unless password.blank?
    command += " #{database}"
    command += " > #{filename}"
    
    sh command
    
  end
  
end