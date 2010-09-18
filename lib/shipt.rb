require 'fog'
require 'logger'

class Shipt

  def initialize(bucket_key, options={})
    raise RuntimeError unless options[:access_key] && options[:secret_key]

    @server_name = bucket_key
    @bucket_key = "#{options[:namespace]}-#{bucket_key}"
    @description = options[:description]
    @access_key = options[:access_key]
    @secret_key = options[:secret_key]
    @logger     = Logger.new(options[:logger] || STDOUT)
  end

  def upload_file(path)
    ext = File.extname(path)
    key_name =  if ext == '.log'
                  "#{@server_name}-#{@description}-#{Time.now.strftime("%Y%m%d-%H%M%S")}#{ext}"
                else
                  "#{@server_name}-#{@description}-#{Time.now.strftime("%Y%m%d-%H%M%S")}.log#{ext}"
                end

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
