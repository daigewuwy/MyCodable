//
//  AnyCodingKey.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

public extension JSONEncoder.KeyEncodingStrategy
{
    /// 转换为首字母大写
    static var convertToUpperCamelCase: JSONEncoder.KeyEncodingStrategy
    {
        return .custom { codingKeys in
            
            var key = AnyCodingKey(codingKeys.last!)
            
            if let firstChar = key.stringValue.first
            {
                let i = key.stringValue.startIndex
                let range = i...i
                let replaceChar = String(firstChar).uppercased()
                key.stringValue.replaceSubrange(range,
                                                with: replaceChar)
            }
            
            return key
        }
    }
}

fileprivate struct AnyCodingKey : CodingKey
{
    var stringValue: String
    var intValue: Int?
    
    init(_ base: CodingKey)
    {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    init(stringValue: String)
    {
        self.stringValue = stringValue
    }
    
    init(intValue: Int)
    {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?)
    {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}
