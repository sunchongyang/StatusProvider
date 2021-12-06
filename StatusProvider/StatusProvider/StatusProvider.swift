//
//  StatusProvider.swift
//
//  Created by MarioHahn on 23/08/16.
//

import Foundation
import UIKit

public protocol StatusThemeModel {
	var titleColor: UIColor 			{ get }
	var titleFont: UIFont 				{ get }
	var descriptionColor: UIColor 		{ get }
	var descriptionFont: UIFont 		{ get }
	var actionTitleColor: UIColor? 	{ get }
	var actionTitleFont: UIFont? 		{ get }
	var itemsVerticalSpacing: CGFloat 	{ get }
}

extension StatusThemeModel {
	public var titleColor: UIColor {
		return .black
	}
	
	public var titleFont: UIFont {
		return UIFont.preferredFont(forTextStyle: .headline)
	}
	
	public var descriptionColor: UIColor {
		return .black
	}
	
	public var descriptionFont: UIFont {
		return UIFont.preferredFont(forTextStyle: .caption2)
	}
	
	public var actionTitleColor: UIColor? {
		return nil
	}
	
	public var actionTitleFont: UIFont? {
		return nil
	}
	
	public var itemsVerticalSpacing: CGFloat {
		return 10
	}
}

public struct StatusTheme: StatusThemeModel {
	public let titleColor: UIColor
	public let titleFont: UIFont
	public let descriptionColor: UIColor
	public let descriptionFont: UIFont
	public let actionTitleColor: UIColor?
	public let actionTitleFont: UIFont?
	public let itemsVerticalSpacing: CGFloat

	public init(
		titleColor: UIColor = UIColor(red: 0x20/255.0, green: 0x20/255.0, blue: 0x20/255.0, alpha: 1.0),
		titleFont: UIFont = UIFont.preferredFont(forTextStyle: .headline),
		descriptionColor: UIColor = UIColor(red: 0xC7/255.0, green: 0xC7/255.0, blue: 0xC7/255.0, alpha: 1.0),
		descriptionFont: UIFont = UIFont.preferredFont(forTextStyle: .caption2),
		actionTitleColor: UIColor? = nil,
		actionTitleFont: UIFont? = nil,
		itemsVerticalSpacing: CGFloat = 10
		) {
		self.titleColor = titleColor
		self.titleFont = titleFont
		self.descriptionColor = descriptionColor
		self.descriptionFont = descriptionFont
		self.actionTitleColor = actionTitleColor
		self.actionTitleFont = actionTitleFont
		self.itemsVerticalSpacing = itemsVerticalSpacing
	}

	public static var defaultTheme = StatusTheme()
}

public protocol StatusModel {
    var isLoading: Bool         { get }
    var title: String?          { get }
    var description: String?    { get }
    var actionTitle: String?    { get }
    var image: UIImage?         { get }
    var action: (() -> Void)?   { get }
}

extension StatusModel {
    
    public var isLoading: Bool {
        return false
    }
    
    public var title: String? {
        return nil
    }
    
    public var description: String? {
        return nil
    }
    
    public var actionTitle: String? {
        return nil
    }
    
    public var image: UIImage? {
        return nil
    }
    
    public var action: (() -> Void)? {
        return nil
    }
}

public struct Status: StatusModel {
    public let isLoading: Bool
    public let title: String?
    public let description: String?
    public let actionTitle: String?
    public let image: UIImage?
    public let action: (() -> Void)?
    
    public init(isLoading: Bool = false, title: String? = nil, description: String? = nil, actionTitle: String? = nil, image: UIImage? = nil, action: (() -> Void)? = nil) {
        self.isLoading = isLoading
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.image = image
        self.action = action
    }
    
    public static var simpleLoading: Status {
        return Status(isLoading: true)
    }
}

public protocol StatusView: class {
    var status: StatusModel?  { set get }
    var view: UIView { get }
	var statusTheme: StatusTheme { set get }
}

public protocol StatusController {
    var onView: StatusViewContainer { get }
    var statusView: StatusView?     { get }
    
    func show(status: StatusModel)
    func hideStatus()
}

extension StatusController {
    
    public var statusView: StatusView? {
        return DefaultStatusView()
    }
    
    public func hideStatus() {
        onView.statusContainerView = nil
    }
    
    fileprivate func _show(status: StatusModel) {
        guard let sv = statusView else { return }
        sv.status = status
        onView.statusContainerView = sv.view
    }
}

extension StatusController where Self: UIView {
    
    public var onView: StatusViewContainer {
        return self
    }
    
    public func show(status: StatusModel) {
        _show(status: status)
    }
}

extension StatusController where Self: UIViewController {
    
    public var onView: StatusViewContainer {
        return view
    }
    
    public func show(status: StatusModel) {
        _show(status: status)
        
        #if os(tvOS)
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
        #endif
    }
}

extension StatusController where Self: UITableViewController {
    
    public var onView: StatusViewContainer {
        if let backgroundView = tableView.backgroundView {
            return backgroundView
        }
        return view
    }
    
    public func show(status: StatusModel) {
        _show(status: status)
        
        #if os(tvOS)
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
        #endif
    }
}

extension StatusController where Self: UICollectionViewController {
	
	public var onView: StatusViewContainer {
		if let backgroundView = collectionView.backgroundView {
			return backgroundView
		}
		return view
	}
	
	public func show(status: StatusModel) {
		_show(status: status)
		
		#if os(tvOS)
		setNeedsFocusUpdate()
		updateFocusIfNeeded()
		#endif
	}
}

public protocol StatusViewContainer: class {
    var statusContainerView: UIView? { get set }
}

extension UIView: StatusViewContainer {
    public static let StatusViewTag = 666
    
    open var statusContainerView: UIView? {
        get {
            return viewWithTag(UIView.StatusViewTag)
        }
        set {
            viewWithTag(UIView.StatusViewTag)?.removeFromSuperview()
            
            guard let view = newValue else { return }
            
            view.tag = UIView.StatusViewTag
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
                view.leadingAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.leadingAnchor),
                view.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor),
                view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
                view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
                ])
        }
    }
}
