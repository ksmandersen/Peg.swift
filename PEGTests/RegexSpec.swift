import Foundation
import Nimble
import Quick

import Peg

class RegexSpec: QuickSpec {
    override func spec(){
        let grammar = Regex("a*")
        
        describe("Regex") {
            it("matches at beginning of source") {
                let source = "aaa..."
                expect(grammar.match(source)).to(equal(Node(source, 0..<3)))
            }
            
            it("does not match source without expression") {
                let source = "bbbb"
                expect(grammar.match(source)).to(beNil())
            }
            
            it("matches from the middle of the source") {
                let source = "...aaa..."
                expect(grammar.match(source, at: 3)).to(equal(Node(source, 3..<6)))
            }
        }
    }
}
