# Git CLI interaction

# Commits the path it's given
def commit(_path : String, _message : String)
  Dir.cd _path
  system "git add #{_path}"
  system "git commit -m \"#{_message}\""
  system "git push"
end
