require 'mspec/guards/guard'

class Object
  def env
    command_output = ''

    platform_is_not :opal, :windows do
      command_output = `env`
    end

    platform_is :windows do
      command_output = `cmd.exe /C set`
    end

    environment_variables(command_output)
  end

  def windows_env_echo(var)
    platform_is_not :opal do
      `cmd.exe /C ECHO %#{var}%`.strip
    end
  end

  def username
    user = ""

    platform_is :windows do
      user = windows_env_echo('USERNAME')
    end

    platform_is_not :opal do
      user = `whoami`.strip
    end

    user
  end

  def home_directory
    return ENV['HOME'] unless PlatformGuard.windows?
    windows_env_echo('HOMEDRIVE') + windows_env_echo('HOMEPATH')
  end

  def dev_null
    if PlatformGuard.windows?
      "NUL"
    else
      "/dev/null"
    end
  end

  def hostname
    commands = ['hostname', 'uname -n']
    commands.each do |command|
      name = ''
      platform_is_not :opal do
        name = `#{command}`
      end
      return name.strip if $?.success?
    end
    raise Exception, "hostname: unable to find a working command"
  end

  private

  def environment_variables(command_output)
    Hash[*environment_tuples(command_output)]
  end
  
  def environment_tuples(command_output)
    command_output.split("\n").map { |e| e.split("=", 2) }.flatten
  end
end
