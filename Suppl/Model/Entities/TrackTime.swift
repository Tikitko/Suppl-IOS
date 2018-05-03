import Foundation

struct TrackTime {
    static let zeroTime = "0:00"
    let sec: Int
    var formatted: String {
        get {
            let min = "\((self.sec % 3600) / 60)"
            let secInt = (self.sec % 3600) % 60
            let sec = (secInt < 10 ? "0" : "") + "\(secInt)"
            return String("\(min):\(sec)")
        }
    }
}
