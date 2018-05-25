import Foundation
import UIKit

class SearchBarViewController: UIViewController, SearchBarViewControllerProtocol {
    
    var presenter: SearchBarPresenterProtocolView!
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.frame = view.bounds
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(searchBar);

    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = false
        searchBar.backgroundColor = UIColor.white
        searchBar.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBarViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        presenter.searchButtonClicked(query: searchBar.text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
