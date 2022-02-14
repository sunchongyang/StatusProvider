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

	private let layers: [CAGradientLayer] = [
		CAGradientLayer(),
		CAGradientLayer(),
		CAGradientLayer()
	]
	private let gradientColors = [
		UIColor(red: 0xB1/255.0, green: 0xB1/255.0, blue: 0x49/255.0, alpha: 1.0).cgColor,
		UIColor(red: 0xE3/255.0, green: 0xA6/255.0, blue: 0x0C/255.0, alpha: 1.0).cgColor,
		UIColor(red: 0xEA/255.0, green: 0x60/255.0, blue: 0x5E/255.0, alpha: 1.0).cgColor
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
		let dotSize: CGFloat = 8
		let dotSpacing: CGFloat = 8
		for (index, layer) in layers.enumerated() {
			layer.colors = gradientColors
			layer.startPoint = CGPoint(x: 0, y: 0)
			layer.endPoint = CGPoint(x: 1, y: 1)
			layer.cornerRadius = dotSize/2
			layer.masksToBounds = true
			switch index {
			case 0:
				layer.frame = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)

			case 1:
				layer.frame = CGRect(x: dotSize + dotSpacing, y: 0, width: dotSize, height: dotSize)

			case 2:
				layer.frame = CGRect(x: dotSize, y: dotSize + dotSpacing/2, width: dotSize, height: dotSize)

			default:
				break
			}

			self.layer.addSublayer(layer)
		}
	}

	public override var intrinsicContentSize: CGSize {
		let width = 24
		let height = 20
		return CGSize(width: width, height: height)
	}

	private func makeCAAnimation(keyPath: String, toValue: Any, duration: CFTimeInterval, beginTime: CFTimeInterval = 0) -> CABasicAnimation {
		let basicAnimation = CABasicAnimation(keyPath: keyPath)
		basicAnimation.duration = duration
		basicAnimation.beginTime = beginTime
		basicAnimation.toValue = toValue
		basicAnimation.isRemovedOnCompletion = false
		basicAnimation.fillMode = .forwards
		return basicAnimation
	}

	private func nextLayer(after layer: CAGradientLayer) -> CAGradientLayer? {
		if let index = layers.index(of: layer) {
			let nextIndex = (index + 1)%layers.count
			return layers[nextIndex]
		}

		return nil
	}

	private var timerTicks: Int = 0
	@objc private func timerFired() {
		let preIndex = (timerTicks - 1)
		let prevLayer = preIndex >= 0 ? layers[preIndex] : nil
		let currentIndex = timerTicks
		let currentLayer = currentIndex < layers.count ? layers[currentIndex] : nil
		UIView.animate(withDuration: 0.30) {
			currentLayer?.setAffineTransform(CGAffineTransform(scaleX: 1.5, y: 1.5))
			prevLayer?.setAffineTransform(.identity)
		}
		if timerTicks == layers.count {
			timerTicks = 0
		} else {
			timerTicks += 1
		}
	}

	public func startAnimating() {
		isAnimating = true
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
	}

	public func stopAnimating() {
		isAnimating = false
		timer?.invalidate()
		timer = nil
		timerTicks = 0
	}
}
