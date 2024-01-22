import Cocoa

public enum WindowFullscreenCalculation {
  public static func calculate(from originFrame: CGRect,
                               padding: Int) -> CGRect {
    guard let currentDisplay = NSScreen.mainDisplay,
          let mainDisplay = NSScreen.main else {
      return originFrame
    }

    let paddingOffset = CGFloat(padding)
    let x: CGFloat
    let y: CGFloat
    let height: CGFloat

    if Dock.position(currentDisplay) == .bottom {
      height = currentDisplay.frame.height - Dock.tileSize - paddingOffset * 2
    } else {
      height = currentDisplay.visibleFrame.height - paddingOffset * 2
    }

    let size = CGSize(width: currentDisplay.frame.width - paddingOffset * 2,
                      height: height)
    let newFrame: CGRect

    if currentDisplay == mainDisplay {
      x = CGFloat.formula(currentDisplay.frame.origin.x) { fn in
        fn.add(paddingOffset)
      }
      y = CGFloat.formula(currentDisplay.frame.origin.y) { fn in
        fn.add(currentDisplay.frame.height)
        fn.subtract(size.height)
        fn.subtract(paddingOffset)
      }

      newFrame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    } else {
      // Handle secondary screens
      x = CGFloat.formula(currentDisplay.frame.origin.x) { fn in
        fn.add(paddingOffset / 2)
      }
      y = CGFloat.formula(mainDisplay.frame.maxY) { fn in
        fn.subtract(currentDisplay.visibleFrame.origin.y)
        fn.subtract(size.height)
        fn.subtract(paddingOffset)
      }
      newFrame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    }

    return newFrame
  }
}
