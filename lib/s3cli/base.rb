module S3cli
  class CLI < Thor
    def initialize(args = [], options = {}, config = {})
      super
      setting = YAML::load(ERB.new(IO.read(
        File.join(File.dirname(__FILE__), '../../config/setting.yml')
      )).result)
      @s3 = AWS::S3.new(setting)
      @progressbar = Proc.new do |method, line|
        ProgressBar.create(
          title: method,
          format: "#{method}: %a |%b>>%i| %p%%",
          starting_at: 0,
          total: line
        )
      end
    end

    desc "version", "Prints the s3cli version information"
    def version
      puts "S3cli version #{S3cli::VERSION}"
    end
    map %w(-v --version) => :version

    private

    def bucket_parse(path)
      uri = uri_parse(path)
      bucket_path = uri.host
      /^\/(?<object_path>.+)$/ =~ uri.path
      object_path ||= ""
      return { bucket: bucket_path,
               object: object_path }
    end

    def uri_parse(path)
      uri = URI.parse(path)
      unless uri.scheme
        uri = URI.parse('s3://'+path)
      end
      return uri
    end

    def error_format(ex)
      puts "ERROR: #{ex}\n\n#{ex.backtrace.join('')}"
    end
  end
end

class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KB' => 1024 * 1024,
      'MB' => 1024 * 1024 * 1024,
      'GB' => 1024 * 1024 * 1024 * 1024,
      'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s }
  end
end
