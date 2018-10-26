require 'cocoapods-core'

filePath = Dir.pwd + "/Podfile"
parentFilePath = File.expand_path("..", Dir.pwd) + "/Podfile"

podfile = nil
if File.exist?(filePath)
  podfile = Pod::Podfile.from_file(filePath)
elsif File.exist?(parentFilePath)
  podfile = Pod::Podfile.from_file(parentFilePath)
else
  return ""
end

localPods = podfile.dependencies.select { |pod| 
  pod.local?
}

dirs = localPods.map { |pod| 
  path = pod.external_source[:path]
  fullPath = File.absolute_path(path)
}.select { |path|
  File.directory?(path)
}

puts dirs.join(" ")
