//
//  SimpleAvtivityIndicatorView.swift
//  StatusProvider
//
//  Created by Sun chongyang on 2021/12/5.
//  Copyright © 2021 MarioHahn. All rights reserved.
//

import UIKit

public class SimpleAvtivityIndicatorView: UIView {
	public var isAnimating: Bool = false {
		didSet {
			isHidden = hidesWhenStopped && !isAnimating
		}
	}
	public var hidesWhenStopped: Bool = true

	public var layers: [CALayer] = [
		CALayer(),
		CALayer(),
		CALayer()
	]
	private let colors = [
		UIColor(red: 0x20/255.0, green: 0x20/255.0, blue: 0x20/255.0, alpha: 1.0),
		UIColor(red: 0xA6/255.0, green: 0xA6/255.0, blue: 0xA6/255.0, alpha: 1.0),
		UIColor(red: 0xD2/255.0, green: 0xD2/255.0, blue: 0xD2/255.0, alpha: 1.0)
	]
	private var timer: Timer?

	override init(frame: CGRect) {
		super.init(frame: frame)
		addLayers()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		addLayers()
	}

	private func addLayers() {
		backgroundColor = .clear
		let dotSize: CGFloat = 4
		let dotSpacing: CGFloat = 4
		for (index, layer) in layers.enumerated() {
			layer.backgroundColor = colors[index].cgColor
			layer.cornerRadius = dotSize/2
			layer.masksToBounds = true
			let x = CGFloat(index) * (dotSize + dotSpacing)
			layer.frame = CGRect(x: x, y: 0, width: dotSize, height: dotSize)
			self.layer.addSublayer(layer)
		}
	}

	public override var intrinsicContentSize: CGSize {
		let width = 3*4 + 2*4
		let height = 4
		return CGSize(width: width, height: height)
	}

	private var timerTicks: Int = 0
	@objc private func timerFired() {
		for (index, layer) in layers.enumerated() {
			let colorIndex = (index + timerTicks)%colors.count
			layer.backgroundColor = colors[colorIndex].cgColor
		}
		timerTicks += 1
	}

	public func startAnimating() {
		isAnimating = true
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
	}

	public func stopAnimating() {
		isAnimating = false
		timer?.invalidate()
		timer = nil
		timerTicks = 0
	}
}
