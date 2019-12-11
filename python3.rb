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
        # make sure python2 via homebrew exists
        system "brew install python@2 2>/dev/null"
        python2_version = Version.extract_from(`brew info python@2`)
        python2_executable = "/usr/local/Cellar/python@2/#{python2_version}/bin/python"
        
        # overwrite all system links for python3 encase anything was broken from previous installs
        -"brew unlink python@3 2>/dev/null"
        -"brew link --overwrite python@3 2>/dev/null"
        python3_version = Version.extract_from(`brew info python@3`)
        python3_executable = "/usr/local/Cellar/python/#{python3_version}/bin/python3"
        
        # directly link python2, python, python3 to their most homebrew-up-to-date executables
        system "sudo", "ln", "-sf", python2_executable, "/usr/local/bin/python2"
        system "sudo", "ln", "-sf", python3_executable, "/usr/local/bin/python"
        system "sudo", "ln", "-sf", python3_executable, "/usr/local/bin/python3"
        
        # directly link pip2, pip, and pip3 to their correct pythons
        FS.write("#!/bin/bash\npython3 -m pip $@", to: "/usr/local/bin/pip3")
        FS.write("#!/bin/bash\npython -m pip $@", to: "/usr/local/bin/pip")
        FS.write("#!/bin/bash\npython2 -m pip $@", to: "/usr/local/bin/pip2")
    elsif OS.is?('windows')
        # just pick it
        system("scoop reset python")
    elsif OS.is?('linux')
        # TODO: make this more efficient by have it being bash 
        Console.set_command("python", "exec 'python3', *ARGV")
        # fix all the pips
        FS.write("#!/bin/bash\npython3 -m pip $@", to: "/usr/local/bin/pip3")
        FS.write("#!/bin/bash\npython -m pip $@", to: "/usr/local/bin/pip")
        FS.write("#!/bin/bash\npython2 -m pip $@", to: "/usr/local/bin/pip2")
        
    end
end

def ensure_python_3()
    # check if python3 exists
    if not Console.has_command("python3")
        install_python_3()
    end
    link_python_3()
end