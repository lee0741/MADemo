//
//  detailController.swift
//  MADemo
//
//  Created by Yancen Li on 3/16/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class DetailController: UIViewController {
    
    var personName: String?
    var audioPlayer: AVAudioPlayer?
    var interstitial: GADInterstitial!
    var timer: Timer!
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "pic1")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("拒否", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("応答", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(35)
        label.textColor = .brown
        label.text = "着信中\n\(self.personName!)\nXXX-XXXX-XXXX"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3818139859760841/4780360612")
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "e5c728e682abdeff6ab6858bb902d581"]
        interstitial.load(request)
        return interstitial
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ringtone = NSURL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "mp3")!)
        audioPlayer = try? AVAudioPlayer(contentsOf: ringtone as URL)
        audioPlayer?.prepareToPlay()
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
        interstitial = createAndLoadInterstitial()
    }
    
}

// MARK: - Layout Constraints

extension DetailController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(noButton)
        view.addSubview(yesButton)
        view.addSubview(stateLabel)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: noButton.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            noButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            noButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            noButton.rightAnchor.constraint(equalTo: yesButton.leftAnchor, constant: -15),
            noButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            yesButton.leftAnchor.constraint(equalTo: noButton.rightAnchor, constant: 15),
            yesButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            yesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            yesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            yesButton.widthAnchor.constraint(equalTo: noButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
        
    }
}

// MARK: - Actions

extension DetailController: GADInterstitialDelegate {

    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func noButtonTapped() {
        audioPlayer?.stop()
        timer?.invalidate()
        
        if noButton.titleLabel?.text == "拒否" {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func yesButtonTapped() {
        view.layoutIfNeeded()
        stateLabel.text = "通話中\n\(personName!)"
        noButton.setTitle("通話を終了", for: .normal)
        
        yesButton.isHidden = true
        NSLayoutConstraint.activate([
            stateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            noButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50)
        ])
        
        view.layoutIfNeeded()
        
        audioPlayer?.stop()
        audioPlayer?.numberOfLoops = 0
        
        var count = 0
        let bgms = [
            NSURL(fileURLWithPath: Bundle.main.path(forResource: "ohayougozaimasu", ofType: "mp3")!),
            NSURL(fileURLWithPath: Bundle.main.path(forResource: "chottomatte", ofType: "mp3")!),
            NSURL(fileURLWithPath: Bundle.main.path(forResource: "moushiranai", ofType: "mp3")!)]
        let bgImage = [#imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic3"), #imageLiteral(resourceName: "pic4")]
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            self.imageView.image = bgImage[count]
            self.audioPlayer = try? AVAudioPlayer(contentsOf: bgms[count] as URL)
            self.audioPlayer?.play()
            count += 1
            
            if count == bgms.count {
                timer.invalidate()
            }
        }
    }
}
