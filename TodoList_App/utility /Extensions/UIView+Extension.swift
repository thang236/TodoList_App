//
//  UIView+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 16/08/2024.
//

import UIKit

extension UIView {
    func setBackgroundImageWithGradient(imageName: String, topHexColor: String, bottomHexColor: String) {
        backgroundColor = .clear

        let backgroundImageView = UIImageView(frame: bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill

        insertSubview(backgroundImageView, at: 0)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundImageView.bounds
        gradientLayer.opacity = 0.5

        let topColor = UIColor(hex: topHexColor).cgColor
        let bottomColor = UIColor(hex: bottomHexColor).cgColor

        gradientLayer.colors = [topColor, bottomColor]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        backgroundImageView.layer.addSublayer(gradientLayer)
    }
}
