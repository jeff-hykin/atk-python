require 'atk_toolbox'

version_they_want_me_to_install = Console.args[0]

# pick an operating system
if OS.is?('mac')

    # make sure both exist
    if not Console.has_command("python2")
        -"brew install python2"
    end
    # overwrite all system links for python2 encase anything was broken from previous installs
    -"brew link --overwrite python@2"
    if not Console.has_command("python3")
        -"brew install python3"
    end

elsif OS.is?('linux')
    # if on ubuntu
    if -"which apt"
        system("sudo apt update")
        system("sudo apt upgrade python3")
        system("yes \"\" | sudo apt install python2.7 python-pip")
        system("yes \"\" | sudo apt install python3 python3-pip")
    else
        raise "Sorry, the automatic install of python isn't supported on your flavor of linux yet :/"
    end

elsif OS.is?('windows')

    system("scoop install python27 python")

end


# 
# set the command
# 
puts Console.args
if Console.args[1] == "2"
    puts "Setting #{"python".green} command to be #{"python2".green}"
    set_command("python", "exec 'python2', *ARGV")
    set_command("pip", "exec 'pip2', *ARGV")
elsif Console.args[1] == "3"
    puts "Setting #{"python".green} command to be #{"python3".green}"
    set_command("python", "exec 'python3', *ARGV")
    set_command("pip", "exec 'pip3', *ARGV")
else
    # if no version specified, then ask the user
    options = ["uh... I'm not sure", "I need it to link to python2!", "I need it to link to python3!"]
    if options[1] == Console.select("\n\nWhat would you like the python command to link to?", options)
        puts "Okay I'll link it to python2"
        set_command("python", "exec 'python2', *ARGV")
        set_command("pip", "exec 'pip2', *ARGV")
    else
        puts "Okay I'll link it to python3"
        set_command("python", "exec 'python3', *ARGV")
        set_command("pip", "exec 'pip3', *ARGV")
    end
end