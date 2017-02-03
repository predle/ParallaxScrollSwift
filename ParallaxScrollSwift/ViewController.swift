//
//  ViewController.swift
//  ParallaxScrollSwift
//
//  Created by Beomseok Seo on 2/2/17.
//  Copyright © 2017 Beomseok Seo. All rights reserved.
//

import UIKit

final class HeaderView: UIView {

    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.gray
        
        imageView = UIImageView(frame: frame)
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.backgroundColor = UIColor.brown
        imageView!.image = UIImage(named: "img")
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        self.addSubview(imageView!)
        
        var subviews: [String : AnyObject] = ["imageView": imageView!]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: [], metrics: [:], views: subviews)
        self.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: [], metrics: [:], views: subviews)
        self.addConstraints(constraints)
        
        //
        //
        //
        //  ///////
        //  //   //
        //  //   // <-PosterView
        //  ///////
        //
        //////////////////
        
        let posterView: UIImageView = UIImageView(frame: CGRect.zero)
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.backgroundColor = UIColor.darkGray
        posterView.image = UIImage(named: "poster")
        posterView.contentMode = .scaleAspectFill
        posterView.layer.borderColor = UIColor.white.cgColor
        posterView.layer.borderWidth = 2
        posterView.clipsToBounds = true
        
        self.addSubview(posterView)
        subviews["posterView"] = posterView
        
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[posterView(80)]", options: [], metrics: [:], views: subviews)
        self.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[posterView(100)]-|", options: [], metrics: [:], views: subviews)
        self.addConstraints(constraints)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 일단 Storyboard 에서 안쓰이므로 막아둔다.
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    fileprivate weak var scrollView: UIScrollView?
    fileprivate weak var contentView: UIView?
    fileprivate weak var lastAddedView: UIView?
    fileprivate weak var headerView: HeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let views: (UIScrollView, UIView) = addScrollViewTo(view: self.view)
        self.scrollView = views.0
        self.contentView = views.1
        
        //
        self.scrollView?.delegate = self
        
        // SubViews
        // 헤더뷰 추가하기
        let headerView: HeaderView = HeaderView(frame: CGRect.zero)
        self.headerView = headerView
        
        self.contentView?.addSubview(headerView)
        self.lastAddedView = headerView
        
        let subviews: [String : AnyObject] = ["headerView":headerView]
        let metrics = ["headerViewHeight": NSNumber(value: 300), "verticalSpacing": NSNumber(value: 8)]
        let leftAndRightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerView]-0-|", options: [], metrics: nil, views: subviews)
        let topAndBottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[headerView(headerViewHeight)]|", options: [], metrics: metrics, views: subviews)
        self.contentView?.addConstraints(leftAndRightConstraints)
        self.contentView?.addConstraints(topAndBottomConstraints)
        
        for _ in 1...10 {
            insertViewToContentView()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addScrollViewTo(view: UIView) -> (UIScrollView, UIView) {
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        var views: [String : AnyObject] = ["scrollView":scrollView]
        var leftAndRightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-0-|", options: [], metrics: nil, views: views)
        var topAndBottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollView]-0-|", options: [], metrics: nil, views: views)
        
        view.addConstraints(leftAndRightConstraints)
        view.addConstraints(topAndBottomConstraints)
        
        let contentView: UIView = UIView()
        contentView.backgroundColor = UIColor.blue
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        views = ["contentView": contentView, "scrollView": scrollView, "containerView": self.view]
        leftAndRightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView(==scrollView)]-0-|", options: [], metrics: nil, views: views)
        topAndBottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView(>=0)]-0-|", options: [], metrics: nil, views: views)
        view.addConstraints(leftAndRightConstraints)
        view.addConstraints(topAndBottomConstraints)
        
        return (scrollView, contentView)
    }
    
    func insertViewToContentView() {
        
        let metrics = ["subViewHeight": NSNumber(value: 100), "verticalSpacing": NSNumber(value: 8)]
        let subView: UIView = UIView()
        subView.backgroundColor = UIColor.yellow
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        // if already exist subView
        if let _lastSubView: UIView = self.lastAddedView {
            
            // SubView 가 늘어남에 따라 ContentView 가 늘어나야함으로
            // 이미 추가한 Bottom Constraint 를 비활성화 시킨다.
            let constraint = self.contentView?.constraints.last
            constraint?.isActive = false
            
            self.contentView?.addSubview(subView)
            self.lastAddedView = subView
            
            let views: [String : AnyObject] = ["subView": subView, "lastSubView": _lastSubView]
            let leftAndRightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: [], metrics: nil, views: views)
            let topAndBottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[lastSubView]-verticalSpacing-[subView(subViewHeight)]|", options: [], metrics: metrics, views: views)
            self.contentView?.addConstraints(leftAndRightConstraints)
            self.contentView?.addConstraints(topAndBottomConstraints)
            
            return
        }
        
        // or not
        self.contentView?.addSubview(subView)
        self.lastAddedView = subView
        
        let views: [String : AnyObject] = ["subView":subView]
        let leftAndRightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: [], metrics: nil, views: views)
        let topAndBottomConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView(subViewHeight)]|", options: [], metrics: metrics, views: views)
        self.contentView?.addConstraints(leftAndRightConstraints)
        self.contentView?.addConstraints(topAndBottomConstraints)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            // 얼마만큼 떨어져있는가. == offset
            // (위에서부터 얼마만큼 떨어졌는지) / (뷰의 높이)
            let headerScaleFactor: CGFloat = -(offset) / headerView!.bounds.height
            headerTransform = CATransform3DTranslate(headerTransform, 0, -(headerView!.bounds.height/2.0) + offset, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            // 이미지를 TopCenter 를 anchor 로 해서 이미지가 늘어나게끔 하기 위해서
            // 만약에 CGPoint(x: 0.5, 0.5) 이렇게하면 Center 기준으로 늘어난다.
            
            // CGPoint(x: 0.5, y: 0.0) 이렇게하면 반만큼 내려간 상태에서 transform 이 시작되므로 3DTranslate 에서 HeaderView.imageView 높이의 반을 위로 올려준다.
            headerView!.imageView!.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            headerView!.imageView!.layer.transform = headerTransform
            
        }
    }

}











