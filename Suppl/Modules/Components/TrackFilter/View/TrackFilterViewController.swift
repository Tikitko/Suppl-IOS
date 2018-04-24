import Foundation
import UIKit
import SwiftTheme

class TrackFilterViewController: UIViewController, TrackFilterViewControllerProtocol {
    
    var presenter: TrackFilterPresenterProtocol!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchTitleSwitch: UISwitch!
    @IBOutlet weak var searchPerformerSwitch: UISwitch!
    @IBOutlet weak var okButton: UIButton!
    
    var defaultValues: FilterDefaultValues?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        if let df = defaultValues {
            timeSlider.value = df.timeValue
            searchTitleSwitch.isOn = df.titleValue
            searchPerformerSwitch.isOn = df.performerValue
        }
        timeSlider.isEnabled = true
        searchTitleSwitch.isEnabled = true
        searchPerformerSwitch.isEnabled =  true
        okButton.isEnabled = false
        okButton.isHidden = true
    }
    
    func setTheme() {
        okButton.theme_tintColor = "secondColor"
        searchTitleSwitch.theme_onTintColor = "secondColor"
        searchPerformerSwitch.theme_onTintColor = "secondColor"
        timeSlider.theme_tintColor = "secondColor"
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
