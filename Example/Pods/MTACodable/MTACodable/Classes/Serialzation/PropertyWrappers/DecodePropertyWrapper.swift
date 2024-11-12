//
//  NewDecodePropertyWrappers.swift
//  ActionKit
//
//  Created by 吴伟毅 on 2024/11/6.
//

import Foundation

enum DecodeError: Error {
    case failed
}

// MARK: - 解析协议
public protocol iDecodeProvider: Codable {
    
    associatedtype OriginValueType = Self
    
    static var defaultValue: Self { get }
    static func decode(from source: Any) throws -> Self
}

// MARK: - 转 Int
/// 将能够转为 Int 的数据转成 Int，如 "1" -> 1、true -> 1、"1.0001" -> 1
extension Int: iDecodeProvider {
    
    public static var defaultValue: Int {
        0
    }
    
    public static func decode(from source: Any) throws -> Int {
        
        if let str = source as? String {
            if let value = Int(str) { return value }
            throw DecodeError.failed
        } else if let int = source as? Int {
            return int
        } else if let int16 = source as? Int16 {
            return Int(int16)
        } else if let int32 = source as? Int32 {
            return Int(int32)
        } else if let int64 = source as? Int64 {
            return Int(int64)
        } else if let bool = source as? Bool {
            return bool ? 1 : 0
        } else if let double = source as? Double {
            return Int(double)
        } else if let float = source as? Float {
            return Int(float)
        }  else if let float = source as? CGFloat {
            return Int(float)
        } else {
            throw DecodeError.failed
        }
    }
}

// MARK: - 转 Int64
/// 将能够转为 Int64 的数据转成 Int64，如 "1" -> 1、true -> 1、"1.0001" -> 1
extension Int64: iDecodeProvider {
    
    public static var defaultValue: Int64 {
        0
    }
    
    public static func decode(from source: Any) throws -> Int64 {
        
        if let str = source as? String {
            if let value = Int64(str) { return value }
            throw DecodeError.failed
        } else if let int = source as? Int {
            return Int64(int)
        } else if let int16 = source as? Int16 {
            return Int64(int16)
        } else if let int32 = source as? Int32 {
            return Int64(int32)
        } else if let int64 = source as? Int64 {
            return int64
        } else if let bool = source as? Bool {
            return bool ? 1 : 0
        } else if let double = source as? Double {
            return Int64(double)
        } else if let float = source as? Float {
            return Int64(float)
        } else if let float = source as? CGFloat {
            return Int64(float)
        } else if let str = source as? String {
            return Int64(str) ?? 0
        } else {
            throw DecodeError.failed
        }
    }
}

// MARK: - 转 Bool
/// 将能够转为 Bool 的数据转成 Bool，如 "1"、"yes"、"true"、"y"、"t" -> true，"1" -> true
extension Bool: iDecodeProvider {
    
    public static var defaultValue: Bool {
        false
    }
    
    public static func decode(from source: Any) throws -> Bool {
       
        if let str = source as? String {
            return [
                "yes",
                "true",
                "y",
                "t",
                "1"
            ].contains(str.lowercased())
        } else if let int = source as? Int {
            return int > 0
        } else if let int16 = source as? Int16 {
            return int16 > 0
        } else if let int32 = source as? Int32 {
            return int32 > 0
        } else if let int64 = source as? Int64 {
            return int64 > 0
        } else if let bool = source as? Bool {
            return bool
        } else if let double = source as? Double {
            return double > 0
        } else if let float = source as? Float {
            return float > 0
        } else if let float = source as? CGFloat {
            return float > 0
        } else {
            throw DecodeError.failed
        }
    }
}

// MARK: - 转 String
/// 将能够转为 String 的数据转成 String
extension String: iDecodeProvider {
    
    public static var defaultValue: String { "" }
    
    public static func decode(from source: Any) throws -> String {
        
        if let stringValue = source as? String {
            return stringValue
        } else if let representation = source as? CustomStringConvertible {
            return "\(representation.description)"
        } else {
            throw DecodeError.failed
        }
    }
}

