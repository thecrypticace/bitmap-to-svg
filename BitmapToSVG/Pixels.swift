//
//  Pixels.swift
//  BitmapToSVG
//
//  Created by Jordan Pittman on 9/28/16.
//  Copyright © 2016 Cryptica. All rights reserved.
//

import Cocoa

struct Pixels {
    typealias Pixel = (origin: CGPoint, size: CGSize, color: NSColor)

    let image: NSImage
    let blockSize: CGSize

    init(image: NSImage, blockSize: CGSize = CGSize(width: 1, height: 1)) {
        self.image = image
        self.blockSize = blockSize
    }
}

extension Pixels: Sequence {
    func makeIterator() -> AnyIterator<Pixel> {
        // keep the index of the next car in the iteration
        var x: Int = 0
        var y: Int = 0

        let xBlocks = Int(image.size.width / blockSize.width)
        let yBlocks = Int(image.size.width / blockSize.height)

        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!

        return AnyIterator {
            defer { x += 1 }

            if x >= xBlocks {
                x = 0
                y += 1
            }

            if y >= yBlocks {
                return nil
            }

            let origin = CGPoint(x: x, y: y)

            let block = CGRect(origin: origin, size: self.blockSize)

            // FIXME: This is a condition that should throw an error not return early
            guard let color = bitmap.color(at: block) else { return nil }

            return (
                origin: CGPoint(x: origin.x * self.blockSize.width, y: origin.y * self.blockSize.height),
                size: self.blockSize,
                color: color
            )
        }
    }
}
