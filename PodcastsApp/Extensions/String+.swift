//
//  String+.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 16/06/21.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
}
