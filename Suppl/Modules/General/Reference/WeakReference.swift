final class WeakReference<Element>: ReferenceProtocol {
    weak private var value: AnyObject?
    var pointee: Element? {
        return value as? Element
    }
    init<T: AnyObject>(_ pointee: T) {
        self.value = pointee
    }
}
