import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Основное"
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
            let themes = AppStaticData.themesList
            var themeId = themes.count > SettingsManager.theme! ? SettingsManager.theme! : 0
            cell = SettingTableCell(labelText: "Тема приложения", buttonText: themes[themeId]) { button in
                themeId = themes.count > themeId + 1 ? themeId + 1 : 0
                button.setTitle(themes[themeId], for: .normal)
                SettingsManager.theme = themeId
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
}
