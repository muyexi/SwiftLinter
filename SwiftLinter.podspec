Pod::Spec.new do |s|
  s.name           = 'SwiftLinter'
  s.version        = '0.2'
  s.platform       = :ios, '8.0'
  s.summary        = 'Lint changed files with SwiftLint.'
  s.license        = 'MIT'
  s.homepage       = 'https://github.com/muyexi/SwiftLinter'
  s.author         = { 'muyexi' => 'muyexi@gmail.com' }
  s.source         = { :git => 'https://github.com/muyexi/SwiftLinter.git', :tag => s.version }
  s.preserve_paths = ["swiftlint.yml", "swift-lint.sh"]
end
