//
//  FaveButton.swift
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



public typealias DotColors = (first: UIColor, second: UIColor)

public protocol FaveButtonDelegate{
    func faveButton(faveButton: FaveButton, didSelected selected: Bool)
    
    func faveButtonDotColors(faveButton: FaveButton) -> [DotColors]?
}

public class FaveButton: UIButton {
    
    private struct Const{
        static let duration             = 1.0
        static let expandDuration       = 0.1298 
        static let collapseDuration     = 0.1089
        static let faveIconShowDelay    = Const.expandDuration + Const.collapseDuration/2.0
        static let dotRadiusFactors     = (first: 0.0633, second: 0.04)
    }
    
    @IBInspectable public var normalColor: UIColor     = UIColor(colorLiteralRed: 137/255, green: 156/255, blue: 167/255, alpha: 1)
    @IBInspectable public var selectedColor: UIColor   = UIColor(colorLiteralRed: 226/255, green: 38/255,  blue: 77/255,  alpha: 1)
    @IBInspectable public var dotFirstColor: UIColor   = UIColor(colorLiteralRed: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    @IBInspectable public var dotSecondColor: UIColor  = UIColor(colorLiteralRed: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    @IBInspectable public var circleFromColor: UIColor = UIColor(colorLiteralRed: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    @IBInspectable public var circleToColor: UIColor   = UIColor(colorLiteralRed: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    
    @IBOutlet public var delegate: AnyObject?
    
    private(set) var sparkGroupCount: Int = 7
    
    private var faveIconImage:UIImage?
    private var faveIcon: FaveIcon!
    
    
    override public var selected: Bool{
        didSet{
            animateSelect(self.selected, duration: Const.duration)
        }
    }
    
    init(frame: CGRect, faveIconNormal: UIImage?) {
        super.init(frame: frame)
        
        guard let icon = faveIconNormal else{
            fatalError("missing image for normal state")
        }
        faveIconImage = icon
        
        applyInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyInit()
    }
}


// MARK: create
extension FaveButton{
    private func applyInit(){
        
        if nil == faveIconImage{
            faveIconImage = imageForState(.Normal)
        }
        
        guard let faveIconImage = faveIconImage else{
            fatalError("please provide an image for normal state.")
        }
        
        setImage(UIImage(), forState: .Normal)
        setImage(UIImage(), forState: .Selected)
        setTitle(nil, forState: .Normal)
        setTitle(nil, forState: .Selected)
        
        faveIcon  = createFaveIcon(faveIconImage)
        
        addActions()
    }
    
    
    private func createFaveIcon(faveIconImage: UIImage) -> FaveIcon{
        return FaveIcon.createFaveIcon(self, icon: faveIconImage,color: normalColor)
    }
    
    
    private func createSparks(radius: CGFloat) -> [Spark] {
        var sparks    = [Spark]()
        let step      = 360.0/Double(sparkGroupCount)
        let base      = Double(bounds.size.width)
        let dotRadius = (base * Const.dotRadiusFactors.first, base * Const.dotRadiusFactors.second)
        let offset    = 10.0
        
        for index in 0..<sparkGroupCount{
            let theta  = step * Double(index) + offset
            let colors = dotColors(atIndex: index)
            
            let spark  = Spark.createSpark(self, radius: radius, firstColor: colors.first,secondColor: colors.second, angle: theta,
                                           dotRadius: dotRadius)
            sparks.append(spark)
        }
        return sparks
    }
}


// MARK: utils

extension FaveButton{
    private func dotColors(atIndex index: Int) -> DotColors{
        if case let delegate as FaveButtonDelegate = delegate where nil != delegate.faveButtonDotColors(self){
            let colors     = delegate.faveButtonDotColors(self)!
            let colorIndex = 0..<colors.count ~= index ? index : index % colors.count
            
            return colors[colorIndex]
        }
        return DotColors(self.dotFirstColor, self.dotSecondColor)
    }
}


// MARK: actions
extension FaveButton{
    func addActions(){
        self.addTarget(self, action: #selector(toggle(_:)), forControlEvents: .TouchUpInside)
    }
    
    func toggle(sender: FaveButton){
        sender.selected = !sender.selected
        
        guard case let delegate as FaveButtonDelegate = self.delegate else{
            return
        }
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * Const.duration))
        dispatch_after(delay, dispatch_get_main_queue()){
            delegate.faveButton(sender, didSelected: sender.selected)
        }
    }
}


// MARK: animation
extension FaveButton{
    private func animateSelect(isSelected: Bool, duration: Double){
        let color  = isSelected ? selectedColor : normalColor
        
        faveIcon.animateSelect(isSelected, fillColor: color, duration: duration, delay: Const.faveIconShowDelay)
        
        if isSelected{
            let radius           = bounds.size.scaleBy(1.3).width/2 // ring radius
            let igniteFromRadius = radius*0.8
            let igniteToRadius   = radius*1.1
            
            let ring   = Ring.createRing(self, radius: 0.01, lineWidth: 3, fillColor: self.circleFromColor)
            let sparks = createSparks(igniteFromRadius)
            
            ring.animateToRadius(radius, toColor: circleToColor, duration: Const.expandDuration, delay: 0)
            ring.animateColapse(radius, duration: Const.collapseDuration, delay: Const.expandDuration)

            sparks.forEach{
                $0.animateIgniteShow(igniteToRadius, duration:0.4, delay: Const.collapseDuration/3.0)
                $0.animateIgniteHide(0.7, delay: 0.2)
            }
        }
    }
}



















