require 'atk_toolbox'

version_they_want_me_to_install = Console.args[0]

# pick an operating system
if OS.is?('mac')

    # make sure both exist
    -"brew install python2"
    -"brew install python3"

elsif OS.is?('linux')
    # if on ubuntu
    if -"which apt"
        system("sudo apt update")
        system("sudo apt upgrade python3")
        system("yes \"\" | sudo apt install python2.7 python-pip")
        system("yes \"\" | sudo apt install python3 python3-pip")
    else
        raise "Sorry, I don't support your version of linux yet :/"
    end

elsif OS.is?('windows')

    system("scoop install python27 python")

end


# 
# set the command
# 
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