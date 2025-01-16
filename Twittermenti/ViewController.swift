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
	
	private var swifter: Swifter = Swifter(
		consumerKey: "LTReJyreyyuz4SWjVABuA1WKI",
		consumerSecret: "ajf107xfd6869heCG8Ptn8iztFHBWPlxLkFGvsmoEwI7MKZcz"
	)
	private let sentimentClassifier = TweetSentimentClassifier()
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
	// MARK: - IBActions
	
	@IBAction func predictPressed(_ sender: Any) {
		
	}
	
	// MARK: - private functions
	
	private func updateUI() {
		fetchTweets()
		
	}
	
	private func fetchTweets() {
		swifter.searchTweet(using: "@Apple", lang: "en", count: 100, success: { (results, metadata) in
			var tweets = [TweetSentimentClassifierInput]()
			
			for i in 0..<100 {
				if let tweet = results[i]["full_text"].string {
					let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
					tweets.append(tweetForClassification)
				}
			}
			print("tweets: \(tweets.count)")
			
			let sentimentScore = self.getSentimentScore(tweets)
			print("sentimentScore: \(sentimentScore)")
			
		}) { (error) in
			print("There was an error with the Twitter API Request, \(error)")
		}
	}
	
	private func getSentimentScore(_ tweets : [TweetSentimentClassifierInput]) -> Int {
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
			
			print(sentimentScore)
		} catch {
			print("Three was an error with making a prediction, \(error)")
		}
		return sentimentScore
	}
}
