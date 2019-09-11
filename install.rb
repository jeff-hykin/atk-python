require 'atk_toolbox'

version_they_want_me_to_install = Console.args[0]

# pick an operating system
if OS.is?('mac')
    if version_they_want_me_to_install == nil
        system 'brew install python'
    else
        version = Version.new(version_they_want_me_to_install)
        system "brew install python@#{version.major}"
    end
elsif OS.is?('linux')
    if version_they_want_me_to_install == nil
        system 'brew install python'
    else
        version = Version.new(version_they_want_me_to_install)
        system "brew install python@#{version.major}"
    end

    answer = Console.yes?("do you like linux")
    if answer
        puts "cool! me too"
        log "(this message only gets printed if Console.verbose == true) I think linux is one of the greatest projects of the modern era, so much of the world runs on linux"
    end

elsif OS.is?('windows')

    puts "Why are you running windows?"

end