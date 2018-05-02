import Foundation
import UIKit

class TracklistPresenter: TracklistPresenterProtocol {
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func setListener() {
        interactor.setListener()
    }
    
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
    
    func load() {
        interactor.load()
    }
    
    func updateButtonClick() {
        interactor.updateButtonClick()
    }
    
    func filterButtonClick() {
        router.showFilter()
    }
    
}
