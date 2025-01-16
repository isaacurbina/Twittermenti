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
		let prediction = try! sentimentClassifier.prediction(text: "@Apple is a terrible company!")
		print(prediction.label)
		
		swifter.searchTweet(using: "@Apple", lang: "en", count: 100, success: { (results, metadata) in
			var tweets = [String]()
			
			for i in 0..<100 {
				if let tweet = results[i]["full_text"].string {
					tweets.append(tweet)
				}
			}
		}) { (error) in
			print("There was an error with the Twitter API Request, \(error)")
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func predictPressed(_ sender: Any) {
		
	}
}
