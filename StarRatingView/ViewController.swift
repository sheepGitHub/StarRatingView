//
//  ViewController.swift
//  StarRatingView
//
//  Created by YANG ZONG-HAN on 2017/9/18.
//  Copyright © 2017年 YANG ZONG-HAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Property
    
    @IBOutlet weak var starRatingView_storyboard: StarRatingView!
    
    fileprivate var starRatingView: StarRatingView = StarRatingView()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIContentContainer
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.adjustFrame(size: size)
        }, completion: nil)
    }
    
    // MARK: - Initialization
    
    fileprivate func initialization() {
        starRatingView_storyboard.starRatingViewDelegate = self
        
        starRatingView.starRatingViewDelegate = self
        starRatingView.tag = 2
        starRatingView.numberOfStars = 4
        starRatingView.starInterval = 20
        starRatingView.score = 1
        starRatingView.backgroundStarImage = UIImage(named: "score_big_off.png")
        starRatingView.foregroundStarImage = UIImage(named: "score_big_on.png")
        starRatingView.allowUnderCompleteStar = false
        view.addSubview(starRatingView)
        
        adjustFrame(size: view.frame.size)
    }
    
    // MARK: - Adjust UI Frame
    
    fileprivate func adjustFrame(size: CGSize) {
        starRatingView.frame = CGRect(x: 0.0, y: starRatingView_storyboard.frame.maxY + 30.0, width: size.width, height: 50.0)
    }
    
    // MARK: - Actions

    @IBAction func clickChangeParmeter(_ sender: Any) {
        print(#function)
        
        starRatingView_storyboard.numberOfStars = Int(arc4random_uniform(10)) + 1 // random 1 ~ 10
        starRatingView_storyboard.starInterval = CGFloat(arc4random_uniform(21)) // random 0 ~ 20
        starRatingView_storyboard.score = CGFloat(arc4random_uniform(UInt32(starRatingView.numberOfStars + 1))) // // random 0 ~ 10
        
        starRatingView.numberOfStars = Int(arc4random_uniform(10)) + 1 // random 1 ~ 10
        starRatingView.starInterval = CGFloat(arc4random_uniform(21)) // random 0 ~ 20
        starRatingView.score = CGFloat(arc4random_uniform(UInt32(starRatingView.numberOfStars + 1))) // // random 0 ~ 10
    }
    
}

extension ViewController: StarRatingViewDelegate {
    
    func starRatingView(_ starRatingView: StarRatingView, score: CGFloat) {
        print("\(starRatingView.tag) -> score = \(score)")
    }
    
}
