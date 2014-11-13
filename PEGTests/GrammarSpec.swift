import Foundation
import Nimble
import Quick

import Peg

class GrammarSpec: QuickSpec {
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
            
            
            
            
        }
    }
}