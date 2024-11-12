//
//  iSerialization.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/4.
//

import Foundation

/// 序列化
public protocol iSerialization
{
    /// 转 json 字符串
    var toJSONString: String? { get }
    
    /// 提供一次在解析失败时的默认值
    static var defaultValue: Self? { get }
}

public extension iSerialization
{
    var toJSONString: String?
    {
        /// options: .prettyPrinted 输出友好的 json 格式
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                         options: .prettyPrinted)
        else
        {
            assert(false, "解析 jsonData 失败，请确认")
            return nil
        }
        
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        return jsonString
    }
    
    
    static var defaultValue: Self? { nil }
}
