# Crawl ![Logo](./Crawl/Utilities/Assets.xcassets/Worm36.imageset/worm@36x1.png "Crawl Logo")

Crawl is an iOS application with a mission to get and display the 100th character, every 10th character and the count of words from a website.

Open **Crawl.xcworkspace** because I've used [CocoaPods](https://cocoapods.org/).

Thoughts on implementation:
  - Rather than perform 3 separate, simultaneous requests to the same url (to receive the same content), perform 1 request.
  - The 100th character is the 10th element in the sequence of every tenth character in the html response string.

### Tech
* [Swift](https://swift.org/)
* [SwiftUI](https://developer.apple.com/xcode/swiftui/)
* [Combine](https://developer.apple.com/documentation/combine)
* [SwiftLint](https://github.com/realm/SwiftLint)
* [Quick](https://github.com/Quick/Quick)
* [Nimble](https://github.com/Quick/Nimble)
* [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)
