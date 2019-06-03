//
//  VideoContainer.swift
//  Cutu Meu
//
//  Created by Narcis Zait on 04/06/2018.
//  Copyright © 2018 Narcis Zait. All rights reserved.
//

import UIKit

class VideoContainer: UIViewController {

    var backgroundPlayer: BackgroundVideo?;
    var blurEffect: UIBlurEffect!;
    var blurredEffectView: UIVisualEffectView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        let n = Int(arc4random_uniform(12)) + 1
        backgroundPlayer = BackgroundVideo(on: self, withVideoURL: "Traffic1.mp4");
        backgroundPlayer?.setUpBackground();
        
        blurEffect = UIBlurEffect(style: .dark);
        blurredEffectView = UIVisualEffectView(effect: blurEffect);
//        blurredEffectView.backgroundColor = UIColor.white
        blurredEffectView?.frame = (backgroundPlayer?.viewController?.view.bounds)!;
        blurredEffectView?.alpha = 0.5;
        view.addSubview(blurredEffectView!);
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
