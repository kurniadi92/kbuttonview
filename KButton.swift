//
//  KButton.swift
//  kbutton
//
//  Created by DynEd on 8/6/16.
//  Copyright © 2016 DynEd. All rights reserved.
//

import Foundation
import UIKit

enum KButtonType {
    case BottomMiddleToCenter
    case BottomLeftToCenter
    case BottomRightToCenter
    case TopMiddleToCenter
    case TopLeftToCenter
    case TopRightToCenter
}

class KButton: UIView {
    
    private var childButtons:[UIButton] = [UIButton]()
    private var mainBtn:UIButton!
    private var buttons:[ChildButton] = [ChildButton]()
    private var mainButton:MainButton!
    private var viewController:UIViewController!
    private var margin:CGFloat = 18
    private var type:KButtonType!
    private var isFrameSetted = false
    private var isOpen = false
    private var viewOriginRect:CGRect?
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewController:UIViewController, childs:[UIButton], mainBtn:UIButton, margin:CGFloat, type:KButtonType){
        super.init(frame: CGRect(x: (viewController.view.frame.width - mainBtn.frame.width) / 2, y: (viewController.view.frame.height - (mainBtn.frame.height + 24)), width: mainBtn.frame.width, height: mainBtn.frame.height))
        viewOriginRect = CGRect(x: (viewController.view.frame.width - mainBtn.frame.width) / 2, y: (viewController.view.frame.height - (mainBtn.frame.height + 24)), width: mainBtn.frame.width, height: mainBtn.frame.height)
        self.viewController = viewController
        self.childButtons = childs
        self.mainBtn = mainBtn
        self.margin = margin
    }
    
    func setFrameBottomMiddleToCenter(){
        //first set button to bottom middle
        mainBtn.frame = CGRect(x: 0, y: 0 , width: mainBtn.frame.width, height: mainBtn.frame.height)
        self.addSubview(mainBtn)
        
        //then prepare target for main so it will place in the middle of the screen
        var mainBtnTarget = CGRect(x: (self.viewController.view.frame.width - mainBtn.frame.width) / 2, y: (self.viewController.view.frame.height - mainBtn.frame.height) / 2, width: mainBtn.frame.width, height: mainBtn.frame.height)
        mainButton = MainButton(main: mainBtn, origin: mainBtn.frame, target: mainBtnTarget)
        
        if childButtons.count > 0 {
            var pembagi:Double = Double(childButtons.count)
            var start:Double = 0
            var angle:Double = 360 / pembagi
            var angleArr:[Double] = [Double]()
            for a in 0 ..< childButtons.count {
                start = (start + angle)
                angleArr.append(start)
            }
            
            var temp = UIView(frame: mainButton.target!)
            
            for a in 0 ..< childButtons.count {
                
                var angle = angleArr[a]
                var x:Double = 0
                var y:Double = 0
                var radian = (angle - 90) * M_PI / 180
                x = Double(temp.center.x) + ((Double(margin) * 2) * cos(Double(radian)))
                y = Double(temp.center.y) + ((Double(margin) * 2) * sin(Double(radian)))
                var targetFrame = CGRect(x: x - (Double(margin) / 2), y: y-(Double(margin) / 2), width: Double(childButtons[a].frame.width), height: Double(childButtons[a].frame.height))
                var originButton = childButtons[a]
                originButton.frame = mainButton.target!
                self.buttons.append(ChildButton(child: originButton, target: targetFrame))
                
            }
        }
        else{
            isFrameSetted = false
        }
        
        /*
        var tempView:UIView = UIView()
        var tempWidth:CGFloat = 0
        var tempHeight:CGFloat = 0
        var index = 0
        for var button in childButtons {
            if index == 0 {
                tempWidth = button.frame.width
            }
            else{
                tempWidth = tempWidth + margin + button.frame.width
            }
            if tempHeight < button.frame.height {
                tempHeight = button.frame.height
            }
            index = index + 1
        }
        var firstX = (UIScreen.mainScreen().applicationFrame.width - tempWidth) / 2
        
        self.buttons.removeAll(keepCapacity: false)
        for var button in childButtons {
            buttons.append(ChildButton(child: button, target: CGRectMake(firstX, 0, button.frame.width, button.frame.height)))
            self.insertSubview(button, belowSubview: mainBtn)
            firstX = firstX + button.frame.width + margin
        }*/
    }
    
    func toggle(){
        if isOpen == false {
            isOpen = true
            open()
        }
        else{
            isOpen = false
            close()
        }
    }
    func open(){
        
        BottomToMiddleOpenAnimation()
        
        self.frame = self.viewController.view.frame
        self.mainButton.main?.frame = viewOriginRect!
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            self.mainButton.main?.frame = (self.mainButton.target?.offsetBy(dx: 0, dy: -24))!
            }, completion: {
                Bool in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
                    self.mainButton.main?.frame = self.mainButton.target!
                    }, completion: {
                        Bool in
                        for var child in self.buttons {
                            child.child?.transform = CGAffineTransformMakeScale(1, 1)
                            child.child?.frame = (self.mainButton.main?.frame)!
                        }
                        
                        var index:Double = 0
                        for var child in self.buttons {
                            index = index + 1
                            self.insertSubview(child.child!, belowSubview: self.mainButton.main!)
                            UIView.animateWithDuration(0.5, delay: 0.3 * index, options: .CurveEaseOut, animations: {
                                child.child?.frame = child.target!
                                }, completion: {
                                    Bool in
                            })
                            
                            print(child.child!.frame)
                        }
                })
        })
    }
    
    func close(){
        var index = 0
        for var child in buttons {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
                child.child?.frame = (self.mainButton.target)!
                //
                }, completion: {
                    Bool in
                    index = index + 1
                    child.child?.transform = CGAffineTransformMakeScale(0, 0)
                    if index == 3 {
                        self.BottomToMiddleCloseAnimation()
                    }
            })
        }
        UIView.animateWithDuration(0.4, delay: 0.6, options: .CurveEaseOut, animations: {
            self.mainButton.main?.frame = self.viewOriginRect!
            }, completion: {
                Bool in
        })
        
    }
    
    func BottomToMiddleOpenAnimation(){
        let bounds = mainButton.origin
        
        // Create CAShapeLayerS
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds!
        rectShape.position = self.center
        rectShape.cornerRadius = bounds!.width / 2
        rectShape.setValue("main", forKey: "animated")
        self.layer.insertSublayer(rectShape, below: mainButton.main?.layer)
        
        // Apply effects here
        
        // fill with yellow
        rectShape.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        
        // 1
        // begin with a circle with a 50 points radius
        let startShape = UIBezierPath(roundedRect: bounds!, cornerRadius: 50).CGPath
        // animation end with a large circle with 500 points radius
        let endShape = UIBezierPath(roundedRect: CGRect(x: self.viewController.view.frame.height * (-1), y: self.viewController.view.frame.height * (-1), width: self.viewController.view.frame.height * 2, height: self.viewController.view.frame.height * 2), cornerRadius: self.viewController.view.frame.height).CGPath
        
        // set initial shape
        rectShape.path = startShape
        
        // 2
        // animate the `path`
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endShape
        animation.duration = 1 // duration is 1 sec
        // 3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        // 4
        rectShape.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func BottomToMiddleCloseAnimation(){
        for v in self.layer.sublayers! {
            if v.valueForKey("animated") != nil {
                if v.valueForKey("animated") as! String == "main" {
                    var rectShape = v as! CAShapeLayer
                    var ca = rectShape.animationForKey("path") as! CABasicAnimation
                    // 1
                    // begin with a circle with a 50 points radius
                    let startShape = ca.toValue as! CGPath
                    // animation end with a large circle with 500 points radius
                    let endShape = UIBezierPath(roundedRect: mainButton.origin!, cornerRadius: mainButton.main!.frame.width/2).CGPath
                    
                    // set initial shape
                    rectShape.path = startShape
                    
                    // 2
                    // animate the `path`
                    let animation = CABasicAnimation(keyPath: "path")
                    animation.setValue("end", forKey: "id")
                    animation.toValue = endShape
                    animation.duration = 1 // duration is 1 sec
                    // 3
                    animation.delegate = self
                    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
                    animation.fillMode = kCAFillModeBoth // keep to value after finishing
                    animation.removedOnCompletion = false // don't remove after finishing
                    // 4
                    rectShape.addAnimation(animation, forKey: animation.keyPath)
                }
            }
        }
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim.valueForKey("id") != nil {
           self.frame = viewOriginRect!
           self.mainButton.main?.frame = mainButton.origin!
            for var lyr in self.layer.sublayers! {
                if lyr.valueForKey("animated") != nil {
                    if lyr.valueForKey("animated") as! String == "main" {
                        lyr.removeAllAnimations()
                        lyr.removeFromSuperlayer()
                    }
                }
            }
        }
    }
}

class MainButton {
    
    var main:UIButton?
    var origin:CGRect?
    var target:CGRect?
    
    init(main: UIButton, origin:CGRect, target: CGRect){
        self.main = main
        self.target = target
        self.origin = origin
    }
    
}

class ChildButton {
    
    var child:UIButton?
    var target:CGRect?
    
    init(child: UIButton, target: CGRect){
        self.child = child
        self.target = target
    }
    
}