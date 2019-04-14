//
//  Line.swift
//  PrototypeApp
//
//  Created by New User on 10/28/18.
//  Copyright © 2018 New User. All rights reserved.
//

 import UIKit



//draws a circle inside the square

class Line: UIView {

    var circle = UIBezierPath()
    
    //let rect = CGRect(x: 88, y: 161, width: 240, height: 240)
 
    func graph(){

        UIColor.yellow.setStroke()
        
        circle.stroke()
        
    }
  
    override func draw(_ rect: CGRect) {
        
       // circle = UIBezierPath(arcCenter: CGPoint(x: 208, y: 398), radius: CGFloat(60), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

        self.circle = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width/2 - self.frame.size.height/2,
                                                y: 0.0,
                                                width: self.frame.size.height,
                                                height: self.frame.size.height))
      
        graph()

    }
    

} 

