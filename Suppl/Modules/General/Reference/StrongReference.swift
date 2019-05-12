final class StrongReference<Element>: ReferenceProtocol {
    private let value: AnyObject
    var pointee: Element? {
        return value as? Element
    }
    init<T: AnyObject>(_ pointee: T) {
        self.value = pointee
    }
}
