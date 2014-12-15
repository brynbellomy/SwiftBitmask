

Pod::Spec.new do |s|
  s.name = 'SwiftBitmask'
  s.version = '0.0.4'
  s.license = 'WTFPL'
  s.summary = 'Generic Bitmask utility type, written in Swift.'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/SwiftBitmask'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true

  s.source = { :git => 'https://github.com/brynbellomy/SwiftBitmask.git', :tag => s.version }
end
