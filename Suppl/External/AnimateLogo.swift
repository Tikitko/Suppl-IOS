import Foundation
import UIKit

class AnimateLogo {
    
    private(set) var view: UIView!
    private var layer: CAShapeLayer!
    
    private var continueAnimation = true
    
    private let color: UIColor
    
    init(_ text: String, color: UIColor, fontName: String = "System", fontSize: CGFloat = 60) {
        self.color = color
        let wordBezierPath = AnimateLogo.getPathForWord(text, font: CTFontCreateWithName(fontName as CFString, fontSize, nil), spacing: fontSize / 10)
        let (view, layer) = getViewWithPath(wordBezierPath)
        self.view = view
        self.layer = layer
    }
    
    public static func getPathForLetter(_ letter: Character, font: CTFont) -> UIBezierPath {
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
    
    public static func getPathForWord(_ word: String, font: CTFont, spacing: CGFloat = 10) -> UIBezierPath {
        let path = UIBezierPath()
        var i: CGFloat = 0
        for letter in word {
            let newPath = getPathForLetter(letter, font: font)
            let actualPathRect = path.cgPath.boundingBox
            let transform = CGAffineTransform(translationX: (actualPathRect.width + min(i, 1) * spacing), y: 0)
            newPath.apply(transform)
            path.append(newPath)
            i += 1
        }
        path.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
        path.apply(CGAffineTransform(translationX: 0, y: path.bounds.height))
        return path
    }
    
    private func getViewWithPath(_ wordBezierPath: UIBezierPath) -> (UIView, CAShapeLayer) {
        let layer = CAShapeLayer()
        layer.path = wordBezierPath.cgPath
        layer.lineWidth = 2
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        
        let pathBounds = wordBezierPath.cgPath.boundingBoxOfPath
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: pathBounds.size))
        layer.position = CGPoint(x: -pathBounds.origin.x, y: -pathBounds.origin.y)
        view.layer.addSublayer(layer)
        
        return (view, layer)
    }
    
    private func createAnim() -> CAAnimation {
        let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let closeAnimation = CABasicAnimation(keyPath: "strokeStart")
        closeAnimation.fromValue = 0
        closeAnimation.toValue = 1
        closeAnimation.beginTime = 0
        closeAnimation.duration = 0.5
        closeAnimation.timingFunction = easeOut
        
        let closeColorAnimation = CABasicAnimation(keyPath: "fillColor")
        closeColorAnimation.fromValue = color.cgColor
        closeColorAnimation.toValue = UIColor.clear.cgColor
        closeColorAnimation.fillMode = kCAFillModeForwards
        closeColorAnimation.isRemovedOnCompletion = false
        closeColorAnimation.beginTime = 0
        closeColorAnimation.duration = 0.2
        closeColorAnimation.timingFunction = easeOut
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.beginTime = 0.5
        animation.duration = 1.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = easeOut
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = color.cgColor
        colorAnimation.fillMode = kCAFillModeForwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.beginTime = 2
        colorAnimation.duration = 0.2
        colorAnimation.timingFunction = easeOut
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3.5;
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
            guard let `self` = self else { return }
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.layer.strokeEnd = 1
            self.layer.fillColor = self.color.cgColor
            CATransaction.setValue(kCFBooleanFalse, forKey: kCATransactionDisableActions)
            self.startAnim()
        }
        layer.add(createAnim(), forKey: nil)
        CATransaction.commit()
    }
    
    public func stopAnim() {
        continueAnimation = false
        layer.removeAllAnimations()
    }
    
}
