import CoreData
import Foundation

@objc(UserTrack)
class UserTrack: CoreDataManager.Entity {
    @NSManaged var userIdentifier: NSNumber
    @NSManaged var trackId: NSString
    @NSManaged var position: NSNumber
}
