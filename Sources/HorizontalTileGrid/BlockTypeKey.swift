//
//  BlockTypeKey.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import SwiftUI

/// A display type key that acts as an identifier for the ``HorizontalTileGrid`` subviews. ``HorizontalTileGrid`` will look for this key on the the subviews only when it has been initiated without a ``BlockType`` list.
public struct BlockTypeKey: LayoutValueKey {
	public static var defaultValue: HorizontalTileGrid.BlockType = .block
}
