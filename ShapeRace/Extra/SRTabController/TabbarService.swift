//
//  TabbarService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-29.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import UIKit

class TabBarCustomizator {
    
    // MARK: - Properties
    var tabBar: UITabBar!
    var shapeLayer: CALayer?
    var caShapeLayer: CAShapeLayer?
    private var lineWidth = CGFloat(2)
    
    // MARK: - Methods
    func customize() {
        addShape()
    }
    
    private func addShape() {
        caShapeLayer = CAShapeLayer()
        guard let shapeLayer = caShapeLayer else { return }
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor(patternImage: GradientColor.gradientImage(withColours: GradientColor.blueGradient, location: GradientColor.blueGradientLocation, view: tabBar)).cgColor
        shapeLayer.fillColor = SRColor.background.cgColor
        shapeLayer.lineWidth = lineWidth
        
        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = tabBar.frame.width / 2
        
        path.move(to: CGPoint(x: -(lineWidth), y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: (centerWidth - 35), y: height))
        
        path.addCurve(to: CGPoint(x: centerWidth + height * 2, y: 0),
                      controlPoint1: CGPoint(x: (centerWidth + 35), y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: tabBar.frame.width + lineWidth, y: 0))
        path.addLine(to: CGPoint(x: tabBar.frame.width + lineWidth, y: tabBar.frame.height + lineWidth))
        path.addLine(to: CGPoint(x: -(lineWidth), y: tabBar.frame.height + lineWidth))
        path.close()
        
        return path.cgPath
    }
}
