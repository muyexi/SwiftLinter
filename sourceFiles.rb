require 'cocoapods-core'

filePath = Dir.pwd + "/Podfile"
parentFilePath = File.expand_path("..", Dir.pwd) + "/Podfile"

puts "filePath:#{filePath}"

podfile = nil
if File.file?(filePath)
  podfile = Pod::Podfile.from_file(filePath)
elsif File.file?(parentFilePath)
  podfile = Pod::Podfile.from_file(parentFilePath)
else
  return ""
end

dependencies = podfile.dependencies.select { |dependency| 
  dependency.local?
}

sourceFiles = dependencies.select { |pod|
  path = pod.external_source[:path]
  fullPath = File.absolute_path(path)

  File.directory?(path)
}.map { |pod| 
  path = pod.external_source[:path]
  fullPath = File.absolute_path(path)

  specPath = fullPath + "/#{pod.name.split("/").first}.podspec"
  spec = Pod::Specification.from_file(specPath)
  subspecs = spec.subspecs

  sourceFiles = []
  if spec.attributes_hash["source_files"] != nil
    sourceFiles = Dir.glob(spec.attributes_hash["source_files"])
  end

  Dir.chdir(fullPath)
  for subspec in subspecs
    if subspec.attributes_hash["source_files"] != nil
      sourceFiles += Dir.glob(subspec.attributes_hash["source_files"])
    end    
  end

  sourceFiles.map { |path| 
    "#{fullPath}/#{path}"
  }
}.flatten.select { |path|
  File.file?(path)
}

puts sourceFiles
