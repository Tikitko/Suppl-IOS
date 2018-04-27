import Foundation

final class ModulesCommunicateManager {
    
    static public let s = ModulesCommunicateManager()
    private init() {}
    
    public var searchDelegate: SearchCommunicateProtocol?
    public var trackFilterDelegate: TrackFilterCommunicateProtocol?
    
}
