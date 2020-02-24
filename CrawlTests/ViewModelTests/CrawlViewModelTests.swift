//
//  CrawlViewModelTests.swift
//  CrawlTests
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

import Quick
import Nimble

import OHHTTPStubs

@testable import Crawl

class CrawlViewModelTests: QuickSpec {
    override func spec() {
        describe("Crawl") {
            var crawlable: Crawlable?
            var networkService: NetworkService?
            var modelStub: HTTPStubsDescriptor?
            beforeEach {
                networkService = NetworkService()
                crawlable = Website()
                guard let stubPath = OHPathForFile("jenga.docs.html", type(of: self)),
                    let crawlable = crawlable else {
                    return
                }
                modelStub = stub(condition: isAbsoluteURLString(crawlable.url.absoluteString)) { _ -> HTTPStubsResponse in
                    return fixture(
                        filePath: stubPath,
                        headers: [
                            "Content-Type": "application/json",
                            "Accept": "text/html"
                        ]
                    )
                    .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
                }
            }
            it("Sets Required Values From Crawled URL") {
                guard let crawlable = crawlable,
                    let networkService = networkService else {
                    fail("Network Service and Crawlable dependencies are not set")
                    return
                }

                guard let everyTenthCharacter = self.loadEveryTenthCharacter() else {
                    fail("Could not load string from `everyTenthCharacter.txt`")
                    return
                }

                let crawlViewModel = CrawlViewModel(
                    crawlable: crawlable,
                    networkService: networkService
                )

                expect(crawlViewModel.hundredthCharacter).to(equal("..."))
                expect(crawlViewModel.wordCount).to(equal("..."))
                expect(crawlViewModel.everyTenthCharacter).to(equal("..."))
                expect(crawlViewModel.crawling).to(beFalse())

                crawlViewModel.crawl()

                expect(crawlViewModel.crawling).to(beTrue())
                expect(crawlViewModel.crawling).toEventually(beFalse(), timeout: 5)
                expect(crawlViewModel.hundredthCharacter).toEventually(equal("a"), timeout: 5)
                expect(crawlViewModel.wordCount).toEventually(equal("7,747"), timeout: 5)
                expect(crawlViewModel.everyTenthCharacter.filter { !$0.isWhitespace })
                    .toEventually(equal(everyTenthCharacter.filter { !$0.isWhitespace }), timeout: 5)
                expect(crawlViewModel.crawling).toEventually(beFalse(), timeout: 5)
            }
            afterEach {
                guard let stub = modelStub else { return }
                HTTPStubs.removeStub(stub)
            }
        }
    }

    private func loadEveryTenthCharacter() -> String? {
        guard let filepath = Bundle(for: CrawlViewModelTests.self).path(forResource: "everyTenthCharacter", ofType: "txt") else {
            return nil
        }
        return try? String(contentsOfFile: filepath, encoding: .utf8)
    }
}
