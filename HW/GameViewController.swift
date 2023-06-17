//
//  GameViewController.swift
//  HW
//
//  Created by Nadeen Maree on 14/06/2023.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func gameViewControllerDidDismiss(_ viewController: GameViewController)
}

class GameViewController: UIViewController, ResultViewControllerDelegate {
    public var playerName: String = ""
    private var playerScore: Int = 0
    private var computerScore: Int = 0
    private var gameCount: Int = 0
    
    weak var delegate: GameViewControllerDelegate?
    
    private let playerCardImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let computerCardImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let computerNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let playerScoreLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let computerScoreLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private let cardImages: [(UIImage, Int)] = [
        (UIImage(named: "card2")!, 2),
        (UIImage(named: "card3")!, 3),
        (UIImage(named: "card4")!, 4),
        (UIImage(named: "card5")!, 5),
        (UIImage(named: "card6")!, 6),
        (UIImage(named: "card7")!, 7),
        (UIImage(named: "card8")!, 8),
        (UIImage(named: "card9")!, 9),
        (UIImage(named: "card10")!, 10),
        (UIImage(named: "card11")!, 11),
        (UIImage(named: "card12")!, 12),
        (UIImage(named: "card13")!, 13),
        (UIImage(named: "card14")!, 14)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(playerNameLabel)
        view.addSubview(computerNameLabel)
        view.addSubview(playerScoreLabel)
        view.addSubview(computerScoreLabel)
        view.addSubview(playerCardImageView)
        view.addSubview(computerCardImageView)
        
        let playerSide = UserDefaults.standard.string(forKey: "playerSide")
           
        if playerSide == "west"{
            playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                playerNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
            
            computerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                computerNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
            
            playerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerScoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                playerScoreLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 8)
            ])
            
            computerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerScoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                computerScoreLabel.topAnchor.constraint(equalTo: computerNameLabel.bottomAnchor, constant: 8)
            ])
            
            playerCardImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerCardImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
                playerCardImageView.topAnchor.constraint(equalTo: playerScoreLabel.bottomAnchor, constant: 20)
            ])

            computerCardImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerCardImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
                computerCardImageView.topAnchor.constraint(equalTo: computerScoreLabel.bottomAnchor, constant: 20)
            ])
        }else if playerSide == "east"{
            playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                playerNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
            
            computerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                computerNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
            
            playerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerScoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                playerScoreLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 8)
            ])
            
            computerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerScoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                computerScoreLabel.topAnchor.constraint(equalTo: computerNameLabel.bottomAnchor, constant: 8)
            ])
            
            playerCardImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerCardImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
                playerCardImageView.topAnchor.constraint(equalTo: playerScoreLabel.bottomAnchor, constant: 20)
            ])
            
            computerCardImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                computerCardImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
                computerCardImageView.topAnchor.constraint(equalTo: computerScoreLabel.bottomAnchor, constant: 20)
            ])
        }
        // Start the game
        startGame()
    }

    private var playerCard: (UIImage, Int)?  // Declare playerCard as a property
    private var computerCard: (UIImage, Int)?  // Declare computerCard as a property
    
    private func startGame() {
        // Get the player name from the previous page
        if let userName = UserDefaults.standard.string(forKey: "UserName") {
            playerName = userName
        }
        
        playerNameLabel.text = "\(playerName)"
        computerNameLabel.text = "Computer"
        
        // Start the game loop
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            // Perform card flipping animation
            self.flipCards()
            
            // Determine the power/strength of player and computer cards
            if let playerCard = self.playerCard,
               let computerCard = self.computerCard {
                let playerCardStrength = playerCard.1
                let computerCardStrength = computerCard.1
                
                // Update the score and check for a winner
                self.updateScore(playerCardStrength: playerCardStrength, computerCardStrength: computerCardStrength)
            }
            
            // Increment the game count and check if it reached 10
            self.gameCount += 1
            if self.gameCount == 10 {
                // End the game and navigate to the next page
                self.endGame()
                timer.invalidate()
            }
        }
    }
    
    private func flipCards() {
        // Perform the card flipping animation to flip the cards back
        flipBackCards()
        
        // Delay the flipping to the front side
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Randomly select card images for player and computer
            if let playerCard = self.cardImages.randomElement(),
               let computerCard = self.cardImages.randomElement() {
                
                self.playerCard = playerCard
                self.computerCard = computerCard
                
                UIView.transition(with: self.playerCardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    self.playerCardImageView.image = playerCard.0
                }, completion: nil)
                
                UIView.transition(with: self.computerCardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    self.computerCardImageView.image = computerCard.0
                }, completion: nil)
            }
        }
    }
    
    private func flipBackCards() {
        // Perform the card flipping animation to flip the cards back
        UIView.transition(with: playerCardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.playerCardImageView.image = UIImage(named: "back")
        }, completion: nil)
        
        UIView.transition(with: computerCardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.computerCardImageView.image = UIImage(named: "back")
        }, completion: nil)
    }
    
    private func updateScore(playerCardStrength: Int, computerCardStrength: Int) {
        // Compare the strengths of player and computer cards
        if playerCardStrength > computerCardStrength {
            playerScore += 1
        } else if playerCardStrength < computerCardStrength {
            computerScore += 1
        }
        
        // Update the score labels
        playerScoreLabel.text = "\(playerScore)"
        computerScoreLabel.text = "\(computerScore)"
    }
    
    private func endGame() {
        // Determine the winner
        let winner: String
        let score: Int
        
        if playerScore > computerScore {
            winner = playerName
            score = playerScore
        } else if playerScore < computerScore {
            winner = "Computer"
            score = computerScore
        } else {
            winner = "Computer" // If it's a draw, decide that the computer wins
            score = computerScore
        }
        
        // Create the result view controller
        let resultViewController = ResultViewController()
        resultViewController.winnerName = winner
        resultViewController.winnerScore = score
        resultViewController.modalPresentationStyle = .overFullScreen
        
        // Set up a completion handler to handle the "Back to main menu" action
        resultViewController.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.delegate?.gameViewControllerDidDismiss(self!)
            })
        }
        
        // Present the result view controller as a popup
        present(resultViewController, animated: true, completion: nil)
    }
    
    // Implement the ResultViewControllerDelegate method
    func resultViewControllerDidDismiss(_ viewController: ResultViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameToResultSegue" {
            if let resultViewController = segue.destination as? ResultViewController,
               let winner = sender as? (name: String, score: Int) {
                resultViewController.winnerName = winner.name
                resultViewController.winnerScore = winner.score
                resultViewController.dismissHandler = { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

