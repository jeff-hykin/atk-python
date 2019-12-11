require 'atk_toolbox'

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