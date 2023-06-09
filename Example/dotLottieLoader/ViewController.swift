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
            DotLottieLoader.loadedFrom(url: url) { result in
                switch result {
                case .success(let success):
                    print("""
                          dotLottieFile decompressed successfuly with:
                          - \(success.animations.count) animations
                          - Default animation: \(success.animations.first?.animationUrl.absoluteString ?? "not defined")
                          """)
                case .failure(let failure):
                    print("invalid dotLottie file: \(failure.localizedDescription)")
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

