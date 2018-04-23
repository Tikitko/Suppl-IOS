import Foundation

class TracklistPresenter: TracklistPresenterProtocol {
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
    var titleCallback: (( _: inout Bool) -> Void)! {
        get {
            return interactor.titleCallback
        }
    }
    var performerCallback: (( _: inout Bool) -> Void)! {
        get {
            return interactor.performerCallback
        }
    }
    var timeCallback: (( _: inout Float) -> Void)! {
        get {
            return interactor.timeCallback
        }
    }
    var searchByTitle: Bool {
        get {
            return interactor.searchByTitle
        }
    }
    var searchByPerformer: Bool {
        get {
            return interactor.searchByPerformer
        }
    }
    var searchTimeRate: Float {
        get {
            return interactor.searchTimeRate
        }
    }
    
    func clearSearch() {
        view.clearSearch()
    }
    
    func updateButtonIsEnabled(_ value: Bool) {
        view.updateButtonIsEnabled(value)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        interactor.searchBarSearchButtonClicked(searchText: searchText)
    }
    
    func setInfo(_ text: String? = nil) {
        text != nil ? view.onLabel(text: text!) : view.offLabel()
    }
    
    func load() {
        interactor.load()
    }
    
    func updateButtonClick() {
        interactor.updateButtonClick()
    }
    
    func filterButtonClick(_ sender: Any) {
        router.showFilter(sender: sender, timeValue: interactor.searchTimeRate, titleValue: interactor.searchByTitle, performerValue: interactor.searchByPerformer, timeCallback: interactor.timeCallback, titleCallback: interactor.titleCallback, performerCallback: interactor.performerCallback)
    }
    
}
