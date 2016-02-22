//
//  TwitterColor.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class TwitterColor: UIColor {
    
    func tweetcolor() -> CAGradientLayer {
        
        let topColor = UIColor(red: 200/255.0, green: 233/255.0, blue: 253/255.0, alpha: 1)
        let bottomColor = UIColor(red: 88/255.0, green: 158/255.0, blue: 208/255.0, alpha: 1)
        
        let gradientColors: [CGColorRef] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
        
    }
}
