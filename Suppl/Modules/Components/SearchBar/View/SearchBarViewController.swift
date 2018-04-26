import Foundation
import UIKit

class SearchBarViewController: UISearchController, SearchBarViewControllerProtocol {
    
    var presenter: SearchBarPresenterProtocol!
    
    var searchCallback: ((String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
}

extension SearchBarViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = searchBar.text else { return }
        searchCallback(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
