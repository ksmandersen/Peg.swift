import Foundation

public protocol Matchable {
    func match(source: String, at start: Int) -> Node?
}

public class Node: Equatable, Printable {
    public let source: String
    public let range: Range<Int>
    public let children: [Node]
    
    public init(_ source: String, _ range: Range<Int>? = nil, children: [Node] = []) {
        self.source = source
        self.range = (range != nil) ? range! : 0..<source.length
        self.children = children
    }
    
    public convenience init(fromChildren nodes: [Node]) {
        assert(countElements(nodes) > 0)
        let startIndex = nodes.first!.range.startIndex
        let endIndex = nodes.last!.range.endIndex
        let range = startIndex..<endIndex
        
        self.init(nodes.first!.source, range, children: nodes)
    }
    
    public var text: String {
        return source[range]
    }
    
    public var description: String {
        return "Node(\(source), \(range), children: \(children))"
    }
}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.source == rhs.source && lhs.range == rhs.range && lhs.children == rhs.children
}

public class Literal: Matchable {
    public let literal: String
    
    public init(_ literal: String) {
        self.literal = literal
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        let range = start..<source.length
        if source[range].hasPrefix(literal) {
            return Node(source, start..<start+literal.length)
        }
        
        return nil
    }
}

public class Regex: Matchable {
    public let regex: String
    
    public init(_ regex: String) {
        self.regex = regex
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        let expr = NSRegularExpression(pattern: "^\(regex)")
        if let firstMatch = expr?.firstMatchInString(source, options: nil, range: NSMakeRange(start, source.length - start)) {
            
            let range = firstMatch.range
            if range.location != NSNotFound && range.length > 0 {
                let matchedRange = start..<start+firstMatch.range.length
                return Node(source, matchedRange)
            } else {
                return nil
            }
            
        }
        
        return nil
    }
}

public class Sequence: Matchable {
    public let matchables: [Matchable]
    
    public init(_ matchables: Matchable...) {
        self.matchables = matchables
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        var i = start
        var nodes = [Node]()
        for matchable in matchables {
            if let node = matchable.match(source, at: i) {
                nodes.append(node)
                i = node.range.endIndex
            } else {
                return nil
            }
        }
        
        return Node(fromChildren: nodes)
    }
}

public class Either: Matchable {
    public let matchables: [Matchable]
    
    public init(_ matchables: Matchable...) {
        self.matchables = matchables
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        for matchable in matchables {
            if let node = matchable.match(source, at: start) {
                return Node(source, node.range, children: [node])
            }
        }
        
        return nil
    }
}

public class Not: Matchable {
    public let matchable: Matchable
    
    public init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        return matchable.match(source, at: start) != nil ? nil : Node(source, start..<start)
    }
}

public class Lookahead: Matchable {
    public let matchable: Matchable
    
    public init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        return Not(Not(matchable)).match(source, at: start)
    }
}

public class OneOrMore: Matchable {
    public var range: Range<Int>  {
        return 1..<Int.max
    }
    
    public let matchable: Matchable
    
    public init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    public func match(source: String, at start: Int = 0) -> Node? {
        var i = start
        var nodes = [Node]()
        while true {
            if let node = matchable.match(source, at: i) {
                nodes.append(node)
                i = node.range.endIndex
                println(i)
            } else {
                break
            }
            
            if countElements(nodes) >= range.endIndex {
                break
            }
        }
        
        let nodeCount = countElements(nodes)
        let inRange = nodeCount >= range.startIndex && nodeCount <= range.endIndex
        if inRange {
            return Node(fromChildren: nodes)
        }
        
        return nil
    }
}


//public class ZeroOrMore: OneOrMore {
//    public override var range: Range<Int> {
//        return 0..<Int.max
//    }
//}



// Helpers

private extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    var length: Int {
        return countElements(self)
    }
}

extension NSRegularExpression {
    convenience init?(pattern: String, caseInsensitive: Bool = false) {
        var opts: NSRegularExpressionOptions = nil
        if caseInsensitive {
            opts = .CaseInsensitive
        }
        
        self.init(pattern: pattern, options: opts, error: nil)
    }
}