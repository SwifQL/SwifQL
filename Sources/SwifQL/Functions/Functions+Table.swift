//
//  Functions+Table.swift
//  SwifQL
//

extension Fn.Name {
    public static let readCSV = Self("read_csv")
    public static let readParquet = Self("read_parquet")
    public static let readJSON = Self("read_json")
    public static let glob = Self("glob")
}

private func appendTableFunctionOptions(
    _ options: [TableFunctionOption],
    to parts: inout [SwifQLPart]
) {
    guard !options.isEmpty else { return }

    parts.append(o: .comma, .space)
    for (index, option) in options.enumerated() {
        if index > 0 {
            parts.append(o: .comma, .space)
        }
        parts.append(contentsOf: option.parts)
    }
}

extension Fn {
    public static func readCSV(
        _ path: SwifQLable,
        options: TableFunctionOption...
    ) -> SwifQLable {
        readCSV(path, options: options)
    }

    public static func readCSV(
        _ path: SwifQLable,
        options: [TableFunctionOption]
    ) -> SwifQLable {
        var parts = path.parts
        appendTableFunctionOptions(options, to: &parts)
        return build(.readCSV, body: parts)
    }

    public static func readParquet(
        _ path: SwifQLable,
        options: TableFunctionOption...
    ) -> SwifQLable {
        readParquet(path, options: options)
    }

    public static func readParquet(
        _ path: SwifQLable,
        options: [TableFunctionOption]
    ) -> SwifQLable {
        var parts = path.parts
        appendTableFunctionOptions(options, to: &parts)
        return build(.readParquet, body: parts)
    }

    public static func readJSON(
        _ path: SwifQLable,
        options: TableFunctionOption...
    ) -> SwifQLable {
        readJSON(path, options: options)
    }

    public static func readJSON(
        _ path: SwifQLable,
        options: [TableFunctionOption]
    ) -> SwifQLable {
        var parts = path.parts
        appendTableFunctionOptions(options, to: &parts)
        return build(.readJSON, body: parts)
    }

    public static func glob(_ pattern: SwifQLable) -> SwifQLable {
        build(.glob, body: pattern.parts)
    }
}
