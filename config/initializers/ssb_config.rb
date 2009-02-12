# Stack Stock Books API Setting
SsbConfig = Struct.new(:user, :token).new(YAML.load(File.read("#{RAILS_ROOT/config/ssb.yml}")))
