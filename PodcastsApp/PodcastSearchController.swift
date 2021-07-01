//
//  PodcastSearchController.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 15/06/21.
//

import UIKit

class PodcastSearchController: UITableViewController, UISearchBarDelegate {
    
    fileprivate let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.register(PodcastResultCell.self, forCellReuseIdentifier: cellId)
    }
    
    var timer: Timer?
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            APIService.shared.fetchPodcasts(text: searchText) { podcasts in
                DispatchQueue.main.async {
                    self.podcasts = podcasts
                    self.tableView.reloadData()
                }
                
            }

        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UILabel()
        v.text = "Please enter a search term"
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return v
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        let l = UILabel()
        l.text = "Currently Searching..."
        let stack = UIStackView(arrangedSubviews: [UIView(),ai,l,UIView()])
        stack.distribution = .equalSpacing
        return stack
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
       
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 100 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodeVC = PodcastEpisodesController()
        episodeVC.podcast = self.podcasts[indexPath.row]
        self.navigationController?.pushViewController(episodeVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastResultCell
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
}
