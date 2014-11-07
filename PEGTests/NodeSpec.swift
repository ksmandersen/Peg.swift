import Foundation
import Nimble
import Quick

import Peg

class NodeSpec: QuickSpec {
    override func spec() {
        describe("Node") {
            it("sets source and range") {
                let source = "testString"
                let range = 0..<3
                let node = Node(source, range)
                expect(node.source).to(equal(source))
                expect(node.range).to(equal(range))
            }
            
            it("compares equality correctly") {
                let a = Node("Hello", 1..<2, children: [Node("test")])
                let b = Node("Hello", 1..<2, children: [Node("test")])
                let c = Node("Hello", 1..<3, children: [Node("test")])
                let d = Node("Helo", 1..<2, children: [Node("test")])
                let e = Node("Hello", 1..<2)
                
                expect(a).to(equal(b))
                expect(a).toNot(equal(c))
                expect(a).toNot(equal(d))
                expect(a).toNot(equal(e))
            }
            
            it("can represent its own text value without range") {
                expect(Node("aaa").text).to(equal("aaa"))
            }
            
            it("can represent its own text value with range") {
                expect(Node("...aaa", 3..<6).text).to(equal("aaa"))
            }
        }
    }
}