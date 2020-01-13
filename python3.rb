require 'atk_toolbox'

version = Console.args[0]

def select_version(version, from: "")
    version_list = from
    if version_list.is_a?(String)
        versions = version_list.split("\n").map(&:strip)
    elsif version_list.is_a?(Array)
        versions = version_list.map(&:strip)
    end
    # exact match
    if versions.include?(version)
        return version
    end
    
    pure_versions = versions.select do |each|
        each =~ /\A\d+\.\d+\.\d+\z/
    end.map{|each| Version.new(each)}.sort!.reverse!
    
    # if none selected, then pick the latest stable
    if version == nil
        return pure_versions[0]
    else
        version = Version.new(version)
        
        if version > pure_versions[0]
            raise <<-HEREDOC.remove_indent
                
                
                Version higher than avalible version
                    requested version: #{version}
                    highest avalible: #{pure_versions[0]}
            HEREDOC
        end
        
        for each in pure_versions
            if version >= each
                return each
            end
        end
        
        # TODO: error lowest version not found
        return nil
    end
end

if OS.is?(:windows)
    require_relative './python3.rb'
    require_relative './python2.rb'

    # 
    # decide which version
    # 
    primary_version = 3
    if Console.args[0] == "2"
        puts "Setting #{"python".green} command to be #{"python2".green}"
        primary_version = 2
    elsif Console.args[0] == "3"
        puts "Setting #{"python".green} command to be #{"python3".green}"
        primary_version = 3
    else
        # if no version specified, then ask the user
        options = ["uh... I'm not sure", "I need it to link to python2!", "I need it to link to python3!"]
        if options[1] == Console.select("\n\nWhat would you like the python command to link to?", options)
            puts "Okay I'll link it to python2"
            primary_version = 2
        else
            puts "Okay I'll link it to python3"
            primary_version = 3
        end
    end


    # 
    # do the install/setup accordingly
    # 
    if primary_version == 3
        ensure_python_2()
        ensure_python_3()
    elsif primary_version == 2
        ensure_python_3()
        ensure_python_2()
    end
end


if OS.is?(:unix)
    # 
    # install a python version manager
    # 
    Atk.run("jeff-hykin/atk-asdf")
    
    asdf_path = HOME/".asdf"
    asdf_path = `brew --prefix asdf`.chomp if OS.is?(:mac)
    asdf_command = "source #{Console.as_shell_argument(asdf_path/"asdf.sh")}"
    
    # 
    # add python plugin
    # 
    system <<-HEREDOC
        # run the asdf setup
        #{asdf_command}
        # then add python
        asdf plugin add python
        asdf plugin update python
    HEREDOC
    
    # 
    # figure out which version
    # 
    versions = `#{asdf_command};asdf list all python`.split("\n").map(&:strip)
    selected_version = select_version(version, from: versions)
    
    # execute the setup so the command is avalible
    system <<-HEREDOC
        # run the asdf setup
        #{asdf_command}
        # then add python
        asdf plugin add python
        asdf plugin update python
        # then install the version
        asdf install python #{selected_version}
        # then set the local version
        asdf local python #{selected_version}
        # then set the version
        asdf global python #{selected_version}
    HEREDOC
    
    # TODO: check to make sure python2/python3, pip3, pip2 etc get installed
end
