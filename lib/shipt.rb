require 'fog'
require 'logger'

class Shipt
  
  def initialize(bucket_key, options={})
    raise RuntimeError unless options[:access_key] && options[:secret_key]
    
    @bucket_key = bucket_key
    @access_key = options[:access_key]
    @secret_key = options[:secret_key]
    @logger     = Logger.new(options[:logger] || STDOUT)
  end
  
  def upload_file(path)
    key_name = "#{@bucket_key}-#{Time.now.strftime("%Y%m%d-%H%M%S")}.log"
    
    @logger.info "Uploading \"#{path}\" => \"#{key_name}\""
    r = directory.files.create(:key => key_name, :body => File.read(path))
    @logger.info "Uploaded: #{r.inspect}"
  end
  
  def directory
    @logger.info "Creating and Moving to directory #{@bucket_key}"
    @directory = connection.directories.create(:key => "#{@bucket_key}")
  end
  
  protected
  
    def connection
      @connection ||= Fog::AWS::S3.new(:aws_access_key_id => @access_key, :aws_secret_access_key => @secret_key)
    end                
                
end