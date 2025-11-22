//
//  ProgressTests.swift
//  ProgressTests
//
//  Created by Justus Kandzi on 31/12/15.
//  Copyright © 2015 Justus Kandzi. All rights reserved.
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
import Foundation
import Progress
import Testing

class ProgressBarTestPrinter: ProgressBarPrinter {
  var lastValue: String = ""

  func display(_ progressBar: ProgressBar) {
    lastValue = progressBar.value
  }
}

@Suite("ProgressTests")
struct ProgressTests {

  @Test("testProgressDefaultConfiguration")
  func testProgressDefaultConfiguration() throws {
    let testPrinter = ProgressBarTestPrinter()
    var bar = ProgressBar(count: 2, printer: testPrinter)

    bar.next()
    #expect(
      testPrinter.lastValue
        == "0 of 2 [                              ] ETA: 00:00:00 (at 0.00) it/s)")
    bar.next()
    #expect(testPrinter.lastValue.hasPrefix("1 of 2 [---------------               ] ETA: "))
  }

  @Test("testProgressDefaultConfigurationUpdate")
  func testProgressDefaultConfigurationUpdate() {
    let bar = ProgressBar(count: 2, configuration: [ProgressPercent()])
    #expect(bar.value == "0%")
  }

  @Test("testProgressConfiguration")
  func testProgressConfiguration() {
    let testPrinter = ProgressBarTestPrinter()
    var bar = ProgressBar(
      count: 2, configuration: [ProgressString(string: "percent done:"), ProgressPercent()],
      printer: testPrinter)

    bar.next()
    #expect(testPrinter.lastValue == "percent done: 0%")
    bar.next()
    #expect(testPrinter.lastValue == "percent done: 50%")
  }

  @Test("testProgressBarCountZero")
  func testProgressBarCountZero() {
    let bar = ProgressBar(count: 0)

    #expect(
      bar.value == "0 of 0 [------------------------------] ETA: 00:00:00 (at 0.00) it/s)")
  }

  @Test("testProgressBarOutOfBounds")
  func testProgressBarOutOfBounds() {
    let testPrinter = ProgressBarTestPrinter()

    var bar = ProgressBar(count: 2, configuration: [ProgressIndex()], printer: testPrinter)
    for _ in 0...10 {
      bar.next()
    }

    #expect(testPrinter.lastValue == "2 of 2")
  }

  @Test("testProgressBarCustomIndex")
  func testProgressBarCustomIndex() {
    let testPrinter = ProgressBarTestPrinter()

    var bar = ProgressBar(count: 100, configuration: [ProgressIndex()], printer: testPrinter)
    for _ in 0...10 {
      bar.next()
    }

    bar.setValue(30)
    #expect(testPrinter.lastValue == "30 of 100")

    bar.setValue(1)
    #expect(testPrinter.lastValue == "1 of 100")

    bar.setValue(-5)
    #expect(testPrinter.lastValue == "1 of 100")

    bar.setValue(100)
    #expect(testPrinter.lastValue == "100 of 100")

    bar.setValue(10000)
    #expect(testPrinter.lastValue == "100 of 100")

    bar.setValue(0)
    #expect(testPrinter.lastValue == "0 of 100")
  }

  @Test("testProgressGenerator")
  func testProgressGenerator() {
    let testPrinter = ProgressBarTestPrinter()
    let progress = Progress(6...7, configuration: [ProgressIndex()], printer: testPrinter)

    var generator = progress.makeIterator()

    #expect(generator.next() == 6)
    #expect(testPrinter.lastValue == "0 of 2")
    #expect(generator.next() == 7)
    #expect(testPrinter.lastValue == "1 of 2")
    #expect(generator.next() == nil)
    #expect(testPrinter.lastValue == "2 of 2")
  }

  @Test("testProgressBarPerformance")
  func testProgressBarPerformance() {
    // Simple run without performance measurements
    for _ in Progress(1...100000) {}
    // Note: Performance testing would need to be implemented differently with the Testing framework
  }

  @Test("testProgressGroup")
  func testProgressGroup() {
    let n = 10
    let seqArr: [Range<Int>] = (0..<n).map { _ in 0..<n }
    let progressGroup = ProgressGroup(sequences: seqArr)
    for i in 0..<n {
      for _ in progressGroup.getProgress(index: i) {}
    }
  }
}
