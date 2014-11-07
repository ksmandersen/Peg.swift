import Foundation
import Nimble
import Quick

import Peg

class SequenceSpec: QuickSpec {
    override func spec() {
        describe("Sequence") {
            it("matches a sequence of regex with and literal") {
                let grammar = Sequence(Regex("a*"), Literal("bbb"))
                let source = "aaaaabbb..."
                expect(grammar.match(source)).to(equal(Node(source, 0..<8, children: [Node(source, 0..<5), Node(source, 5..<8)])))
            }
        }
    }
}