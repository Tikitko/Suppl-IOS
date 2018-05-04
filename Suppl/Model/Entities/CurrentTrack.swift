import Foundation
import UIKit

struct CurrentTrack {
    let id: String
    let title: String
    let performer: String
    let duration: Int
    var image: UIImage?
    
    mutating func setImage(_ image: UIImage) {
        self.image = image
    }
}
