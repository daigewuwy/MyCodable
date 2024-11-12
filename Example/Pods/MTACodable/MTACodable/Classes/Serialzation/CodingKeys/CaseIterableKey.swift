//
//  CaseIterableKey.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

public protocol CaseIterableEncodable: Encodable {
}

extension CaseIterableEncodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let mirror = Mirror(reflecting: self)
        guard let associated = mirror.children.first else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid associated values"))
        }
        
        let associatedValues = Mirror(reflecting: associated.value).children
        for (label, value) in associatedValues {
            guard let label = label else { continue }
            let key = CodingKeys(stringValue: label)!
            if let encodableValue = value as? Encodable {
                try encodableValue.encode(to: container.superEncoder(forKey: key))
            }
        }
    }
}


fileprivate struct CodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int?
    init?(intValue: Int) { return nil }
}
