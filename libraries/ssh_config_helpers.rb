require_relative 'ssh_helpers'
include Chef::SSH::Helpers

class Chef
  module SSH
    module ConfigHelpers

      def default_or_user_path(username = nil)
        if username
          user_dir(username)
        else
          ssh_path = node['ssh']['config_path']
        end
      end

      def default?(path)
        File.expand_path(path).eql? File.expand_path(node['ssh']['config_path'])
      end

      def parse_file(path)
        entries = {}
        return entries unless ::File.exist?(path)
        name = nil?
        IO.foreach(path) do |line|
          matchdata = line.match(/^\s*([h|H]ost)(.*$)/)
          if matchdata
            name = matchdata.captures[1].strip
            entries[name] = {}
            next
          end

          matchdata = line.match(/^\s*(\w+)(.*$)/)
          entries[name][matchdata.captures[0]] = matchdata.captures[1].strip
        end
        entries
      end

      def to_config(existing_entries)
        existing_entries.map do |name, options|
          if options
            body = options.map{ |key, value| "  #{key} #{value}" }.join("\n")
          else
            body = ''
          end
          [ "Host #{name}", body ].join("\n")
        end.join("\n\n") + "\n"
      end
    end
  end
end