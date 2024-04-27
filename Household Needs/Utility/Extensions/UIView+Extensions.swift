//
//  UIView+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    
    func addDropShadow(elevation: CGFloat = 2) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1 / Float(elevation * 2)
        layer.shadowRadius = elevation
        layer.masksToBounds = false
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            let offset = CGSize(width: 0, height: 10)
            addShadow(offset: offset,
                      color: color,
                      opacity: opacity,
                      radius: radius
            )
        case .top:
            let offset = CGSize(width: 0, height: -10)
            addShadow(offset: offset,
                      color: color,
                      opacity: opacity,
                      radius: radius
            )
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat)
    {
        let maskLayer = CAShapeLayer()
        let cornerRadii = CGSize(width: radius, height: radius)
        maskLayer.path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        ).cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView {
    func transformGoToRight(xPoint: CGFloat) {
        let goRight = CGAffineTransform(translationX: xPoint, y: 0)
        self.transform = goRight
    }
    
    func transformGoToLeft(minusXPoint: CGFloat) {
        let goLeft = CGAffineTransform(translationX: -minusXPoint, y: 0)
        self.transform = goLeft
    }
    
    func transformGoToUp(minusYPoint: CGFloat) {
        let goUp = CGAffineTransform(translationX: 0, y: -minusYPoint)
        self.transform = goUp
    }
    
    func transformGoToDown(yPoint: CGFloat) {
        let goDown = CGAffineTransform(translationX: 0, y: yPoint)
        self.transform = goDown
    }
    
    func transformScale(multiple: CGFloat) {
        let scale = CGAffineTransform(scaleX: multiple, y: multiple)
        self.transform = scale
    }
    
    func transformReset() {
        self.transform = .identity
    }
}
