import UIKit
import SwiftTheme

class SettingTableCell: UITableViewCell {
    
    enum ControlType {
        case button
        case `switch`
    }
    
    static let identifier = String(describing: SettingTableCell.self)
    
    private var settingLabel: UILabel = UILabel()
    public var controlType: ControlType
    private var settingControl: UIControl
    private var settingControlCallback: (_ control: UIControl) -> Void
    
    init(labelText: String, controlType: ControlType, controlCallback: @escaping (_ control: UIControl) -> Void) {
        self.controlType = controlType
        settingControlCallback = controlCallback
        switch controlType {
        case .button:
            settingControl = UIButton(type: .system)
        case .switch:
            settingControl = UISwitch()
        }
        super.init(style: .default, reuseIdentifier: nil)
        switch controlType {
        case .button:
            let settingButton = settingControl as! UIButton
            settingButton.addTarget(self, action: #selector(settingControlCallback(_:)), for: .touchUpInside)
            settingButton.theme_tintColor = "secondColor"
            settingButton.translatesAutoresizingMaskIntoConstraints = false
            settingButton.titleLabel?.lineBreakMode = .byTruncatingTail
            addSubview(settingButton)
        case .switch:
            let settingSwitch = settingControl as! UISwitch
            settingSwitch.addTarget(self, action: #selector(settingControlCallback(_:)), for: .valueChanged)
            settingSwitch.theme_onTintColor = "secondColor"
            settingSwitch.translatesAutoresizingMaskIntoConstraints = false
            addSubview(settingSwitch)
        }
        settingLabel.text = labelText
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingLabel)
        setConstraints()
    }
    
    convenience init(labelText: String, buttonText: String, buttonCallback: @escaping (_ button: UIButton) -> Void) {
        self.init(labelText: labelText, controlType: .button) { buttonCallback($0 as! UIButton) }
        (settingControl as! UIButton).setTitle(buttonText, for: .normal)
    }
    
    convenience init(labelText: String, switchValue: Bool, switchCallback: @escaping (_ switch: UISwitch) -> Void) {
        self.init(labelText: labelText, controlType: .switch) { switchCallback($0 as! UISwitch) }
        (settingControl as! UISwitch).isOn = switchValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func settingControlCallback(_ control: UIControl) {
        settingControlCallback(control)
    }
    
    private func setConstraints() {
        let allViews: [String:UIView] = ["label": settingLabel, "element": settingControl]
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options:[], metrics: nil, views: allViews)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[element]-|", options:[], metrics: nil, views: allViews)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-[element(50)]-|", options: .alignAllCenterY, metrics: nil, views: allViews)
        addConstraints(constraints)
        updateConstraints()
    }
    
}
