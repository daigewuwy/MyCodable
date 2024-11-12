import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// 用于给类型的所有字段添加一个 @Decode<T> 的属性包装器，来使用项目中的 @Decode 包装器，T 为字段的类型
/// 字段可通过添加 @DecodeSkip 来跳过添加 @Decode<T> 包装器
public struct DecodeMembersMacro: MemberAttributeMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.AttributeSyntax] {
        
        guard let varDecl = member.as(VariableDeclSyntax.self) else { return [] }
        
        let attributes = varDecl.attributes.compactMap {
            $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name
        }
        
        /// 有标记跳过，则跳过
        let isSkip = attributes.filter {
            $0.text.lowercased().contains("ignore")
        }.count > 0
        
        guard !isSkip else { return [] }
        
        let type = varDecl.bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name ?? varDecl.bindings.first?.typeAnnotation?.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name
        
        guard let type else { return [] }
        
        return ["@Decode<\(type)>"]
    }
}

@main
struct DecodeMembersPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DecodeMembersMacro.self,
    ]
}
