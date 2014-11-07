//
//  PEGTests.swift
//  Docopt
//
//  Created by Kristian Andersen on 05/11/14.
//  Copyright (c) 2014 docopt. All rights reserved.
//

import XCTest

import Peg

//class NotTests: XCTestCase {
//    func testNotDoesntMatchEmptyString() {
//        let grammar = Not(Regex("."))
//        
//        let s = ""
//        eq(grammar.match(s), Node(s, 0..<0))
//    }
//    
//    func testNotDoesnMatch() {
//        let grammar = Not(Regex("."))
//        
//        let s = "aa"
//        XCTAssertNil(grammar.match(s))
//    }
//}
//
//class LokaheadTests: XCTestCase {
//    func testLookaheadDoesntMatchEmptyString() {
//        let grammar = Lookahead(Literal("a"))
//        
//        let s = "a"
//        eq(grammar.match(s), Node(s, 0..<0))
//    }
//    
//    func testNotDoesnMatch() {
//        let grammar = Lookahead(Literal("a"))
//        
//        let s = "b"
//        XCTAssertNil(grammar.match(s))
//    }
//}
//
//class OneOrMoreTests: XCTestCase {
//    func testDoesntMatch() {
//        let grammar = OneOrMore(Literal("a"))
//        
//        XCTAssertNil(grammar.match("."))
//    }
//    
//    func testMatchesSingleChild() {
//        let grammar = OneOrMore(Literal("a"))
//        
//        let s = "a."
//        eq(grammar.match(s), Node(s, 0..<1, children: [Node(s, 0..<1)]))
//    }
//    
//    func testMatchesMultiple() {
//        let grammar = OneOrMore(Literal("a"))
//        
//        let s = "aaa."
//        eq(grammar.match(s), Node(s, 0..<3, children: [Node(s, 0..<1), Node(s, 1..<2), Node(s, 2..<3)]))
//    }
//}
//
////class ZeroOrMoreTests: XCTestCase {
////    func testDoesntMatch() {
////        let grammar = ZeroOrMore(Literal("a"))
////
////        eq(grammar.match("."), Node(""))
////    }
////
////    func testMatchesSingleChild() {
////        let grammar = ZeroOrMore(Literal("a"))
////
////        let s = "a."
////        eq(grammar.match(s), Node(s, 0..<1, children: [Node(s, 0..<1)]))
////    }
////
////    func testMatchesMultiple() {
////        let grammar = ZeroOrMore(Literal("a"))
////
////        let s = "aaa."
////        eq(grammar.match(s), Node(s, 0..<3, children: [Node(s, 0..<1), Node(s, 1..<2), Node(s, 2..<3)]))
////    }
////
////    func testMatchesEmpty() {
////        let grammar = ZeroOrMore(Regex(""))
////
////        let s = "a"
////        eq(grammar.match(s), Node("", 0..<0, children: [Node("", 0..<0)]))
////    }
////}