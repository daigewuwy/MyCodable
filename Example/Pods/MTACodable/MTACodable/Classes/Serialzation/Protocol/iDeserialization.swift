//
//  iDeserialization.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

/// 反序列化协议
public protocol iDeserialization
{
    /// 转模型
    func toModel<T>(_ type: T.Type, decoder: JSONDecoder) -> T? where T: Decodable
}

extension iDeserialization
{
    public func toModel<T>(_ type: T.Type,
                           decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable
    {
        mta_jsonToModel(type,
                        value: self,
                        decoder: decoder)
    }
}

extension iDeserialization
{
    static var defaultInstance: Self? { nil }
}

// MARK: json 转模型
public func mta_jsonToModel<T>(_ type: T.Type,
                               value: Any?,
                               decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable
{
    /// 已经是 T 类型了，就不需要在转换一次了
    if let matchValue = value as? T
    {
        return matchValue
    }
    
    guard
        let value = value,
        let data = try? JSONSerialization.data(withJSONObject: value)
    else
    {
        assert(false, "请确认")
        return nil
    }
    
    return mta_jsonDataToModel(type, data, decoder: decoder)
}

// MARK: jsonData 转模型
public func mta_jsonDataToModel<T>(_ type: T.Type,
                                   _ data: Data,
                                   decoder: JSONDecoder = JSONDecoder()) -> T? where T : Decodable
{
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
    
    do
    {
        if let multipleFieldType = type as? iFieldMapper.Type
        {
            decoder.keyDecodingStrategy = multipleFieldType.multipleFieldDecodingStrategy
        } else {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        }
        
        return try decoder.decode(type, from: data)
    }
    catch
    {
        if let serialization = type as? iSerialization.Type,
           let defaultValue = serialization.defaultValue as? T
        {
            return defaultValue
        }
        
        let errorMsg = error.localizedDescription
        let tip = """
        
        
        ❌【温馨提示】看看 【errorMsg】 和 【error】 的描述，重点排查字段是否与下发字段类型不一致或者缺失。
        
        ⛔️【errorMsg】：\(errorMsg)
        
        ⛔️【error】：\(error)
        
        
        """
        
        debug_breakpoint(message: tip)
        
        return nil
    }
}

public extension KeyedDecodingContainer
{
    func decode<T: iDecodeProvider>(_ type: Decode<T>.Type,
                                    forKey key: Key) throws -> Decode<T>
    {
        let value = try decodeIfPresent(type, forKey: key)
        return value ?? .init(wrappedValue: T.defaultValue,
                              originValue: T.defaultValue)
    }
}
