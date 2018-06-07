import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    private let settingsCells: [UITableViewCell] = [
        SettingTableCell(labelText: LocalesManager.s.get(.setting0), switchValue: SettingsManager.s.autoNextTrack!) { switchElement in
            SettingsManager.s.autoNextTrack = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting1), switchValue: SettingsManager.s.loadImages!) { switchElement in
            SettingsManager.s.loadImages = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting2), switchValue: SettingsManager.s.roundIcons!) { switchElement in
            SettingsManager.s.roundIcons = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting4), switchValue: OfflineModeManager.s.offlineMode) { switchElement in
            if switchElement.isOn {
                OfflineModeManager.s.on()
            } else {
                OfflineModeManager.s.off()
            }
        },
        {
            let themes = AppStaticData.themesList
            var themeId = themes.count > SettingsManager.s.theme! ? SettingsManager.s.theme! : 0
            return SettingTableCell(labelText: LocalesManager.s.get(.setting3), buttonText: themes[themeId]) { button in
                themeId = themes.count > themeId + 1 ? themeId + 1 : 0
                button.setTitle(themes[themeId], for: .normal)
                SettingsManager.s.theme = themeId
            }
        }(),
        SettingTableCell(labelText: LocalesManager.s.get(.setting5), buttonText: LocalesManager.s.get(.clear)) { button in
            RemoteDataManager.s.resetAllCachedImages()
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting6), buttonText: LocalesManager.s.get(.clear)) { button in
            PlayerItemsManager.s.resetAllCachedItems()
        }
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.s.get(.titleSMain)
        settingsTable.allowsSelection = false
    }
    
}

extension SettingsGeneralViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingsCells[indexPath.row]
    }
    
}
