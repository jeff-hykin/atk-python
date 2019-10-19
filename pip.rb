
# if a version was provided
if ARGV[1] != nil
    system 'pip', 'install', "#{ARGV[0]}==#{ARGV[1]}"
# if no version
else
    system 'pip', 'install', ARGV[0]
end