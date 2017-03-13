//
//  ViewController.swift
//  ViewRecorder
//
//  Created by Thanh-Dung Nguyen on 3/13/17.
//  Copyright © 2017 Dzung Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: EPSignatureView!
    @IBOutlet weak var btnRecord: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawView.layer.borderWidth = 1.0
        drawView.layer.borderColor = UIColor.black.cgColor
        drawView.backgroundColor = UIColor(hex: 0xE8615B)
        
        btnRecord.layer.cornerRadius = btnRecord.bounds.width/2
        btnRecord.backgroundColor = UIColor(hex: 0x158141)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(_ sender: UIButton) {
        btnRecord.backgroundColor = UIColor(hex: 0xEB2427)
        
        saveSignature()
    }
}

extension ViewController: EPSignatureDelegate {
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        
    }
    
    func saveSignature() {
        if let signature = drawView.getSignatureAsImage() {
            drawView.saveSignature("test.png")
            drawView.saveSignatureToFile(image: signature)
        } else {
//            showAlert("You did not sign", andTitle: "Please draw your signature")
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
