import Cocoa
import XCTest
import Windows

final class WindowsTests: XCTestCase {
  func testActiveWindows() throws {
    let controller = WindowsController()
    let windows = try controller.getWindows([])

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
      if runningApplication.bundleIdentifier?.contains("Pages") == true {
        runningApplication.activate(options: .activateIgnoringOtherApps)
      }

      Swift.print(runningApplication.bundleIdentifier)
      Swift.print(windows)
      Swift.print("–––––––––––")
    }

    XCTAssertFalse(dictionary.isEmpty)
  }
}