//
//  Ring.swift
//  FaveButton
//
// Copyright © 2016 Jansel Valentin.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class Ring: UIView {
    
    fileprivate struct Const{
        static let collapseAnimation = "collapseAnimation"
        static let sizeKey           = "sizeKey"
    }
    
    var fillColor: UIColor!
    var radius: CGFloat!
    var lineWidth: CGFloat!
    var ringLayer: CAShapeLayer!
    
    init(radius: CGFloat, lineWidth:CGFloat, fillColor: UIColor) {
        self.fillColor = fillColor
        self.radius    = radius
        self.lineWidth = lineWidth
        super.init(frame: CGRect.zero)
        
        applyInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: create
extension Ring{
    
    class func createRing(_ faveButton: FaveButton, radius: CGFloat, lineWidth: CGFloat, fillColor: UIColor) -> Ring{
        
        let ring = Init(Ring(radius: radius, lineWidth:lineWidth, fillColor: fillColor)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor                           = .clear
        }
        
        faveButton.superview?.insertSubview(ring, belowSubview: faveButton)
        
        (ring,faveButton) >>- [.centerX, .centerY]
        
        attributes(.width, .height).forEach{ attr in
            ring >>- {
                $0.attribute  = attr
                $0.constant   = radius * 2
                $0.identifier = Const.sizeKey
            }
        }
        
        return ring
    }
    
    
    fileprivate func applyInit(){
        let centerView = Init(UIView(frame: CGRect.zero)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor                           = .clear
        }
        self.addSubview(centerView)
        
        (centerView, self) >>- [ .centerY, .centerX ]
        
        centerView >>- [.width, .height]
        
        let circle = createRingLayer(radius, lineWidth: lineWidth, fillColor: .clear, strokeColor: fillColor)
        centerView.layer.addSublayer(circle)
        
        self.ringLayer = circle
    }
    
    
    fileprivate func createRingLayer(_ radius: CGFloat, lineWidth: CGFloat, fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer{
        let circle = UIBezierPath(arcCenter: CGPoint.zero, radius: radius - lineWidth/2, startAngle: 0, endAngle: 2*(.pi), clockwise: true)
        
        let ring = Init(CAShapeLayer()){
            $0.path         = circle.cgPath
            $0.fillColor    = fillColor.cgColor
            $0.lineWidth    = 0
            $0.strokeColor  = strokeColor.cgColor
        }
        return ring
    }
}

// MARK : animation
extension Ring{
    
    func animateToRadius(_ radius: CGFloat, toColor: UIColor, duration: Double, delay: Double = 0){
        self.layoutIfNeeded()
        
        self.constraints.filter{ $0.identifier == Const.sizeKey }.forEach{
            $0.constant = radius * 2
        }
        
        let fittedRadius = radius - lineWidth/2
        
        let fillColorAnimation  = animationFillColor(self.fillColor, toColor: toColor, duration: duration, delay: delay)
        let lineWidthAnimation  = animationLineWidth(lineWidth, duration: duration, delay: delay)
        let lineColorAnimation  = animationStrokeColor(toColor, duration: duration, delay: delay)
        let circlePathAnimation = animationCirclePath(fittedRadius, duration: duration, delay: delay)
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveLinear,
            animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        
    
        ringLayer.add(fillColorAnimation, forKey: nil)
        ringLayer.add(lineWidthAnimation, forKey: nil)
        ringLayer.add(lineColorAnimation, forKey: nil)
        ringLayer.add(circlePathAnimation, forKey: nil)
    }
    
    
    func animateColapse(_ radius: CGFloat, duration: Double, delay: Double = 0){
        let lineWidthAnimation  = animationLineWidth(0, duration: duration, delay: delay)
        let circlePathAnimation = animationCirclePath(radius, duration: duration, delay: delay)
     
        circlePathAnimation.delegate = self
        circlePathAnimation.setValue(Const.collapseAnimation, forKey: Const.collapseAnimation)
        
        ringLayer.add(lineWidthAnimation, forKey: nil)
        ringLayer.add(circlePathAnimation, forKey: nil)
    }
    
    
    fileprivate func animationFillColor(_ fromColor:UIColor, toColor: UIColor, duration: Double, delay: Double = 0) -> CABasicAnimation{
        let animation = Init(CABasicAnimation(keyPath: "fillColor")){
            $0.fromValue      = fromColor.cgColor
            $0.toValue        = toColor.cgColor
            $0.duration       = duration
            $0.beginTime      = CACurrentMediaTime() + delay
            #if swift(>=4.2)
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            #else
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            #endif
            
        }
        
        return animation
    }
    
    
    fileprivate func animationStrokeColor(_ strokeColor: UIColor, duration: Double, delay: Double) -> CABasicAnimation{
        let animation = Init(CABasicAnimation(keyPath: "strokeColor")){
            $0.toValue             = strokeColor.cgColor
            $0.duration            = duration
            $0.beginTime           = CACurrentMediaTime() + delay
            #if swift(>=4.2)
            $0.fillMode            = CAMediaTimingFillMode.forwards
            $0.timingFunction      = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            #else
            $0.fillMode            = kCAFillModeForwards
            $0.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            #endif
            $0.isRemovedOnCompletion = false
            
        }
        return animation
    }
    
    
    fileprivate func animationLineWidth(_ lineWidth: CGFloat, duration: Double, delay: Double = 0) -> CABasicAnimation{
        let animation = Init(CABasicAnimation(keyPath: "lineWidth")){
            $0.toValue              = lineWidth
            $0.duration             = duration
            $0.beginTime            = CACurrentMediaTime() + delay
            $0.isRemovedOnCompletion  = false
            #if swift(>=4.2)
            $0.fillMode             = CAMediaTimingFillMode.forwards
            $0.timingFunction       = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            #else
            $0.fillMode             = kCAFillModeForwards
            $0.timingFunction       = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            #endif
        }
        return animation
    }
    
    
    fileprivate func animationCirclePath(_ radius: CGFloat, duration: Double, delay: Double) -> CABasicAnimation{
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: 2*(.pi), clockwise: true)
        
        let animation = Init(CABasicAnimation(keyPath: "path")){
            $0.toValue              = path.cgPath
            $0.duration             = duration
            $0.beginTime            = CACurrentMediaTime() + delay
            $0.isRemovedOnCompletion  = false
            #if swift(>=4.2)
            $0.fillMode             = CAMediaTimingFillMode.forwards
            $0.timingFunction       = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            #else
            $0.fillMode             = kCAFillModeForwards
            $0.timingFunction       = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            #endif
        }
        return animation
    }
}


// MARK: CAAnimationDelegate
extension Ring : CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let _ = anim.value(forKey: Const.collapseAnimation){
            self.removeFromSuperview()
        }
    }
}


