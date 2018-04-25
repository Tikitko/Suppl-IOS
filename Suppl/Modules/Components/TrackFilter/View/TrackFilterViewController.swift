import Foundation
import UIKit
import SwiftTheme

class TrackFilterViewController: UIViewController, TrackFilterViewControllerProtocol {
    
    var presenter: TrackFilterPresenterProtocol!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchTitleSwitch: UISwitch!
    @IBOutlet weak var searchPerformerSwitch: UISwitch!
    @IBOutlet weak var okButton: UIButton!
    
    var config: FilterConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        okButton.isEnabled = false
        okButton.isHidden = true
        
        guard let c = config else { return }
        timeSlider.value = c.timeValue
        searchTitleSwitch.isOn = c.titleValue
        searchPerformerSwitch.isOn = c.performerValue
        timeSlider.isEnabled = true
        searchTitleSwitch.isEnabled = true
        searchPerformerSwitch.isEnabled =  true
    }
    
    func setTheme() {
        okButton.theme_tintColor = "secondColor"
        searchTitleSwitch.theme_onTintColor = "secondColor"
        searchPerformerSwitch.theme_onTintColor = "secondColor"
        timeSlider.theme_tintColor = "secondColor"
    }
    
    @IBAction func timeChange(_ sender: Any) {
        config?.delegate.timeChange(&timeSlider.value)
    }
    @IBAction func titleChange(_ sender: Any) {
        config?.delegate.titleChange(&searchTitleSwitch.isOn)
    }
    @IBAction func performerChange(_ sender: Any) {
        config?.delegate.performerChange(&searchPerformerSwitch.isOn)
    }
}
