import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.s.get(.titleSMain)
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
            cell = SettingTableCell(labelText: LocalesManager.s.get(.setting2), switchValue: SettingsManager.s.roundIcons!) { switchElement in
                SettingsManager.s.roundIcons = switchElement.isOn
            }
        case 1:
            cell = SettingTableCell(labelText: LocalesManager.s.get(.setting1), switchValue: SettingsManager.s.loadImages!) { switchElement in
                SettingsManager.s.loadImages = switchElement.isOn
            }
        case 0:
            cell = SettingTableCell(labelText: LocalesManager.s.get(.setting0), switchValue: SettingsManager.s.autoNextTrack!) { switchElement in
                SettingsManager.s.autoNextTrack = switchElement.isOn
            }
        case 3:
            let themes = AppStaticData.themesList
            var themeId = themes.count > SettingsManager.s.theme! ? SettingsManager.s.theme! : 0
            let labelText: String = LocalesManager.s.get(.setting3)
            cell = SettingTableCell(labelText: labelText, buttonText: themes[themeId]) { button in
                themeId = themes.count > themeId + 1 ? themeId + 1 : 0
                button.setTitle(themes[themeId], for: .normal)
                SettingsManager.s.theme = themeId
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
}
