class Chef
  module SSH
    module PathHelpers
      require 'etc'

      def default_or_user_path(default, ssh_user)
        filename = File.basename(default)
        ssh_path = nil
        if (new_resource.user && !new_resource.path)
          pwent = get_pwent_for(new_resource.user)
          ssh_path = "#{pwent.dir}/.ssh/#{filename.gsub('ssh_','')}"
        elsif new_resource.path
          ssh_path = new_resource.path
        else
          ssh_path = default
        end

        directory ::File.dirname(ssh_path) do
          owner ssh_user
          group(pwent.gid) unless pwent.nil?
          mode ssh_path == default ? 00755 : 00700
          recursive true
          path ::File.dirname(ssh_path)
          user ssh_user
        end

        return ssh_path
      end

      def get_pwent_for(uid)
        uid.is_a?(Fixnum) ? Etc.getpwuid(uid) : Etc.getpwnam(uid)
      end

    end
  end
end
