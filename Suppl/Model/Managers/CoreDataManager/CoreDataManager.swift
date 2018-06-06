import Foundation
import CoreData

final class CoreDataManager {
    
    static public let s = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            /*
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            */
        })
        return container
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    
    public func saveContext(context: NSManagedObjectContext? = nil) {
        let workContext = context ?? mainContext
        if workContext.hasChanges {
            do {
                try workContext.save()
            } catch {
                /*
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                */
            }
        }
    }
    
    public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, context: NSManagedObjectContext? = nil) throws -> [ENTITY] {
        let objectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        objectsFetch.predicate = predicate
        objectsFetch.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit {
            objectsFetch.fetchLimit = fetchLimit
        }
        let fetchedObjects = try (context ?? mainContext).fetch(objectsFetch)
        return fetchedObjects as! [ENTITY]
    }
    
    public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: @escaping ([ENTITY]?, Error?, NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask() { [weak self] context in
            var entitiesOut: [ENTITY]? = nil
            var errorOut: Error? = nil
            do {
                entitiesOut = try self?.fetche(type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, context: context)
            } catch {
                errorOut = error
            }
            completion(entitiesOut, errorOut, context)
        }
    }
    
    public func create<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, context: NSManagedObjectContext? = nil) -> ENTITY {
        let workContext = context ?? mainContext
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: workContext)!
        return NSManagedObject(entity: entity, insertInto: workContext) as! ENTITY
    }
    
    public func delete<ENTITY: CoreDataEntity>(_ entity: ENTITY, context: NSManagedObjectContext? = nil) {
        (context ?? mainContext).delete(entity)
    }
    
}
