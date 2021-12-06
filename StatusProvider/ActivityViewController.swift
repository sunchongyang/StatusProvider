//
//  ActivityViewController.swift
//  StatusProvider
//
//  Created by MarioHahn on 26/08/16.
//  Copyright © 2016 MarioHahn. All rights reserved.
//

import Foundation
import UIKit
import StatusProvider

class ActivityViewController: UIViewController, StatusController {
    
	override func loadView() {
		super.loadView()
		let theme = StatusTheme(titleColor: .green, descriptionColor: .red, actionTitleColor: .yellow)
		StatusTheme.defaultTheme = theme
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loading"
        
        let status = Status(isLoading: true, description: "Lädt…")
        
        show(status: status)
    }

	@IBAction func start(_ sender: Any) {
		if let st = view.statusContainerView as? DefaultStatusView {
			st.activityIndicatorView.startAnimating()
		}
	}
	
	@IBAction func stop(_ sender: Any) {
		if let st = view.statusContainerView as? DefaultStatusView {
			st.activityIndicatorView.stopAnimating()
		}
	}
	
}
