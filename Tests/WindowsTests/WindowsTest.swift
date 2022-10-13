import Cocoa
import XCTest
import Windows

final class WindowsTests: XCTestCase {
  func testActiveWindows() throws {
    let windows = try WindowsInfo.getWindows([])

    var dictionary = [NSRunningApplication: [WindowModel]]()

    for window in windows {
      if let pid = pid_t(exactly: window.ownerPid.rawValue),
         let runningApplication = NSRunningApplication(processIdentifier: pid) {

        var applicationWindows: [WindowModel] = dictionary[runningApplication] ?? []
        applicationWindows.append(window)
        dictionary[runningApplication] = applicationWindows
      }
    }

    for (runningApplication, windows) in dictionary {
      Swift.print(runningApplication.bundleIdentifier)
      Swift.print(windows)
      Swift.print("–––––––––––")
    }

    XCTAssertFalse(dictionary.isEmpty)
  }
}
