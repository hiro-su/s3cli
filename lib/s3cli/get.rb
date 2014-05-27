module S3cli
  class CLI
    desc 'get: copy object', 's3 get s3://<bucket>/<object> local_path'
    def get(path,file)
      parse = bucket_parse(path)
      puts "Bucket: #{parse[:bucket]}"
      puts "Prefix: #{parse[:object]}"
      puts "---"
      if file =~ /^\.$|(.*)\/$/
        file = "#{$1 + "/" unless $1.nil?}#{parse[:object]}"
      end
      File.open(file, "wb") do |f|
        @s3.buckets[parse[:bucket]].objects[parse[:object]].read do |chunk|
          f.write(chunk)
        end
      end
      puts "get: #{parse[:object]} => #{File.expand_path(file)}"
    rescue => ex
      error_format ex
    end
  end
end
