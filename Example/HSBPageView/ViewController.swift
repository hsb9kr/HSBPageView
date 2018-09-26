//
//  ViewController.swift
//  HSBPageView
//
//  Created by Red on 09/23/2018.
//  Copyright (c) 2018 Red. All rights reserved.
//

import UIKit
import HSBPageView

class ViewController: UIViewController {

	let colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
	@IBOutlet var pageView: HSBPageView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		
    }
}

extension ViewController: HSBPageViewDataSource {
	func numberOfView(pageView: HSBPageView) -> Int {
		return colors.count
	}
	
	func pageView(pageView: HSBPageView, for index: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = colors[index]
		
		return view
	}
	
	
}



