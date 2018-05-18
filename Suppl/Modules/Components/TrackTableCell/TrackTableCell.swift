import UIKit

class TrackTableCell: UITableViewCell {
    
    static let identifier = String(describing: TrackTableCell.self)

    var view: UIView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    private(set) var moduleNameId: String!
    
    private var baseImage = true
    private var cellTrackId: String?
    
    
    convenience init(cellModuleNameId: inout String) {
        self.init(style: .default, reuseIdentifier: TrackTableCell.identifier)
        baseSetting(cellModuleNameId: &cellModuleNameId)
    }
    
    private override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var temp = ""
        baseSetting(cellModuleNameId: &temp)
    }
    
    func xibSetup() {
        view = UINib(nibName: TrackTableCell.identifier, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view);
    }
    
    private func baseSetting(cellModuleNameId: inout String) {
        xibSetup()
        let tempId = String(describing: "\(NSStringFromClass(type(of: self)))-\(arc4random_uniform(1000000001))")
        cellModuleNameId = cellModuleNameId != "" ? tempId + "-" + cellModuleNameId : tempId
        moduleNameId = cellModuleNameId
        PlayerManager.s.setListener(name: moduleNameId, delegate: self)
        ModulesCommunicateManager.s.setListener(name: moduleNameId, delegate: self)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        baseImage = true
        trackTitle.text = nil
        trackPerformer.text = nil
        trackDuration.text = nil
        trackImage.image = #imageLiteral(resourceName: "cd")
        cellTrackId = nil
        backgroundColor = nil
    }
    
    private func setImage(image: UIImage) {
        guard baseImage else { return }
        baseImage = false
        trackImage.image = image
    }
    
    private func loadImageType() {
        if SettingsManager.s.roundIcons! {
            trackImage.layer.cornerRadius = trackImage.frame.width / 2
            trackImage.clipsToBounds = true
        } else {
            trackImage.layer.cornerRadius = 5
            trackImage.clipsToBounds = true
        }
    }
    
    private func setSelectedIfCurrent(id: String? = nil, instantly: Bool = false) {
        let result = id != nil && id == cellTrackId ? UIColor(hue: 0.7778, saturation: 0, brightness: 0.96, alpha: 1.0) : nil
        if instantly {
            backgroundColor = result
        } else {
            setBackgroundColorWithAnimation(result)
        }
    }

    private func setBackgroundColorWithAnimation(_ color: UIColor?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = color
        }, completion: nil)
    }
    
}

extension TrackTableCell: PlayerListenerDelegate {
    
    func trackInfoChanged(_ track: CurrentTrack) {
        setSelectedIfCurrent(id: track.id)
    }
    
    func playlistRemoved() {
        setSelectedIfCurrent()
    }
    
}

extension TrackTableCell: TrackTableCellCommunicateProtocol {
    
    func setNewData(id: String, title: String, performer: String, duration: Int) {
        loadImageType()
        cellTrackId = id
        trackTitle.text = title
        trackPerformer.text = performer
        trackDuration.text = TrackTime(sec: duration).formatted
        setSelectedIfCurrent(id: PlayerManager.s.currentTrack?.id ?? "", instantly: true)
    }
    
    func setNewImage(imageData: NSData) {
        guard let image = UIImage(data: imageData as Data) else { return }
        setImage(image: image)
    }
    
}
