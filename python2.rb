def install_python_2
    if OS.is?('mac')
        -"brew install python@2 2>/dev/null"
    elsif OS.is?('windows')
        system("scoop install python27")
    elsif OS.is?('linux')
        # if on ubuntu
        if OS.is?("ubuntu")
            system("sudo apt update")
            system("yes \"\" | sudo apt install python2.7 python-pip")
        else
            raise "Sorry, the automatic install of python isn't supported on your flavor of linux yet :/"
        end
    end
end

def link_python_2
    if OS.is?('mac')
        # overwrite all system links for python2 encase anything was broken from previous installs
        -"brew unlink python@2 2>/dev/null"
        -"brew link python@2 2>/dev/null"
        -"brew link --overwrite python@2 2>/dev/null"
    elsif OS.is?('windows')
        # just pick it
        system("scoop reset python27")
    elsif OS.is?('linux')
        # TODO: make this more efficient by have it being bash 
        # make python2 the default
        Console.set_command("python", "exec 'python2', *ARGV")
        # link the pips
        Console.set_command("pip", "exec 'python', '-m', 'pip', *ARGV")
        Console.set_command("pip2", "exec 'python2', '-m', 'pip', *ARGV")
    end
end

def ensure_python_2()
    # check if python2 exists
    if not Console.has_command("python2")
        install_python_2()
    end
    link_python_2()
end