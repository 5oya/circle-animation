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
private let borderWidth = CGFloat(2.0)

final class ViewController: UIViewController {
    var maxFrame: CGRect?
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
    lazy var contentLayer: CAShapeLayer = {
        let contentLayer = CAShapeLayer()
        return contentLayer
    }()
    lazy var contentGradientLayer: CAGradientLayer = {
        let contentGradientLayer = CAGradientLayer()
        return contentGradientLayer
    }()
    lazy var borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.strokeColor = UIColor.purpleColor().CGColor
        borderLayer.lineWidth = borderWidth
        return borderLayer
    }()
    lazy var borderGradientLayer: CAGradientLayer = {
        let borderGradientLayer = CAGradientLayer()
        return borderGradientLayer
    }()
    lazy var nameCardLayer: CALayer = {
        let nameCardLayer = CALayer()
        nameCardLayer.contents = UIImage(named: "meisi.jpg")?.CGImage
        nameCardLayer.frame = CGRect(x: self.view.bounds.width / 4, y: self.view.bounds.height / 4, width: 200, height: 120)
        return nameCardLayer
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(meishiView)
        view.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.addSublayer(rectanglesLayer)
        rectanglesLayer.addSublayer(nameCardLayer)

        let radius = CGFloat(80)
        let diameter = radius * 2.0
        var cardMinX = meishiView.frame.minX
        var cardMinY = meishiView.frame.minY
        var cardMaxX = meishiView.frame.maxX
        var cardMaxY = meishiView.frame.maxY
        var cardWidth = meishiView.bounds.width
        var cardHeight = meishiView.bounds.height
        
        // 縦名刺か横名刺の情報をもっていればそれを使う
        if cardHeight < diameter {
            // 横名刺の場合
            let plusFrame = radius - (cardHeight / 2)
            cardMaxY = cardMaxY + plusFrame
            cardMinY = cardMinY - plusFrame
            cardHeight = cardHeight + (plusFrame * 2)
        } else if cardWidth < diameter {
            // 縦名刺の場合
            let plusFrame = radius - (cardWidth / 2)
            cardMaxX = cardMaxX + plusFrame
            cardMinX = cardMinX - plusFrame
            cardWidth = cardWidth + (plusFrame * 2)
        }
        
        maxFrame = CGRect(x: cardMinX, y: cardMinY, width: cardWidth, height: cardHeight).insetBy(dx: -borderWidth, dy: -borderWidth)
        guard let maxFrame = maxFrame else { return }
        
        contentGradientLayer.frame = maxFrame
        let contentStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 0.4).CGColor
        let contentEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 0.4).CGColor
        contentGradientLayer.colors = [contentStartColor, contentEndColor]
        contentGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        contentGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        contentGradientLayer.mask = contentLayer
        rectanglesLayer.addSublayer(contentGradientLayer)
        
        borderGradientLayer.frame = maxFrame
        let borderStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).CGColor
        let borderEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        borderGradientLayer.colors = [borderStartColor, borderEndColor]
        borderGradientLayer.startPoint  = CGPoint(x: 0.0, y: 0.5)
        borderGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        borderGradientLayer.mask = borderLayer
        rectanglesLayer.addSublayer(borderGradientLayer)
        
        
        // 初期のcircle(本番だと消す)
        let center = CGPoint(x: maxFrame.width / 2, y: maxFrame.height / 2)
        let point0 = CGPoint(x: center.x, y: center.y - radius)
        let point1 = CGPoint(x: center.x + radius, y: center.y)
        let point2 = CGPoint(x: center.x, y: center.y + radius)
        let point3 = CGPoint(x: center.x - radius, y: center.y)
        let fromPath = UIBezierPath()
        fromPath.moveToPoint(point0)
        fromPath.addCurveToPoint(point1, controlPoint1: CGPointMake(point0.x + radius / 1.8, point0.y), controlPoint2: CGPointMake(point1.x, point1.y - radius / 1.8))
        fromPath.addCurveToPoint(point2, controlPoint1: CGPointMake(point1.x, point1.y + radius / 1.8), controlPoint2: CGPointMake(point2.x + radius / 1.8, point2.y))
        fromPath.addCurveToPoint(point3, controlPoint1: CGPointMake(point2.x - radius / 1.8, point2.y), controlPoint2: CGPointMake(point3.x, point3.y + radius / 1.8))
        fromPath.addCurveToPoint(point0, controlPoint1: CGPointMake(point3.x, point3.y - radius / 1.8), controlPoint2: CGPointMake(point0.x - radius / 1.8, point0.y))
        fromPath.closePath()
        
        borderLayer.path = fromPath.CGPath
    }

    @IBAction func startAnimation(sender: UIButton) {
        playNameCardAnimation {
            self.borderLayer.lineWidth = 0
            CATransaction.begin()
//            CATransaction.setCompletionBlock(completion)
            if let ellipseToQuadrangleAnimation = self.ellipseToQuadrangleAnimation() {
                self.borderLayer.addAnimation(ellipseToQuadrangleAnimation, forKey: "ellipseToQuadrangleAnimation")
                self.contentLayer.addAnimation(ellipseToQuadrangleAnimation, forKey: "ellipseToQuadrangleAnimation")
            }
            self.contentGradientLayer.addAnimation(self.clearContentColorAnimation(), forKey: "clearContentColorAnimation")
            CATransaction.commit()
        }
    }
    
    private func playNameCardAnimation(completion: (() -> Void)? = nil) {
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock(completion)
        }
        
        if let circleToEllipseAnimation = circleToEllipseAnimation() {
            borderLayer.addAnimation(circleToEllipseAnimation, forKey: "circleToEllipseAnimation")
            contentLayer.addAnimation(circleToEllipseAnimation, forKey: "circleToEllipseAnimation")
        }
        contentGradientLayer.addAnimation(paintContentColorAnimation(), forKey: "paintContentColorAnimation")
        CATransaction.commit()
    }
    
    private func circleToEllipseAnimation() -> CABasicAnimation? {
        // path animation
        
        guard let maxFrame = maxFrame else { return nil }
        let center = CGPoint(x: maxFrame.width / 2, y: maxFrame.height / 2)
        // fromPathを生成
        let fromPath = UIBezierPath()
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
        
        
        // 縦名刺か横名刺の情報をもっていればそれを使う
        // 横名刺の場合
        let cardHeight = meishiView.bounds.height
        let plusFrame = radius - (cardHeight / 2)
        let origin = CGPoint(x: 0.0 + borderWidth, y: plusFrame + borderWidth)
        // 横名刺の場合
        //        let cardWidth = meishiView.bounds.width
        //        let plusFrame = radius - (cardWidth / 2)
        //        let origin = CGPoint(x: plusFrame, y: 0.0)
        
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
        
        return pathAnimation
    }
    
    private func paintContentColorAnimation() -> CABasicAnimation {
        let colorsProperty = "colors"
        let colorsAnimation = CABasicAnimation(keyPath: colorsProperty)
        
        let fromStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 0.0).CGColor
        let fromEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 0.0).CGColor
        let toStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).CGColor
        let toEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        let fromColors = [fromStartColor, fromEndColor]
        let toColors = [toStartColor, toEndColor]
        colorsAnimation.fromValue = fromColors
        colorsAnimation.toValue = toColors
        colorsAnimation.duration = 1.0
        colorsAnimation.removedOnCompletion = false
        colorsAnimation.fillMode = kCAFillModeForwards
        
        return colorsAnimation
    }
    
    private func clearContentColorAnimation() -> CABasicAnimation {
        let colorsProperty = "colors"
        let colorsAnimation = CABasicAnimation(keyPath: colorsProperty)
        
        let fromStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).CGColor
        let fromEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        let toStartColor = UIColor(red: 219 / 255.0, green: 123 / 255.0, blue: 255.0 / 255.0, alpha: 0.0).CGColor
        let toEndColor = UIColor(red: 0.0 / 255.0, green: 207.0 / 255.0, blue: 221.0 / 255.0, alpha: 0.0).CGColor
        let fromColors = [fromStartColor, fromEndColor]
        let toColors = [toStartColor, toEndColor]
        colorsAnimation.fromValue = fromColors
        colorsAnimation.toValue = toColors
        colorsAnimation.duration = 1.0
        colorsAnimation.removedOnCompletion = false
        colorsAnimation.fillMode = kCAFillModeForwards
        
        return colorsAnimation
    }
    
    private func ellipseToQuadrangleAnimation() -> CABasicAnimation? {
        // path animation
        // 縦名刺か横名刺の情報をもっていればそれを使う
        // 横名刺の場合
        let cardHeight = meishiView.bounds.height
        let radius = CGFloat(80)
        let plusFrame = radius - (cardHeight / 2)
        let origin = CGPoint(x: 0.0 + borderWidth, y: plusFrame + borderWidth)
        // 横名刺の場合
        //        let cardWidth = meishiView.bounds.width
        //        let plusFrame = radius - (cardWidth / 2)
        //        let origin = CGPoint(x: plusFrame, y: 0.0)
        
        let magnification =  radius / 2.5
        
        // fromPathを生成
        let fromPath = UIBezierPath()
        let fromPoint0 = CGPoint(x: origin.x + magnification, y: origin.y)
        let fromPoint1 = CGPoint(x: (origin.x + 200) - magnification, y: origin.y)
        let fromPoint2 = CGPoint(x: origin.x + 200, y: origin.y + magnification)
        let fromPoint3 = CGPoint(x: origin.x + 200, y: (origin.y + 120) - magnification)
        let fromPoint4 = CGPoint(x: (origin.x + 200) - magnification , y: origin.y + 120)
        let fromPoint5 = CGPoint(x: origin.x + magnification, y: origin.y + 120)
        let fromPoint6 = CGPoint(x: origin.x, y: (origin.y + 120) - magnification)
        let fromPoint7 = CGPoint(x: origin.x, y: origin.y + magnification)
        
        fromPath.moveToPoint(fromPoint0)
        fromPath.addLineToPoint(fromPoint1)
        fromPath.addCurveToPoint(fromPoint2, controlPoint1: CGPointMake(fromPoint1.x + (magnification / 2), fromPoint1.y), controlPoint2: CGPointMake(fromPoint2.x, fromPoint2.y - (magnification / 2)))
        fromPath.addLineToPoint(fromPoint3)
        fromPath.addCurveToPoint(fromPoint4, controlPoint1: CGPointMake(fromPoint3.x, fromPoint3.y + (magnification / 2)), controlPoint2: CGPointMake(fromPoint4.x + (magnification / 2), fromPoint4.y))
        fromPath.addLineToPoint(fromPoint5)
        fromPath.addCurveToPoint(fromPoint6, controlPoint1: CGPointMake(fromPoint5.x - (magnification / 2), fromPoint5.y), controlPoint2: CGPointMake(fromPoint6.x, fromPoint6.y + (magnification / 2)))
        fromPath.addLineToPoint(fromPoint7)
        fromPath.addCurveToPoint(fromPoint0, controlPoint1: CGPointMake(fromPoint7.x, fromPoint7.y - (magnification / 2)), controlPoint2: CGPointMake(fromPoint0.x - (magnification / 2), fromPoint0.y))
        fromPath.closePath()
        
        // afterPathを生成
        let toPath = UIBezierPath()
        let toPoint0 = CGPoint(x: origin.x, y: origin.y)
        let toPoint1 = CGPoint(x: origin.x + 200, y: origin.y)
        let toPoint2 = CGPoint(x: origin.x + 200, y: origin.y + 120)
        let toPoint3 = CGPoint(x: origin.x, y: origin.y + 120)
        
        toPath.moveToPoint(toPoint0)
        toPath.addLineToPoint(toPoint1)
        toPath.addLineToPoint(toPoint1)
        toPath.addLineToPoint(toPoint2)
        toPath.addLineToPoint(toPoint2)
        toPath.addLineToPoint(toPoint3)
        toPath.addLineToPoint(toPoint3)
        toPath.addLineToPoint(toPoint0)
        toPath.addLineToPoint(toPoint0)
        toPath.closePath()
        
        
        let pathProperty = "path"
        let pathAnimation = CABasicAnimation(keyPath: pathProperty)
        
        pathAnimation.fromValue = fromPath.CGPath
        pathAnimation.toValue = toPath.CGPath
        pathAnimation.duration = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        
        return pathAnimation
    }
}

