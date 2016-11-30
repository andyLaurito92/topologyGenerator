module CustomFileUtils
    def create_empty_file(full_file_path)
        dir = File.dirname(full_file_path)

        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        
        File.new(full_file_path, 'w').close()
    end

    def write_file(path_to_file, file_content)
        create_empty_file path_to_file 
		open(path_to_file, 'w') do |f|		  
            f.puts file_content
        end
    end
end