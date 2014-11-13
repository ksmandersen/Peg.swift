import Foundation
import Nimble
import Quick

import Peg

class ReferenceSpec: QuickSpec {
    override func spec() {
        describe("Reference") {
            let mappings =  BoxedDictionary<String, Matchable>(dictionary: ["rule": Literal("a")])
            let grammar = Reference("rule", mappings)
            
            it("matches the underlying literal") {
                let source = "a"
                let expected = Node(source, 0..<1, name: "rule", children: [Node(source, 0..<1)])
                expect(grammar.match(source)).to(equal(expected))
            }
            
            it("matches the underlying literal") {
                let source = "b"
                expect(grammar.match(source)).to(beNil())
            }
        }
    }
}