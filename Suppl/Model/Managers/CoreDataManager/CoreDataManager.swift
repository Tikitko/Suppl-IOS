import Foundation
import CoreData

final class CoreDataManager {
    
    static public let shared = CoreDataManager()
    private init() {}
    
    public class CoreDataEntity: NSManagedObject {}
    
    public class CoreDataBaseContextWorker {
        
        fileprivate let context: NSManagedObjectContext
        
        fileprivate init(context: NSManagedObjectContext) {
            self.context = context
        }
        
        public func saveContext() {
            if context.hasChanges { try? context.save() }
        }
        
        public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) throws -> [ENTITY] {
            let objectsFetch = NSFetchRequest<ENTITY>(entityName: String(describing: type))
            objectsFetch.predicate = predicate
            objectsFetch.sortDescriptors = sortDescriptors
            if let fetchLimit = fetchLimit {
                objectsFetch.fetchLimit = fetchLimit
            }
            return try context.fetch(objectsFetch)
        }
        
        public func create<ENTITY: CoreDataEntity>(_ type: ENTITY.Type) -> ENTITY {
            let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
            return NSManagedObject(entity: entity, insertInto: context) as! ENTITY
        }
        
        public func delete<ENTITY: CoreDataEntity>(_ entity: ENTITY) {
            context.delete(entity)
        }
        
    }
    
    public class CoreDataBackgroundContextWorker {
        
        private let baseWorker: CoreDataBaseContextWorker
        
        fileprivate init(coordinator: NSPersistentStoreCoordinator) {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            baseWorker = CoreDataBaseContextWorker(context: context)
        }
        
        fileprivate init(container: NSPersistentContainer) {
            baseWorker = CoreDataBaseContextWorker(context: container.newBackgroundContext())
        }
        
        public func run(completion: @escaping (CoreDataBaseContextWorker) -> Void) {
            baseWorker.context.perform { completion(self.baseWorker) }
        }
        
        public func saveContext(completion: @escaping () -> Void) {
            run { $0.saveContext() }
        }
        
        public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: @escaping ([ENTITY]?, Error?) -> Void) {
            run { inWorker in
                var entitiesOut: [ENTITY]? = nil
                var errorOut: Error? = nil
                do {
                    entitiesOut = try inWorker.fetche(
                        type,
                        predicate: predicate,
                        sortDescriptors: sortDescriptors,
                        fetchLimit: fetchLimit
                    )
                } catch {
                    errorOut = error
                }
                completion(entitiesOut, errorOut)
            }
        }
        
        public func create<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, completion: @escaping (ENTITY) -> Void) {
            run { completion($0.create(type)) }
        }
        
        public func delete<ENTITY: CoreDataEntity>(_ entity: ENTITY, completion: @escaping () -> Void) {
            run {
                $0.delete(entity)
                completion()
            }
        }
        
    }
    
    public class CoreDataForegroundContextWorker {
        
        private let baseWorker: CoreDataBaseContextWorker
        
        fileprivate init(coordinator: NSPersistentStoreCoordinator) {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            baseWorker = CoreDataBaseContextWorker(context: context)
        }
        
        fileprivate init(container: NSPersistentContainer) {
            baseWorker = CoreDataBaseContextWorker(context: container.newBackgroundContext())
        }
        
        public func saveContext() {
            baseWorker.saveContext()
        }
        
        public func fetche<ENTITY: CoreDataEntity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) throws -> [ENTITY] {
            return try baseWorker.fetche(type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
        }
        
        public func create<ENTITY: CoreDataEntity>(_ type: ENTITY.Type) -> ENTITY {
            return baseWorker.create(type)
        }
        
        public func delete<ENTITY: CoreDataEntity>(_ entity: ENTITY) {
            baseWorker.delete(entity)
        }
        
    }
    
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: AppStaticData.Consts.coreDataMainModel, withExtension: AppStaticData.Consts.momdType)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public var isInited: Bool {
        get { return persistentStoreCoordinator != nil }
    }
    public func initStack(completion: @escaping (Error?) -> Void) {
        if let _ = persistentStoreCoordinator {
            completion(nil)
            return
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent(AppStaticData.Consts.coreDataMainModel + AppStaticData.Consts.fullSQliteType)
        DispatchQueue.global(qos: .default).async { [weak self] in
            var errorOut: Error? = nil
            do {
                let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
                self?.persistentStoreCoordinator = coordinator
            } catch {
                errorOut = error
            }
            DispatchQueue.main.async { completion(errorOut) }
        }
    }

    
    public func getForegroundWorker() -> CoreDataForegroundContextWorker? {
        return persistentStoreCoordinator != nil ? CoreDataForegroundContextWorker(coordinator: persistentStoreCoordinator!) : nil
    }
    
    public func getBackgroundWorker() -> CoreDataBackgroundContextWorker? {
        return persistentStoreCoordinator != nil ? CoreDataBackgroundContextWorker(coordinator: persistentStoreCoordinator!) : nil
    }
    
}
