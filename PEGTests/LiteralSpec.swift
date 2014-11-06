import Foundation
import Nimble
import Quick

import Peg

class LiteralSpec: QuickSpec {
    override func spec(){
        let grammar = Literal("aaa")
        
        describe("Literal") {
            it("matches source with trailing characters") {
                let source = "aaa..."
                expect(grammar.match(source)).to(equal(Node(source, 0..<3)))
            }
            
            it("matches source with leading characters") {
                let source = "...aaa..."
                expect(grammar.match(source, at: 3)).to(equal(Node(source, 3..<6)))
            }
            
            it("does not match source without literal") {
                let source = "..."
                expect(grammar.match(source)).to(beNil())
            }
            
            it("matches matches source with multiple occurences") {
                let source = "aaaaaa"
                expect(grammar.match(source)).to(equal(Node(source, 0..<3)))
                expect(grammar.match(source, at: 1)).to(equal(Node(source, 1..<4)))
                expect(grammar.match(source, at: 3)).to(equal(Node(source, 3..<6)))
            }
        }
    }
}
