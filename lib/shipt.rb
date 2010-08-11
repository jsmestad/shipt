require 'fog'
require 'logger'

class Shipt

  def initialize(bucket_key, options={})
    raise RuntimeError unless options[:access_key] && options[:secret_key]

    @server_name = bucket_key
    @bucket_key = "#{options[:namespace]}-#{bucket_key}"
    @access_key = options[:access_key]
    @secret_key = options[:secret_key]
    @logger     = Logger.new(options[:logger] || STDOUT)
  end

  def upload_file(path)
    key_name = "#{@server_name}-#{Time.now.strftime("%Y%m%d-%H%M%S")}.log"

    @logger.info "Uploading \"#{path}\" => \"#{key_name}\""

    @logger.info "Creating and Moving to directory #{@bucket_key}"
    @directory = connection.directories.create(:key => "#{@bucket_key}")

    r = connection.put_object(@bucket_key, key_name, File.read(path))
    @logger.info "Uploaded: #{r.inspect}"
    return r
  end

  protected

    def connection
      @connection ||= Fog::AWS::S3.new(:aws_access_key_id => @access_key, :aws_secret_access_key => @secret_key)
    end

end
