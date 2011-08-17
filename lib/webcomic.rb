if defined? Encoding
  Encoding.default_internal = Encoding.default_external = "UTF-8"
else
  $KCODE = "UTF-8"
end

require 'webcomic/data'
require 'webcomic/admin'
require 'webcomic/helpers'
#require 'webcomic/mock_app'
require 'webcomic/html_template'
require 'webcomic/middleman'
