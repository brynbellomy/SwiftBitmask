Pod::Spec.new do |s|
  s.name = 'SwiftBitmask'
  s.version = '0.2.0'
  s.summary = 'NS_OPTIONS for Swift (type-checked bitmask container).  Basically an easier-to-implement RawOptionSet.'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/SwiftBitmask'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true

  s.dependency 'Funky', '0.3.0'

  s.source = { :git => 'https://github.com/brynbellomy/SwiftBitmask.git', :tag => s.version }
end
