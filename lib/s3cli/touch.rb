module S3cli
  class CLI
    desc 'touch: create empty file', 's3 touch s3://<bucket>/<object>'
    def touch(path)
      parse = bucket_parse(path)
      puts "Bucket: #{parse[:bucket]}"
      puts "Prefix: #{parse[:object]}"
      puts "---"
      puts "touch: #{@s3.buckets[parse[:bucket]].objects[parse[:object]].write("").key}"
    rescue => ex
      error_format ex
    end
  end
end
