import Foundation

final class ModulesCommunicateManager {
    
    static public let s = ModulesCommunicateManager()
    private init() {}
    
    private let mapTableDelegates = NSMapTable<NSString, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)
    
    public func setListener(name: String, delegate: CommunicateManagerProtocol) {
        mapTableDelegates.setObject(delegate, forKey: name as NSString)
    }
    
    public func getListener(name: String) -> CommunicateManagerProtocol? {
        return mapTableDelegates.object(forKey: name as NSString) as? CommunicateManagerProtocol
    }
    
}
