import CoreGraphics
import Foundation

public struct WindowModel: Hashable, Sendable {
  public var id: Int { Int(windowNumber.rawValue) }
  public let alpha: Float
  public let isOnScreen: Bool
  public let layer: Int
  public let name: String
  public let ownerName: String
  public let ownerPid: Pid
  public let rect: CGRect
  public let windowName: String
  public let windowNumber: WindowNumber

  init?(_ dictionary: [String: Any]) {
    guard let pid = dictionary[kCGWindowOwnerPID as String] as? Int else {
      return nil
    }

    guard let windowNumber = dictionary[kCGWindowNumber, Double.self] else {
      return nil
    }

    guard dictionary[kCGWindowLayer, Double.self] == 0 else {
      return nil
    }

    self.windowNumber = WindowNumber(rawValue: windowNumber)

    let rect = dictionary[kCGWindowBounds, [String: Double]()]

    self.alpha = dictionary[kCGWindowAlpha, 0]
    self.isOnScreen = dictionary.isEnabled(kCGWindowIsOnscreen)
    self.name = dictionary[kCGWindowName, ""]
    self.ownerName = dictionary[kCGWindowOwnerName, ""]
    self.ownerPid = Pid(rawValue: pid)
    self.windowName = dictionary[kCGWindowName, ""]
    self.layer = dictionary[kCGWindowLayer, -1]
    self.rect = Rect(rect).toCGRect
  }

  public struct WindowNumber: Hashable, Sendable {
    public let rawValue: Double
  }

  public struct Pid: Hashable, Sendable {
    public let rawValue: Int
  }
}

extension CGRect: Hashable {
   public func hash(into hasher: inout Hasher) {
    hasher.combine(origin.x)
    hasher.combine(origin.y)
    hasher.combine(size.width)
    hasher.combine(size.height)
  }
}

private extension Dictionary where Key == String, Value == Any {
  func isEnabled(_ key: CFString) -> Bool {
    self[key, 0] == 1 ? true : false
  }

  subscript<T>(key: CFString, type: T.Type) -> T? {
    self[key as String] as? T
  }


  subscript<T>(key: CFString, default: T) -> T {
    (self[key as String] as? T) ?? `default`
  }
}

private struct Rect: Hashable {
  let x: Double
  let y: Double
  let width: Double
  let height: Double

  var toCGRect: CGRect {
    CGRect(x: x, y: y, width: width, height: height)
  }

  init(_ dictionary: [String: Double]) {
    self.x = dictionary["X", default: 0.0]
    self.y = dictionary["Y", default: 0.0]
    self.width = dictionary["Width", default: 0.0]
    self.height = dictionary["Height", default: 0.0]
  }

  init(_ rect: CGRect) {
    self.x = rect.origin.x
    self.y = rect.origin.y
    self.width = rect.size.width
    self.height = rect.size.height
  }
}
