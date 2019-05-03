import Foundation
import UIKit

class SettingsMainTableViewController: UITableViewController {
    
    struct CellConfig {
        let title: String
        let image: UIImage
        let segueIdentifier: String
    }
    
    private lazy var sectionCellConfigurations: [CellConfig] = [
        CellConfig(title: "titleSMain".localizeKey, image: #imageLiteral(resourceName: "icon_247"), segueIdentifier: "Settings1"),
        CellConfig(title: "titleSAccount".localizeKey, image: #imageLiteral(resourceName: "icon_266"), segueIdentifier: "Settings2")
    ]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsMainTableCell.identifier, for: indexPath) as! SettingsMainTableCell
        cell.fromConfig(sectionCellConfigurations[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionCellConfigurations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: sectionCellConfigurations[indexPath.row].segueIdentifier, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


