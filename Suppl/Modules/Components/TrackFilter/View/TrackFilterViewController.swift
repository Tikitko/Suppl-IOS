import Foundation
import UIKit
import SwiftTheme

class TrackFilterViewController: UIViewController, TrackFilterViewControllerProtocol {
    
    var presenter: TrackFilterPresenterProtocolView!
    
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
        
        let titles = presenter.getAllLocalizedStrings()
        
        titleLabel.text = titles[.filterTitle]
        timeLabel.text = titles[.filterTime]
        searchLabel.text = titles[.filterSearch]
        searchTLabel.text = titles[.filterSearchT]
        searchPLabel.text = titles[.filterSearchP]
        okButton.setTitle(titles[.filterOK], for: .normal)
        
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
