//
//  HSBPageView.swift
//  Pods
//
//  Created by 홍상보 on 2018. 9. 23..
//

import UIKit

@objc public protocol HSBPageViewDataSource {
	func numberOfView(pageView: HSBPageView) -> Int
	func pageView(pageView: HSBPageView, for index: Int) -> UIView?
}

@objc public protocol HSBPageViewDelegate {
	@objc optional func pageView(pageView: HSBPageView, willDisplay view: UIView?, for index: Int)
	@objc optional func pageView(pageView: HSBPageView, frameFor index:Int) -> CGRect
	@objc optional func pageView(pageView: HSBPageView, didLoad view: UIView?, for index: Int)
	@objc optional func pageView(pageView: HSBPageView, loadMore: HSBLoadMore)
	@objc optional func pageView(pageView: HSBPageView, didSelect index:Int)
	@objc optional func pageView(pageView: HSBPageView, didDragging rate: CGFloat)
}

@objc public enum HSBLoadMore: Int {
	case next
	case previous
}

public class HSBPageView: UIView {
	
	public let scrollView = HSBScrollView()
	@IBOutlet weak public var dataSource: HSBPageViewDataSource?
	@IBOutlet weak public var delegate: HSBPageViewDelegate?
	public fileprivate(set) var currentIndex: Int = 0
	public fileprivate(set) var views: [UIView] = []
	public var currentView: UIView? {
		guard views.count > currentIndex else {
			return nil
		}
		return views[currentIndex]
	}
	@IBInspectable public var inBorderColor: UIColor?
	@IBInspectable public var inBorderWidth: CGFloat = 0
	@IBInspectable public var inBorderRadius: CGFloat = 0
	
	var reuseViewClass: [String : UIView.Type] = [:]
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		reloadData()
	}
	
	public func reloadData() {
		
		let oldIndex = currentIndex
		scrollView.frame = bounds
		scrollView.contentSize = bounds.size
		
		guard let dataSource = self.dataSource else {
			return
		}
		
		let number = dataSource.numberOfView(pageView: self)
		var contentSize = scrollView.contentSize
		contentSize.width = contentSize.width * CGFloat(number)
		scrollView.contentSize = contentSize
		
		views.removeAll()
		
		for view in scrollView.subviews {
			view.removeFromSuperview()
		}
		
		for index in 0..<number {
			
			let contentView = UIView()
			contentView.backgroundColor = UIColor.clear
			
			guard let view = dataSource.pageView(pageView: self, for: index) else {
				continue
			}
			contentView.addSubview(view)
			
			view.layer.borderColor = inBorderColor?.cgColor
			view.layer.borderWidth = inBorderWidth
			view.layer.cornerRadius = inBorderRadius
			
			var frame = bounds
			frame.origin.x = frame.width * CGFloat(index)
			contentView.frame = frame
			
			frame.origin = CGPoint.zero
			view.frame = delegate?.pageView?(pageView: self, frameFor: index) ?? frame
			delegate?.pageView?(pageView: self, didLoad: view, for: index)
			
			views.append(view)
			scrollView.addSubview(contentView)
		}
		
		sendSubviewToBack(scrollView)
		scroll(to: oldIndex)
	}
	
	public func scroll(to index: Int) {
		var point = scrollView.contentOffset
		point.x = bounds.width * CGFloat(index)
		scrollView.contentOffset = point
	}
	
	public func scrollAnimate(to index: Int, duration: TimeInterval, completion: ((Bool) -> Void)?) {
		UIView.animate(withDuration: duration, animations: {
			self.scroll(to: index)
		}, completion: completion)
	}
	
	public func register(reuseView identifier: String, viewType: UIView.Type) {
		reuseViewClass[identifier] = viewType
	}
	
	public func dequeueReusableView(with identifier: String, for index: Int) -> UIView? {
		
		guard let aClass = reuseViewClass[identifier] else {
			return nil
		}
		
		guard views.count > index, views[index] === aClass else {
			return aClass.init()
		}
		
		return views[index]
	}
	
	public func view(for index: Int) -> UIView? {
		guard views.count > index else {
			return nil
		}
		
		return views[index]
	}
	
	fileprivate func initialize() {
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
		addSubview(scrollView)
	}
}

extension HSBPageView {
	@IBInspectable var bounces: Bool {
		set {
			scrollView.bounces = newValue
		}
		
		get {
			return scrollView.bounces
		}
	}
	
	@IBInspectable var isPagingEnabled: Bool {
		set {
			scrollView.isPagingEnabled = newValue
		}
		
		get {
			return scrollView.isPagingEnabled
		}
	}
	
	@IBInspectable var showsHorizontalScrollIndicator: Bool {
		set {
			scrollView.showsHorizontalScrollIndicator = newValue
		}
		
		get {
			return scrollView.showsHorizontalScrollIndicator
		}
	}
	
	@IBInspectable var showsVerticalScrollIndicator: Bool {
		set {
			scrollView.showsVerticalScrollIndicator = newValue
		}
		
		get {
			return scrollView.showsVerticalScrollIndicator
		}
	}
}

extension HSBPageView: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let width = scrollView.bounds.width
		let index = Int(floor((scrollView.contentOffset.x - width / 3) / width) + 1)
		let rate = scrollView.contentOffset.x / scrollView.contentSize.width
		delegate?.pageView?(pageView: self, didDragging: rate)
		
		guard views.count > index && currentIndex != index else {
			return
		}
		
		currentIndex = index
		delegate?.pageView?(pageView: self, willDisplay: views[index].subviews.first, for: index)
	}
	
	public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.x < 0 {
			delegate?.pageView?(pageView: self, loadMore: .previous)
		} else if scrollView.contentOffset.x + scrollView.bounds.width > scrollView.contentSize.width {
			delegate?.pageView?(pageView: self, loadMore: .next)
		}
	}
}

extension HSBPageView: HSBScrollViewDelegate {
	
	public func scrollView(scrollView: HSBScrollView, selected index: Int) {
		delegate?.pageView?(pageView: self, didSelect: index)
	}
}
