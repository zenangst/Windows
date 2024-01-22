import Cocoa

internal enum Dock {
  static func size(_ screen: NSScreen) -> CGFloat {
    switch position(screen) {
    case .right:
      return screen.frame.width - screen.visibleFrame.width
    case .left:
      return screen.visibleFrame.origin.x
    case .bottom:
      if screen.isMainDisplay {
        return screen.visibleFrame.origin.y
      } else {
        return abs(screen.visibleFrame.height - screen.frame.size.height)
      }
    }
  }

  static let dockDefaults = UserDefaults(suiteName: "com.apple.dock")!

  static var tileSize: Double {
    dockDefaults.double(forKey: "tilesize")
  }

  static func position(_ screen: NSScreen) -> DockPosition {
    if screen.visibleFrame.origin.y == screen.frame.origin.y {
      if screen.visibleFrame.origin.x == screen.frame.origin.x {
        return .right
      } else {
        return .left
      }
    } else {
      return .bottom
    }
  }

  static func isHidden(_ screen: NSScreen) -> Bool {
    size(screen) < 25
  }
}

internal enum DockPosition: Int {
  case bottom = 0
  case left = 1
  case right = 2
}
