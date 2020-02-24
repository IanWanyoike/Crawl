//
//  Crawled.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

struct JengaDocs: Crawlable {
    let url: URL = {
        guard let url = URL(string: "https://developer.jengaapi.io/docs") else {
            fatalError("Failed to build URL from valid URL string")
        }
        return url
    }()
}
