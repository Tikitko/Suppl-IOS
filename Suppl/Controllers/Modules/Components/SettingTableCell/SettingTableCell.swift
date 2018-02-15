import UIKit
import SwiftTheme

class SettingTableCell: UITableViewCell {
    
    static let identifier = String(describing: SettingTableCell.self)
    
    private var settingLabel: UILabel = UILabel()
    
    private var settingSwitch: UISwitch? = nil
    private var settingSwitchCallback: ((_ switch:UISwitch) -> Void)? = nil
    
    private var settingButton: UIButton? = nil
    private var settingButtonCallback: ((_ button:UIButton) -> Void)? = nil
    
    convenience init(labelText: String, buttonText:String, buttonCallback: @escaping (_ button:UIButton) -> Void) {
        self.init(style: .default, reuseIdentifier: nil)
        settingButtonCallback = buttonCallback
        
        initLabel(text: labelText)
        
        settingButton = UIButton(type: .system)
        settingButton?.addTarget(self, action: #selector(settingButtonClick(_:)), for: .touchUpInside)
        settingButton?.setTitle(buttonText, for: .normal)
        settingButton?.theme_tintColor = "secondColor"
        settingButton?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingButton!)
        
        setConstraints()
    }
    
    convenience init(labelText: String, switchValue: Bool, switchCallback: @escaping (_ switch:UISwitch) -> Void) {
        self.init(style: .default, reuseIdentifier: nil)
        settingSwitchCallback = switchCallback
        
        initLabel(text: labelText)
        
        settingSwitch = UISwitch()
        settingSwitch?.addTarget(self, action: #selector(settingSwitchValueChange(_:)), for: .valueChanged)
        settingSwitch?.setOn(switchValue, animated: false)
        settingSwitch?.theme_onTintColor = "secondColor"
        settingSwitch?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingSwitch!)
        
        setConstraints()
    }
    
    private func initLabel(text: String) {
        settingLabel.text = text
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingLabel)
    }
    
    private func setConstraints() {
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        var allViews: [String:UIView] = ["label":settingLabel]
        if let settingButton = settingButton {
            allViews["element"] = settingButton
        } else if let settingSwitch = settingSwitch {
            allViews["element"] = settingSwitch
        } else {
            return
        }
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options:[], metrics: nil, views: allViews)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[element]-|", options:[], metrics: nil, views: allViews)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-[element(50)]-|", options: .alignAllCenterY, metrics: nil, views: allViews)
        addConstraints(constraints)
        updateConstraints()

    }
    
    @objc private func settingButtonClick(_ sender:UIButton)
    {
        guard let settingButtonCallback = settingButtonCallback, let settingButton = settingButton else { return }
        settingButtonCallback(settingButton)
    }
    
    @objc private func settingSwitchValueChange(_ sender:UISwitch)
    {
        guard let settingSwitchCallback = settingSwitchCallback, let settingSwitch = settingSwitch else { return }
        settingSwitchCallback(settingSwitch)
    }
}


