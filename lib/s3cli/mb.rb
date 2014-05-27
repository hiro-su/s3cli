module S3cli
  class CLI
    desc 'mb: make bucket', 's3 mb s3://<bucket>'
    def mb(path)
      parse = bucket_parse(path)
      if bucket = parse[:bucket]
        if @s3.buckets[bucket].exists?
          puts "already exists: #{bukcet}"
        else
          puts "create bucket: #{@s3.buckets.create(bucket).name}"
        end
      else
        puts "ERROR: bucket name is invalid."
      end
    rescue => ex
      error_format ex
    end
  end
end
