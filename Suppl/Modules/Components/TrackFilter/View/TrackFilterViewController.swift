import Foundation
import UIKit
import SwiftTheme

class TrackFilterViewController: UIViewController, TrackFilterViewControllerProtocol {
    
    var presenter: TrackFilterPresenterProtocol!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchTitleSwitch: UISwitch!
    @IBOutlet weak var searchPerformerSwitch: UISwitch!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        timeSlider.isEnabled = false
        searchTitleSwitch.isEnabled = false
        searchPerformerSwitch.isEnabled = false
        okButton.isEnabled = false
        okButton.isHidden = true
    }
    
    func setTheme() {
        okButton.theme_tintColor = "secondColor"
        searchTitleSwitch.theme_onTintColor = "secondColor"
        searchPerformerSwitch.theme_onTintColor = "secondColor"
        timeSlider.theme_tintColor = "secondColor"
    }
    
    func timeValue(_ value: Float) {
        timeSlider.value = value
    }
    
    func timeIsEnabled(_ isEnabled: Bool) {
        timeSlider.isEnabled = isEnabled
    }
    
    func titleValue(_ value: Bool) {
        searchTitleSwitch.isOn = value
    }
    
    func titleIsEnabled(_ isEnabled: Bool) {
        searchTitleSwitch.isEnabled = isEnabled
    }
    
    func performerValue(_ value: Bool) {
        searchPerformerSwitch.isOn = value
    }
    
    func performerIsEnabled(_ isEnabled: Bool) {
        searchPerformerSwitch.isEnabled = isEnabled
    }
    
    @IBAction func timeChange(_ sender: Any) {
        presenter.timeCallbackFunc(&timeSlider.value)
    }
    @IBAction func titleChange(_ sender: Any) {
        presenter.titleCallbackFunc(&searchTitleSwitch.isOn)
    }
    @IBAction func performerChange(_ sender: Any) {
        presenter.performerCallbackFunc(&searchTitleSwitch.isOn)
    }
}
