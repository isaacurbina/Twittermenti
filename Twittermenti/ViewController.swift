//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

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
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		swifter.searchTweet(using: "@Apple", count: 10, success: { (results, metadata) in
			print(results)
		}) { (error) in
			print("There was an error with the Twitter API Request, \(error)")
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func predictPressed(_ sender: Any) {
		
	}
}
