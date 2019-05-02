//
//  AudioRecordingViewController.swift
//  WatchYourTone
//
//  Created by Simmons, Spence D on 4/25/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import UIKit
import Speech

class AudioRecordingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Asks user permission to record
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }

        // Do any additional setup after loading the view.
    }
    
    
    //Linked to the "Record" button
    
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    //Placeholder func for now
    func loadRecordingUI() {
        
        recordButton.setTitle("Tap to Record", for: .normal)
    }
    
    
    
    //Begins recording
    //This needs to decide where to save the audio, configure the recording settings, then start recording.
    func startRecording() {
        
        //Creates the file initializer
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        
        //Specifications for the file
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        //Attempts to start recording
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as! AVAudioRecorderDelegate
            audioRecorder.record()
            
            //Sets the text in the button to "Tap to Stop" to stop the recording whenever the user wishes
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    //Creates the path for the file as a URL type variable
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //Ends the recording session. If it doesn't record properly, it asks to re-record. Otherwise, the text asks for another recording
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    
    //Calls on the recording methods
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    
    //Checks if the audio recording has been manually ended
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    //This transcribes the audio and turns it into text
    func transcribeAudio(url: URL) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        // start recognition!
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            
            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                print(result.bestTranscription.formattedString)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
