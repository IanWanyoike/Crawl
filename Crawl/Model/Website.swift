//
//  Crawled.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

struct Website: Crawlable {
    let url: URL = {
        guard let url = URL(string: "Set the website url to crawl here") else {
            fatalError("Failed to build URL from URL string")
        }
        return url
    }()
}
