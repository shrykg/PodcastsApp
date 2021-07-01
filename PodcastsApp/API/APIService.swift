//
//  APIService.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 15/06/21.
//

import UIKit
import FeedKit

class APIService {
    
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, completion: @escaping ([Episode]) -> ()) {
        let modifiedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: modifiedUrl) else {return}
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { result in
                
                switch result {
                case .success(let feed):
                    switch feed {
                    case let .rss(feed):
                        let episodes = feed.toEpisodes()
                        completion(episodes)
                        break
                    default :
                        ()
                    }
                case .failure(let error):
                    print(error)
                }
            }

        }
    }
    
    func fetchPodcasts(text: String, completion: @escaping ([Podcast]) -> ()) {
        
        guard let url = "https://itunes.apple.com/search?term=\(text)&media=podcast".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard let data = data else {return}
            DispatchQueue.main.async {
                do {
                    let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                    completion(searchResults.results)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
        
        
    }
    
    
}
