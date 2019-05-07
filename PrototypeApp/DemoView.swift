//
//  DemoView.swift
//  PrototypeApp
//
//  Created by New User on 4/4/19.
//  Copyright © 2019 New User. All rights reserved.
//

import UIKit
class DemoView: UIView {
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var path: UIBezierPath!
    var circle = UIBezierPath()
    var radius = CGFloat(45.0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func createSquare() {
        
        let halfOfFrameH = self.frame.size.height/2
        let halfOfFrameW = self.frame.size.width/2
        // Initialize the path.
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        //path.move(to: CGPoint(x: halfOfFrameW, y: halfOfFrameH))
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        //path.addLine(to: CGPoint(x: halfOfFrameW, y: halfOfFrameH+radius))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        // Create the bottom line (bottom-left to bottom-right).
        //path.addLine(to: CGPoint(x: halfOfFrameW+radius, y: halfOfFrameH+radius))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        // Create the vertical line from the bottom-right to the top-right side.
        //path.addLine(to: CGPoint(x: halfOfFrameW+radius, y: halfOfFrameH))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        
        path.lineWidth = 2
        
        // Close the path. This will create the last line automatically.
        path.close()
    }
    
    func createCircle() {
        let halfOfFrameH = self.frame.size.height/2
        let halfOfFrameW = self.frame.size.width/2
        
        //self.circle = UIBezierPath(ovalIn: CGRect(x:halfOfFrameW, y: halfOfFrameH, width: 45, height: 45))
        self.circle = UIBezierPath(ovalIn: CGRect(x:halfOfFrameW - halfOfFrameH, y: 0.0, width: self.frame.size.height, height:self.frame.size.height))
        UIColor.blue.setStroke()
        circle.lineWidth = 2
        circle.stroke()
        
    }

    override func draw(_ rect: CGRect) {
        self.createSquare()
        self.createCircle()
        // Specify the fill color and apply it to the path.
        //UIColor.orange.setFill()
       UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0).setFill()
        path.fill()
        
        // Specify a border (stroke) color.
        UIColor.blue.setStroke()
        path.stroke()
    }
    
}

