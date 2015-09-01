include Chef::SSH::Helpers

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  validate_options(new_resource.options, "Resource #{new_resource.name}") if new_resource.options
  validate_type(new_resource.type, "Resource #{new_resource.name}")
  if @current_resource.exists?
    action_update
  else
    @lines << { :options => new_resource.options,
                :type => new_resource.type,
                :key => new_resource.key,
                :comment => new_resource.comment }
    update_file
  end
end

action :update do
  return unless @current_resource.exists?
  current = @lines.find { |line| line[:key] == new_resource.key }
  current[:options] = new_resource.options
  current[:type] = new_resource.type
  current[:comment] = new_resource.comment
  update_file
end

action :remove do
  return unless @current_resource.exists?
  @lines.reject! { |line| line[:key] == new_resource.key }
  update_file
end

def update_file
  directory ::File.dirname(@path) do
    action :create
    owner  new_resource.user
    mode   00700
  end

  file @path do
    action :create
    mode   00600
    owner  new_resource.user
    content format_lines
  end
end

def format_lines
  @lines.collect do |line|
    joined = ''
    if line[:options]
      joined << line[:options].collect do |key, value|
        if value.nil? || value.empty?
          key.to_s
        elsif value.include?(' ') && !value.include?('"')
          "#{key}=\"#{value}\""
        else
          "#{key}=#{value}"
        end
      end.join(',')
      joined << ' '
    end
    joined << line[:type] << ' ' << line[:key]
    line[:comment] && (joined << ' ' << line[:comment])
    joined
  end.join("\n") + "\n"
end

def initialize(new_resource, run_context)
  super(new_resource, run_context)

  @path = ::File.join(user_dir(new_resource.user), '.ssh', 'authorized_keys')

  load_current_resource
end

def load_current_resource
  @lines = ::File.exist?(@path) ? parse(::IO.readlines(@path)) : []

  current_line = @lines.find { |line| line[:key] == @new_resource.key }
  @current_resource = Chef::Resource::SshKnownHosts.new(@new_resource.name)
  @current_resource.exists = current_line
end

protected

def parse(current)
  current.reduce([]) do |memo, row|
    line = {}
    fields = extract_fields(row)
    line[:options] = parse_options(fields.shift) unless types.include? fields[0]
    validate_type(fields[0], @path)
    line[:type] = fields[0]
    line[:key] = fields[1]
    line[:comment] = fields[2..-1].join(' ') if row[2]
    memo << line
  end
end

def extract_fields(row)
  return :comment => row if row.empty? || row[0] == '#'

  quotes = 0
  fields = []
  row.scan(/\S+/) do |match|
    if quotes.even? || quotes == 0
      fields << match
    else
      fields[-1] << " #{match}"
    end
    quotes += match.count('"')
  end
  fields
end

def parse_options(text)
  options = {}
  split = text.split(',')
  split.each do |group|
    validate_options(group, @path)
    group = group.split('=')
    options[group[0]] = group[1]
  end
  options
end

def types
  %w(id-rsa ecdsa-sha2-nistp256 ecdsa-sha2-nistp384 ecdsa-sha2-nistp521 ssh-ed25519 ssh-dss)
end

def validate_type(type, source)
  valid = types
  fail "Invalid Type #{type} in #{source}" unless valid.include? type.to_s
end

def validate_options(option, source)
  if option.is_a? Hash
    option.each { |o| validate_options o, source }
    return
  elsif option.is_a? String
    option = option.split('=')
  end

  binary_options = %w(cert-authority no-agent-forwarding no-port-forwarding no-pty no-user-rc no-X11-forwarding)
  other_options = %w(command environment from permitopen principals tunnel)

  if option[1].nil? || option[1].empty?
    fail "Invalid Option in #{source}: #{option}" unless binary_options.include? option[0].to_s
  else
    fail "Invalid Option in #{source}: #{option}" unless other_options.include? option[0].to_s
  end
end
