import Foundation
import UIKit

final class AnimateLogoView: UIView {
    
    private weak var shapeLayer: CAShapeLayer?
    
    private var continueAnimation = true
    
    private let color: UIColor
    private let lineWidth: CGFloat
    
    init(_ text: String, color: UIColor, fontName: String = "System", fontSize: CGFloat = 60, lineWidth: CGFloat = 2) {
        self.color = color
        self.lineWidth = lineWidth
        
        let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
        let wordBezierPath = type(of: self).path(word: text, font: font, spacing: fontSize / 10)
        let wordPathBounds = wordBezierPath.cgPath.boundingBoxOfPath
        
        let layer = CAShapeLayer()
        layer.path = wordBezierPath.cgPath
        layer.lineWidth = lineWidth
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        layer.position = CGPoint(x: -wordPathBounds.origin.x, y: -wordPathBounds.origin.y)
        self.shapeLayer = layer
        
        super.init(frame: CGRect(origin: .zero, size: wordPathBounds.size))
        self.layer.addSublayer(layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func path(letter: Character, font: CTFont) -> UIBezierPath {
        var path = UIBezierPath()
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath(cgPath: cgpath!)
        }
        return path
    }
    
    public static func path(word: String, font: CTFont, spacing: CGFloat = 10) -> UIBezierPath {
        let _path = UIBezierPath()
        var i: CGFloat = 0
        for letter in word {
            let newPath = path(letter: letter, font: font)
            let actualPathRect = _path.cgPath.boundingBox
            let transform = CGAffineTransform(translationX: (actualPathRect.width + min(i, 1) * spacing), y: 0)
            newPath.apply(transform)
            _path.append(newPath)
            i += 1
        }
        _path.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
        _path.apply(CGAffineTransform(translationX: 0, y: _path.bounds.height))
        return _path
    }
    
    private func createAnim() -> CAAnimation {
        let easeOut = CAMediaTimingFunction(name: .easeOut)
        
        let closeAnimation = CABasicAnimation(keyPath: "strokeStart")
        closeAnimation.fromValue = 0
        closeAnimation.toValue = 1
        closeAnimation.beginTime = 0
        closeAnimation.duration = 0.5
        closeAnimation.timingFunction = easeOut
        
        let closeColorAnimation = CABasicAnimation(keyPath: "fillColor")
        closeColorAnimation.fromValue = color.cgColor
        closeColorAnimation.toValue = UIColor.clear.cgColor
        closeColorAnimation.fillMode =  .forwards
        closeColorAnimation.isRemovedOnCompletion = false
        closeColorAnimation.beginTime = 0
        closeColorAnimation.duration = 0.2
        closeColorAnimation.timingFunction = easeOut
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.beginTime = 0.5
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = easeOut
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = color.cgColor
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.beginTime = 2
        colorAnimation.duration = 0.2
        colorAnimation.timingFunction = easeOut
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3.5
        animationGroup.animations = [closeAnimation, closeColorAnimation, animation, colorAnimation]
        
        return animationGroup
    }
    
    public func startAnim() {
        guard continueAnimation else {
            continueAnimation = true
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock() { [weak self] in
            guard let self = self else { return }
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.shapeLayer?.strokeEnd = 1
            self.shapeLayer?.fillColor = self.color.cgColor
            CATransaction.setValue(kCFBooleanFalse, forKey: kCATransactionDisableActions)
            self.startAnim()
        }
        shapeLayer?.add(createAnim(), forKey: nil)
        CATransaction.commit()
    }
    
    public func stopAnim() {
        continueAnimation = false
        layer.removeAllAnimations()
    }
    
}
