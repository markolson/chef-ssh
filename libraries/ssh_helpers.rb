class Chef
  module SSH
    module Helpers
      require 'etc'

      def user_dir(username)
        pwent = pwent_for(username)
        pwent.dir
      end

      def pwent_for(uid)
        uid.is_a?(Fixnum) ? Etc.getpwuid(uid) : Etc.getpwnam(uid)
      end
    end
  end
end

