import Foundation

final class ModulesCommunicateManager {
    
    static public let s = ModulesCommunicateManager()
    private init() {}
    
    public weak var searchDelegate: SearchCommunicateProtocol?
    public weak var trackFilterDelegate: TrackFilterCommunicateProtocol?
    public weak var trackTableDelegate: TrackTableCommunicateProtocol?
    
}
