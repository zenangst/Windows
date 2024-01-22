import Cocoa

extension NSScreen {
  // Different from `NSScreen.main`, the `mainDisplay` sets the conditions for the
  // coordinate system. All other screens have a coordinate space that is relative
  // to the main screen.
  var isMainDisplay: Bool { frame.origin == .zero }
  static var mainDisplay: NSScreen? { screens.first(where: { $0.isMainDisplay }) }

  static func screenContaining(_ rect: CGRect) -> NSScreen? {
    NSScreen.screens.first(where: { $0.frame.contains(rect) })
  }

  static var maxY: CGFloat {
    var maxY = 0.0 as CGFloat
    for screen in screens {
      maxY = CGFloat.maximum(screen.frame.maxY, maxY)
    }
    return maxY
  }
}
