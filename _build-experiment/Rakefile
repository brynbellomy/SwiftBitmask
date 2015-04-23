SCHEME      = "SwiftBitmask"
DESTINATION = "platform=OS X,arch=x86_64"

desc "unit test"
task :default do
  sh "xcodebuild test -scheme #{SCHEME} -destination \"#{DESTINATION}\" -configuration Debug | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}"
end
