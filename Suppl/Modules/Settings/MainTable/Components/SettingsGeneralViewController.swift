import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    private lazy var settingsCells: [UITableViewCell] = [
        SettingTableCell(labelText: LocalesManager.shared.get(.setting0), switchValue: SettingsManager.shared.autoNextTrack) { switchElement in
            SettingsManager.shared.autoNextTrack = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting1), switchValue: SettingsManager.shared.loadImages) { switchElement in
            SettingsManager.shared.loadImages = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting2), switchValue: SettingsManager.shared.roundIcons) { switchElement in
            SettingsManager.shared.roundIcons = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting7), switchValue: SettingsManager.shared.smallCell) { switchElement in
            SettingsManager.shared.smallCell = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting8), switchValue: SettingsManager.shared.hideLogo) { switchElement in
            SettingsManager.shared.hideLogo = switchElement.isOn
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting4), switchValue: OfflineModeManager.shared.offlineMode) { switchElement in
            if switchElement.isOn {
                OfflineModeManager.shared.on()
            } else {
                OfflineModeManager.shared.off()
                if OfflineModeManager.shared.offlineMode {
                    switchElement.isOn = true
                }
            }
        },
        {
            let themes = AppStaticData.themesList
            var themeId: Int = themes.count > SettingsManager.shared.theme ? SettingsManager.shared.theme : 0
            return SettingTableCell(labelText: LocalesManager.shared.get(.setting3), buttonText: themes[themeId]) { button in
                themeId = themes.count > themeId + 1 ? themeId + 1 : 0
                button.setTitle(themes[themeId], for: .normal)
                SettingsManager.shared.theme = themeId
            }
        }(),
        SettingTableCell(labelText: LocalesManager.shared.get(.setting5), buttonText: LocalesManager.shared.get(.clear)) { [weak self] button in
            RemoteDataManager.shared.resetAllCachedImages()
            NotificationCenter.default.post(name: .imagesCacheRemoved, object: nil, userInfo: nil)
            self?.showToast(text: LocalesManager.shared.get(.imagesCacheRemoved))
        },
        SettingTableCell(labelText: LocalesManager.shared.get(.setting6), buttonText: LocalesManager.shared.get(.clear)) { [weak self] button in
            PlayerItemsManager.shared.resetAllCachedItems()
            NotificationCenter.default.post(name: .tracksCacheRemoved, object: nil, userInfo: nil)
            self?.showToast(text: LocalesManager.shared.get(.tracksCacheRemoved))
        }
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.shared.get(.titleSMain)
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

extension Notification.Name {
    static let imagesCacheRemoved = Notification.Name("ImagesCacheRemoved")
    static let tracksCacheRemoved = Notification.Name("TracksCacheRemoved")
}
