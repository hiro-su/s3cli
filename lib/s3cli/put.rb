module S3cli
  class CLI
    desc 'put object', 's3 put local_file s3://<bucket>[/<object>]'
    def put(from, to)
      parse = bucket_parse(to)
      puts "Bucket: #{parse[:bucket]}"
      puts "Prefix: #{parse[:object]}"
      print "\n"
      if Dir.exist?(from)
        Dir.glob(from+"/**/*") do |path|
          unless Dir.exist?(path)
            puts "upload: #{put_write(path, parse)}"
          end
        end
      else
        puts "upload: #{put_write(from, parse)}"
      end
    rescue => ex
      error_format ex
    end
    
    private

    def put_write(file_path, to_uri)
      object_path = to_uri[:object]
      case object_path
      when /.*\//
        object_path = object_path+File.basename(file_path)
      when ""
        object_path = File.basename(file_path)
      end
      bucket = @s3.buckets[to_uri[:bucket]]
      object = bucket.objects[object_path]
      object.write(Pathname.new(file_path))
      return object.key
    end
  end
end
