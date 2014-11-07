import Foundation
import Nimble
import Quick

import Peg

class OneOrMoreSpec: QuickSpec {
    override func spec() {
        describe("OneOrMore") {
            let grammar = OneOrMore(Literal("a"))
            
            it("does not match source without occurence") {
                let source = "."
                expect(grammar.match(source)).to(beNil())
            }
            
            it("matches source with single occurence") {
                let source = "a"
                expect(grammar.match(source)).to(equal(Node(source, 0..<1, children: [Node(source, 0..<1)])))
            }
            
            it("matches source with multiple occurences") {
                let source = "aaa."
                expect(grammar.match(source)).to(equal(Node(source, 0..<3, children: [Node(source, 0..<1), Node(source, 1..<2), Node(source, 2..<3)])))
            }
        }
    }
}