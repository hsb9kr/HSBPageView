//
//  HSBScrollView.swift
//  Pods
//
//  Created by 홍상보 on 2018. 9. 23..
//

import UIKit

@objc public protocol HSBScrollViewDelegate {
	func scrollView(scrollView: HSBScrollView, selected index: Int)
}

public class HSBScrollView: UIScrollView {
	fileprivate weak var customDelegate: HSBScrollViewDelegate?
	public override var delegate: UIScrollViewDelegate? {
		didSet {
			customDelegate = delegate as? HSBScrollViewDelegate
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let index = Int(contentOffset.x / bounds.width)
		customDelegate?.scrollView(scrollView: self, selected: index)
	}
}
