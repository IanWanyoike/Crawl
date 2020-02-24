//
//  CrawlViewModel.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation
import Combine
import os.log

class CrawlViewModel: ObservableObject, Crawler {

    // MARK: - State
    @Published var hundredthCharacter: String = "..."
    @Published var wordCount: String = "..."
    @Published var everyTenthCharacter: String = "..."
    @Published var crawling: Bool = false {
        didSet {
            guard self.crawling else { return }
            self.hundredthCharacter = "..."
            self.everyTenthCharacter = "..."
            self.wordCount = "..."
        }
    }
    @Published var alertMessage: Message?

    var actionLabel: String { self.crawling ? "Crawling" : "Crawl" }

    private(set) var crawlable: Crawlable
    private(set) var networkService: NetworkServiceType

    private lazy var cancellables: Set<AnyCancellable> = Set()

    // MARK: - Initialization
    init(crawlable: Crawlable, networkService: NetworkServiceType = NetworkService()) {
        self.crawlable = crawlable
        self.networkService = networkService
    }

    // MARK: - Methods
    func crawl() {
        guard !self.crawling else { return }
        self.crawling = true

        let sharedPublisher = self.networkService.request(
            from: self.crawlable.url,
            acceptContentType: .html
        ).compactMap {
            String(data: $0, encoding: .utf8)
        }.share()

        sharedPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] event in
                    guard let `self` = self else { return }
                    self.crawling = false
                    switch event {
                    case .finished:
                        break
                    case .failure(let error):
                        os_log(.error, "Error fetching content: %@", error.localizedDescription)
                        self.alertMessage = Message(title: "Crawl Error", message: error.localizedDescription)
                    }
                }, receiveValue: { _ in }
            )
            .store(in: &self.cancellables)

        sharedPublisher
            .map { content in content.split(whereSeparator: { $0.isWhitespace }).count.formattedWithSeparator }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] count in self?.wordCount = count }
            )
            .store(in: &self.cancellables)

        sharedPublisher
            .map { content in
                stride(from: 9, to: content.count, by: 10).map {
                    String(content[String.Index(utf16Offset: $0, in: content)])
                }
            }
            .map { collection in
                (everyTenthCharacter: collection.joined(), hundredthCharacter: collection.count > 9 ? collection[9] : "")
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] tuple in
                    guard let `self` = self else { return }
                    self.everyTenthCharacter = tuple.everyTenthCharacter
                    self.hundredthCharacter = tuple.hundredthCharacter
                }
            )
            .store(in: &self.cancellables)
    }

    deinit { self.cancellables.forEach { $0.cancel() } }
}
