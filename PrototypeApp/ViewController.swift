//
//  ViewController.swift
//  PrototypeApp
//
//  Created by New User on 10/14/18.
//  Copyright © 2018 New User. All rights reserved.
//


import UIKit

//code to identify color of pixels in RGB
extension UIImage {
    public func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        }
}
// get RGB value from UIColor
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    

// This is the label that displays the number when calculate is hit
    @IBOutlet weak var piCalc: UILabel!
    
    var demoView = DemoView()
    var pinchGesture = UIPinchGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //faceDetect1()
        
        // this code is for the filter (not yet integrated)
//        if let image = UIImage(named: "pupil.jpg"){
//           let originalImage = CIImage(image: image)
//           let filter = CIFilter(name: "CISharpenLuminance")
//           filter?.setDefaults()
  //         filter?.setValue(originalImage, forKey: kCIInputImageKey)
 //          if let outputImage = filter?.outputImage{
 //               let newImage = UIImage(ciImage: outputImage)
//                pupil.image = newImage
        

        
        self.demoView = DemoView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 150, height: 150))
        
        
        
        // Initialization code
    
        
        self.demoView.isUserInteractionEnabled = true //pinching action setup
        self.demoView.isMultipleTouchEnabled = true
        
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self,action:#selector(handlePinch(recognizer:)))
        self.panGesture = UIPanGestureRecognizer(target: self,action:#selector(handlePan(recognizer:)))
        self.pinchGesture.delegate = self
        self.panGesture.delegate = self
        self.demoView.addGestureRecognizer(self.pinchGesture)
        self.demoView.addGestureRecognizer(self.panGesture)
        
        
        self.view.addSubview(demoView)

        
        
        }

    @IBAction func handlePinch(recognizer:UIPinchGestureRecognizer) {
        //demoView.transform = CGAffineTransform(scaleX: recognizer.scale, y: recognizer.scale)
        demoView.transform = demoView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.demoView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.demoView)
    }

//Displays the image
    @IBOutlet weak var pupil: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    // code to access camera: take picture button
    @IBAction func camera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // code to access photo library: upload photo button
    @IBAction func library(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //code to save image
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
// code to display selected image and crop
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        pupil.image = image
        //UIImageWriteToSavedPhotosAlbum(pupil.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) //save image
        dismiss(animated:true, completion: nil)
    }
    

//defines the area of the circle. The loop checks whether or not the points are within this

    
    //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.
