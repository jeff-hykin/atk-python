require 'atk_toolbox'

version_they_want_me_to_install = Console.args[0]

# pick an operating system
if OS.is?('mac')

    puts "Now I can do my install stuff for mac here"
    -"which python3" || puts("you don't have python! :O ")

elsif OS.is?('linux')

    answer = Console.yes?("do you like linux")
    if answer
        puts "cool! me too"
        log "(this message only gets printed if Console.verbose == true) I think linux is one of the greatest projects of the modern era, so much of the world runs on linux"
    end

elsif OS.is?('windows')

    puts "Why are you running windows?"

end