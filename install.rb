require 'atk_toolbox'

# pick an operating system
if OS.is?('mac')

    # make sure both exist
    if not Console.has_command("python2")
        -"brew install python2"
    end
    # overwrite all system links for python2 encase anything was broken from previous installs
    -"brew unlink python@2"
    -"brew link python@2"
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
if Console.args[1] == "2"
    puts "Setting #{"python".green} command to be #{"python2".green}"
    Console.set_command("python", "exec 'python2', *ARGV")
elsif Console.args[1] == "3"
    puts "Setting #{"python".green} command to be #{"python3".green}"
    Console.set_command("python", "exec 'python3', *ARGV")
else
    # if no version specified, then ask the user
    options = ["uh... I'm not sure", "I need it to link to python2!", "I need it to link to python3!"]
    if options[1] == Console.select("\n\nWhat would you like the python command to link to?", options)
        puts "Okay I'll link it to python2"
        Console.set_command("python", "exec 'python2', *ARGV")
    else
        puts "Okay I'll link it to python3"
        Console.set_command("python", "exec 'python3', *ARGV")
    end
end

# 
# fix pip
# 
Console.set_command("pip", "exec 'python', '-m', 'pip', *ARGV")
Console.set_command("pip2", "exec 'python2', '-m', 'pip', *ARGV")
Console.set_command("pip3", "exec 'python3', '-m', 'pip', *ARGV")