//
//  CommonToast.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 12/12/23.
//

import Foundation
import UIKit
import SnapKit

/// this class for replace Toast from Aloha.
/// > the implementation similar with the Toast aloha
///
/// **example:**
/// - set title toast only
/// ```
/// let toast = CommonToast(title: "test toast", direction: .fromTop)
/// toast.show()
/// ```
///
/// - set titile and image
/// ```
/// let toast = CommonToast(title: "test toast", image: UIImage(named: ""), direction: .fromTop)
/// toast.show()
/// ```
class CommonToast: UIView {
    
    private lazy var stack = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 6
        
    }
    
    private lazy var titleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private lazy var iconView = builder(UIImageView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    var padding: UIEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 12)
    
    /// Checks if there is a toast being displayed on the current window and return it.
    public static var currentToast: CommonToast? {
        guard let window = UIApplication.currentWindow else { return nil }
        return currentToast(in: window)
    }
    
    var direction: CommonToastDirection
    
    var duration: CommonToastDuration
    
    static func currentToast(in window: UIWindow) -> CommonToast? {
        return window.subviews.first(where: { view -> Bool in
            return view.accessibilityIdentifier == "CommonToastView"
        }) as? CommonToast
    }
    
    public init(title: String, image: UIImage?, direction: CommonToastDirection = .fromBottom, duration: CommonToastDuration = .long) {
        self.direction = direction
        self.duration = duration
        super.init(frame: .zero)
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "CommonToastView"
        self.setupView()
        self.titleLabel.text = title
        self.iconView.image = image
        
        if iconView.image != nil {
            stack.addArrangedSubview(iconView)
        }
        stack.addArrangedSubview(titleLabel)
        setupConstraint()
    }
    
    /// init with title only
    public convenience init(title: String, direction: CommonToastDirection = .fromBottom, duration: CommonToastDuration = .long) {
        self.init(title: title, image: nil, direction: direction, duration: duration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    private func setupConstraint() {
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding.top)
            make.left.equalToSuperview().offset(padding.left)
            make.right.equalToSuperview().inset(padding.right)
            make.bottom.equalToSuperview().inset(padding.bottom)
        }
    }
    
    private func setupView() {
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.layer.opacity = 0.0
        self.backgroundColor = .black.withAlphaComponent(0.8)
        self.titleLabel.font = .systemFont(ofSize: 14)
        self.titleLabel.textColor = .white
    }
    
    public func show() {
        guard let window = UIApplication.currentWindow else { return }
        if let currentToast = CommonToast.currentToast {
            currentToast.removeFromSuperview()
        }
        show(on: window)
    }
    
    func show(on window: UIWindow) {
        window.addSubview(self)
        switch direction {
        case .fromTop:
            showFromTop(window)
        case .fromBottom:
            showFromBottom(window)
        }
        showAnimation()
    }
}

// MARK: - construct layout in window
extension CommonToast {
    private func showFromTop(_ window: UIWindow) {
        let hasTopInset = window.safeAreaInsets.top > 0
        switch hasTopInset {
        case true:
            self.snp.makeConstraints { make in
                make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(16)
                make.centerX.equalTo(window.snp.centerX)
                make.left.greaterThanOrEqualTo(window.snp.left).offset(16)
                make.right.lessThanOrEqualTo(window.snp.right).inset(16)
            }
        case false:
            self.snp.makeConstraints { make in
                make.top
                    .equalTo(window.safeAreaLayoutGuide.snp.top)
                    .offset(16)
                make.centerX.equalTo(window.snp.centerX)
                make.left.greaterThanOrEqualTo(window.snp.left).offset(16)
                make.right.lessThanOrEqualTo(window.snp.right).inset(16)
            }
        }
    }
    
    private func showFromBottom(_ window: UIWindow) {
        let hasBottomInset = window.safeAreaInsets.bottom > 0
        switch hasBottomInset {
        case true:
            self.snp.makeConstraints { make in
                make.centerX.equalTo(window.snp.centerX)
                make.left.greaterThanOrEqualTo(window.snp.left).offset(16)
                make.right.lessThanOrEqualTo(window.snp.right).inset(16)
                make.bottom.equalTo(window.safeAreaLayoutGuide.snp.bottom)
            }
        case false:
            self.snp.makeConstraints { make in
                make.centerX.equalTo(window.snp.centerX)
                make.left.greaterThanOrEqualTo(window.snp.left).offset(16)
                make.right.lessThanOrEqualTo(window.snp.right).inset(16)
                make.bottom
                    .equalTo(window.safeAreaLayoutGuide.snp.bottom)
                    .inset(16)
            }
        }
    }
}

// MARK: - showing animation
extension CommonToast {
    private func showAnimation() {
        if direction == .fromTop {
            animationFromTop()
        } else {
            animationFromBottom()
        }
    }
    
    private func animationFromTop() {
        let yPoint: CGFloat = 100
        self.transformGoToUp(minusYPoint: yPoint)
        self.alpha = 0
        UIView.chainAnimate(withDuration: 0.5, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.self.transformReset()
        }.thenChainAnimate(withDuration: 0.5, delay: self.duration.rawValue) { [weak self] in
            guard let self = self else { return }
            self.transformGoToUp(minusYPoint: yPoint)
            self.alpha = 0
        }.animate()
    }
    
    private func animationFromBottom() {
        let yPoint: CGFloat = 100
        self.transformGoToDown(yPoint: yPoint)
        self.alpha = 0
        UIView.chainAnimate(withDuration: 0.5, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.self.transformReset()
        }.thenChainAnimate(withDuration: 0.5, delay: self.duration.rawValue) { [weak self] in
            guard let self = self else { return }
            self.transformGoToDown(yPoint: yPoint)
            self.alpha = 0
        }.animate()
    }
}

//MARK: - Helper for showing EWToast
extension CommonToast {
    static func show(title: String,
                     image: UIImage? = nil,
                     direction toastDirection: CommonToastDirection = .fromBottom,
                     duration toastDuration: CommonToastDuration = .long) {
        CommonToast(title: title, image: image, direction: toastDirection, duration: toastDuration).show()
    }
}
public enum CommonToastDirection {
    case fromTop
    case fromBottom
}

public enum CommonToastDuration: TimeInterval {
    case short = 2.0
    case long = 4.0
}

