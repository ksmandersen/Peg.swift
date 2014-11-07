import Foundation
import Nimble
import Quick

import Peg

class EitherSpec: QuickSpec {
    override func spec() {
        describe("Either") {
            it("matches first valid regex") {
                let grammar = Either(Regex("a+"), Regex("b*"))
                let source = "aaabb"
                
                expect(grammar.match(source)).to(equal(Node(source, 0..<3, children: [Node(source, 0..<3)])))
            }
            
            it("matches second literal when first doesnt match") {
                let grammar = Either(Regex("a+"), Literal("b"))
                let source = "b..."
                
                expect(grammar.match(source)).to(equal(Node(source, 0..<1, children: [Node(source, 0..<1)])))
            }
            
            it("does not match anything with non-matching source") {
                let grammar = Either(Literal("aa"), Regex("b+"))
                let source = "..."
                
                expect(grammar.match(source)).to(beNil())
            }
        }
    }
}