//
//  Functions+Time.swift
//  SwifQL
//

extension Fn {
    /// Emits the exact SQL `current_time` keyword.
    public static var currentTime: SwifQLable {
        SwifQLableParts(parts: Name.currentTime.part)
    }

    /// Emits the exact SQL `current_timestamp` keyword.
    public static var currentTimestamp: SwifQLable {
        SwifQLableParts(parts: Name.currentTimestamp.part)
    }
}
