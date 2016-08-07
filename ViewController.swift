//
//  ViewController.swift
//  kbutton
//
//  Created by DynEd on 8/6/16.
//  Copyright © 2016 DynEd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var kbuttonView:KButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*var view1 = UIView(frame: CGRect(x: (self.view.frame.width / 2) - 25, y: (self.view.frame.height / 2) - 25, width: 50, height: 50))
        view1.backgroundColor = UIColor.blackColor()
        view1.layer.cornerRadius = 25
        self.view.addSubview(view1)
        
        var pembagi:Double = 3
        var start:Double = 0
        var angle:Double = 360 / pembagi
        var angelArr:[Double] = [Double]()
        for a in 0 ..< 3 {
            start = (start + angle)
            angelArr.append(start)
            print("angel \(start)")
        }
        
        for var z in angelArr {
            var x:Double = 0
            var y:Double = 0
            //double x = x0 + r * Math.Cos(theta * Math.PI / 180);
            //double y = y0 + r * Math.Sin(theta * Math.PI / 180);
            var radian = (z - 90) * M_PI / 180
            x = Double(view1.center.x) + ((100) * cos(Double(radian)))
            y = Double(view1.center.y) + ((100) * sin(Double(radian)))

            var view2:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            view2.center = CGPoint(x: x, y: y)
            view2.backgroundColor = UIColor.blackColor()
            view2.layer.cornerRadius = 25
            var uilabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            uilabel.text = "\(z)"
            uilabel.textColor = UIColor.whiteColor()
            view2.addSubview(uilabel)
            self.view.addSubview(view2)
        }*/
        
        
        var main = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        main.backgroundColor = UIColor.redColor()
        main.addTarget(self, action: #selector(mainTap), forControlEvents: .TouchUpInside)
        main.layer.cornerRadius = 15
        
        var child1 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        child1.backgroundColor = UIColor.blueColor()
        child1.layer.cornerRadius = 15
        
        var child2 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        child2.backgroundColor = UIColor.blackColor()
        child2.layer.cornerRadius = 15
        
        var child3 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        child3.backgroundColor = UIColor.yellowColor()
        child3.layer.cornerRadius = 15
        
        var child4 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        child4.backgroundColor = UIColor.greenColor()
        child4.layer.cornerRadius = 15
        
        var child5 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        child5.backgroundColor = UIColor.redColor()
        child5.layer.cornerRadius = 15
        
        kbuttonView = KButton(viewController: self, childs: [child1,child2,child3,child4,child5], mainBtn: main, margin: 30, type: KButtonType.BottomMiddleToCenter)
        kbuttonView.setFrameBottomMiddleToCenter()
        self.view.addSubview(kbuttonView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mainTap(){
        print("open tap")
        kbuttonView.toggle()
    }

    @IBAction func action_tap(sender: AnyObject) {
        print("button tap")
    }

}

