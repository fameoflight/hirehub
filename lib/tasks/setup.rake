namespace :setup do
    desc "Creating Upload and Run Directory"
    task :paths => :environment do
        uploadpath = Settings.uploadpath
        runpath = Settings.run_dir
        begin
            puts "uploadpath #{uploadpath}"
            puts "runpath #{runpath}"

            system "mkdir -p #{runpath}"
            system "chmod 777 #{runpath}"

            system "mkdir -p #{uploadpath}"
            system "chmod 777 #{uploadpath}"

            system "mkdir -p /tmp/hirehub"
            system "chmod 777 /tmp/hirehub"
        rescue
            puts "error in running setup:upload_path"
        end
    end
    #Rake::Task["upload_path"].execute
end
