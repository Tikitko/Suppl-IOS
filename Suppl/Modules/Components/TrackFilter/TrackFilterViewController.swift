import Foundation
import UIKit
import SwiftTheme

class TrackFilterViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchTitleSwitch: UISwitch!
    @IBOutlet weak var searchPerformerSwitch: UISwitch!
    @IBOutlet weak var okButton: UIButton!
    
    private var timeCallback: ((_:inout Float) -> Void)?
    private var titleCallback: ((_: inout Bool) -> Void)?
    private var performerCallback: ((_:inout Bool) -> Void)?
    private var okCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        timeSlider.isEnabled = false
        searchTitleSwitch.isEnabled = false
        searchPerformerSwitch.isEnabled = false
        okButton.isEnabled = false
        okButton.isHidden = true
    }
    
    private func setTheme() {
        okButton.theme_tintColor = "secondColor"
        searchTitleSwitch.theme_onTintColor = "secondColor"
        searchPerformerSwitch.theme_onTintColor = "secondColor"
        timeSlider.theme_tintColor = "secondColor"
    }
    
    public func timeValue(_ value: Float) {
        timeSlider.value = value
    }
    
    public func timeCallback(_ timeCallback: @escaping ((_: inout Float) -> Void)) {
        self.timeCallback = timeCallback
        timeSlider.isEnabled = true
    }
    
    public func titleValue(_ value: Bool) {
        searchTitleSwitch.isOn = value
    }
    
    public func titleCallback(_ titleCallback: @escaping ((_: inout Bool) -> Void)) {
        self.titleCallback = titleCallback
        searchTitleSwitch.isEnabled = true
    }
    
    public func performerValue(_ value: Bool) {
        searchPerformerSwitch.isOn = value
    }
    
    public func performerCallback(_ performerCallback: @escaping ((_: inout Bool) -> Void)) {
        self.performerCallback = performerCallback
        searchPerformerSwitch.isEnabled = true
    }
    
    public func okTitle(_ text: String) {
        okButton.setTitle(text, for: .normal)
    }
    
    public func okCallback(_ okCallback: @escaping (() -> Void)) {
        self.okCallback = okCallback
        okButton.isEnabled = true
    }
    
    @IBAction func timeChange(_ sender: Any) {
        guard let timeCallback = timeCallback else { return }
        timeCallback(&timeSlider.value)
    }
    @IBAction func titleChange(_ sender: Any) {
        guard let titleCallback = titleCallback else { return }
        titleCallback(&searchTitleSwitch.isOn)
    }
    @IBAction func performerChange(_ sender: Any) {
        guard let performerCallback = performerCallback else { return }
        performerCallback(&searchTitleSwitch.isOn)
    }
    @IBAction func okButtonClick(_ sender: Any) {
        guard let okCallback = okCallback else { return }
        okCallback()
    }
}
