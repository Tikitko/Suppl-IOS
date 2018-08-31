import Foundation

struct TrackTime {
    let sec: Int
    var formatted: String {
        get {
            let hours = self.sec % 3600
            let min = "\(hours / 60)"
            let secInt = hours % 60
            let sec = (secInt < 10 ? "0" : String()) + "\(secInt)"
            return String("\(min):\(sec)")
        }
    }
}
