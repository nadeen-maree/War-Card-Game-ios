//
//  ResultViewController.swift
//  HW
//
//  Created by Nadeen Maree on 15/06/2023.
//

import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func resultViewControllerDidDismiss(_ viewController: ResultViewController)
}

class ResultViewController: UIViewController {
    
    var winnerName: String?
    var winnerScore: Int?
    weak var delegate: ResultViewControllerDelegate?
    public var dismissHandler: (() -> Void)?
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back to Main Menu", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add winnerLabel to the view hierarchy and set its constraints
        view.addSubview(winnerLabel)
        NSLayoutConstraint.activate([
            winnerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            winnerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // Add scoreLabel to the view hierarchy and set its constraints
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 20),
        ])

        // Add backButton to the view hierarchy and set its constraints
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
        ])
        
        // Additional setup and configuration
        configureUI()
        configureUI2()
    }
    
    private func configureUI() {
        if let winnerName = winnerName {
            winnerLabel.text = "Winner: \(winnerName)"
        }
    }
    
    
    private func configureUI2() {
        if let winnerScore = winnerScore {
            scoreLabel.text = "Score: \(winnerScore)"
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: dismissHandler)
        delegate?.resultViewControllerDidDismiss(self)
    }
}
