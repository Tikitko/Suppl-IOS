import Foundation
import UIKit

class SearchBarViewController: UISearchBar, SearchBarViewControllerProtocol {
    
    var presenter: SearchBarPresenterProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBarStyle = .minimal
        isTranslucent = false
        backgroundColor = UIColor.white
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SearchBarViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
        guard let query = searchBar.text else { return }
        presenter.searchButtonClicked(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
    }
    
}
