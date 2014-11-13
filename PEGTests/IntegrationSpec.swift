import Foundation
import Nimble
import Quick

import Peg

class IntegrationSpec: QuickSpec {
    override func spec() {
        describe("Grammar") {
//          value  <- number / expr
//          number <- [0-9]+
//          expr   <- "(" sum ")"
//          prod   <- value ("*" value)*
//          sum    <- prod ("+" prod)*
            
            var mappings = BoxedDictionary<String, Matchable>()
            mappings["value"] = Either(Reference("number", mappings), Reference("expr", mappings))
            mappings["number"] = OneOrMore(Regex("[0-9]"))
            mappings["expr"] = Sequence(Literal("("), Reference("sum", mappings), Literal(")"))
            mappings["prod"] = Sequence(Reference("value", mappings),
                                        ZeroOrMore(Sequence(Literal("*"),
                                                   Reference("value", mappings))))
            mappings["sum"] = Sequence(Reference("prod", mappings),
                                       ZeroOrMore(Sequence(Literal("+"),
                                                  Reference("sum", mappings))))
            let grammar = Reference("value", mappings)
            
            it("parses (1)") {
                
            let s = "(1)"
            let expected =
                Node(s, 0..<3, name: "value", children:
                    [Node(s, 0..<3, children:
                        [Node(s, 0..<3, name: "expr", children:
                            [Node(s, 0..<3, children:
                                [Node(s, 0..<1, children: []),
                                 Node(s, 1..<2, name: "sum", children:
                                    [Node(s, 1..<2, children:
                                        [Node(s, 1..<2, name: "prod", children:
                                            [Node(s, 1..<2, children:
                                                [Node(s, 1..<2, name: "value", children:
                                                    [Node(s, 1..<2, children:
                                                        [Node(s, 1..<2, name: "number", children:
                                                            [Node(s, 1..<2, children:
                                                                [Node(s, 1..<2, children: [])
                                                            ])
                                                        ])
                                                    ])
                                                ]),
                                                Node(s, 2..<2, children: [])
                                            ])
                                        ]),
                                        Node(s, 2..<2, children: [])
                                    ])
                                ]),
                                Node(s, 2..<3, children: [])
                            ])
                        ])
                    ])
                ])
                
                expect(grammar.match(s, at: 0)).to(equal(expected))
            }
        }
    }
}