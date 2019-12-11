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
        -"brew link --overwrite python@2 2>/dev/null"
        python2_version = Version.extract_from(`brew info python@2`)
        python2_executable = "/usr/local/Cellar/python@2/#{python2_version}/bin/python"
        system "sudo", "ln", "-sf", python2_executable, "/usr/local/bin/python2"
        system "sudo", "ln", "-sf", python2_executable, "/usr/local/bin/python"
        # directly link pip2, pip to their correct pythons
        FS.write("#!/bin/bash\npython -m pip $@", to: "/usr/local/bin/pip")
        FS.write("#!/bin/bash\npython2 -m pip $@", to: "/usr/local/bin/pip2")
        
        # if homebrew python3 is installed, ensure those links are maintained
        if `brew list`.split("\n").include?("python")
            # directly link python3 to their most homebrew-up-to-date executables
            system "sudo", "ln", "-sf", python3_executable, "/usr/local/bin/python3"
            # directly link pip3
            FS.write("#!/bin/bash\npython3 -m pip $@", to: "/usr/local/bin/pip3")
        end
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