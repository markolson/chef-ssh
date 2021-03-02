require_relative 'ssh_helpers'
include Chef::SSH::Helpers

class Chef
  module SSH
    module ConfigHelpers
      def default_or_user_path(username = nil)
        username ? "#{user_dir(username)}/.ssh/config" : node['ssh']['config_path']
      end

      def default?(path)
        File.expand_path(path).eql? File.expand_path(node['ssh']['config_path'])
      end

      def parse_file(path) # rubocop:disable Style/CyclomaticComplexity
        entries = {}
        return entries unless ::File.exist?(path)
        name = nil
        IO.foreach(path) do |line|
          next if line =~ /^\s*(#|\r?\n|\s*$)/ # skip lines with only comments or whitespace

          check_name = parse_name(line)
          next if check_name && (name = check_name) && (entries[name] = {})

          key, entry = parse_line(line)
          next unless entry && name
          entries[name][key] = entry
        end
        entries
      end

      def to_config(existing_entries)
        existing_entries.map do |name, options|
          body = if options
                   options.map { |key, value| "  #{key} #{value}" }.join("\n")
                 else
                   ''
                 end
          ["Host #{name}", body].join("\n")
        end.join("\n\n") + "\n"
      end

      def parse_name(line)
        matchdata = line.match(/^\s*([h|H]ost\s+)(.*$)/)
        matchdata ? matchdata.captures[1].strip : false
      end

      def parse_line(line)
        matchdata = line.match(/^\s*(\w+)(.*$)/)
        return matchdata.captures[0], matchdata.captures[1].strip if matchdata

        Chef::Log.error("Line |#{line}| does not parse correctly")
        nil
      end
    end
  end
end
