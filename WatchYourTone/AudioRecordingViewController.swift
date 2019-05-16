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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    var fileURLArray : [URL] = []
    var urlPath: URL?
    var transcriptionList: [String] = []
    
    //Returns a URL on the specified index
    func getURL(index: Int) -> URL {
        return self.fileURLArray[index]
    }
    
    func getLengthOfArray() -> Int {
        return self.fileURLArray.count
    }
    
    func getTranscription(index: Int) -> String {
        return self.transcriptionList[index]
    }


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
    var chunkNum = 0
    
    //Placeholder func for now
    func loadRecordingUI() {
        recordButton.setTitle("Tap to Record", for: .normal)
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        recordButton.setTitle("Tap to Stop Record", for: .normal)
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    
    //Begins recording
    //This needs to decide where to save the audio, configure the recording settings, then start recording.
    func startRecording() {
        
        //Creates the file initializer
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording\(chunkNum).m4a")
        
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
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            
            
            urlPath = getDocumentsDirectory().appendingPathComponent("recording\(chunkNum).m4a")
            
            
            
//            pr]int(getDocumentsDirectory().appendingPathComponent("recording\(chunkNum).m4a"))
            
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
            fileURLArray.append(urlPath!)
            transcribeAudio(url: urlPath!)
            print(fileURLArray)
            chunkNum += 1
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    func makeAudioLabel(name: String){
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        label.text = name
        self.stackView.addSubview(label)
    }
    
    
    //Calls on the recording methods
//    func recordTapped() {
//        if audioRecorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
//    }
    
    
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
                    self.transcriptionList.append(result.bestTranscription.formattedString)
                print(self.transcriptionList)
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

