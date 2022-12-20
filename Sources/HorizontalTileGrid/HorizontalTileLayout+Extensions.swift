//
//  HorizontalTileGrid+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import Foundation
public extension HorizontalTileGrid {
	enum BlockType {
		/// a full block is a square that fills the height of the HorizontalTileGrid (width = height = HorizontalTileGrid.hight) (equals to 4 blocks)
		case full
		/// a block is the smallest possible displayable square in the HorizontalTileGrid. the height of a block is equal to half of HorizontalTileGrid height (width = height = HorizontalTileGrid.height / 2)
		case block
		// a block that its height is equal to the HorizontalTileGrid but its width can be a custom value.
		case fullCustom(width: CGFloat)
	}
}
