//
//  EmptyStatusView
//
//  Created by MarioHahn on 25/08/16.
//

import Foundation
import UIKit

open class DefaultStatusView: UIView, StatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: StatusModel? {
        didSet {
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            #if swift(>=4.2)
            actionButton.setTitle(status.actionTitle, for: UIControl.State())
            #else
            actionButton.setTitle(status.actionTitle, for: UIControlState())
            #endif
            
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            actionButton.isHidden = status.action == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButton.isHidden
        }
    }

	public var statusTheme: StatusTheme = StatusTheme.defaultTheme {
		didSet {
			titleLabel.font = statusTheme.titleFont
			titleLabel.textColor = statusTheme.titleColor
			descriptionLabel.font = statusTheme.descriptionFont
			descriptionLabel.textColor = statusTheme.descriptionColor
			actionButton.setTitleColor(statusTheme.actionTitleColor, for: UIControl.State())
			actionButton.titleLabel?.font = statusTheme.actionTitleFont
			verticalStackView.spacing = statusTheme.itemsVerticalSpacing
		}
	}
    
    public let titleLabel: UILabel = {
		$0.font = StatusTheme.defaultTheme.titleFont
		$0.textColor = StatusTheme.defaultTheme.titleColor
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    public let descriptionLabel: UILabel = {
		$0.font = StatusTheme.defaultTheme.descriptionFont
		$0.textColor = StatusTheme.defaultTheme.descriptionColor
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    public let activityIndicatorView: SimpleAvtivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        return $0
	}(SimpleAvtivityIndicatorView(frame: .zero))
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    public let actionButton: UIButton = {
		$0.setTitleColor(StatusTheme.defaultTheme.actionTitleColor, for: UIControl.State())
		$0.titleLabel?.font = StatusTheme.defaultTheme.actionTitleFont
        return $0
    }(UIButton(type: .system))
	
    public let verticalStackView: UIStackView = {
		$0.axis = .vertical
		$0.spacing = StatusTheme.defaultTheme.itemsVerticalSpacing
        $0.alignment = .center

		return $0
	}(UIStackView())
    
    public let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
	public override init(frame: CGRect) {
		super.init(frame: frame)
        
        actionButton.addTarget(self, action: #selector(DefaultStatusView.actionButtonAction), for: .touchUpInside)
		
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(verticalStackView)
		verticalStackView.addArrangedSubview(activityIndicatorView)
		verticalStackView.addArrangedSubview(imageView)
		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(descriptionLabel)
		verticalStackView.addArrangedSubview(actionButton)
		
		NSLayoutConstraint.activate([
			horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
			horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
    
    #if os(tvOS)
    override open var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [actionButton]
    }
    #endif
    
    @objc func actionButtonAction() {
        status?.action?()
    }
	
	open override var tintColor: UIColor! {
		didSet {
			titleLabel.textColor = tintColor
			descriptionLabel.textColor = tintColor
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
