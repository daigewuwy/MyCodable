//
//  MultipleFieldCodingKey.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

public typealias FieldMapper = [String: [String]]
public typealias NestedFieldMapper = [String: iFieldMapper.Type]

public enum FieldMapStrategy {
    /// 自定义
    case custom(mapper: FieldMapper, nestedMapper: NestedFieldMapper)
    /// 蛇形
    case snakeCase
}

/// 自定义字段映射规则协议
/// 适用于服务端下发字段名与本地字段名不匹配的场景
public protocol iFieldMapper
{
    static var mapStrategys: [FieldMapStrategy] { get }
}

extension iFieldMapper {
    
    static var mapStrategys: [FieldMapStrategy] {
        [.snakeCase, .custom(mapper: FieldMapper(), nestedMapper: NestedFieldMapper())]
    }
}

extension iFieldMapper
{
    public static var multipleFieldDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    {
        .custom { codingPaths in
            
            /// codingPaths 是解析路径，如 ContainerType 中有一个 NestedType，则 codingPaths = [ContainerType, NestedType]
            let lastCodingKey = codingPaths.last!.stringValue
            
            var strategys = self.mapStrategys
            
            if codingPaths.count > 1,
               case .custom(_, let nestedMapper) = strategys.first(where: {
                   switch $0 {
                   case .custom:
                       return true
                   default:
                       return false
                   }
               }),
               !nestedMapper.isEmpty,
               let nestedDecodeType = checkoutDeeplyNestedDecodeType(codingPaths: codingPaths, fromNestedDecodeTypeMapper: nestedMapper)
            {
                strategys = nestedDecodeType.mapStrategys
            }
            
            return MultipleFieldCodingKey(stringValue: lastCodingKey,
                                            strategys: strategys)
        }
    }
    
    private static func checkoutDeeplyNestedDecodeType(codingPaths: [CodingKey],
                                                       fromNestedDecodeTypeMapper: NestedFieldMapper) -> iFieldMapper.Type?
    {
        var curNestedDecodeType: iFieldMapper.Type?
        var curNestedDecodeTypeMapper = fromNestedDecodeTypeMapper
        
        for codingPath in codingPaths where !curNestedDecodeTypeMapper.isEmpty
        {
            let codingKey = codingPath.stringValue
            guard let _curNestedDecodeType = curNestedDecodeTypeMapper[codingKey]
            else
            {
                break
            }
            
            curNestedDecodeType = _curNestedDecodeType
            
            let customStrategy = mapStrategys.first(where: {
                switch $0 {
                case .custom:
                    return true
                default:
                    return false
                }
            })
            
            if case .custom(_, let nestedMapper) = customStrategy
            {
                curNestedDecodeTypeMapper = nestedMapper
            }
        }
        
        return curNestedDecodeType
    }
}

fileprivate struct MultipleFieldCodingKey: CodingKey
{
    var intValue: Int?
    init?(intValue: Int)
    {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }

    var stringValue: String
    init?(stringValue: String)
    {
        self.stringValue = stringValue
    }
    
    init(stringValue: String, strategys: [FieldMapStrategy])
    {
        var resultKey = stringValue
        
        for strategy in strategys {
            switch strategy {
            case .custom(let mapper, _):
                if let matchKey = mapper.keys.first(where: {
                    mapper[$0]?.contains(stringValue) ?? false
                }) {
                    resultKey = matchKey
                }
            case .snakeCase:
                resultKey = resultKey.snakeToCamelCase()
            }
        }
        
        self.stringValue = resultKey
    }
}


fileprivate extension String {
    /// 将蛇形字段转换为首字母小写的驼峰字段
    func snakeToCamelCase() -> String {
        
        let separator: Character = "_"
        guard self.contains(separator) else { return self }
        
        let components = self.split(separator: separator)
        
        guard let first = components.first?.lowercased() else {
            return self
        }
        
        let capitalizedComponents = components
            .dropFirst()
            .map { $0.capitalized }
        
        return ([first] + capitalizedComponents).joined()
    }
}