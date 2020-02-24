source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

def testPods
  pod 'Quick'
  pod 'Nimble'
  pod 'OHHTTPStubs/Swift'
end

target 'Crawl' do
  use_frameworks!

  pod 'SwiftLint'

  target "CrawlTests" do
    testPods
  end

  target "CrawlUITests" do
    testPods
  end

end
