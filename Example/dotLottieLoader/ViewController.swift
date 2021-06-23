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
//        DotLottieLoader.dotLottie(fromJsonLottieAt: URL(string: "https://assets7.lottiefiles.com/packages/lf20_6k4jsmai.json")!) { url in
//            // file compressed into dotLottie
//            guard let url = url else { return }
//            DotLottieLoader.load(from: url) { dotLottieFile in
//                // file decompressed from dotLottie
//                guard let dotLottieFile = dotLottieFile else {
//                    print("invalid dotLottie file")
//                    return
//                }
//                print("dotLottieFile decompressed successfuly with \(dotLottieFile.animations.count) animation\(dotLottieFile.animations.count == 1 ? "" : "s")")
//            }
//        }
        
        DotLottieLoader.dotLottie(fromJsonLottieAt: URL(string: "https://assets7.lottiefiles.com/private_files/lf30_p25uf33d.json")!,
                                  appearances: [.dark: "https://assets8.lottiefiles.com/private_files/lf30_yiodtvs6.json"]) { url in
            // file compressed into dotLottie
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
                      - Light theme: \(dotLottieFile.animationURL(for: .light)?.absoluteString ?? "not defined")
                      - Dark theme: \(dotLottieFile.animationURL(for: .dark)?.absoluteString ?? "not defined")
                      """)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

