import Foundation
import UIKit

class SearchBarViewController: ViperDefaultView<SearchBarPresenterProtocolView>, SearchBarViewControllerProtocol {
    
    override func loadView() {
        view = createSearchBarModuleView()
    }
    
    var searchBarView: UISearchBar {
        return view as! UISearchBar
    }
    
    private func createSearchBarModuleView() -> UISearchBar {
        let searchBarView = UISearchBar()
        searchBarView.searchBarStyle = .minimal
        searchBarView.isTranslucent = false
        searchBarView.backgroundColor = .white
        searchBarView.delegate = self
        return searchBarView
    }
    
}

extension SearchBarViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        presenter.searchButtonClicked(query: searchBar.text ?? String())
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
