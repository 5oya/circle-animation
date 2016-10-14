//
//  ViewController.swift
//  CircleAnimation
//
//  Created by Soya Takahashi on 2016/10/14.
//  Copyright © 2016年 NeXT, Inc. All rights reserved.
//

import UIKit

final class ViewModel {
    
}

final class ViewController: UIViewController {
    lazy var videoPreviewLayer: CALayer = {
        let videoPreviewLayer = CALayer()
        videoPreviewLayer.frame = self.view.frame
        return videoPreviewLayer
    }()
    lazy var meishiView: UIImageView = {
        let meishiView = UIImageView(frame: CGRect(x: self.view.bounds.width / 4, y: self.view.bounds.height / 4, width: 200, height: 120))
        meishiView.image = UIImage(named: "meisi.jpg")
        return meishiView
    }()
    lazy var rectanglesLayer: CAShapeLayer = {
        let rectanglesLayer = CAShapeLayer()
        return rectanglesLayer
    }()
    lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor(red: 144.0 / 255.0, green: 153.0 / 255.0, blue: 224.0 / 255.0, alpha: 0.1).CGColor
        circleLayer.strokeColor = UIColor(red: 35.0 / 255.0, green: 190.0 / 255.0, blue: 214 / 255.9, alpha: 1.0).CGColor
        return circleLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(meishiView)
        view.layer.addSublayer(videoPreviewLayer)
        
        videoPreviewLayer.addSublayer(rectanglesLayer)
        rectanglesLayer.addSublayer(circleLayer)
        
        let fromPath = UIBezierPath()
        
        let center = CGPoint(x: self.view.bounds.width / 4 + (meishiView.bounds.width / 2), y: self.view.bounds.height / 4 + (meishiView.bounds.height / 2))
        let radius = CGFloat(80)
        let point0 = CGPoint(x: center.x, y: center.y - radius)
        let point1 = CGPoint(x: center.x + radius, y: center.y)
        let point2 = CGPoint(x: center.x, y: center.y + radius)
        let point3 = CGPoint(x: center.x - radius, y: center.y)
        
        fromPath.moveToPoint(point0)
        fromPath.addCurveToPoint(point1, controlPoint1: CGPointMake(point0.x + radius / 1.8, point0.y), controlPoint2: CGPointMake(point1.x, point1.y - radius / 1.8))
        fromPath.addCurveToPoint(point2, controlPoint1: CGPointMake(point1.x, point1.y + radius / 1.8), controlPoint2: CGPointMake(point2.x + radius / 1.8, point2.y))
        fromPath.addCurveToPoint(point3, controlPoint1: CGPointMake(point2.x - radius / 1.8, point2.y), controlPoint2: CGPointMake(point3.x, point3.y + radius / 1.8))
        fromPath.addCurveToPoint(point0, controlPoint1: CGPointMake(point3.x, point3.y - radius / 1.8), controlPoint2: CGPointMake(point0.x - radius / 1.8, point0.y))
        fromPath.closePath()
        
        
        