// calculate pi button. Checks "x" number of pixels. "Black" points inside the circle are added to i, others are added to o. Divides to get ratio and displays this ratio.
    
    @IBAction func calculate(_ sender: Any) {
        var i = 0
        var o = 0
        var x = 0
        let image = pupil.image

        let frameSquare = UIView(frame: demoView.convert(demoView.bounds, to: pupil.inputView)) //UI View out of square's location on image frame
        let Xmin = Int(frameSquare.frame.minX)
        let Ymin = Int(frameSquare.frame.minY)
        let Xmax = Int(frameSquare.frame.maxX)
        let Ymax = Int(frameSquare.frame.maxY)
        let radius = Int(frameSquare.frame.size.width)/2
//        let Xmin = Int(pupil.frame(forAlignmentRect: demoView.convert(demoView.bounds, to: pupil.inputView)).minX)
//        let Ymin = Int(pupil.frame(forAlignmentRect: demoView.convert(demoView.bounds, to: pupil.inputView)).minY)
//        let Xmax = Int(pupil.frame(forAlignmentRect: demoView.convert(demoView.bounds, to: pupil.inputView)).maxX)
//        let Ymax = Int(pupil.frame(forAlignmentRect: demoView.convert(demoView.bounds, to: pupil.inputView)).maxY)
//        let radius = Int(pupil.frame(forAlignmentRect: demoView.convert(demoView.bounds, to: pupil.inputView)).size.width)/2
        print(Xmin, Ymin, Xmax, Ymax)
        
        let xCenter = Int(Xmin + radius)
        let yCenter = Int(Ymin + radius)
        let circle1 = UIBezierPath(arcCenter: CGPoint(x: xCenter, y: yCenter), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        //find the color of the center point
        let centerPoint = CGPoint(x:xCenter,y:yCenter)
        let centerColor = image?.getPixelColor(pos: centerPoint)
        if centerColor == nil {piCalc.text = "please select an image"}
        else{
            var centerR: CGFloat = centerColor!.rgba.red
            var centerG: CGFloat = centerColor!.rgba.green
            var centerB: CGFloat = centerColor!.rgba.blue
            
            while x < 3000{
                
                let point = CGPoint(x:Int.random(in:Xmin...Xmax),y:Int.random(in: Ymin...Ymax))
                let color = image?.getPixelColor(pos: point)
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                //var alpha: CGFloat = 0
                //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.
                
                red = color!.rgba.red
                green = color!.rgba.green
                blue = color!.rgba.blue
                //edge case
                if circle1.contains(point) && (centerR + centerG + centerB == 0) {
                    centerR = 0.03
                    centerG = 0.03
                    centerB = 0.03
                }
                
                //adjust the values for contrast: right now 0.2 deviation from the color of the center pt
                //gray scale transformation: New grayscale image = ( (0.3 * R) + (0.59 * G) + (0.11 * B) ).
                
                if circle1.contains(point) && (red + green + blue <= 1.2 * (centerR + centerG + centerB))
//                    red < 1.3 * centerR &&
//                    green < 1.3 * centerG &&
//                    blue < 1.3 * centerB {
                    //print(color)
                    //print(point)
                {
                    i += 1}
                else{
                    o += 1}
                
                x += 1}
            let ratio = 4 * Float(i)/Float(x)
            
            //            print(color)
            //            print(point)
            piCalc.text = String(ratio)
        }
        
    }
    /*
    @IBAction func calculate(_ sender: Any) {
        var i = 0
        var o = 0
        var x = 0
        while x < 3000{
            let image = pupil.image
            //let Xmin = Int(pupil.frame.minX)
            //let Ymin = Int(pupil.frame.minY)
            //let Xmax = Int(pupil.frame.maxX)
            //let Ymax = Int(pupil.frame.maxY)
            
            
            //demo view contains square
            let frameSquare = UIView(frame: demoView.convert(demoView.bounds, to: pupil.inputView)) //UI View out of square's location on image frame
            let Xmin = Int(frameSquare.frame.minX) //where the square begins
            let Ymin = Int(frameSquare.frame.minY)
            let Xmax = Int(frameSquare.frame.maxX)
            let Ymax = Int(frameSquare.frame.maxY) //where the square ends
            let radius = Int(frameSquare.frame.size.width)/2
            let xCenter = Int(Xmin + radius)
            let yCenter = Int(Ymin + radius)
            
            let circle1 = UIBezierPath(arcCenter: CGPoint(x: xCenter, y: yCenter), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            let point = CGPoint(x:Int.random(in:Xmin...Xmax),y:Int.random(in: Ymin...Ymax))
            let color = image?.getPixelColor(pos: point)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            //var alpha: CGFloat = 0
            //defines the colors that are "black" and part of the pupil. Not all pixels in the pupil will be exactly black, rather, a varying range of dark shades that appear black.

            red = color!.rgba.red
            green = color!.rgba.green
            blue = color!.rgba.blue
            //adjust the values for shades of blackness
            if circle1.contains(point) && red < 0.15 && green < 0.15 && blue < 0.15{
                //print(color)
                //print(point)
                
                i += 1}
            else{
                o += 1}
            
            x += 1}
        let ratio = 4 * Float(i)/Float(x)
        
        //let difference = Double(pupil.frame.origin.x - demoView.frame.origin.x)
        print(demoView.frame)
//            print(color)
//            print(point)
            piCalc.text = String(ratio)
        
   
    } */
    
    func faceDetect1(){
        if let inputImage = UIImage(named: "test1.jpg") {
            let ciImage = CIImage(cgImage: inputImage.cgImage!)
            
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
            
            let faces = faceDetector.features(in: ciImage)
            
            if let face = faces.first as? CIFaceFeature {
                print("Found face at \(face.bounds)")
                
                if face.hasLeftEyePosition {
                    print("Found left eye at \(face.leftEyePosition)")
                }
                
                if face.hasRightEyePosition {
                    print("Found right eye at \(face.rightEyePosition)")
                }
                
                if face.hasMouthPosition {
                    print("Found mouth at \(face.mouthPosition)")
                }
            }
        }
    }


    
    // face detection using CI Image library
    func faceDetect() {
        //get the image from image view
        let faceImage = CIImage(image: pupil.image!)!//unwrap imageview
        
        //set up detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetetector?.features(in: faceImage)
        
        if !(faces!.isEmpty) { //if faces is not empty, has features
            for face in faces as! [CIFaceFeature] {
                var hasEyeVisible = "An eye is visible"
                    
                if (!face.hasLeftEyePosition) || (!face.hasRightEyePosition) //no eyes
                {
                    hasEyeVisible = "No eyes found in photo"
                }
                
                testLabel.text = hasEyeVisible
            }
            
            
        }
        
    }
    
    
}







