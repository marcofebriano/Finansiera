//
//  CommonPageControl.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 04/12/23.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
class CommonPageControl: UIControl {
    
    //MARK: - Properties
    private var numberOfDots = [UIView]() {
        didSet {
            guard numberOfDots.count == numberOfPages else { return }
            setupViews()
        }
    }
    
    @IBInspectable public var numberOfPages: Int = 0 {
        didSet {
            for tag in 0 ..< numberOfPages {
                let dot = getDotView()
                dot.tag = tag
                dot.backgroundColor = normalColor
                self.numberOfDots.append(dot)
            }
        }
    }
    
    public var currentPage: Int = 0 {
        didSet {
            debugPrint("CurrentPage is \(currentPage)")
            setSelectedByCurrentPage(currentPage)
        }
    }
    
    @IBInspectable public var normalColor: UIColor? = .lightGray
    @IBInspectable public var activeColor: UIColor? = .darkGray
    
    private lazy var stackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    // MARK: - Intialisers
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(withNoOfPages pages: Int) {
        self.numberOfPages = pages
        self.currentPage = 0
        super.init(frame: .zero)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        self.addSubview(stackView)
        self.stackView.addArrangedSubviews(numberOfDots)
        stackView.snp.makeConstraints { make in
            make.height.centerX.centerY.equalToSuperview()
        }
        
        self.numberOfDots.forEach { dot in
            dot.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(stackView.snp.height).multipliedBy(0.45)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setSelectedByCurrentPage(self.currentPage)
        }
    }
    
    private func setSelectedByCurrentPage(_ index: Int) {
        for dot in numberOfDots {
            guard let dot = dot as? CommonDotPageControl else { continue }
            dot.normalStyle()
            guard dot.tag == index else { continue }
            dot.animateActive()
            self.sendActions(for: .valueChanged)
        }
    }
    
    public func setSelected(_ index: Int) {
        currentPage = index
    }
    
}

// MARK: - Helper methods...
extension CommonPageControl {

    private func getDotView() -> UIView {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onPageControlTapped(_:)))
        let dot = CommonDotPageControl()
        dot.activeColor = activeColor
        dot.normalColor = normalColor
        dot.normalStyle()
        dot.addGestureRecognizer(tap)
        return dot
    }
    
    @objc
    private func onPageControlTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedDot = sender.view as? CommonDotPageControl else { return }
        currentPage = selectedDot.tag
    }
}
