//
//  Crawlable.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

protocol Crawlable {
    var url: URL { get }
}

protocol Crawler {
    var crawlable: Crawlable { get }
    var networkService: NetworkServiceType { get }
    func crawl()
}
