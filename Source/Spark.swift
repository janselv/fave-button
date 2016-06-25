//
//  Spark.swift
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

internal typealias DotRadius = (first: Double, second: Double)

class Spark: UIView {
    
    private struct Const{
        static let distance           = (vertical: 4.0, horizontal: 0.0)
        static let expandKey          = "expandKey"
        static let dotSizeKey         = "dotSizeKey"
    }
    
    
    var radius: CGFloat
    var firstColor: UIColor
    var secondColor: UIColor
    var angle: Double
    
    var dotRadius: DotRadius!
    
    private var dotFirst:  UIView!
    private var dotSecond: UIView!
    
    
    private var distanceConstraint: NSLayoutConstraint?
    
    init(radius: CGFloat, firstColor: UIColor, secondColor: UIColor, angle: Double, dotRadius: DotRadius){
        self.radius      = radius
        self.firstColor  = firstColor
        self.secondColor = secondColor
        self.angle       = angle
        self.dotRadius   = dotRadius
        super.init(frame: CGRectZero)
        
        applyInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: create
extension Spark{
    
    class func createSpark(faveButton: FaveButton, radius: CGFloat, firstColor: UIColor, secondColor: UIColor, angle: Double, dotRadius: DotRadius) -> Spark{
        
        let spark = Init(Spark(radius: radius, firstColor: firstColor, secondColor: secondColor, angle: angle, dotRadius: dotRadius)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor                           = .clearColor()
            $0.layer.anchorPoint                         = CGPoint(x: 0.5, y: 1)
            $0.alpha                                     = 0.0
        }
        faveButton.superview?.insertSubview(spark, belowSubview: faveButton)
        
        (spark, faveButton) >>- [.CenterX, .CenterY]
        
        let width = CGFloat((dotRadius.first * 2.0 + dotRadius.second * 2.0) + Const.distance.horizontal)
        spark >>- {
            $0.attribute  = .Width
            $0.constant   =  width
        }
        
        let height = CGFloat(Double(radius) + (dotRadius.first * 2.0 + dotRadius.second * 2.0))
        spark >>- {
            $0.attribute  = .Height
            $0.constant   =  height
            $0.identifier =  Const.expandKey
        }
        
        return spark
    }
    
    
    private func applyInit(){
        dotFirst  = createDotView(dotRadius.first,  fillColor: firstColor)
        dotSecond = createDotView(dotRadius.second, fillColor: secondColor)
        
        
        (dotFirst, self) >>- [.Trailing]
        attributes(.Width, .Height).forEach{ attr in
            dotFirst >>- {
                $0.attribute  = attr
                $0.constant   = CGFloat(dotRadius.first * 2.0)
                $0.identifier = Const.dotSizeKey
            }
        }
        
        (dotSecond,self) >>- [.Leading]
        attributes(.Width,.Height).forEach{ attr in
            dotSecond >>- {
                $0.attribute  = attr
                $0.constant   = CGFloat(dotRadius.second * 2.0)
                $0.identifier = Const.dotSizeKey
            }
        }
        
        (dotSecond,self) >>- {
            $0.attribute = .Top
            $0.constant  = CGFloat(dotRadius.first * 2.0 + Const.distance.vertical)
        }
        
        distanceConstraint = (dotFirst, dotSecond) >>- {
            $0.attribute       = .Bottom
            $0.secondAttribute = .Top
            $0.constant        =  0
        }
        
        self.transform = CGAffineTransformMakeRotation(CGFloat(angle.degrees))
    }
    
    
    private func createDotView(radius: Double, fillColor: UIColor) -> UIView{
        let dot = Init(UIView(frame: CGRectZero)){
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor                           = fillColor
            $0.layer.cornerRadius                        = CGFloat(radius)
        }
        
        self.addSubview(dot)
        return dot
    }
    
}

// MARK: animation
extension Spark{
    func animateIgniteShow(radius: CGFloat, duration:Double, delay: Double = 0){
        self.layoutIfNeeded()
        
        let diameter = (dotRadius.first * 2.0) + (dotRadius.second * 2.0)
        let height   = CGFloat(Double(radius) + diameter + Const.distance.vertical)
        
        if let constraint = self.constraints.filter({ $0.identifier == Const.expandKey }).first{
            constraint.constant = height
        }
        
        UIView.animateWithDuration(0, delay: delay, options: .CurveLinear, animations: {
            self.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(duration * 0.7, delay: delay, options: .CurveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func animateIgniteHide(duration: Double, delay: Double = 0){
        self.layoutIfNeeded()
        distanceConstraint?.constant = CGFloat(-Const.distance.vertical)
        
        UIView.animateWithDuration(
            duration*0.5,
            delay: delay,
            options: .CurveEaseOut,
            animations: {
                self.layoutIfNeeded()
            }, completion: { succeed in
        })
        
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: .CurveEaseOut,
            animations: {
                self.dotSecond.backgroundColor = self.firstColor
                self.dotFirst.backgroundColor  = self.secondColor
            }, completion: nil)
        
        
        for dot in [dotFirst, dotSecond]{
            dot.setNeedsLayout()
            dot.constraints.filter{ $0.identifier == Const.dotSizeKey }.forEach{
                $0.constant = 0
            }
        }
    
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: .CurveEaseOut,
            animations: {
                self.dotSecond.layoutIfNeeded()
            }, completion:nil)
        
        
        UIView.animateWithDuration(
            duration*1.7,
            delay: delay ,
            options: .CurveEaseOut,
            animations: {
                self.dotFirst.layoutIfNeeded()
            }, completion: { succeed  in
                
                self.removeFromSuperview()
        })
    }
}






