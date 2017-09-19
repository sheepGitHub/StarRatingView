//
//  StarRatingView.swift
//  StarRatingView
//
//  Created by YANG ZONG-HAN on 2017/9/18.
//  Copyright © 2017年 YANG ZONG-HAN. All rights reserved.
//

import UIKit

public protocol StarRatingViewDelegate: class {
    func starRatingView(_ starRatingView: StarRatingView, score: CGFloat)
}

@IBDesignable
final public class StarRatingView: UIView {

    // MARK: - Property
    
    @IBInspectable public var numberOfStars: Int = 5 {
        didSet {
            removeSubImageView(superView: self)
            removeSubImageView(superView: starForegroundView)
            
            addSubImageView(superView: self, starImage: backgroundStarImage)
            addSubview(addSubImageView(superView: starForegroundView, starImage: foregroundStarImage))
            
            adjustSubImageViewFrame(superView: self)
            adjustSubImageViewFrame(superView: starForegroundView)
            showStarRate()
        }
    }
    
    @IBInspectable public var starInterval: CGFloat = 2 {
        didSet {
            adjustSubImageViewFrame(superView: self)
            adjustSubImageViewFrame(superView: starForegroundView)
            showStarRate()
        }
    }
    
    @IBInspectable public var score: CGFloat = 0 {
        didSet {
            showStarRate()
            backSorce()
        }
    }
    
    @IBInspectable public var backgroundStarImage: UIImage? = nil {
        willSet {
            changeSubImage(superView: self, starImage: newValue)
        }
    }
    
    @IBInspectable public var foregroundStarImage: UIImage? = nil {
        willSet {
            changeSubImage(superView: starForegroundView, starImage: newValue)
        }
    }
    
    @IBInspectable public var hasAnimation: Bool = false
    
    @IBInspectable public var allowUnderCompleteStar:Bool = true {
        didSet {
            showStarRate()
            backSorce()
        }
    }
    
    public weak var starRatingViewDelegate: StarRatingViewDelegate?
    
    fileprivate var starForegroundView: UIView  = UIView()
    
    fileprivate var starWidth: CGFloat {
        return (frame.size.width - (CGFloat(numberOfStars) - 1.0) * starInterval) / CGFloat(numberOfStars)
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    fileprivate func initialization() {
        addSubImageView(superView: self, starImage: backgroundStarImage)
        addSubview(addSubImageView(superView: starForegroundView, starImage: foregroundStarImage))
    }
    
    // MARK: - Override
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        adjustSubImageViewFrame(superView: self)
        adjustSubImageViewFrame(superView: starForegroundView)
        showStarRate()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        if let point = touch?.location(in: self) {
            score = point.x / frame.width * CGFloat(numberOfStars)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        if let point = touch?.location(in: self) {
            if point.x >= 0.0 && point.x <= frame.width {
                score = point.x / frame.width * CGFloat(numberOfStars)
            }
        }
    }
    
    // MARK: - Private
    
    @discardableResult
    fileprivate func addSubImageView(superView: UIView, starImage: UIImage?) -> UIView {
        superView.clipsToBounds = true
        for index in 0...numberOfStars {
            let imageView = UIImageView(frame: .null)
            imageView.tag = index
            imageView.image = starImage
            superView.addSubview(imageView)
        }
        return superView
    }
    
    fileprivate func removeSubImageView(superView: UIView) {
        for subView in superView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    fileprivate func adjustSubImageViewFrame(superView: UIView) {
        for subView in superView.subviews {
            if let imageView = subView as? UIImageView {
                imageView.frame = CGRect(x: CGFloat(imageView.tag) * (starWidth + starInterval),
                                         y: 0,
                                         width: starWidth,
                                         height: bounds.size.height)
            }
        }
    }
    
    fileprivate func changeSubImage(superView: UIView, starImage: UIImage?) {
        for subView in superView.subviews {
            if let imageView = subView as? UIImageView {
                imageView.image = starImage
            }
        }
    }
    
    fileprivate func showStarRate() {
        let duration = hasAnimation ? 0.25 : 0.0
        UIView.animate(withDuration: duration, animations: {
            if self.allowUnderCompleteStar {
                self.starForegroundView.frame = CGRect(x: 0.0,
                                                       y: 0.0,
                                                       width: self.bounds.width * self.score / CGFloat(self.numberOfStars),
                                                       height: self.bounds.height)
            } else {
                self.starForegroundView.frame = CGRect(x: 0.0,
                                                       y: 0.0,
                                                       width: (self.starWidth + self.starInterval) * CGFloat(lround(Double(self.score))),
                                                       height: self.bounds.height)
            }
        })
    }
    
    fileprivate func backSorce(){
        if let _ = starRatingViewDelegate {
            var newScore: CGFloat = allowUnderCompleteStar ? score : CGFloat(lround(Double(score)))
            if  newScore > CGFloat(numberOfStars) {
                newScore = CGFloat(numberOfStars)
            } else if newScore < 0 {
                newScore = 0
            }
            starRatingViewDelegate?.starRatingView(self, score: newScore)
        }
    }

}
