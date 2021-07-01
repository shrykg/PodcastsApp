//
//  EpisodeCell.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 16/06/21.
//

import UIKit
import Kingfisher

class EpisodeCell: UITableViewCell {
    
    var episode: Episode!{
        didSet{
            episodeName.text = episode.title
            descriptionLabel.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            pubDate.text = dateFormatter.string(from: episode.pubDate)
            
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImage.kf.setImage(with: url)
        }
    }
    
    let episodeImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "appicon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    var episodeName: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    var descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .gray
        return l
    }()
    
    var pubDate: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .purple
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(episodeImage)
        episodeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        episodeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [pubDate, episodeName, descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: episodeImage.trailingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
