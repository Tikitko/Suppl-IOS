import Foundation

struct Playlist {
    
    private var IDs: [String]
    private var current: Int
    
    public init?(IDs: [String], current: Int = 0) {
        if IDs.count > 0, current < IDs.count {
            self.IDs = IDs
            self.current = current
            return
        }
        return nil
    }
    
    public var curr: String {
        get { return IDs[current] }
    }
    
    public mutating func next() -> String {
        current = IDs.count - 1 == current ? 0 : current + 1
        return curr
    }
    
    public mutating func prev()  -> String {
        current = 0 == current ? IDs.count - 1 : current - 1
        return curr
    }

}
