import Foundation

struct TrackTime {
    static let zeroTime = "0:00"
    let sec: Int
    var formatted: String {
        get {
            let minSec = minAndSec
            let min = String(minSec.min)
            let sec = (minSec.1 < 10 ? "0" : "") + String("\(minSec.sec)")
            return String("\(min):\(sec)")
        }
    }
    var minAndSec: (min: Int, sec: Int) {
        get {
            return ((sec % 3600) / 60, (sec % 3600) % 60)
        }
    }
}
