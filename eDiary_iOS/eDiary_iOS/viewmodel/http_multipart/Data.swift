//
//  Data.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 06.04.2024..
//

import Foundation


public extension Data {

    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}
