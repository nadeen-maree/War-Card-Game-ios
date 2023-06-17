//
//  ViewController.swift
//  HW
//
//  Created by Nadeen Maree on 10/06/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    private let locationManager = CLLocationManager()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var enterNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enter Name", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(enterNameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let eastImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "east_side")
        imageView.isHidden = true
        return imageView
    }()
    
    private let westImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "west_side")
        imageView.isHidden = true
        return imageView
    }()
    
    private let midpoint: CLLocationDegrees = 34.817549168324334

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(nameLabel)
        view.addSubview(enterNameButton)
        view.addSubview(startButton)
        view.addSubview(westImage)
        view.addSubview(eastImage)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            enterNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),

            westImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            westImage.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            westImage.topAnchor.constraint(equalTo: view.topAnchor),
            westImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            eastImage.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            eastImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eastImage.topAnchor.constraint(equalTo: view.topAnchor),
            eastImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func showEnterNameAlert() {
        let alert = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alert.textFields?.first,
                  let name = textField.text,
                  !name.isEmpty else {
                self?.showEnterNameAlert()
                return
            }
            
            UserDefaults.standard.set(name, forKey: "UserName")
            self.nameLabel.text = "Hello, \(name)"
            self.nameLabel.isHidden = false
            self.enterNameButton.isHidden = true
            self.startButton.isHidden = false
        }
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func enterNameButtonTapped() {
        showEnterNameAlert()
    }
    
    @objc private func startButtonTapped() {
        if let location = locationManager.location {
            let longitude = location.coordinate.longitude
            if longitude > midpoint {
                eastImage.isHidden = false
                westImage.isHidden = true
            } else {
                eastImage.isHidden = true
                westImage.isHidden = false
            }
            locationManager.stopUpdatingLocation()
            
            // Instantiate the game view controller and set player name
            let gameVC = GameViewController()
            gameVC.playerName = nameLabel.text ?? ""
            
            // Present the game view controller modally
            present(gameVC, animated: true, completion: nil)
        }
        
        // Implement the delegate method
        func gameViewControllerDidFinish(_ gameViewController: GameViewController) {
            // Handle the dismissal of GameViewController here
            if let presentedGameVC = presentedViewController as? GameViewController {
                presentedGameVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func resultViewControllerDidFinish(_ resultViewController: ResultViewController) {
        UserDefaults.standard.removeObject(forKey: "UserName")
        nameLabel.isHidden = true
        enterNameButton.isHidden = false
        startButton.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        var playerSide: String = ""
    
        let longitude = location.coordinate.longitude
        if longitude > midpoint {
            playerSide = "east"
            eastImage.isHidden = false
            westImage.isHidden = true
        } else {
            playerSide = "west"
            eastImage.isHidden = true
            westImage.isHidden = false
        }

        locationManager.stopUpdatingLocation()
        UserDefaults.standard.set(playerSide, forKey: "playerSide")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle the location manager error here
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
