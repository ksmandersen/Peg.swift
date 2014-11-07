import Foundation
import Nimble
import Quick

import Peg

class LookaheadSpec: QuickSpec {
    override func spec() {
        describe("Lookahead") {
            let grammar = Lookahead(Literal("a"))
            
            it("matches source with occurence of lookahead without consuming") {
                let source = "a"
                expect(grammar.match(source)).to(equal(Node(source, 0..<0)))
            }
            
            it("does not match source without occurence of lookahead") {
                let source = "b"
                expect(grammar.match(source)).to(beNil())
            }
        }
    }
}