require "json"
require "file_utils"
require "git"

CONFIG_DIR = ENV["HOME"] + "/.config/dot-manager/"

DOTS_FILE_LOCATION = CONFIG_DIR + "dots.json"

# Check for dots file
if File.exists? DOTS_FILE_LOCATION
else
    # STDOUT.print doesnt add a newline
    STDOUT.print "dots.json not found, would you like to create it? [y/N] "
    
    inp = gets
    if inp == "y"
        # Creates the directorys
        Dir.mkdir_p CONFIG_DIR
        # Write empty json
        File.write DOTS_FILE_LOCATION, "{\"dots\":[]}"
    else
        exit
    end
end

# The data structure of the JSON file
data_structure = Hash(
    String, 
    Array(
        Hash(
            String,
            Path | String)
        )
    )

# Read the exisiting data
existing_dots = data_structure.from_json File.read(DOTS_FILE_LOCATION)

if ARGV[0]? == "add"
    # STDOUT.print doesnt add a newline
    STDOUT.print "Name of service? "
    name = gets.not_nil!
    
    # Expand the path
    loc = Path.posix(ARGV[1]).expand 

    # Build out data structure
    new_dot = { "name" => name, "loc" => loc }
    
    existing_dots["dots"].push new_dot

    File.write DOTS_FILE_LOCATION, existing_dots.to_json
    exit
end

if ARGV[0]? == "ls"
    # Maps each dot to a code block printing out info
    existing_dots["dots"].each do |dot|
        puts "#{dot["name"]} => #{dot["loc"]}"
    end
    exit
end

if ARGV[0]? == "copy"
    existing_dots["dots"].each do |dot|
        # Get the filename for the loc
        filename = Path[dot["loc"]].parts.last

        puts "Copying #{dot["name"]} file to ~/.config/dot-manager/#{dot["name"]}/#{filename} "

        # Create the folder if it doesnt exist, and then copy
        if Dir.exists? CONFIG_DIR + dot["name"].to_s
            FileUtils.cp dot["loc"].to_s, CONFIG_DIR + dot["name"].to_s + "/" + filename
        else
            Dir.mkdir CONFIG_DIR + dot["name"].to_s
            FileUtils.cp dot["loc"].to_s, CONFIG_DIR + dot["name"].to_s + "/" + filename
        end
    end

    if ARGV[1]? == "c"
        commit CONFIG_DIR, "commited at now"
    end

    exit
end

if ARGV[0]? == "write"
    existing_dots["dots"].each do |dot|
        # Get the filename for the loc
        filename = Path[dot["loc"]].parts.last

        puts "Copying #{filename} to #{dot["loc"]}"

        FileUtils.cp CONFIG_DIR + dot["name"].to_s + "/" + filename, dot["loc"].to_s
    end
    exit
end

help_msg = "Usage:
  dots [commands] <arguments>

COMMANDS:
  add <path to file>   adds the file to the dots config
  copy                 copies all dots to the config dir for backup
  write                copies the backups back to their respective locations
  ls                   list all dots
"
puts help_msg