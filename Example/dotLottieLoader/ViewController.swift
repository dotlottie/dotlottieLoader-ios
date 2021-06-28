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
        
        var creator = DotLottieCreator(animationUrl: URL(string: "https://assets7.lottiefiles.com/private_files/lf30_p25uf33d.json")!)
        
        creator.appearance = [
            .init(.dark, animation: "https://assets8.lottiefiles.com/private_files/lf30_yiodtvs6.json"),
            .init(.custom("alternative"), animation: "https://assets8.lottiefiles.com/private_files/lf30_yiodtvs6.json", colors: [.init(layer: ["Love 2", "Heart Outlines 2", "Group 1", "Stroke 1", "Color"], color: "#fafafa")])
        ]
        
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
                      - \(dotLottieFile.manifest?.appearance?.count ?? 0) appearances
                      - Default animation: \(dotLottieFile.animationUrl?.absoluteString ?? "not defined")
                      - Light appearance: \(dotLottieFile.animationURL(for: .light)?.absoluteString ?? "not defined")
                      - Dark appearance: \(dotLottieFile.animationURL(for: .dark)?.absoluteString ?? "not defined")
                      """)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

