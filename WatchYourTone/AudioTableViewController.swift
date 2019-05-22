//
//  AudioTableViewController.swift
//  WatchYourTone
//
//  Created by Sage Simmons on 5/19/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import UIKit
import AVKit

class AudioTableViewController: UITableViewController {

    var audioPlayer = AVAudioPlayer()
    var audioArray : [AudioFile] = []
    var transcriptionArray : [String] = []
    var selectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transcriptionArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)
        let file = audioArray[indexPath.row].url
        let transcription = transcriptionArray[indexPath.row]
        cell.textLabel?.text = transcription

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    func play(){
        for index in 0...(audioArray.count - 1){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioArray[index].url)
                audioPlayer.prepareToPlay()
            }
            catch{
                print(error.localizedDescription)
            }
            
            audioPlayer.play()
        }
    }
    
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if case segue.identifier = "editSegue"{
            var destination = segue.destination as! AudioEditingViewController
            destination.navigationItem.title = transcriptionArray[selectedIndex]
            destination.url = audioArray[selectedIndex].url
            destination.Pitch = audioArray[selectedIndex].pitch
            destination.Volume = audioArray[selectedIndex].volume
            destination.Speed = audioArray[selectedIndex].speed
        }
        
        // Pass the selected object to the new view controller.
        
    }
 

}
