def install_python_3
    if OS.is?('mac')
        -"brew install python@3 2>/dev/null"
    elsif OS.is?('windows')
        system("scoop install python")
    elsif OS.is?('linux')
        # if on ubuntu
        if OS.is?("ubuntu")
            system("sudo apt update")
            system("sudo apt upgrade python3")
            system("yes \"\" | sudo apt install python3 python3-pip")
        else
            raise "Sorry, the automatic install of python isn't supported on your flavor of linux yet :/"
        end
    end
end

def link_python_3
    if OS.is?('mac')
        # overwrite all system links for python3 encase anything was broken from previous installs
        -"brew unlink python@3 2>/dev/null"
        -"brew link python@3 2>/dev/null"
        -"brew link --overwrite python@3 2>/dev/null"
    elsif OS.is?('windows')
        # just pick it
        system("scoop reset python")
    elsif OS.is?('linux')
        # TODO: make this more efficient by have it being bash 
        # make python3 the default
        Console.set_command("python", "exec 'python3', *ARGV")
        # link the pips
        Console.set_command("pip", "exec 'python', '-m', 'pip', *ARGV")
        Console.set_command("pip3", "exec 'python3', '-m', 'pip', *ARGV")
    end
end

def ensure_python_3()
    # check if python3 exists
    if not Console.has_command("python3")
        install_python_3()
    end
    link_python_3()
end