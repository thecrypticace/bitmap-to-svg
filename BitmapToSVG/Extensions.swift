//
//  Extensions.swift
//  BitmapToSVG
//
//  Created by Jordan Pittman on 9/28/16.
//  Copyright © 2016 Cryptica. All rights reserved.
//

import Cocoa

extension NSImage {
    func svgPixelArt(blockSize: CGSize = CGSize(width: 1, height: 1)) -> String {
        var svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 \(Int(self.size.width / blockSize.width)) \(Int(self.size.height / blockSize.height))\">"

        for pixel in Pixels(image: self, blockSize: blockSize) {
            guard pixel.color.alphaComponent > 0 else {
                continue
            }

            let x = Int(pixel.origin.x / blockSize.width)
            let y = Int(pixel.origin.y / blockSize.height)
            let width = Int(pixel.size.width / blockSize.width)
            let height = Int(pixel.size.height / blockSize.height)

            svg += "\n"
            svg += "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(width)\" height=\"\(height)\" fill=\"#\(pixel.color.hex)\" />"
        }

        svg += "\n"
        svg += "</svg>"

        return svg
    }
}

extension NSBitmapImageRep {
    func color(at block: CGRect) -> NSColor? {
        return colorAt(x: Int(block.size.width * block.origin.x), y: Int(block.size.height * block.origin.y))
    }
}

extension NSColor {
    var hex: String {
        let red = Int(redComponent * 255)
        let blue = Int(blueComponent * 255)
        let green = Int(greenComponent * 255)

        return String(format:"%02X%02X%02X", red, green, blue)
    }
}
