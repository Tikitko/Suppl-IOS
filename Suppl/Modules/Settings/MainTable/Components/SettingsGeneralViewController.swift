import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    private lazy var settingsCells: [UITableViewCell] = [
        SettingTableCell(labelText: LocalesManager.s.get(.setting0), switchValue: SettingsManager.s.autoNextTrack!) { switchElement in
            SettingsManager.s.autoNextTrack = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting1), switchValue: SettingsManager.s.loadImages!) { switchElement in
            SettingsManager.s.loadImages = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting2), switchValue: SettingsManager.s.roundIcons!) { switchElement in
            SettingsManager.s.roundIcons = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting7), switchValue: SettingsManager.s.smallCell!) { switchElement in
            SettingsManager.s.smallCell! = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting4), switchValue: OfflineModeManager.s.offlineMode) { switchElement in
            if switchElement.isOn {
                OfflineModeManager.s.on()
            } else {
                OfflineModeManager.s.off()
                if OfflineModeManager.s.offlineMode {
                    switchElement.isOn = true
                }
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
        SettingTableCell(labelText: LocalesManager.s.get(.setting5), buttonText: LocalesManager.s.get(.clear)) { [weak self] button in
            RemoteDataManager.s.resetAllCachedImages()
            self?.showToast(text: LocalesManager.s.get(.imagesCacheRemoved))
        },
        SettingTableCell(labelText: LocalesManager.s.get(.setting6), buttonText: LocalesManager.s.get(.clear)) { [weak self] button in
            PlayerItemsManager.s.resetAllCachedItems()
            self?.showToast(text: LocalesManager.s.get(.tracksCacheRemoved))
        }
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.s.get(.titleSMain)
        settingsTable.allowsSelection = false
        if #available(iOS 11.0, *) {
            let offset: CGFloat = settingsTable.constraints.first(where: { $0.identifier == "topConstraint" })?.constant ?? 10
            settingsTable.contentInset = UIEdgeInsetsMake(topLayoutGuide.length + offset, 0, bottomLayoutGuide.length + offset, 0)
        }
    }
    
    func showToast(text: String) {
        view.makeToast(text, duration: 2.0, position: .top)
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
