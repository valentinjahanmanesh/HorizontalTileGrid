//
//  HorizontalTileLayout+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import Foundation
public extension HorizontalTileLayout {
	enum BlockType {
		/// a full block is a square that fills the height of the HorizontalTileLayout (width = height = HorizontalTileLayout.hight) (equals to 4 blocks)
		case full
		/// a block is the smallest possible displayable square in the HorizontalTileLayout. the height of a block is equal to half of HorizontalTileLayout height (width = height = HorizontalTileLayout.height / 2)
		case block
		// a block that its height is equal to the HorizontalTileLayout but its width can be a custom value.
		case fullCustom(width: CGFloat)
	}
}
