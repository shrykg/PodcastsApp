//
//  PlayerDetailsView.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 16/06/21.
//

import UIKit
import Kingfisher
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView {
    
    var miniImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return iv
    }()
    
    var miniTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let miniPlayPauseButton: UIButton = {
        let b = UIButton(type: .system)
//        b.backgroundColor = .green
        b.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let symbol = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        b.setImage(symbol, for: .normal)
        b.widthAnchor.constraint(equalToConstant: 32).isActive = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let miniForwardButton: UIButton = {
        let b = UIButton(type: .system)
//        b.backgroundColor = .blue
        b.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let symbol = UIImage(systemName: "goforward.15", withConfiguration: configuration)
        b.widthAnchor.constraint(equalToConstant: 32).isActive = true
        b.setImage(symbol, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()
    
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    var episode: Episode! {
        didSet{
            episodeNameLabel.text = episode.title
            authorNameLabel.text = episode.author
            miniTitle.text = episode.title
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            image.kf.setImage(with: url)
//            miniImage.kf.setImage(with: url)
            
            miniImage.kf.setImage(with: url) { result in
                
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                switch result {
                case .success(let value):
                    let img = value.image
                    let artWork = MPMediaItemArtwork(boundsSize: img.size) { (_) -> UIImage in
                        return img
                    }
                    nowPlayingInfo?[MPMediaItemPropertyArtwork] = artWork
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            playEpisode()
            
            setUpNowPlayingInfo()
            
        }
    }
    
    var player: AVPlayer = {
        let p = AVPlayer()
        p.automaticallyWaitsToMinimizeStalling = false
        return p
    }()
    
    lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 1).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.transform = shrunkenTransform
        return iv
    }()
    
    let dismissButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Dismiss", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        b.setTitleColor(.black, for: .normal)
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return b
    }()
    
    let slider: UISlider = {
        let s = UISlider()
        s.tintColor = .purple
        s.isContinuous = true
        s.translatesAutoresizingMaskIntoConstraints = false
        s.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return s
    }()
    
    let episodeNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Episode name"
        l.numberOfLines = 2
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return l
    }()
    
    let authorNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Author name"
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .purple
        return l
    }()
    
    let playPauseButton: UIButton = {
        let b = UIButton(type: .system)
//        b.backgroundColor = .green
        b.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 56)
        let symbol = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        b.setImage(symbol, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let rewindButton: UIButton = {
        let b = UIButton(type: .system)
//        b.backgroundColor = .red
        b.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 36)
        let symbol = UIImage(systemName: "gobackward.15", withConfiguration: configuration)
        b.setImage(symbol, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let forwardButton: UIButton = {
        let b = UIButton(type: .system)
//        b.backgroundColor = .blue
        b.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 36)
        let symbol = UIImage(systemName: "goforward.15", withConfiguration: configuration)
        b.setImage(symbol, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let volumeLowButton: UIButton = {
        let b = UIButton()
        b.tintColor = .black
        b.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let volumeHighButton: UIButton = {
        let b = UIButton()
        b.tintColor = .black
        b.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let volumeSlider: UISlider = {
        let s = UISlider()
        s.tintColor = .purple
        s.value = 1
        s.isContinuous = true
        s.translatesAutoresizingMaskIntoConstraints = false
//        s.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return s
    }()
    
    let startTimeLabel: UILabel = {
        let l = UILabel()
        l.text = "0:00"
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    let endTimeLabel: UILabel = {
        let l = UILabel()
        l.text = "--:--"
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        v.backgroundColor = .lightGray
        return v
    }()
    
    @objc func handleTap() {
        let main = UIApplication.shared.windows.first?.rootViewController as? MainTabbarController
        main?.maximizePlayer(episode: nil)
    }
    
    var mainStack = UIStackView()
    var miniStack = UIStackView()
    
    fileprivate func setUpAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("failed to set audio session: \(error)")
        }
    }
    
    fileprivate func setUpRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true
//        commandCenter.playCommand.addTarget { _ in
////            self.handlePlayPause()
//            return .success
//        }
        
        commandCenter.playCommand.addTarget(self, action: #selector(playCommand))
        
//        commandCenter.pauseCommand.addTarget { _ in
////            self.handlePlayPause()
//            return .success
//        }
        
        commandCenter.togglePlayPauseCommand.addTarget { _ in
//            self.handlePlayPause()
            return .success
        }
        
        
    }
    
    @objc func playCommand() -> MPRemoteCommandHandlerStatus {
        handlePlayPause()
        return .success
    }
    
    fileprivate func setUpNowPlayingInfo() {
        
        var nowPlayingInfo = [String:Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpRemoteControl()
        
        setUpAudioSession()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
//        self.miniStack.addGestureRecognizer(pan)
        
        observePlayerTrack()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeImage()
        }
        
        
        backgroundColor = .white
        
        addSubview(separatorView)
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        separatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        
        miniStack = UIStackView(arrangedSubviews: [miniImage, miniTitle, miniPlayPauseButton, miniForwardButton])
        miniStack.alignment = .center
        miniStack.translatesAutoresizingMaskIntoConstraints = false
        miniStack.distribution = .fill
        miniStack.spacing = 12
        miniStack.isUserInteractionEnabled = true
        
        
        
        addSubview(miniStack)
        miniStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        miniStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        miniStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        miniStack.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.miniStack.addGestureRecognizer(pan)
        
        
        
        let timeStampStack = UIStackView(arrangedSubviews: [startTimeLabel,UIView(),endTimeLabel])
        timeStampStack.translatesAutoresizingMaskIntoConstraints = false
        timeStampStack.alignment = .center
        
        let playControlsStack = UIStackView(arrangedSubviews: [rewindButton, playPauseButton,forwardButton])
        playControlsStack.translatesAutoresizingMaskIntoConstraints = false
        playControlsStack.alignment = .center
        playControlsStack.distribution = .fillEqually
        
        let volumeStack = UIStackView(arrangedSubviews: [volumeLowButton, volumeSlider, volumeHighButton])
        volumeStack.translatesAutoresizingMaskIntoConstraints = false
        volumeStack.alignment = .center
        volumeStack.distribution = .fill
        volumeStack.spacing = 4
        
        
        
        mainStack = UIStackView(arrangedSubviews: [dismissButton, image, slider,timeStampStack, episodeNameLabel, authorNameLabel, playControlsStack, volumeStack])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 8
        
        
        addSubview(mainStack)
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        slider.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1).isActive = true
        playControlsStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1).isActive = true
        volumeStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1).isActive = true
        timeStampStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1).isActive = true
        timeStampStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        forwardButton.addTarget(self, action: #selector(forwardTime), for: .touchUpInside)
        miniForwardButton.addTarget(self, action: #selector(forwardTime), for: .touchUpInside)
        rewindButton.addTarget(self, action: #selector(reverseTime), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(handleVolumeChange), for: .valueChanged)
        slider.addTarget(self, action: #selector(handleTrackScrub), for: .valueChanged)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        let position = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        switch gesture.state {
        case .began:
            ()
        case .changed:
            self.transform = CGAffineTransform(translationX: 0, y: position.y)
            self.mainStack.alpha = -position.y / 200
            self.miniStack.alpha = 1 + position.y / 200
            print(position.y)
        case .ended:
            
            if position.y < -200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    let tabVC = UITabBarController()
                    self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height + 64)
                    self.mainStack.alpha = 1
                    self.miniStack.alpha = 0

                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.transform = .identity
                    self.mainStack.alpha = 0
                    self.miniStack.alpha = 1
                }
            }
        case .possible:
            ()
        case .cancelled:
            ()
        case .failed:
            ()
        @unknown default:
            ()
        }
        
    }
    
    @objc func handleDismiss() {
//        self.removeFromSuperview()
        let main = UIApplication.shared.windows.first?.rootViewController as? MainTabbarController
        main?.minimizePlayer()
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            let configuration = UIImage.SymbolConfiguration(pointSize: 56)
            let symbol = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playPauseButton.setImage(symbol, for: .normal)
            let miniconfiguration = UIImage.SymbolConfiguration(pointSize: 24)
            let minisymbol = UIImage(systemName: "pause.fill", withConfiguration: miniconfiguration)
            miniPlayPauseButton.setImage(minisymbol, for: .normal)
            enlargeImage()
        } else {
            player.pause()
            let configuration = UIImage.SymbolConfiguration(pointSize: 56)
            let symbol = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playPauseButton.setImage(symbol, for: .normal)
            let miniconfiguration = UIImage.SymbolConfiguration(pointSize: 24)
            let minisymbol = UIImage(systemName: "play.fill", withConfiguration: miniconfiguration)
            miniPlayPauseButton.setImage(minisymbol, for: .normal)
            shrunkImage()
        }
    }
    
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func enlargeImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.image.transform = .identity
        }
    }
    
    fileprivate func shrunkImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.image.transform = self.shrunkenTransform
        }
    }
    
    func observePlayerTrack() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.startTimeLabel.text = time.toTimeString()
            let endTime = self?.player.currentItem?.duration
            self?.endTimeLabel.text = endTime?.toTimeString()
            self?.updateTrackSlider()
            self?.updateLockScreenTrack()
        }
    }
    
    fileprivate func updateLockScreenTrack() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = player.currentItem else {return}
        let durationsInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationsInSeconds
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTimeInSeconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func updateTrackSlider() {
        let currrentTime = CMTimeGetSeconds(player.currentTime())
        let totalTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percent = currrentTime / totalTime
        self.slider.value = Float(percent)
    }
    
    @objc func handleTrackScrub() {
        let percent = slider.value
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percent) * durationInSeconds
        let seek = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seek)
    }
    
    @objc func handleVolumeChange() {
        player.volume = volumeSlider.value
    }
    
    @objc func forwardTime() {
        scrubTime(delta: 15)
    }
    
    @objc func reverseTime() {
        scrubTime(delta: -15)
    }
    
    func scrubTime(delta: Int64) {
        let time = CMTimeAdd(player.currentTime(), CMTimeMake(value: delta, timescale: 1))
        player.seek(to: time)
    }
    
}
