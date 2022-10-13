import CoreGraphics
import Combine
import Foundation

enum WindowsError: Error {
  case noScreenCaptureAccess
  case unableToCopyWindowInfo
  case unableToMatchModel
  case unableToFindWindow
  case unableToCreateImage
}

final public class WindowsInfo {
  public static func getWindows(_ options: CGWindowListOption) throws -> [WindowModel] {
    guard let entries = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
      throw WindowsError.unableToCopyWindowInfo
    }

    return entries.compactMap(WindowModel.init)
  }

  public static func images(for windowModels: [WindowModel], options: CGWindowListOption) throws -> [WindowModel: CGImage] {
    var results = [WindowModel: CGImage]()
    for model in windowModels {
      guard let cgImage = try? image(for: model, options: options) else { continue }
      results[model] = cgImage
    }
    return results
  }

  public static func image(for windowModel: WindowModel, options: CGWindowListOption) throws -> CGImage {
    guard CGPreflightScreenCaptureAccess() else {
      throw WindowsError.noScreenCaptureAccess
    }

    guard let windowNumber = CGWindowID(exactly: windowModel.windowNumber.rawValue),
          let image = CGWindowListCreateImage(
            windowModel.rect,
            [.optionIncludingWindow, .excludeDesktopElements],
            windowNumber,
            .bestResolution) else {
      throw WindowsError.unableToCreateImage
    }

    return image
  }
}
