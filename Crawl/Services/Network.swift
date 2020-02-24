//
//  NetworkServiceType.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
    case html = "text/html; charset=UTF-8"
}

protocol NetworkServiceType {
    func request(from url: URL, with method: HTTPMethod, parameters: [String: Any]?, acceptContentType: ContentType) -> AnyPublisher<Data, Error>
}

extension NetworkServiceType {
    func request(from url: URL, with method: HTTPMethod = .get, parameters: [String: Any]? = nil, acceptContentType: ContentType = .json) -> AnyPublisher<Data, Error> {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        request.setValue(acceptContentType.rawValue, forHTTPHeaderField: "Accept")

        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .mapError {
                guard let error = $0 as? URLError else { return $0 }
                return error
            }
            .eraseToAnyPublisher()
    }
}
