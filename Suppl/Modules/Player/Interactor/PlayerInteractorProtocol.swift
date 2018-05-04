import Foundation
import AVFoundation
import AVKit
import MediaPlayer
import UIKit

protocol PlayerInteractorProtocol: class {
    
    func load()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func navButtonClick(next: Bool)
    func rewindP()
    func rewindM()
    
}
