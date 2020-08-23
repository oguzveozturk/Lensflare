//
//  ImageProcessor.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

protocol ImageProcessor: class {
    func process(_ imageURL: String?)
    func save()
}

protocol ImageProcessorView: ImageProcessor, UIView { }
