//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sentimentLabel: UILabel!
	
	// MARK: - constants/objects
	
	private let tweetCount = 100
	private var swifter: Swifter = Swifter(
		consumerKey: "LTReJyreyyuz4SWjVABuA1WKI",
		consumerSecret: "ajf107xfd6869heCG8Ptn8iztFHBWPlxLkFGvsmoEwI7MKZcz"
	)
	private let sentimentClassifier = TweetSentimentClassifier()
	
	// MARK: - IBActions
	
	@IBAction func predictPressed(_ sender: Any) {
		if let searchText = textField.text {
			fetchTweets(with: searchText)
		}
	}
	
	// MARK: - private functions
	
	private func fetchTweets(with searchText: String) {
		swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, success: { (results, metadata) in
			var tweets = [TweetSentimentClassifierInput]()
			
			for i in 0..<self.tweetCount {
				if let tweet = results[i]["full_text"].string {
					let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
					tweets.append(tweetForClassification)
				}
			}
			
			let sentimentScore = self.makePrediction(tweets)
			self.updateUI(with: sentimentScore)
			
		}) { (error) in
			print("There was an error with the Twitter API Request, \(error)")
		}
	}
	
	private func makePrediction(_ tweets : [TweetSentimentClassifierInput]) -> Int {
		var sentimentScore = 0
		do {
			let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
			
			for prediction in predictions {
				let sentiment = prediction.label
				if sentiment == "Pos" {
					sentimentScore += 1
				} else if sentiment == "Neg" {
					sentimentScore -= 1
				}
			}
		} catch {
			print("Three was an error with making a prediction, \(error)")
		}
		return sentimentScore
	}
	
	private func updateUI(with sentimentScore: Int) {
		if sentimentScore > 20 {
			sentimentLabel.text = "😍"
		} else if sentimentScore > 10 {
			sentimentLabel.text = "😊"
		} else if sentimentScore > 0 {
			sentimentLabel.text = "🙂"
		} else if sentimentScore == 0 {
			sentimentLabel.text = "😐"
		} else if sentimentScore > -10 {
			sentimentLabel.text = "😕"
		} else if sentimentScore > -20 {
			sentimentLabel.text = "😡"
		} else {
			sentimentLabel.text = "🤮"
		}
	}
}