// MARK: - 转 CGFloat
/// 将能够转为 Int 的数据转成 Int，如 "1" -> 1、true -> 1、"1.0001" -> 1
extension CGFloat: iDecodeProvider {
    
    public static var defaultValue: CGFloat {
        0
    }
    
    public static func decode(from source: Any) throws -> CGFloat {
        
        if let str = source as? String {
            /// 精度缺失问题，只保留到后 5 拉
            let value = CGFloat(Float(str) ?? 0)
            let multiplier = pow(10, CGFloat(5))
            return (value * multiplier).rounded() / multiplier
        } else if let int = source as? Int {
            return CGFloat(int)
        } else if let int16 = source as? Int16 {
            return CGFloat(int16)
        } else if let int32 = source as? Int32 {
            return CGFloat(int32)
        } else if let int64 = source as? Int64 {
            return CGFloat(int64)
        } else if let bool = source as? Bool {
            return CGFloat(bool ? 1 : 0)
        } else if let double = source as? Double {
            return CGFloat(double)
        } else if let float = source as? Float {
            return CGFloat(float)
        } else if let float = source as? CGFloat {
            return CGFloat(float)
        } else {
            throw DecodeError.failed
        }
    }
}

// MARK: - 转 Double
/// 将能够转为 Int 的数据转成 Int，如 "1" -> 1、true -> 1、"1.0001" -> 1
extension Double: iDecodeProvider {
    
    public static var defaultValue: Double {
        0
    }
    
    public static func decode(from source: Any) throws -> Double {
        
        if let str = source as? String {
            /// 精度缺失问题，只保留到后 5 拉
            let value = Double(Float(str) ?? 0)
            let multiplier = pow(10, CGFloat(5))
            return (value * multiplier).rounded() / multiplier
        } else if let int = source as? Int {
            return Double(int)
        } else if let int16 = source as? Int16 {
            return Double(int16)
        } else if let int32 = source as? Int32 {
            return Double(int32)
        } else if let int64 = source as? Int64 {
            return Double(int64)
        } else if let bool = source as? Bool {
            return Double(bool ? 1 : 0)
        } else if let double = source as? Double {
            return Double(double)
        } else if let float = source as? Float {
            return Double(float)
        }  else if let float = source as? CGFloat {
            return Double(float)
        } else {
            throw DecodeError.failed
        }
    }
}


// MARK: - 转 Array
/// 将能够转为 Array 的数据转成 Array，也支持将通过 "," 分割的字符串直接转 stringList，如 "1,2,3" 转 ["1", "2", "3"]
extension Array: iDecodeProvider where Element: iDecodeProvider {
    
    public static var defaultValue: Array<Element> { [] }
    
    public static func decode(from source: Any) throws -> Array<Element> {
        
        if let str = source as? String,
           str.contains(",") {
            
            let strList = str.split(separator: ",").map(String.init)
            
            guard let strList = strList as? [Element]
            else {
                throw DecodeError.failed
            }
            
            return strList
        }
        
        guard let array = source as? [Element] else {
            throw DecodeError.failed
        }
        
        return array
    }
}

// MARK: - 转 Enum
/// 使用原值当作 Enum 的 rawValue 生成 Enum
public protocol iDecodeEnum { static var unknown: Self { get } }
public typealias DecodableEnum = iDecodeEnum & iDecodeProvider

extension iDecodeProvider where Self: iDecodeEnum {
    public static var defaultValue: Self { .unknown }
}

extension RawRepresentable where RawValue: iDecodeProvider,
                                 Self: iDecodeEnum {
    
    typealias OriginValueType = RawValue
    
    public static func decode(from source: Any) throws -> Self {
        
        guard let source = source as? RawValue
        else {
            throw DecodeError.failed
        }
        
        guard let value = Self.init(rawValue: source)
        else {
            return .unknown
        }
        
        return value
    }
}

