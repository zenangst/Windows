import Foundation

internal enum Math {
  case add(@autoclosure () -> CGFloat)
  case subtract(@autoclosure () -> CGFloat)
}

@resultBuilder
internal struct GenericBuilder<T> {
  static public func buildBlock(_ components: T...) -> [T] {
    components
  }
}
