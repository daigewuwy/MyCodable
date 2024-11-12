//
//  ViewController.swift
//  MTACodable
//
//  Created by 吴伟毅 on 11/12/2024.
//  Copyright (c) 2024 吴伟毅. All rights reserved.
//

import UIKit

import MTACodable

@DecodeMembers
struct User: Codable, iFieldMapper {
    
    static var mapStrategys: [FieldMapStrategy] {
        [
            /// 蛇形
            .snakeCase,
            /// 直接字段映射
            .map(mapper: [
                "grade": ["++grade++"]
            ], nestedMapper: nil),
            /// 手动映射
            .transform(transformer: { key in
                key.contains("age") ? "age" : key
            })
        ]
    }
    
    /// 1、测试蛇形字段解析
    /// 2、测试 Int 转 String
    var nameValue: String

    /// 1、测试直接映射字段
    /// 2、测试 String 转 Bool
    var grade: Bool
    
    /// 1、测试手动映射字段
    /// 2、测试通过 IgnoreOptional 忽略解析
    /// 也可使用 @Ignore 这个非可选版本，会自动设置默认值
    @IgnoreOptional
    var age: Int?
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userJSON: [String: Any] = [
            "name_value": 123,
            "++grade++": "yes",
            ">>>>age<<<": "18",
        ]
        
        let user = userJSON.toModel(User.self)
        print("")
    }
}

