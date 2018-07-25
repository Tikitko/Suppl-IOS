import CoreData
import Foundation

@objc(Track)
class Track: CoreDataManager.CoreDataEntity {
    
    @NSManaged var id: NSString
    @NSManaged var title: NSString
    @NSManaged var performer: NSString
    @NSManaged var duration: NSNumber
    @NSManaged var imageLink: NSString?
    
    func fromAudioData(_ audioData: AudioData) {
        id = audioData.id as NSString
        title = audioData.title as NSString
        performer = audioData.performer as NSString
        duration = NSNumber(value: audioData.duration)
        imageLink = audioData.images.last as NSString?
    }
    
}
