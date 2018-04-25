import Foundation

class TracklistPresenter: TracklistPresenterProtocol {
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
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
    
    func timeChange(_ value: inout Float) {
        interactor.timeChange(&value)
    }
    
    func titleChange(_ value: inout Bool) {
        interactor.titleChange(&value)
    }
    
    func performerChange(_ value: inout Bool) {
        interactor.performerChange(&value)
    }
    
    func filterButtonClick(_ sender: Any) {
        guard let delegate = view as? TrackFilterDelegate else { return }
        let config = FilterConfig(timeValue: interactor.searchTimeRate, titleValue: interactor.searchByTitle, performerValue: interactor.searchByPerformer, delegate: delegate)
        router.showFilter(sender: sender, config: config)
    }
    
}
