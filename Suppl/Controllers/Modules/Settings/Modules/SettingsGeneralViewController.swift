import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.title = "Основное"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.allowsSelection = false
    }
}

extension SettingsGeneralViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.row {
        case 2:
            cell = SettingTableCell(labelText: "Круглые миниатюры", switchValue: SettingsManager.roundIcons!) { switchElement in
                SettingsManager.roundIcons = switchElement.isOn
            }
        case 1:
            cell = SettingTableCell(labelText: "Загружать миниатюры треков", switchValue: SettingsManager.loadImages!) { switchElement in
                SettingsManager.loadImages = switchElement.isOn
            }
        case 0:
            cell = SettingTableCell(labelText: "Авто. переключение трека", switchValue: SettingsManager.autoNextTrack!) { switchElement in
                SettingsManager.autoNextTrack = switchElement.isOn
            }
        case 3:
            var themeId = SettingsManager.themesList.count <= SettingsManager.theme! ? SettingsManager.themesList.count : 1
            cell = SettingTableCell(labelText: "Тема приложения", buttonText: SettingsManager.themesList[themeId - 1]) { button in
                themeId = SettingsManager.themesList.count <= themeId ? 1 : themeId + 1
                button.setTitle(SettingsManager.themesList[themeId - 1], for: .normal)
                SettingsManager.theme = UInt(themeId)
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
}
