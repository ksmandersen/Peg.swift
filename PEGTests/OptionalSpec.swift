import Foundation
import Nimble
import Quick

import Peg

class OptionalSpec: QuickSpec {
    override func spec() {
        describe("Optional") {
            let grammar = Optional(Literal("a"))
            
            it("matches zero times") {
                let source = "."
                expect(grammar.match(source)).to(equal(Node(source, 0..<0)))
            }
            
            it("matches source with single occurence") {
                let source = "a"
                expect(grammar.match(source)).to(equal(Node(source, 0..<1, children: [Node(source, 0..<1)])))
            }
            
            it("matches one of source with two occurences ") {
                let source = "aa"
                expect(grammar.match(source)).to(equal(Node(source, 0..<1, children: [Node(source, 0..<1)])))
            }
        }
    }
}