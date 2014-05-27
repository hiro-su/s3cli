module S3cli
  class CLI
    desc 'rm: delete bucket or object', 's3 rm s3://<bucket>[/<object>] [-f bucket force delete]'
    method_option :force,
      :type     => :boolean,
      :required => false,
      :default  => false,
      :aliases  => '-f',
      :desc     => 'force remove option.'
    def rm(bucket)
      parse = bucket_parse(bucket)
      bucket = @s3.buckets[parse[:bucket]]
      puts "Bucket: #{parse[:bucket]}"
      unless parse[:object].empty?
        bucket_objects = bucket.objects
        puts "Prefix: #{parse[:object]}"
        if parse[:object] =~ /.*\/$/
          bucket_objects.with_prefix(parse[:object]).each do |obj|
            obj.delete
            puts "delete: #{obj.key}"
          end
          #object.delete_all
        else
          object = bucket_objects[parse[:object]]
          if object.exists?
            object.delete
            puts "delete object: #{parse[:object]}"
          else
            puts "object does not exists."
          end
        end
      else
        if options[:force]
          bucket.delete!
        else
          bucket.delete
        end
        puts "delete bucket: #{parse[:bucket]}"
      end
    rescue AWS::S3::Errors::AccessDenied => ex
      error_format ex
    rescue AWS::S3::Errors::NoSuchKey => ex
      error_format ex
    rescue => ex
      error_format ex
    end
  end
end
