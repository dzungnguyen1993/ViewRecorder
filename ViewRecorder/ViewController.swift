//
//  ViewController.swift
//  ViewRecorder
//
//  Created by Thanh-Dung Nguyen on 3/13/17.
//  Copyright © 2017 Dzung Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: EPSignatureView!
    @IBOutlet weak var btnRecord: UIButton!
    var images: [UIImage] = [UIImage]()
    var isRecording: Bool!
    var recordTimer: Timer!
    var btnTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawView.layer.borderWidth = 1.0
        drawView.layer.borderColor = UIColor.black.cgColor
        drawView.backgroundColor = UIColor(hex: 0xE8615B)
        
        btnRecord.layer.cornerRadius = btnRecord.bounds.width/2
        btnRecord.backgroundColor = UIColor(hex: 0x158141)
        
        isRecording = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(_ sender: UIButton) {
        if (!isRecording) {
            btnRecord.backgroundColor = UIColor(hex: 0xEB2427)
            isRecording = true
            
            // start timer
            
            recordTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
            btnTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateButton), userInfo: nil, repeats: true)
            images.removeAll()
        } else {
            isRecording = false
            btnRecord.backgroundColor = UIColor(hex: 0x158141)
            recordTimer.invalidate()
            btnTimer.invalidate()
            
            // export video
            let height = images[0].cgImage?.height
            var width = images[0].cgImage?.width
            
            if (width! % 16 != 0) {
                let tmp = width! / 16
                width = tmp * 16
            }
            
            let settings = Recorder.videoSettings(codec: AVVideoCodecH264, width: width!, height: height!)
            let movieMaker = Recorder(videoSettings: settings)
            movieMaker.createMovieFrom(images: images){ (fileURL:URL) in
                self.playVideo(url: fileURL)
            }
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        drawView.clear()
    }
    
}

extension ViewController: EPSignatureDelegate {
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        
    }
    
    func saveImage() {
        if let image = drawView.getSignatureAsImage() {
            self.images.append(image)
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

extension ViewController {
    @objc func updateImage() {
        saveImage()
    }
    
    @objc func updateButton() {
        if self.btnRecord.tag == 0 {
            btnRecord.backgroundColor = UIColor(hex: 0xEB2427)
            btnRecord.tag = 1
        } else {
            btnRecord.backgroundColor = UIColor(hex: 0x158141)
            btnRecord.tag = 0
        }
    }
}
