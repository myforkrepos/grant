# TODO: Remove this file when backwards compatibility with grant 2.0.0
# is no longer necessary
require 'grant/grantable'

module Grant
  module ModelSecurity
    include Grant::Grantable unless self.included_modules.include?(Grant::Grantable)
  end
end
