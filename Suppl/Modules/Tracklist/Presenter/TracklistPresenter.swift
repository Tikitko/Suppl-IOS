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
    
    func filterButtonClick(_ sender: Any, name: String) {
        let filterValues = FilterDefaultValues(timeValue: interactor.searchTimeRate, titleValue: interactor.searchByTitle, performerValue: interactor.searchByPerformer)
        interactor.createFilterListeners(name: name)
        router.showFilter(sender: sender, defaultValues: filterValues, name: name)
    }
    
}
