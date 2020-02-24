//
//  FormatterExtensions.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? String(self)
    }
}
