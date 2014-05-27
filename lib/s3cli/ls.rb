module S3cli
  class CLI
    desc 'ls: List S3 objects and common prefixes under a prefix or all S3 buckets.', 's3 ls [s3://<bucket>/<object>]'
    method_option :verbose,
      :type     => :boolean,
      :required => false,
      :default  => false,
      :aliases  => '-v',
      :desc     => 'verbose option. sort by datetime.'
    method_option :count,
      :type     => :boolean,
      :required => false,
      :default  => false,
      :aliases  => '-c',
      :desc     => 'objects count.'
    method_option :size,
      :type     => :boolean,
      :required => false,
      :default  => false,
      :aliases  => '-s',
      :desc     => 'bucket size.'
    method_option :hidden,
      :type     => :boolean,
      :required => false,
      :default  => false,
      :aliases  => '-h',
      :desc     => 'hidden result.'
    method_option :thread,
      :type     => :numeric,
      :required => false,
      :default  => 50,
      :aliases  => '-t',
      :desc     => 'exec parallel threads.'
    def ls(path=nil)
      @max_threads = options[:thread]
      @size = 0
      @results = []
      if path.nil?
        buckets = []
        Parallel.each(@s3.buckets.entries,
                      in_threads: @max_threads) do |bucket|
          buckets << bucket.name
        end
        puts buckets.sort
      else
        parse = bucket_parse(path)
        puts "Bucket: #{parse[:bucket]}"
        puts "Prefix: #{parse[:object]}"
        print "\n"
        bucket_objects = @s3.buckets[parse[:bucket]].objects
        unless parse[:object].empty?
          entries = bucket_objects.with_prefix(parse[:object]).entries
        else
          entries = bucket_objects.entries
        end
        ls_each(entries)
        print "\n"
        unless options[:hidden]
          ls_header(options)
          puts @results.sort_by {|e| e.split("\s")[2]}
        end
        puts "---" if options[:count] || options[:size]
        puts "Total Object: #{entries.length}" if options[:count]
        puts "Total Size: #{@size.to_filesize}" if options[:size]
      end
    rescue => ex
      error_format ex
    end

    private

    def ls_each(entries)
      progress = @progressbar.call("ls", entries.length)
      retry_count = 0
      Parallel.each(entries,
                    in_threads: @max_threads,
                    finish: lambda {|item, i| progress.increment}) do |obj|
        begin
          if options[:verbose] || options[:size]
            content_length = obj.content_length
          end
          @results << ls_result(obj, options, content_length)
          @size += content_length if options[:size]
        rescue => ex
          retry_count += 1
          retry_count < 5 ? retry : raise(ex)
        end
      end
    end

    def ls_result(obj, options, content_length=nil)
      if options[:verbose]
        "%-30s %10s %10s"%[obj.key, content_length.to_filesize, DateTime.parse(obj.last_modified.to_s).to_s]
      else
        "#{obj.key}"
      end
    end

    def ls_header(options)
      if options[:verbose]
        puts "%-30s %10s %10s"%(%w(Name Length Last_Modified))
        puts "%-30s %10s %10s"%(%w(---- ------ -------------))
      else
        puts "Name"
        puts "----"
      end
    end
  end
end
