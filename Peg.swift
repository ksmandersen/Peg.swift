import Foundation

protocol Matchable {
    func match(source: String, at start: Int) -> Node?
}

class Node: Equatable, Printable {
    let name: String?
    let source: String
    let range: Range<Int>
    let children: [Node]
    
    init(_ source: String, _ range: Range<Int>? = nil, children: [Node] = [], name: String? = nil) {
        self.source = source
        self.range = (range != nil) ? range! : 0..<source.length
        self.children = children
        self.name = name
    }
    
    convenience init(fromChildren nodes: [Node]) {
        assert(countElements(nodes) > 0)
        let startIndex = nodes.first!.range.startIndex
        let endIndex = nodes.last!.range.endIndex
        let range = startIndex..<endIndex
        
        self.init(nodes.first!.source, range, children: nodes)
    }
    
    var text: String {
        return source[range]
    }
    
    var description: String {
        return "Node(\(source), \(range), name: \(name), children: \(children))"
    }
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.source == rhs.source &&
    lhs.range == rhs.range &&
    lhs.children == rhs.children &&
    lhs.name == rhs.name
}

class Literal: Matchable {
    let literal: String
    
    init(_ literal: String) {
        self.literal = literal
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        let range = start..<source.length
        if source[range].hasPrefix(literal) {
            return Node(source, start..<start+literal.length)
        }
        
        return nil
    }
}

class Regex: Matchable {
    let regex: String
    
    init(_ regex: String) {
        self.regex = regex
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
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

class Sequence: Matchable {
    let matchables: [Matchable]
    
    init(_ matchables: Matchable...) {
        self.matchables = matchables
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
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

class Either: Matchable {
    let matchables: [Matchable]
    
    init(_ matchables: Matchable...) {
        self.matchables = matchables
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        for matchable in matchables {
            if let node = matchable.match(source, at: start) {
                return Node(source, node.range, children: [node])
            }
        }
        
        return nil
    }
}

class Not: Matchable {
    let matchable: Matchable
    
    init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        return matchable.match(source, at: start) != nil ? nil : Node(source, start..<start)
    }
}

class Lookahead: Matchable {
    let matchable: Matchable
    
    init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        return Not(Not(matchable)).match(source, at: start)
    }
}

class OneOrMore: Matchable {
    var range: Range<Int>  {
        return 1..<Int.max
    }
    
    let matchable: Matchable
    
    init(_ matchable: Matchable) {
        self.matchable = matchable
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        var i = start
        var nodes = [Node]()
        while true {
            if let node = matchable.match(source, at: i) {
                nodes.append(node)
                i = node.range.endIndex
            } else {
                break
            }
            
            if countElements(nodes) == range.endIndex - 1 {
                break
            }
        }
        
        let nodeCount = countElements(nodes)
        let inRange = nodeCount >= range.startIndex && nodeCount < range.endIndex
        if inRange {
            if nodeCount == 0 {
                return Node(source, start..<start)
            }
            
            return Node(fromChildren: nodes)
        }
        
        return nil
    }
}


class ZeroOrMore: OneOrMore {
    override var range: Range<Int> {
        return 0..<Int.max
    }
}

class Optional: OneOrMore {
    override var range: Range<Int> {
        return 0..<2
    }
}

class Reference: Matchable {
    let name: String
    let mappings: BoxedDictionary<String, Matchable>
    
    var matchable: Matchable {
        return mappings[name]!
    }
    
    init(_ name: String, _ mappings: BoxedDictionary<String, Matchable>) {
        self.name = name
        self.mappings = mappings
    }
    
    func match(source: String, at start: Int = 0) -> Node? {
        if let node = matchable.match(source, at: start) {
            return Node(source, node.range, children: [node], name: name)
        }
        
        return nil
    }
}


typealias Action = (Node, [Matchable]) -> [Matchable]
typealias ActionCollection = BoxedDictionary<String, Action>
typealias RuleCollection = BoxedDictionary<String, Matchable>


//[String: Matchable]

public class PEGGrammar {
    var rules = RuleCollection()
    var actions = ActionCollection()
    
    public init() {
        makeGrammar()
    }
    
//    func eval(name: String, source: String) -> Matchable? {
//        if let node = ref(name).match(source) {
//            
//        }
//        
//        return nil
//    }
    
    func eval(node: Node) -> Matchable {
        if let action = actions[node.name!] {
            return action(node, node.children.map(eval))
        } else {
            return { node, matchables in
                
            }(node, node.children.map(eval))
        }
    }
    
    private func makeGrammar() {
//      dot <- '.' spacing
        rule("dot", Sequence(".", ref("spacing"))) { _, _ in
            return Regex(".")
        }
        
//      and <- "&" spacing
        rule("and", Sequence("&", ref("space")))
        
//      not        <- "!" spacing
        rule("not", Sequence("!", ref("space")))
        
//      slash      <- "/" spacing
        rule("slash", Sequence("/", ref("space")))
        
//      left_arrow <- "<-" spacing
        rule("left_arrow", Sequence("<-", ref("space")))
        
//      question   <- "?" spacing
        rule("question", Sequence("?", ref("space")))
        
//      star       <- "*" spacing
        rule("star", Sequence("*", ref("space")))
        
//      plus       <- "+" spacing
        rule("plus", Sequence("+", ref("space")))
        
//      open       <- "(" spacing
        rule("open", Sequence("(", ref("space")))
        
//      close      <- ")" spacing
        rule("close", Sequence(")", ref("space")))
        
//      spacing <- (space / comment)*
        rule("spacing", ZeroOrMore(Either(ref("space"), ref("comment"))))
        
//      comment <- '#' (!end_of_line .)* end_of_line
//      TODO: WTF? comment doesn't match implementation
        rule("comment", Sequence("#",
                                 ZeroOrMore(Sequence(Not(ref("end_of_line")),
                                                     Regex(".")))))
        
//      space <- " " / "\t" / end_of_line
        rule("space", Either(" ", "\t", ref("end_of_line")))
        
//      end_of_line <- "\r\n" / "\n" / "\r"
        rule("end_of_line", Either("\r\n", "\n", "\r"))
    }
    
    private func ref(name: String) -> Reference {
        return Reference(name, rules)
    }
    
    private func rule(name: String, _ matchable: Matchable, _ action: Action? = nil) {
        rules[name] = matchable
        if let action = action {
            actions[name] = action
        }
    }
}

 extension String: Matchable {
    func match(source: String, at start: Int) -> Node? {
        return Literal(self).match(source, at: start)
    }
}


public class BoxedDictionary<K: Hashable, V>: Printable {
    var dict: [K: V]
    
    public init(){
        dict = [K: V]()
    }
    
    public init(dictionary: [K: V]) {
        dict = dictionary
    }
    
    public subscript (key: K) -> V? {
        get { return dict[key] }
        set(newValue) { dict[key] = newValue }
    }
    
    public var description: String {
        return dict.description
    }
}

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