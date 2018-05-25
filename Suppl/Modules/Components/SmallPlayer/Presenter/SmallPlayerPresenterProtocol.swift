import Foundation

protocol SmallPlayerPresenterProtocol: class {}

protocol SmallPlayerPresenterProtocolInteractor: SmallPlayerPresenterProtocol {
    
}

protocol SmallPlayerPresenterProtocolView: SmallPlayerPresenterProtocol {
    func setListener()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func openBigPlayer()
    func removePlayer()
}
