import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    private struct Constants {
        static let topConstraintIdentifier = "topConstraint"
    }
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    private lazy var settingsCells: [UITableViewCell] = [
        SettingTableCell(
            labelText: "setting0".localizeKey,
            switchValue: SettingsManager.shared.autoNextTrack.value,
            switchCallback: { SettingsManager.shared.autoNextTrack.value = $0.isOn }
        ),
        SettingTableCell(
            labelText: "setting1".localizeKey,
            switchValue: SettingsManager.shared.loadImages.value,
            switchCallback: { SettingsManager.shared.loadImages.value = $0.isOn }
        ),
        SettingTableCell(
            labelText: "setting2".localizeKey,
            switchValue: SettingsManager.shared.roundIcons.value,
            switchCallback: { SettingsManager.shared.roundIcons.value = $0.isOn }
        ),
        SettingTableCell(
            labelText: "setting7".localizeKey,
            switchValue: SettingsManager.shared.smallCell.value,
            switchCallback: { SettingsManager.shared.smallCell.value = $0.isOn }
        ),
        SettingTableCell(
            labelText: "setting8".localizeKey,
            switchValue: SettingsManager.shared.hideLogo.value,
            switchCallback: { SettingsManager.shared.hideLogo.value = $0.isOn }
        ),
        SettingTableCell(
            labelText: "setting4".localizeKey,
            switchValue: OfflineModeManager.shared.offlineMode,
            switchCallback: { switchElement in
                if switchElement.isOn {
                    OfflineModeManager.shared.on()
                } else {
                    OfflineModeManager.shared.off()
                    if OfflineModeManager.shared.offlineMode {
                        switchElement.isOn = true
                    }
                }
            }
        ),
        {
            let themes = AppDelegate.themesList
            var themeId: Int = themes.count > SettingsManager.shared.theme.value ? SettingsManager.shared.theme.value : 0
            return SettingTableCell(
                labelText: "setting3".localizeKey,
                buttonText: themes[themeId],
                buttonCallback: { button in
                    themeId = themes.count > themeId + 1 ? themeId + 1 : 0
                    button.setTitle(themes[themeId], for: .normal)
                    SettingsManager.shared.theme.value = themeId
                }
            )
        }(),
        SettingTableCell(
            labelText: "setting5".localizeKey,
            buttonText: "clear".localizeKey,
            buttonCallback: { [weak self] button in
                DataManager.shared.resetAllCachedImages()
                NotificationCenter.default.post(name: .imagesCacheRemoved, object: nil, userInfo: nil)
                self?.showToast(text: "imagesCacheRemoved".localizeKey)
            }
        ),
        SettingTableCell(
            labelText: "setting6".localizeKey,
            buttonText: "clear".localizeKey,
            buttonCallback: { [weak self] button in
                PlayerItemsManager.shared.resetAllCachedItems()
                NotificationCenter.default.post(name: .tracksCacheRemoved, object: nil, userInfo: nil)
                self?.showToast(text: "tracksCacheRemoved".localizeKey)
            }
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "titleSMain".localizeKey
        setVersionLabel()
        settingsTable.allowsSelection = false
        if #available(iOS 11.0, *) {
            let offset: CGFloat = settingsTable.constraints.first(where: { $0.identifier == Constants.topConstraintIdentifier })?.constant ?? 10
            settingsTable.contentInset = UIEdgeInsets(top: topLayoutGuide.length + offset, left: 0, bottom: bottomLayoutGuide.length + offset, right: 0)
        }
    }
    
    func setVersionLabel() {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        versionLabel.text = "\("appVersion".localizeKey) \(appVersion)"
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
