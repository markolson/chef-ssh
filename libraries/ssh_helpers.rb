class Chef
  module SSH
    module Helpers
      require 'etc'
      def user_dir(username)
        pwent = pwent_for(username)
        pwent.dir
      end

      def user_group(username)
        gid = user_gid(username)
        return nil unless gid

        Etc.getgrgid(gid).name
      end

      def user_gid(username)
        username ? pwent_for(username).gid : nil
      end

      def pwent_for(uid)
        uid.is_a?(Fixnum) ? Etc.getpwuid(uid) : Etc.getpwnam(uid)
      end
    end
  end
end