        // 楽に円を描く方法
//        let center = CGPoint(x: self.view.bounds.width / 4 + (meishiView.bounds.width / 2), y: self.view.bounds.height / 4 + (meishiView.bounds.height / 2))
//        let radius = CGFloat(50)
//        let pi = CGFloat(M_PI)
//        let start = CGFloat(0)
//        let end = 2 * pi
//        fromPath.addArcWithCenter(center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        
        circleLayer.path = fromPath.CGPath
    }

    @IBAction func startAnimation(sender: UIButton) {
        // path animation
        
        
        // fromPathを生成
        let fromPath = UIBezierPath()
        let center = CGPoint(x: self.view.bounds.width / 4 + (meishiView.bounds.width / 2), y: self.view.bounds.height / 4 + (meishiView.bounds.height / 2))
        let radius = CGFloat(80)
        let point0 = CGPoint(x: center.x, y: center.y - radius)
        let point1 = CGPoint(x: center.x + radius, y: center.y)
        let point2 = CGPoint(x: center.x, y: center.y + radius)
        let point3 = CGPoint(x: center.x - radius, y: center.y)
        
        fromPath.moveToPoint(point0)
        fromPath.addLineToPoint(point0)
        fromPath.addCurveToPoint(point1, controlPoint1: CGPointMake(point0.x + radius / 1.8, point0.y), controlPoint2: CGPointMake(point1.x, point1.y - radius / 1.8))
        fromPath.addLineToPoint(point1)
        fromPath.addCurveToPoint(point2, controlPoint1: CGPointMake(point1.x, point1.y + radius / 1.8), controlPoint2: CGPointMake(point2.x + radius / 1.8, point2.y))
        fromPath.addLineToPoint(point2)
        fromPath.addCurveToPoint(point3, controlPoint1: CGPointMake(point2.x - radius / 1.8, point2.y), controlPoint2: CGPointMake(point3.x, point3.y + radius / 1.8))
        fromPath.addLineToPoint(point3)
        fromPath.addCurveToPoint(point0, controlPoint1: CGPointMake(point3.x, point3.y - radius / 1.8), controlPoint2: CGPointMake(point0.x - radius / 1.8, point0.y))
        fromPath.closePath()
        
        
        let origin = CGPoint(x: view.bounds.width / 4, y: view.bounds.height / 4)
        let magnification =  radius / 2.5
        
        // afterPathを生成
        let toPath = UIBezierPath()
        let toPoint0 = CGPoint(x: origin.x + magnification, y: origin.y)
        let toPoint1 = CGPoint(x: (origin.x + 200) - magnification, y: origin.y)
        let toPoint2 = CGPoint(x: origin.x + 200, y: origin.y + magnification)
        let toPoint3 = CGPoint(x: origin.x + 200, y: (origin.y + 120) - magnification)
        let toPoint4 = CGPoint(x: (origin.x + 200) - magnification , y: origin.y + 120)
        let toPoint5 = CGPoint(x: origin.x + magnification, y: origin.y + 120)
        let toPoint6 = CGPoint(x: origin.x, y: (origin.y + 120) - magnification)
        let toPoint7 = CGPoint(x: origin.x, y: origin.y + magnification)
        
        toPath.moveToPoint(toPoint0)
        toPath.addLineToPoint(toPoint1)
        toPath.addCurveToPoint(toPoint2, controlPoint1: CGPointMake(toPoint1.x + (magnification / 2), toPoint1.y), controlPoint2: CGPointMake(toPoint2.x, toPoint2.y - (magnification / 2)))
        toPath.addLineToPoint(toPoint3)
        toPath.addCurveToPoint(toPoint4, controlPoint1: CGPointMake(toPoint3.x, toPoint3.y + (magnification / 2)), controlPoint2: CGPointMake(toPoint4.x + (magnification / 2), toPoint4.y))
        toPath.addLineToPoint(toPoint5)
        toPath.addCurveToPoint(toPoint6, controlPoint1: CGPointMake(toPoint5.x - (magnification / 2), toPoint5.y), controlPoint2: CGPointMake(toPoint6.x, toPoint6.y + (magnification / 2)))
        toPath.addLineToPoint(toPoint7)
        toPath.addCurveToPoint(toPoint0, controlPoint1: CGPointMake(toPoint7.x, toPoint7.y - (magnification / 2)), controlPoint2: CGPointMake(toPoint0.x - (magnification / 2), toPoint0.y))
        toPath.closePath()
        
        
        let pathProperty = "path"
        let pathAnimation = CABasicAnimation(keyPath: pathProperty)
        
        pathAnimation.fromValue = fromPath.CGPath
        pathAnimation.toValue = toPath.CGPath
        pathAnimation.duration = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        
        
        // 取引開始
        CATransaction.begin()
        CATransaction.setCompletionBlock { }
        
        circleLayer.addAnimation(pathAnimation, forKey: "circleAnimation")
        // アニメーション開始
        CATransaction.commit()
    }
}

