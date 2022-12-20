//
//  HorizontalTileGrid+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import Foundation
public extension HorizontalTileGrid {
	
	/// Display types supported by HorizontalTileGrid
	///
	///
	///     ------------- HorizontalTileGrid ---------------------
	///		|           |  D  |                      |  D  |  D  |
	///		|           |  01 |                      |  01 |  01 |
	///		|   Block   |-----| BlockWithCustomWidth |-----|-----|
	///		|           |  D  |                      |  D  |  D  |
	///		|           |  02 |                      |  02 |  02 |
	///     ------------- HorizontalTileGrid ---------------------
	enum BlockType {
		/// a block is a square that fills the height of the HorizontalTileGrid (width = height = HorizontalTileGrid.height)
		case block

		/// a double contains two small slot for two views, it divides the height of the HorizontalTileGrid in half and arranges the views horizontally from top to bottom inside those two slots. each slot size would be (width = height = HorizontalTileGrid.height / 4).
		case double

		// this is a block but with custom width. Its height is equal to the HorizontalTileGrid but its width can be various based on the width value.
		case blockCustom(width: CGFloat)
	}
}
