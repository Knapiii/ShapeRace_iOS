//
//  SRTabBar.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-25.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class SRTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private var lineWidth = CGFloat(2)
    
//    init() {
//        print("hejsan")
//        super.init(frame: .zero)
//        self.setNeedsDisplay()
//        needsdi
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func draw(_ rect: CGRect) {
        
        self.addShape()
        self.setTabbarImage()
        self.tintColor = UIColor.blue
    }

    func costomize() {
        print("costomize")
        self.addShape()
        //self.setTabbarImage()
        self.tintColor = .clear
        self.backgroundColor = .clear
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor(patternImage: GradientColor.gradientImage(withColours: GradientColor.blueGradient, location: GradientColor.blueGradientLocation, view: self)).cgColor
        shapeLayer.fillColor = SRColor.background.cgColor
        shapeLayer.lineWidth = lineWidth
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: -(lineWidth), y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: (centerWidth - 35), y: height))
        
        path.addCurve(to: CGPoint(x: centerWidth + height * 2, y: 0),
                      controlPoint1: CGPoint(x: (centerWidth + 35), y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width + lineWidth, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width + lineWidth, y: self.frame.height + lineWidth))
        path.addLine(to: CGPoint(x: -(lineWidth), y: self.frame.height + lineWidth))
        path.close()
        
        return path.cgPath
    }
    
    func setTabbarImage() {
        setItemIcons(item: 0, selected: "Feed_Selected", unSelected: "Feed_Unselected")
        setItemIcons(item: 1, selected: "Dumbbell_Selected", unSelected: "Dumbbell_Unselected")
        setItemIcons(item: 2, selected: "Profile_Selected", unSelected: "Profile")
    }
    
    fileprivate func setItemIcons(item: Int, selected: String, unSelected: String) {
        self.items?[item].selectedImage = UIImage(named: selected)
        self.items?[item].image = UIImage(named: unSelected)
        setItemPosition(item: item)
    }
    
    fileprivate func setItemPosition(item: Int) {
        switch item {
        case 0:
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.items?[item].imageInsets = inset
        case 1:
            let inset = UIEdgeInsets(top: -15, left: 0, bottom: 5, right: 0)
            self.items?[item].imageInsets = inset
        case 2:
            let inset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.items?[item].imageInsets = inset
        default:
            let inset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.items?[item].imageInsets = inset
        }

    }
    
}

class GradientColor {
    
    static let blueGradient = [UIColor(rgb: 0x185d91), UIColor(rgb: 0x1b69a3), UIColor(rgb: 0x1f75b6), UIColor(rgb: 0x3582bd), UIColor(rgb: 0x4b90c4)]
    
    static let blueReversedGradient = [UIColor(rgb: 0x4b90c4), UIColor(rgb: 0x3582bd), UIColor(rgb: 0x1f75b6), UIColor(rgb: 0x1b69a3), UIColor(rgb: 0x185d91)]
    
    static let blueGradientLocation = [0.0, 0.25, 0.5, 0.75, 1.0]
    
    static func gradientImage(withColours colours: [UIColor], location: [Double], view: UIView) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).0
        gradient.endPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).1
        gradient.locations = location as [NSNumber]
        gradient.cornerRadius = view.layer.cornerRadius
        return UIImage.image(from: gradient) ?? UIImage()
    }
}

extension UIImage {
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque, UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    
    var gradiant: UIColor {
        return UIColor(patternImage: GradientColor.gradientImage(withColours: GradientColor.blueGradient, location: GradientColor.blueGradientLocation, view: self))
    }
    
    var gradiantReversed: UIColor {
        return UIColor(patternImage: GradientColor.gradientImage(withColours: GradientColor.blueReversedGradient, location: GradientColor.blueGradientLocation, view: self))
    }
}
