//
//  Podcast.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 15/06/21.
//

import UIKit
import FeedKit

struct Podcast: Decodable {
    var trackName, artistName: String?
    var artworkUrl600: String?
    var feedUrl: String?
    var trackCount: Int?
}

struct SearchResults: Decodable {
    var resultCount: Int
    var results: [Podcast]
}

struct Episode {
    var title: String
    var pubDate: Date
    var description: String
    var imageUrl: String?
    var author: String
    var streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
}
