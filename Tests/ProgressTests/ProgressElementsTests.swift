//
//  ProgressElementsTests.swift
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

import Progress
import Testing

@Suite("ProgressElementsTests")
class ProgressElementsTests {

  @Test("testPercentElement")
  func testPercentElement() {
    var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
    bar.next()
    let percent = ProgressPercent()

    #expect(percent.value(bar) == "10%")
  }

  @Test("testPercentElementDecimalPlacesOne")
  func testPercentElementDecimalPlaces() {
    var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
    bar.next()
    bar.next()
    let percent = ProgressPercent(decimalPlaces: 4)

    #expect(percent.value(bar) == "20.0000%")
  }

  @Test("testPercentElementWithProgressBarCountZero")
  func testPercentElementWithProgressBarCountZero() {
    let bar = ProgressBar(count: 0, printer: ProgressBarTestPrinter())
    let percent = ProgressPercent()
    #expect(percent.value(bar) == "100%")
  }

  @Test("testIndexElement")
  func testIndexElement() {
    var bar = ProgressBar(count: 1, printer: ProgressBarTestPrinter())
    let index = ProgressIndex()

    #expect(index.value(bar) == "0 of 1")

    bar.next()
    #expect(index.value(bar) == "1 of 1")
  }

  @Test("testStringElement")
  func testStringElement() {
    let bar = ProgressBar(count: 1, printer: ProgressBarTestPrinter())
    let stringElement = ProgressString(string: "test")

    #expect(stringElement.value(bar) == "test")
  }

  @Test("testBarLine")
  func testBarLine() {
    var bar = ProgressBar(count: 3, printer: ProgressBarTestPrinter())
    let barLine = ProgressBarLine()

    #expect(barLine.value(bar) == "[                              ]")

    bar.next()

    #expect(barLine.value(bar) == "[----------                    ]")

    bar.next()
    bar.next()

    #expect(barLine.value(bar) == "[------------------------------]")
  }

  @Test("testBarLineLength")
  func testBarLineLength() {
    var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
    let barLine = ProgressBarLine(barLength: 0)

    bar.next()

    #expect(barLine.value(bar) == "[]")
  }

  @Test("testTimeEstimates")
  func testTimeEstimates() {
    let bar = ProgressBar(count: 10000, printer: ProgressBarTestPrinter())
    let timeEstimates = ProgressTimeEstimates()

    #expect(timeEstimates.value(bar) == "ETA: 00:00:00 (at 0.00) it/s)")
  }

  @Test("testStringWithUpdate")
  func testStringWithUpdate() {
    let bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
    var testString = "test"
    let stringWithUpdate = ProgressStringWithUpdate(update: { testString })
    testString = "test2"

    #expect(stringWithUpdate.value(bar) == "test2")
  }

  @Test("testUpdateingString")
  func testUpdateingString() {
    var testString = "test"
    var stringWithUpdate = ProgressStringWithUpdate(update: { testString })
    testString = "test2"

    #expect(
      stringWithUpdate.value(ProgressBar(count: 1, printer: ProgressBarTestPrinter())) == "test2")
  }
}
