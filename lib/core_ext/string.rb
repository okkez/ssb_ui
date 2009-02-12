
class String
  def decode_js
    self.gsub(/\\u(.{4})/){ ["0x#{$1}".to_i(16)].pack('U*') }
  end
end
