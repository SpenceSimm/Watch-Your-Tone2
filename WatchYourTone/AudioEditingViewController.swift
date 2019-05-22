//
//  AudioEditingViewController.swift
//  WatchYourTone
//
//  Created by Patel, Milan M on 4/30/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import UIKit
import AVKit
//import AVFoundation

class AudioEditingViewController: UIViewController {

    
    var audioQueue = AVQueuePlayer()
    var Pitch:Float = 0.0
    var Volume:Float = 0.0
    var Speed:Float = 0.0
    var url: URL?
    var asset: AVAsset?
    var index: Int = 0
    
    
    @IBOutlet weak var pitchSlider: UISlider!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var speedSlider: UISlider!
    
    @IBAction func setPitch(_ sender: Any) {
        pitchControl = AVAudioUnitTimePitch()
        pitchControl.pitch += pitchSlider.value
    }
    
    @IBAction func setVolume(_ sender: Any) {
        Volume = 0
        Volume += volumeSlider.value
        //asset?.preferredVolume = Volume
    }
    
    @IBAction func setSpeed(_ sender: Any) {
        speedControl = AVAudioUnitVarispeed()
        speedControl.rate += speedSlider.value
    }
    
    
//    @IBAction func pitchChanged(_ sender: UISlider) {
//        Pitch = Float((sender.value).rounded()) + 1.0
//        pitchControl.pitch += Pitch
//    }
//    @IBAction func volumeChanged(_ sender: UISlider) {
//        Volume = Float((sender.value).rounded()) + 1.0
//    }
//    @IBAction func speedChanged(_ sender: UISlider) {
//        Speed = Float((sender.value).rounded()) + 1.0
//        speedControl.rate += Speed
//    }
    @IBAction func donePressed(_ sender: UIButton) {
        if let url = url{
            do{
                try play(url)
            }
            catch{
                print(error.localizedDescription)
            }
            
            
        }

    }


    var engine = AVAudioEngine()
    var speedControl = AVAudioUnitVarispeed()
    var pitchControl = AVAudioUnitTimePitch()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func play(_ url: URL) throws {
        // 1: load the file
        var file = AVAudioFile()
        do{
            file = try AVAudioFile(forReading: url)
        }
        catch{
            print(error.localizedDescription)
        }
        

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
        do{
            try engine.start()
        }
        catch{
            print(error.localizedDescription)
        }
        
        audioPlayer.play()
    }

//    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//        <#code#>
//    }

}
