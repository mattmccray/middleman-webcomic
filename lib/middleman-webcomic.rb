# Try to 'force' utf-8 encoding
if defined? Encoding
  Encoding.default_internal = Encoding.default_external = "UTF-8"
else
  $KCODE = "UTF-8"
end

require 'middleman-webcomic/data'
require "middleman-webcomic/feature"
require "middleman-webcomic/template"
