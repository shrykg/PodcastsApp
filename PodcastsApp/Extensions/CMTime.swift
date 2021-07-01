//
//  CMTime.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 16/06/21.
//

import Foundation
import AVKit

extension CMTime {
    
    func toTimeString() -> String {
        if CMTimeGetSeconds(self).isNaN || CMTimeGetSeconds(self).isInfinite {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
        
    }
    
}
