//
//  ViewController.swift
//  Watch Your Tone
//
//  Created by Simmons, Spence D on 4/17/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestTranscribePermissions()
        
    }
    
    func createTemporaryMemory() {
        
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    
}

