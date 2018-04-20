import Foundation

struct TrackList {
    private var IDs: [String]
    private var current: Int
    public static func get(IDs: [String], current: Int = 0) -> TrackList? {
        if IDs.count > 0, current < IDs.count {
            return TrackList.init(IDs: IDs, current: current)
        }
        return nil
    }
    private init(IDs: [String], current: Int = 0) {
        self.IDs = IDs
        self.current = current
    }
    public func curr() -> String {
        return IDs[current]
    }
    public mutating func next() -> String {
        current = IDs.count - 1 == current ? 0 : current + 1
        return IDs[current]
    }
    public mutating func prev()  -> String {
        current = 0 == current ? IDs.count - 1 : current - 1
        return IDs[current]
    }
}
