//
//  PodcastEpisodesController.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 16/06/21.
//

import UIKit
import FeedKit

class PodcastEpisodesController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var podcast: Podcast? {
        didSet {
            self.navigationItem.title = podcast?.trackName
        }
    }
    
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEpisodes()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    func fetchEpisodes() {
        print("fetching podcasts for feed url:\(podcast?.feedUrl ?? "")")
        
        guard let feedUrl = podcast?.feedUrl else {return}
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerView = PlayerDetailsView()
        playerView.episode = episodes[indexPath.row]
        let main = UIApplication.shared.windows.first?.rootViewController as? MainTabbarController
        main?.maximizePlayer(episode: episodes[indexPath.row])
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.count > 0 ? 0 : 250
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        134
    }
    
}
