# Stack Stock Books API Setting

h = YAML.load(File.read("#{RAILS_ROOT}/config/ssb.yml"))
SsbConfig = Struct.new(:user, :token).new()
h.each{|k,v|
  SsbConfig.__send__("#{k}=", v)
}
