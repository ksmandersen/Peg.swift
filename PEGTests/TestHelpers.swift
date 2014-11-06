//
//  TestHelpers.swift
//  PEG
//
//  Created by Kristian Andersen on 06/11/14.
//  Copyright (c) 2014 kristian.co. All rights reserved.
//

import Foundation
import XCTest

/// like XCTAssertEqual, but handles optional unwrapping
public func eq<T: Any where T: Equatable>(expression1: @autoclosure () -> T?, expression2: @autoclosure () -> T?, _ message: String? = nil, file: String = __FILE__, line: UInt = __LINE__) {
    if let exp1 = expression1() {
        if let exp2 = expression2() {
            XCTAssertEqual(exp1, exp2, message != nil ? message! : "", file: file, line: line)
        } else {
            XCTFail(message != nil ? message! : "exp1 != nil, exp2 == nil", file: file, line: line)
        }
    } else if let exp2 = expression2() {
        XCTFail(message != nil ? message! : "exp1 == nil, exp2 != nil", file: file, line: line)
    }
}