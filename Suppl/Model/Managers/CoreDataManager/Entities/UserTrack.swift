import CoreData
import Foundation

@objc(UserTrack)
class UserTrack: CoreDataManager.CoreDataEntity {
    @NSManaged var userIdentifier: NSNumber
    @NSManaged var trackId: NSString
    @NSManaged var position: NSNumber
}
