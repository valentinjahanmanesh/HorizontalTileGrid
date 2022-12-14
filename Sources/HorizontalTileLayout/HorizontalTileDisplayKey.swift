//
//  HorizontalTileDisplayKey.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import SwiftUI

/// A display type key that acts as an identifier for the ``HorizontalTileLayout`` subviews. ``HorizontalTileLayout`` will look for this key on the the subviews only when it has been initiated without a ``DisplayType`` list.
public struct HorizontalTileDisplayKey: LayoutValueKey {
	public static var defaultValue: HorizontalTileLayout.DisplayType = .fullSquare
}
