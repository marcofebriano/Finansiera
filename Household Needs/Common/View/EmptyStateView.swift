//
//  EmptyStateView.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 14/12/23.
//

import Foundation
import UIKit
import SnapKit

public class EmptyStateView: UIView {
    
    private lazy var message = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "message"
    }
    
    private lazy var firstImage = builder(UIImageView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = image
    }
    
    private lazy var image: UIImage? = {
        let image = UIImage(systemName: "doc.text.magnifyingglass")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        return image
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        self.addSubview(firstImage)
        self.addSubview(message)
        
        firstImage.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        message.snp.makeConstraints { make in
            make.top.equalTo(firstImage.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension EmptyStateView {
    var messageText: String? {
        get { message.text }
        set { message.text = newValue}
    }
}
