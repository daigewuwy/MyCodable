//
//  iSerializable.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

// MARK: 组合协议
public typealias iSerializable = iSerialization & iDeserialization

// MARK: Dictionary -> [String: Any]
extension Dictionary: iSerializable where Key == String, Value == Any { }

// MARK: Array
extension Array: iSerializable { }

// MARK: NSArray
extension NSArray: iSerializable { }

// MARK: NSDictionary
extension NSDictionary: iSerializable { }

// MARK: Int
extension Int: iSerializable
{
    public var toJSONString: String? { "\(self)" }
}

// MARK: Bool
extension Bool: iSerializable
{
    public var toJSONString: String? { "\(self)" }
}

// MARK: Data
extension Data: iSerializable
{
    public var toJSONString: String?
    {
        toJSON?.toJSONString
    }
    
    public func toModel<T>(_ type: T.Type) -> T? where T: Decodable
    {
        mta_jsonDataToModel(type, self)
    }
}

// MARK: String
extension String
{
    public func toJSONObject<T>(_ type: T.Type) -> T?
    {
        guard let data = data(using: .utf8)
        else
        {
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data,
                                                           options: .mutableContainers)
        else
        {
            return nil
        }
        
        return json as? T
    }
}

extension String: iDeserialization
{
    public func toModel<T: Decodable>(_ type: T.Type,
                                      decoder: JSONDecoder = JSONDecoder()) -> T?
    {
        if let json = toJSONArray
        {
            return json.toModel(type, decoder: decoder)
        }
        
        guard let json = toJSON
        else
        {
            debug_breakpoint(message:  "转换成 jsonObject 失败，请确认")
            return nil
        }
        
        return json.toModel(type, decoder: decoder)
    }
}

// MARK: - Encodable
public extension Encodable
{
    var toJSONString: String?
    {
        toJSONString()
    }
    
    var toJSON: Dictionary<String, Any>?
    {
        toJSON()
    }
    
    var toJSONArray: [Dictionary<String, Any>]?
    {
        toJSONString?.toJSONObject([Dictionary<String, Any>].self)
    }
    
    func toJSONString(encoder: JSONEncoder = JSONEncoder()) -> String?
    {
        if let jsonString =  self as? String
        {
            return jsonString
        }
        
        do
        {
            let jsonData = try encoder.encode(self)
            return String(decoding: jsonData, as: UTF8.self)
        }
        catch
        {
            let errorMsg = error.localizedDescription
            let tip = """

            
            ❌【温馨提示】看看 【errorMsg】 和 【error】 的描述，重点排查字段是否与下发字段类型不一致或者缺失。
            
            ⛔️【errorMsg】：\(errorMsg)
            
            ⛔️【error】：\(error)
            
            
            """

            assert(false, tip)
            
            return nil
        }
    }
    
    func toJSON(encoder: JSONEncoder = JSONEncoder()) -> Dictionary<String, Any>?
    {
        guard let jsonString = toJSONString(encoder: encoder)
        else
        {
            assert(false, "转换成 jsonString 失败，请确认")
            return nil
        }
        
        return jsonString.toJSONObject(Dictionary<String, Any>.self)
    }
}
