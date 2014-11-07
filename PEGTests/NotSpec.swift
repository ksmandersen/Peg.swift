import Foundation
import Nimble
import Quick

import Peg

class NotSpec: QuickSpec {
    override func spec() {
        describe("Not") {
            let grammar = Not(Regex("."))
            
            it("matches empty source") {
                let source = ""
                expect(grammar.match(source)).to(equal(Node(source, 0..<0)))
            }
            
            it("does not match source with occurence") {
                let source = "aaa"
                expect(grammar.match(source)).to(beNil())
            }
        }
    }
}