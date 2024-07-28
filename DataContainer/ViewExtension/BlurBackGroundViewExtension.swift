//
//  ViewExtension.swift
//  zabihah
//
//  Created by Shakeel Ahmed on 08/07/2024.
//

import Foundation
import UIKit

extension UIView {
    func drawBackgroundBlur(withTag: Int) {
        lazy var blurredView: UIView = {
            // 1. create container view
            let containerView = UIView()
            // 2. create custom blur view
            let blurEffect = UIBlurEffect(style: .extraLight)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
            dimmedView.backgroundColor = .black.withAlphaComponent(0.1)
            dimmedView.frame = self.bounds
            
            // 4. add both as subviews
            containerView.addSubview(customBlurEffectView)
            containerView.addSubview(dimmedView)
            return containerView
        }()
        
//        self.backgroundColor = UIColor.clear
//        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .extraDark))
//        blurredView.frame = self.bounds
        blurredView.tag = withTag
        self.insertSubview(blurredView, at: 0)
    }
    func getScreenshot() -> UIImage? {
        //creates new image context with same size as view
        // UIGraphicsBeginImageContextWithOptions (scale=0.0) for high res capture
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0)

        // renders the view's layer into the current graphics context
        if let context = UIGraphicsGetCurrentContext() { self.layer.render(in: context) }

        // creates UIImage from what was drawn into graphics context
        let screenshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        // clean up newly created context and return screenshot
        UIGraphicsEndImageContext()
        return screenshot
    }
}
final class CustomVisualEffectView: UIVisualEffectView {
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}

class ViewBackGroundContinueButton : UIView {
    //initWithFrame to init view from code
    override init(frame: CGRect) {
      super.init(frame: frame)
      
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    //common func to init our view
    private func setupView() {
        self.circle()
    }
  }

class ViewRadius6 : UIView {
    //initWithFrame to init view from code
    override init(frame: CGRect) {
      super.init(frame: frame)
      
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    //common func to init our view
    private func setupView() {
        self.radius(radius: 6)
    }
  }
