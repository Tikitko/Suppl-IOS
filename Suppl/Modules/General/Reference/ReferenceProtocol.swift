protocol ReferenceProtocol {
    associatedtype Element
    var pointee: Element? { get }
    init<T: AnyObject>(_ pointee: T)
}
