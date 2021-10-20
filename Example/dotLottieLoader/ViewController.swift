//
//  ViewController.swift
//  dotLottieLoader
//
//  Created by eharrison on 08/05/2020.
//  Copyright (c) 2020 eharrison. All rights reserved.
//

import UIKit
import dotLottieLoader

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DotLottieUtils.isLogEnabled = true
        
        let creator = DotLottieCreator(animationUrl: URL(string: "https://assets7.lottiefiles.com/private_files/lf30_p25uf33d.json")!)
        
        creator.create { url in
            guard let url = url else { return }
            DotLottieLoader.load(from: url) { dotLottieFile in
                // file decompressed from dotLottie
                guard let dotLottieFile = dotLottieFile else {
                    print("invalid dotLottie file")
                    return
                }
                
                print("""
                      dotLottieFile decompressed successfuly with:
                      - \(dotLottieFile.animations.count) animations
                      - \(dotLottieFile.images.count) images
                      - Default animation: \(dotLottieFile.animationUrl?.absoluteString ?? "not defined")
                      """)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

