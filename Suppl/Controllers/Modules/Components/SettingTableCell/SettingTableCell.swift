import UIKit

class SettingTableCell: UITableViewCell {
    
    static let identifier = String(describing: TrackTableCell.self)
    
    private var settingLabel: UILabel? = nil
    private var settingSwitch: UISwitch? = nil
    private var settingPicker: UIPickerView? = nil
    
    convenience init(picker: Bool = false) {
        self.init()
        settingLabel = UILabel()
        if picker {
            settingPicker = UIPickerView()
            return
        }
        settingSwitch = UISwitch()
    }
    
}
