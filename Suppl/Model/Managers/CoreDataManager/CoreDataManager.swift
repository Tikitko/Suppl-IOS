import Foundation
import CoreData

final class CoreDataManager {
    
    static public let s = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data stack
    private(set) var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [ENTITY] {
        let objectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        objectsFetch.predicate = predicate
        objectsFetch.sortDescriptors = sortDescriptors
        let fetchedObjects = try persistentContainer.viewContext.fetch(objectsFetch)
        return fetchedObjects as! [ENTITY]
    }
    
    public func create<ENTITY: CoreDataEntity>(_ type: ENTITY.Type) -> ENTITY {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: managedContext)!
        return NSManagedObject(entity: entity, insertInto: managedContext) as! ENTITY
    }
    
}
