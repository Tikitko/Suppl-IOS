import Foundation
import CoreData

final class CoreDataManager {
    
    public class Entity: NSManagedObject {}
    
    public final class ContextWorker {
        
        private let context: NSManagedObjectContext
        
        fileprivate init(context: NSManagedObjectContext) {
            self.context = context
        }
        
        fileprivate func run(block: @escaping (ContextWorker) -> Void) {
            context.perform { block(self) }
        }
        
        fileprivate func runAndWait(block: (ContextWorker) -> Void) {
            context.performAndWait { block(self) }
        }
        
        public var hasChanges: Bool {
            return context.hasChanges
        }
        
        public func saveContext(isNeedCheckChanges: Bool = true) throws {
            guard !isNeedCheckChanges || hasChanges else {
                return
            }
            try context.save()
        }
        
        public func create<ENTITY: Entity>(_ type: ENTITY.Type) -> ENTITY {
            let managedObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: type), into: context)
            return managedObject as! ENTITY
        }
        
        public func fetch<ENTITY: Entity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) -> [ENTITY] {
            let objectsFetch = NSFetchRequest<ENTITY>(entityName: String(describing: type))
            objectsFetch.predicate = predicate
            objectsFetch.sortDescriptors = sortDescriptors
            if let fetchLimit = fetchLimit {
                objectsFetch.fetchLimit = fetchLimit
            }
            return (try? context.fetch(objectsFetch)) ?? []
        }
        
        public func delete<ENTITY: Entity>(_ entities: [ENTITY]) {
            for entity in entities {
                context.delete(entity)
            }
        }
        
    }
    
    public final class BackgroundContextWorker {
        
        private let worker: ContextWorker
        
        fileprivate init(coordinator: NSPersistentStoreCoordinator) {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            worker = ContextWorker(context: context)
        }
        
        fileprivate init(container: NSPersistentContainer) {
            let context = container.newBackgroundContext()
            worker = ContextWorker(context: context)
        }
        
        public func run(block: @escaping (ContextWorker) -> Void) {
            worker.run(block: block)
        }
        
        public func saveContext(completion: @escaping (Error?) -> Void) {
            guard worker.hasChanges else {
                completion(nil)
                return
            }
            worker.run { worker in
                do {
                    try worker.saveContext(isNeedCheckChanges: false)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
        
        public func create<ENTITY: Entity>(_ type: ENTITY.Type, completion: @escaping (ENTITY) -> Void) {
            worker.run { worker in
                let entity = worker.create(type)
                completion(entity)
            }
        }
        
        public func fetch<ENTITY: Entity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: @escaping ([ENTITY]) -> Void) {
            worker.run { worker in
                let entities = worker.fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
                completion(entities)
            }
        }
        
        public func delete<ENTITY: Entity>(_ entities: [ENTITY], completion: @escaping () -> Void) {
            worker.run { worker in
                worker.delete(entities)
                completion()
            }
        }
        
    }
    
    public final class ForegroundContextWorker {
        
        private let worker: ContextWorker
        
        fileprivate init(coordinator: NSPersistentStoreCoordinator) {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            worker = ContextWorker(context: context)
        }
        
        fileprivate init(container: NSPersistentContainer) {
            worker = ContextWorker(context: container.newBackgroundContext())
        }
        
        public func runAndWait(block: (ContextWorker) -> Void) {
            worker.runAndWait(block: block)
        }
        
        public func saveContext() throws {
            guard worker.hasChanges else {
                return
            }
            var saveError: Error?
            runAndWait { worker in
                do {
                    try worker.saveContext(isNeedCheckChanges: false)
                } catch {
                    saveError = error
                }
            }
            guard let _saveError = saveError else {
                return
            }
            throw _saveError
        }
        
        public func create<ENTITY: Entity>(_ type: ENTITY.Type) -> ENTITY {
            var entity: ENTITY!
            worker.runAndWait { worker in
                entity = worker.create(type)
            }
            return entity
        }
        
        public func fetch<ENTITY: Entity>(_ type: ENTITY.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) -> [ENTITY] {
            var entities: [ENTITY]!
            worker.runAndWait { worker in
                entities = worker.fetch(type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
            }
            return entities
        }
        
        public func delete<ENTITY: Entity>(_ entities: [ENTITY]) {
            worker.runAndWait { worker in
                worker.delete(entities)
            }
        }
        
    }
    
    public enum PersistentStoreType {
        case sqLite(name: String)
        case binary(name: String, extension: String)
        case inMemory
        var stringValue: String {
            switch self {
            case .sqLite:
                return NSSQLiteStoreType
            case .binary:
                return NSBinaryStoreType
            case .inMemory:
                return NSInMemoryStoreType
            }
        }
        var storeFileName: String? {
            switch self {
            case .sqLite(let fileName):
                return "\(fileName).\(stringValue.lowercased())"
            case .binary(let fileName, let fileExtension):
                return "\(fileName).\(fileExtension)"
            case .inMemory:
                return nil
            }
        }
        func storeURL(for path: URL) -> URL? {
            guard let storeFileName = storeFileName else {
                return nil
            }
            var mutablePath = path
            mutablePath.appendPathComponent(storeFileName)
            return mutablePath
        }
    }
    
    
    static public let shared = CoreDataManager(dataModelName: "DataModel")
    
    private static let applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    public let dataModelName: String
    public let persistentStoreType: PersistentStoreType
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard
            let modelURL = Bundle.main.url(forResource: dataModelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Error occurred loading ManagedObjectModel!")
        }
        return model
    }()
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    private init(dataModelName: String, persistentStoreType: PersistentStoreType? = nil) {
        self.dataModelName = dataModelName
        self.persistentStoreType = persistentStoreType ?? .sqLite(name: dataModelName)
    }
    
    public var isPersistentCoordinatorLoaded: Bool {
        return persistentStoreCoordinator != nil
    }
    public func loadPersistentCoordinator(completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                completion(nil)
                return
            }
            do {
                let persistentStoreCoordinator = try self.createPersistentCoordinator()
                self.persistentStoreCoordinator = persistentStoreCoordinator
                completion(nil)
            } catch {
                self.persistentStoreCoordinator = nil
                completion(error)
            }
        }
    }
    
    public func loadPersistentCoordinatorIfNeeded(completion: @escaping (Error?) -> Void) {
        guard !isPersistentCoordinatorLoaded else {
            completion(nil)
            return
        }
        loadPersistentCoordinator(completion: completion)
    }
    
    private func createPersistentCoordinator() throws -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try coordinator.addPersistentStore(
            ofType: persistentStoreType.stringValue,
            configurationName: nil,
            at: persistentStoreType.storeURL(for: type(of: self).applicationDocumentsDirectory),
            options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        )
        return coordinator
    }

    public func getForegroundWorker() -> ForegroundContextWorker? {
        guard let persistentStoreCoordinator = persistentStoreCoordinator else {
            return nil
        }
        return ForegroundContextWorker(coordinator: persistentStoreCoordinator)
    }
    
    public func getBackgroundWorker() -> BackgroundContextWorker? {
        guard let persistentStoreCoordinator = persistentStoreCoordinator else {
            return nil
        }
        return BackgroundContextWorker(coordinator: persistentStoreCoordinator)
    }
    
}
