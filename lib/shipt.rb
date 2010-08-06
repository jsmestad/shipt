require 'fog'

class Shipt
  
  def initialize(bucket_key, options={})
    raise RuntimeError unless options[:access_key] && options[:secret_key]
    
    @bucket_key = bucket_key
    @access_key = options[:access_key]
    @secret_key = options[:secret_key]
  end
  
  def upload_file(path)
    directory.files.create(:key => "#{@bucket_key}-#{Time.now.strftime("%Y%m%d-%H%M%S")}.log", :body => File.read(path))
  end
  
  def directory(server)
    directory = connection.directories.create(:key => "#{@bucket_key}")
  end
  
  protected
  
    def connection
      @connection ||= Fog::AWS::S3.new(:aws_access_key_id => @access_key, :aws_secret_access_key => @secret_key)
    end                
                
end