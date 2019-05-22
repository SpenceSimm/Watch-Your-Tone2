//
//  AudioFile.swift
//  WatchYourTone
//
//  Created by Sage Simmons on 5/21/19.
//  Copyright © 2019 Simmons, Spence D. All rights reserved.
//

import Foundation

struct AudioFile{
    var url: URL
    var volume: Float
    var pitch: Float
    var speed: Float
    
    init(url: URL, volume: Float, pitch: Float, speed: Float){
        self.url = url
        self.volume = volume
        self.pitch = pitch
        self.speed = speed
    }
}
