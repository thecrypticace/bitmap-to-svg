//
//  main.swift
//  BitmapToSVG
//
//  Created by Jordan Pittman on 9/28/16.
//  Copyright © 2016 Cryptica. All rights reserved.
//

import Cocoa

func usage() -> String {
    return "BitmapToSVG: Convert a bitmap image into a pixel-art SVG"
         + "\n"
         + "Usage: ./BitmapToSVG <image path> [blockWidth blockHeight]"
         + "\n"
}

guard CommandLine.arguments.count == 2 || CommandLine.arguments.count == 4 else {
    print(usage())

    exit(1)
}

let imagePath = CommandLine.arguments[1]

guard FileManager.default.fileExists(atPath: imagePath) else {
    print("The file given does not exist: \(imagePath)")

    exit(1)
}


let blockSize: CGSize

if CommandLine.arguments.count == 4 {
    guard
        let width = UInt(CommandLine.arguments[2]),
        let height = UInt(CommandLine.arguments[3])
    else {
        print("Block width and height must be positive, whole numbers")
        print(usage())

        exit(1)
    }

    blockSize = CGSize(width: CGFloat(width), height: CGFloat(height))
} else {
    blockSize = CGSize(width: 1, height: 1)
}

guard let image = NSImage(contentsOfFile: imagePath) else {
    print("There was an error reading the image.")

    exit(1)
}

print(image.svgPixelArt(blockSize: blockSize))
