//
//  Functions+TextSearch.swift
//  SwifQL
//
//  Created by Mihael Isaev on 22.05.2020.
//

extension Fn.Name {
    public static var to_tsvector: Self = .init("to_tsvector")
    public static var to_tsquery: Self = .init("to_tsquery")
    public static var plainto_tsquery: Self = .init("plainto_tsquery")
    public static var ts_rank_cd: Self = .init("ts_rank_cd")
}

extension Fn {
    /// PostgreSQL provides the function to_tsvector for converting a document to the tsvector data type.
    /// to_tsvector([ config regconfig, ] document text) returns tsvector
    /// # Example
    /// ```swift
    /// Fn.to_tsvector("english", "a fat  cat sat on a mat - it ate a fat rats")
    /// ```
    /// # Result
    /// ```
    /// 'ate':9 'cat':3 'fat':2,11 'mat':7 'rat':12 'sat':4
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func to_tsvector(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.to_tsvector, body: parts)
    }
    
    /// PostgreSQL provides to_tsquery function for converting a query to the tsquery data type.
    /// to_tsquery offers access to more features than plainto_tsquery, but is less forgiving about its input.
    /// to_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.to_tsquery("english", "The & Fat & Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func to_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.to_tsquery, body: parts)
    }
    
    /// `plainto_tsquery` transforms unformatted text querytext to tsquery
    /// plainto_tsquery([ config regconfig, ] querytext text) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.plainto_tsquery("english", "The Fat Rats")
    /// ```
    /// # Result
    /// ```
    /// 'fat' & 'rat'
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.1/textsearch-controls.html)
    public static func plainto_tsquery(_ config: SwifQLable, _ text: SwifQLable? = nil) -> SwifQLable {
        var parts: [SwifQLPart] = config.parts
        if let text = text {
            parts.append(o: .comma)
            parts.append(o: .space)
            parts.append(contentsOf: text.parts)
        }
        return build(.plainto_tsquery, body: parts)
    }
    
    /// PostgreSQL provides two predefined ranking functions, which take into account lexical, proximity,
    /// and structural information; that is, they consider how often the query terms appear in the document,
    /// how close together the terms are in the document, and how important is the part of the document where they occur.
    
    /// `ts_rank_rd` calculates the rank of the provided tsquery
    /// ts_rank_rd(vector tsvector, query tsquery [, normalization integer ]) returns tsquery
    /// # Example
    /// ```swift
    /// Fn.ts_rank_cd("rats", Fn.to_tsquery("The Fat Rats"))
    /// ```
    /// # Result
    /// ```
    /// ts_rank_cd("rats", to_tsquery('The Fat Rats'))
    /// ```
    /// [Learn more →](https://www.postgresql.org/docs/9.6/textsearch-controls.html#TEXTSEARCH-RANKING)
    public static func ts_rank_cd(_ vector: SwifQLable, _ query: SwifQLable) -> SwifQLable {
        var parts: [SwifQLPart] = vector.parts
        parts.append(o: .comma)
        parts.append(o: .space)
        parts.append(contentsOf: query.parts)
        return build(.ts_rank_cd, body: parts)
    }
}
