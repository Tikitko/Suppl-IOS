import Foundation
import UIKit

class TracklistPresenter: TracklistPresenterProtocol {
    
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
    func reloadData() {
        view.reloadData()
    }
    
    func clearSearch() {
        view.clearSearch()
    }
    
    func updateButtonIsEnabled(_ value: Bool) {
        view.updateButtonIsEnabled(value)
    }
    
    func setInfo(_ text: String? = nil) {
        text != nil ? view.onLabel(text: text!) : view.offLabel()
    }
    
    func setFilterThenPopover(filterController: UIViewController) {
        view.setFilterThenPopover(filterController: filterController)
    }
    
    func setSearchListener() {
        interactor.setSearchListener()
    }
    
    func setTableListener() {
        interactor.setTableListener()
    }
    
    func load() {
        interactor.load()
    }
    
    func updateButtonClick() {
        interactor.updateButtonClick()
    }
    
    func filterButtonClick() {
        interactor.setFilterListener()
        router.showFilter()
    }
    
}