// MARK: - Decode

@propertyWrapper
public struct Decode<T: iDecodeProvider>
{
    /// 目标值
    public var wrappedValue: T
    
    /// 原始值
    /// Q：为什么原始值类型用 Any 修饰？
    /// A：因为目标值可能可以由多种原始值解析得到，如目标类型是 Bool，可以由 “1”、1、“yes”、true 等多种原始值解析得到，所以泛型不了。如果想泛型，就要将 Decode 这个统一的属性包装器拆分成多个泛型化的属性包装器，如 DecodeBool 这种，得不偿失。
    public var originValue: Any
    
    public init(wrappedValue: T,
                originValue: Any) {
        self.wrappedValue = wrappedValue
        self.originValue = originValue
    }
    
    
    public var projectedValue: Any { originValue }
}

extension Decode: Codable {
    
    public init(from decoder: any Decoder) throws {
        
        do {
            let container = try decoder.singleValueContainer()
            
            /// Q：为什么要显式一个个的解析？
            /// A：因为外部使用中 T 与 原始值可能并非相同类型，所以要显式解析，不然直接用 try? container.decode(T.self) 是可以的
            if let source = try? container.decode(String.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Int.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Int16.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Int32.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Int64.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(CGFloat.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Double.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Float.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(Bool.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else if let source = try? container.decode(T.self) {
                originValue = source
                wrappedValue = try T.decode(from: source)
            } else {
                originValue = T.defaultValue
                wrappedValue = T.defaultValue
            }
        }
        catch {
            let errorMsg = error.localizedDescription
            let tip = """
                    
                    
                    ❌【温馨提示】看看 【errorMsg】 和 【error】 的描述，重点排查字段是否与下发字段类型不一致或者缺失。
                    
                    ⛔️【errorMsg】：\(errorMsg)
                    
                    ⛔️【error】：\(error)
                    
                    
                    """
            
            debug_breakpoint(message: tip)
            
#if DEBUG
            print(tip)
#endif
            
            wrappedValue = T.defaultValue
            originValue = T.defaultValue
        }
    }
    
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}



// MARK: ======== 测试用例 ========

//struct Model: Codable, iFieldMapper
//{
//    /// Int
//    @Decode<Int>
//    var intFromStr: Int
//    
//    @Decode<Int>
//    var intFromInt: Int
//    
//    @Decode<Int>
//    var intFromBool: Int
//    
//    @Decode<Int>
//    var intFromFloat: Int
//    
//    /// Bool
//    @Decode<Bool>
//    var boolFromStr: Bool
//    
//    @Decode<Bool>
//    var boolFromInt: Bool
//    
//    @Decode<Bool>
//    var boolFromBool: Bool
//    
//    @Decode<Bool>
//    var boolFromFloat: Bool
//    
//    /// String
//    @Decode<String>
//    var strFromStr: String
//    
//    @Decode<String>
//    var strFromInt: String
//    
//    @Decode<String>
//    var strFromBool: String
//    
//    @Decode<String>
//    var strFromFloat: String
//    
//    /// float
//    @Decode<CGFloat>
//    var floatFromStr: CGFloat
//    
//    @Decode<CGFloat>
//    var floatFromInt: CGFloat
//    
//    @Decode<CGFloat>
//    var floatFromFloat: CGFloat
//    
//    /// Double
//    @Decode<Double>
//    var doubleFromStr: Double
//    
//    @Decode<Double>
//    var doubleFromInt: Double
//    
//    @Decode<Double>
//    var doubleFromFloat: Double
//    
//    /// Array
//    @Decode<Array>
//    var strArray: [String]
//    
//    @Decode<Array>
//    var intArray: [Int]
//    
//    @Decode<Array>
//    var doubleArray: [Double]
//    
//    @Decode<Array>
//    var strSplitArray: [String]
//    
//    /// Enum
//    enum TestEnum: String, DecodableEnum {
//        case unknown
//        case value1
//        case value2
//    }
//    
//    @Decode<TestEnum>
//    var strEnum: TestEnum
//    
//    
//    /// 字段映射
//    @Decode<Int>
//    var fieldMapperValue: Int
//    
//    static var mapStrategys: [FieldMapStrategy] {
//        [
//            .snakeCase,
//            .custom(mapper: [
//                /// 将下发的 _fieldMapperValue_ 的值映射到字段 fieldMapperValue
//                "fieldMapperValue": ["_fieldMapperValue_"]
//            ], nestedMapper: [
//                "nestedModel": NestedModel.self
//            ])
//        ]
//    }
//    
//    /// 嵌套
//    struct NestedModel: Codable, iFieldMapper {
//        
//        @Decode<Int>
//        var intValue: Int
//        
//        
//        static var mapStrategys: [FieldMapStrategy] {
//            [
//                .custom(mapper: [
//                    "intValue": ["___intValue___"]
//                ], nestedMapper: NestedFieldMapper())
//            ]
//        }
//    }
//    
//    var nestedModel: NestedModel
//}
//
//let json: [String : Any] = [
//    
//    /// int
//    "int_from_str": "1",
//    "int_from_int": 1,
//    "int_from_bool": true,
//    "int_from_float": 1.1,
//        
//    /// bool
//    "bool_from_str": "yes",
//    "bool_from_int": 1,
//    "bool_from_bool": true,
//    "bool_from_float": 1.1,
//        
//    /// String
//    "str_from_str": "yes",
//    "str_from_int": 1,
//    "str_from_bool": true,
//    "str_from_float": 1.1,
//        
//    /// float
//    "float_from_str": "1.1",
//    "float_from_int": 1,
//    "float_from_float": 1.1,
//        
//    /// Double
//    "double_from_str": "1.1",
//    "double_from_int": 1,
//    "double_from_float": 1.1,
//    
//    /// Array
//    "int_array": [1, 2, 3],
//    "str_array": ["1", "2", "3"],
//    "double_array": [1.1, 2.2, 3.3],
//    "str_split_array": "1,2,3",
//    
//    /// enum
//    "str_enum": "value2",
//    
//    /// nested
//    "nestedModel": [
//        "___intValue___": "1"
//    ]
//]
//
//let model = json.toModel(Model.self)
//
///// 转换成功
//assert(model != nil)
//
///// int
//assert(model?.intFromStr == 1)
//assert(model?.intFromInt == 1)
//assert(model?.intFromBool == 1)
//assert(model?.intFromFloat == 1)
//
///// bool
//assert(model?.boolFromInt == true)
//assert(model?.boolFromBool == true)
//assert(model?.boolFromFloat == true)
//assert(model?.boolFromStr == true)
//
///// string
//assert(model?.strFromInt == "1")
//assert(model?.strFromStr == "yes")
//assert(model?.strFromBool == "true")
//assert(model?.strFromFloat == "1.1")
//
///// float
//assert(model?.floatFromInt == 1.0)
//assert(model?.floatFromStr == 1.1)
//assert(model?.floatFromFloat == 1.1)
//
///// double
//assert(model?.doubleFromInt == 1.0)
//assert(model?.doubleFromStr == 1.1)
//assert(model?.doubleFromFloat == 1.1)
//
///// array
//assert(model?.intArray == [1, 2, 3])
//assert(model?.strArray == ["1", "2", "3"])
//assert(model?.doubleArray == [1.1, 2.2, 3.3])
//assert(model?.strSplitArray == ["1", "2", "3"])
//
///// enum
//assert(model?.strEnum == .value2)
//assert((model?.$strEnum as? String) == "value2")
//
///// nested
//assert(model?.nestedModel.intValue == 1)
//
///// to json
//let toJson = model?.toJSON
//let recoveryModel = toJson?.toModel(Model.self)
//assert(recoveryModel != nil && recoveryModel?.nestedModel.intValue == 1)
//
//print("通过用例")
