//
//  Message.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

struct Message: Identifiable {

    // MARK: - State
    var id = UUID().uuidString
    let title: String
    let message: String
}
