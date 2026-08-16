//
//  Functions+Base64.swift
//  SwifQL
//

extension Fn {
    private static var fromBase64FunctionName: SwifQLHybridOperator {
        SwifQLHybridOperator(
            SwifQLPartOperator("from_base64"),
            SwifQLPartOperator("FROM_BASE64"),
            SwifQLPartOperator("from_base64")
        )
    }

    public static func fromBase64(_ value: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = [fromBase64FunctionName]
        parts.append(o: .openBracket)
        parts.append(contentsOf: value.parts)
        parts.append(o: .closeBracket)
        return SwifQLableParts(parts: parts)
    }
}
