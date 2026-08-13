//
//  Functions+TextSearch.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var toTsvector: Self = .init("to_tsvector")
    @available(*, deprecated, renamed: "toTsvector")
    public static var to_tsvector: Self { .toTsvector }
    public static var toTsquery: Self = .init("to_tsquery")
    @available(*, deprecated, renamed: "toTsquery")
    public static var to_tsquery: Self { .toTsquery }
    public static var plaintoTsquery: Self = .init("plainto_tsquery")
    @available(*, deprecated, renamed: "plaintoTsquery")
    public static var plainto_tsquery: Self { .plaintoTsquery }
    public static var tsRankCd: Self = .init("ts_rank_cd")
    @available(*, deprecated, renamed: "tsRankCd")
    public static var ts_rank_cd: Self { .tsRankCd }
}

extension Fn {
    /// PostgreSQL provides the function to_tsvector for converting a document to the tsvector data type.
    /// to_tsvector([ config regconfig, ] document text) returns tsvector
    /// # Example
    /// ```swift
    /// Fn.toTsvector("english", "a fat  cat sat on a mat - it ate a fat rats")
    /// ```
    /// # Result
    /// ```
    /// 'ate':9 'cat':3 'fat':2,11 'mat':7 'rat':12 'sat':4
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func toTsvector(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.toTsvector, body: parts)
    }

    @available(*, deprecated, renamed: "toTsvector(_:_:)")
    public static func to_tsvector(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        toTsvector(config, text)
    }
    
    /// PostgreSQL provides to_tsquery function for converting a query to the tsquery data type.
    /// to_tsquery offers access to more features than plainto_tsquery, but is less forgiving about its input.
    /// to_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.toTsquery("english", "The & Fat & Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func toTsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.toTsquery, body: parts)
    }

    @available(*, deprecated, renamed: "toTsquery(_:_:)")
    public static func to_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        toTsquery(config, text)
    }
    
    /// `plainto_tsquery` transforms unformatted text querytext to tsquery
    /// plainto_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.plaintoTsquery("english", "The Fat Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func plaintoTsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.plaintoTsquery, body: parts)
    }

    @available(*, deprecated, renamed: "plaintoTsquery(_:_:)")
    public static func plainto_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        plaintoTsquery(config, text)
    }
    
    /// PostgreSQL provides two predefined ranking functions, which take into account lexical, proximity,
    /// and structural information; that is, they consider how often the query terms appear in the document,
    /// how close together the terms are in the document, and how important is the part of the document where they occur.
    
    /// `ts_rank_rd` calculates the rank of the provided tsquery
    /// ts_rank_rd(vector tsvector, query tsquery [, normalization integer ]) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.tsRankCd("rats", Fn.toTsquery("The Fat Rats"))
    /// ```
    /// # Result
    /// ```
    /// ts_rank_cd("rats", to_tsquery('The Fat Rats'))
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.6/textsearch-controls.html#TEXTSEARCH-RANKING)
    public static func tsRankCd(_ vector: SwifQLable, _ query: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = vector.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: query.parts)
        return build(.tsRankCd, body: parts)
    }

    @available(*, deprecated, renamed: "tsRankCd(_:_:)")
    public static func ts_rank_cd(_ vector: SwifQLable, _ query: SwifQLable) -> SwifQLable {
        tsRankCd(vector, query)
    }
}
