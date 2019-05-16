//
//  AudioEditingViewController.swift
//  WatchYourTone
//
//  Created by Patel, Milan M on 4/30/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import UIKit
import AVKit

class AudioEditingViewController: UIViewController {

    var Pitch:Float = 0.0
    var Volume:Float = 0.0
    var Speed:Float = 0.0
    @IBAction func pitchChanged(_ sender: UISlider) {
        Pitch = Float((sender.value * 50).rounded()) + 1.0
        pitchControl.pitch += Pitch
    }
    @IBAction func volumeChanged(_ sender: UISlider) {
        Volume = Float((sender.value * 1).rounded()) + 1.0
    }
    @IBAction func speedChanged(_ sender: UISlider) {
        Speed = Float((sender.value * 3).rounded()) + 1.0
        speedControl.rate += Speed
    }
    @IBAction func donePressed(_ sender: UIButton) {
        
    }
    
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func play(_ url: URL) throws {
        // 1: load the file
        let file = try AVAudioFile(forReading: url)
        
        // 2: create the audio player
        let audioPlayer = AVAudioPlayerNode()
        
        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)
        
        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)
        
        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)
        
        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
    }
    
    


}
