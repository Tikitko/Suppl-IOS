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
        okButton.isEnabled = false
        okButton.isHidden = true
        
        
        timeSlider.value = presenter.timeValue() ?? 1
        searchTitleSwitch.isOn = presenter.titleValue() ?? true
        searchPerformerSwitch.isOn = presenter.performerValue() ?? true
 
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
        presenter.timeChange(&timeSlider.value)
    }
    @IBAction func titleChange(_ sender: Any) {
        presenter.titleChange(&searchTitleSwitch.isOn)
    }
    @IBAction func performerChange(_ sender: Any) {
        presenter.performerChange(&searchPerformerSwitch.isOn)
    }
}
