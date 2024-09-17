import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    var videoURL: URL?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let palette = GlobalConfig.shared.palette

    // UI Elements
    private let playPauseButton = UIButton(type: .system)
    private let buttonsStackView = UIStackView()
    private let descriptionTextView = UITextView()
    private let toolbar = UIView()
    private let feedbackTypeSelector = UISegmentedControl()
    private let playPauseButtonSize: CGFloat = 48
    
    private var isPlaying = false
    
    init(videoURL: URL? = nil, player: AVPlayer? = nil, playerLayer: AVPlayerLayer? = nil, isPlaying: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.videoURL = videoURL
        self.player = player
        self.playerLayer = playerLayer
        self.isPlaying = isPlaying
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = .black
        addNotifications()
        addGestures()
        setupUI()
    }

    @objc private func discardTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func feedbackTapped() {
        print("Feedback enviado")
    }

    @objc private func playPauseTapped() {
        if isPlaying {
            let playPauseButtonConfiguration = UIImage.SymbolConfiguration(pointSize: playPauseButtonSize)
            let image = UIImage(systemName: "play.circle.fill", withConfiguration: playPauseButtonConfiguration)
            playPauseButton.setImage(image, for: .normal)
            player?.pause()
        } else {
            let playPauseButtonConfiguration = UIImage.SymbolConfiguration(pointSize: playPauseButtonSize)
            let image = UIImage(systemName: "stop.circle.fill", withConfiguration: playPauseButtonConfiguration)
            playPauseButton.setImage(image, for: .normal)
            player?.play()
        }
        isPlaying.toggle()
    }
    
    @objc private func videoDidEnd() {
        let playPauseButtonConfiguration = UIImage.SymbolConfiguration(pointSize: playPauseButtonSize)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: playPauseButtonConfiguration)
        playPauseButton.setImage(image, for: .normal)
        
        player?.seek(to: CMTime.zero)
        
        isPlaying = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: setHeightFrameDiff())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        player = nil
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setHeightFrameDiff() -> CGFloat {
        return view.bounds.height - 80
    }
}

// MARK: - Setup views methods

extension VideoPlayerViewController {
    
    private func setupUI() {
        setupVideoPlayer()
        setupButtonsStackView()
        setupPlayPauseButton()
        setupDescriptionTextView()
        setupSelectorStackView()
        setupToolbar()
    }
    
    private func setupVideoPlayer() {
        guard let videoURL = videoURL else {
            print("Invalid video URL")
            return
        }

        player = AVPlayer(url: videoURL)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect

        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
    }
    
    private func setupPlayPauseButton() {
        let playPauseButtonConfiguration = UIImage.SymbolConfiguration(pointSize: playPauseButtonSize)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: playPauseButtonConfiguration)
        playPauseButton.setImage(image, for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchDown)
        playPauseButton.clipsToBounds = true
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.backgroundColor = .white
        descriptionTextView.textColor = .black
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.addArrangedSubview(descriptionTextView)
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSelectorStackView() {

        feedbackTypeSelector.selectedSegmentTintColor = palette.primaryColor
        feedbackTypeSelector.backgroundColor = palette.secondaryColor
        let selectedTextColor = [NSAttributedString.Key.foregroundColor: palette.primaryFontColor]
        let normalTextColor = [NSAttributedString.Key.foregroundColor: palette.secondaryFontColor]
        feedbackTypeSelector.setTitleTextAttributes(normalTextColor, for: .normal)
        feedbackTypeSelector.setTitleTextAttributes(selectedTextColor, for: .selected)
        feedbackTypeSelector.insertSegment(withTitle: literal(.feedbackTypeFeedback), at: 0, animated: true)
        feedbackTypeSelector.insertSegment(withTitle: literal(.feedbackTypeBug), at: 1, animated: true)
        feedbackTypeSelector.selectedSegmentIndex = 0

        let horizontalStackView = UIStackView(arrangedSubviews: [feedbackTypeSelector])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.backgroundColor = .white
        horizontalStackView.layer.cornerRadius = 8
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            
        view.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -8),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupToolbar() {
        toolbar.backgroundColor = palette.primaryColor
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let discardButton = UIButton(type: .system)
        discardButton.setTitle(literal(.alertButtonCancel), for: .normal)
        discardButton.setTitleColor(.white, for: .normal)
        discardButton.addTarget(self, action: #selector(discardTapped), for: .touchUpInside)
        discardButton.translatesAutoresizingMaskIntoConstraints = false
        
        let centerImageView = UIImageView(image: UIImage(systemName: "video")!)
        centerImageView.contentMode = .scaleAspectFit
        centerImageView.tintColor = .white
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let feedbackButton = UIButton(type: .system)
        feedbackButton.setTitle(literal(.feedbackButtonSend), for: .normal)
        feedbackButton.setTitleColor(.white, for: .normal)
        feedbackButton.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toolbar)
        toolbar.addSubview(discardButton)
        toolbar.addSubview(centerImageView)
        toolbar.addSubview(feedbackButton)
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            
            discardButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 16),
            discardButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            
            feedbackButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16),
            feedbackButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            
            centerImageView.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            centerImageView.heightAnchor.constraint(equalToConstant: 24),
            centerImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

// MARK: - Keyboard methods
extension VideoPlayerViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3) {
                self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.setHeightFrameDiff())
                self.buttonsStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.setHeightFrameDiff())
            self.buttonsStackView.transform = .identity
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
