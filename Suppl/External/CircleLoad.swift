import UIKit
import GLKit

class CircleLoad: UIView {
    
    private let offset: Float = 89.9
    
    private let centerX: CGFloat
    private let centerY: CGFloat
    private var radius: CGFloat
    private var lineWidth: CGFloat
    private var color: CGColor
    
    private var _currentAngle: Float {
        didSet { setNeedsDisplay() }
    }
    public var currentAngle: Float {
        set(value) { _currentAngle = value - offset }
        get { return _currentAngle }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(AppStaticData.Consts.initCoderNotImplemented)
    }
    
    private override init(frame: CGRect) {
        centerX = frame.width / 2
        centerY = frame.height / 2
        radius = centerY < centerX ? centerY : centerX
        _currentAngle = offset
        lineWidth = 1
        color = UIColor.black.cgColor
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    convenience init(frame: CGRect, radiusOffset: Float, lineWidth: Float = 1, color: UIColor) {
        self.init(frame: frame)
        radius -= CGFloat(radiusOffset)
        self.lineWidth = CGFloat(lineWidth)
        self.color = color.cgColor
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = CGMutablePath()
        context.addArc(
            center: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: -CGFloat(Double.pi/2),
            endAngle: CGFloat(GLKMathDegreesToRadians(_currentAngle)),
            clockwise: false
        )
        context.addPath(path)
        context.setStrokeColor(color)
        context.setLineWidth(lineWidth)
        context.strokePath()
    }

}
