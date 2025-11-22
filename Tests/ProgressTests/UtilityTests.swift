//
//  UtilityTests.swift
//  Progress.swift
//
//  Created by Justus Kandzi on 04/01/16.
//  Copyright © 2016 Justus Kandzi. All rights reserved.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Testing

@testable import Progress

@Suite("UtilityTests")
class UtilityTests {

  // MARK: - Substring
  @Test("testSubstringEndOutOfBounds")
  func testSubstringEndOutOfBounds() {
    #expect("abc".substringWithRange(2, end: 100) == "c")
  }

  @Test("testSubstringStartOutOfBounds")
  func testSubstringStartOutOfBounds() {
    #expect("abc".substringWithRange(3, end: 100) == "")
    #expect("abc".substringWithRange(10, end: 100) == "")
  }

  // MARK: - format double
  @Test("testFormat")
  func testFormat() {
    #expect(Double(0.0).format(0) == "0")
    #expect(Double(0.0).format(1) == "0.0")
    #expect(Double(0.0).format(3) == "0.000")

    #expect(Double(0.0).format(0, minimumIntegerPartLength: 1) == "0")
    #expect(Double(0.0).format(0, minimumIntegerPartLength: 2) == "00")
    #expect(Double(0.0).format(3, minimumIntegerPartLength: 3) == "000.000")

    #expect(Double(100.0).format(0, minimumIntegerPartLength: 1) == "100")
    #expect(Double(100.0).format(0, minimumIntegerPartLength: 2) == "100")
    #expect(Double(100.0).format(1, minimumIntegerPartLength: 4) == "0100.0")
  }
}
