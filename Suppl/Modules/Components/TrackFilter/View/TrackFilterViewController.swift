import Foundation
import UIKit

class TrackFilterViewController: ViperDefaultView<TrackFilterPresenterProtocolView>, TrackFilterViewControllerProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTLabel: UILabel!
    @IBOutlet weak var searchPLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var searchTitleSwitch: UISwitch!
    @IBOutlet weak var searchPerformerSwitch: UISwitch!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        titleLabel.text = "filterTitle".localizeKey
        timeLabel.text = "filterTime".localizeKey
        searchLabel.text = "filterSearch".localizeKey
        searchTLabel.text = "filterSearchT".localizeKey
        searchPLabel.text = "filterSearchP".localizeKey
        okButton.setTitle("filterOK".localizeKey, for: .normal)
        
        okButton.isEnabled = false
        okButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        timeSlider.value = presenter.timeValue() ?? 1
        searchTitleSwitch.isOn = presenter.titleValue() ?? true
        searchPerformerSwitch.isOn = presenter.performerValue() ?? true
    }
    
    func setTheme() {
        okButton.theme_tintColor = UIColor.Theme.second.picker
        searchTitleSwitch.theme_onTintColor = UIColor.Theme.second.picker
        searchPerformerSwitch.theme_onTintColor = UIColor.Theme.second.picker
        timeSlider.theme_tintColor = UIColor.Theme.second.picker
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
