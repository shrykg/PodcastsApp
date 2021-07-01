//
//  PodcastResultCell.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 15/06/21.
//

import UIKit
import Kingfisher

class PodcastResultCell: UITableViewCell {
    
    var podcast: Podcast! {
        didSet {
            self.name.text = podcast.trackName
            self.author.text = podcast.artistName
            self.episodeCount.text = "\(podcast.trackCount ?? 0) episodes"
            self.podcastImage.kf.setImage(with: URL(string: podcast.artworkUrl600 ?? ""))
        }
    }
    
    var name: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    var author: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return l
    }()
    
    let episodeCount: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .darkGray
        l.text = "10 episodes"
        return l
    }()
    
    let podcastImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "appicon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(podcastImage)
        podcastImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        podcastImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [name, author, episodeCount])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: podcastImage.trailingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
