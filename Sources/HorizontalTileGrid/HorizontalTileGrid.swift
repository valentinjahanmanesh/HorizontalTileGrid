//
//  HorizontalTileGrid.swift
//
//
//  Created by Farshad Macbook M1 Pro on 12/2/22.
//

import SwiftUI
/// HorizontalTileGrid layouts it's subviews horizontally based on given block types. if no height is provided for HorizontalTileGrid, its height would be equal to the biggest subview and the its width would be calculated as big as the total size of the block types.
/// the simplest block type is ``BlockType``.block that is a square that fills its side fills the HorizontalTileGrid's height.
///
/// ``BlockType`` supported by HorizontalTileGrid are `block`, `double`, and `blockCustom`
///
///
///     ------------- HorizontalTileGrid ---------------------
///		|           |  D  |                      |  D  |  D  |
///		|           |  01 |                      |  01 |  01 |
///		|   Block   |-----| BlockWithCustomWidth |-----|-----|
///		|           |  D  |                      |  D  |  D  |
///		|           |  02 |                      |  02 |  02 |
///     ------------- HorizontalTileGrid ---------------------
public struct HorizontalTileGrid: Layout {
	private let blocks: [BlockType]?


	/// Initialize the layout with an optional array of the display types. if the arrays is null, the layout expects it's subviews to be one of these three views ``DoubleTile``, ``CustomWidthBlockTile``, ``BlockTile`` or a custom view with ``BlockTypeKey`` LayoutValueKey.
	/// - Parameter blocks: an optional array of double types, in case of the presence of a display type array, the subviews of the layout can be any view, and the number of visible items would be equal to the number of items in the BlockType array. It means that the layout would only display the views that have one representation display type inside the BlockType array.
	public init(blocks: [BlockType]? = nil) {
		self.blocks = blocks
	}

	/// Collects the size of all the child views (Proxy instances). Each proxy has a sizeThatFits function which accepts a proposed size, In SwiftUI, views choose their own size, but can take a size proposal from their parent view into account when doing so. above, I didn’t specify any particular size to the child view so I can get the ideal size of each child view.
	/// Calculates the size of the subviews and returns the a list of sizes which indicates how much space each subview needs to be able to show it's contents.
	/// - Parameter subviews: an array of subview proxies
	/// - Returns: list of CGSizes that would indicates the size of the subview
	func sizes(of subviews: Subviews) -> [CGSize]  {
		subviews
			.map({$0.sizeThatFits(.unspecified)})
	}

	
	public typealias Cache = (standardSquare: CGSize, minimumSquare: CGSize)

	/// Calculates and returns the size of the standard square
	/// - Parameter minimumSquareSize: size of the smallest displayable square in the layout. This is the size of one of the squares in **half** display type and ``DoubleTile``.
	/// - Returns: the size of the standard square. This size will be use for displaying the **Square** display type and ``BlockTile``
	func standardSquareSize(from minimumSquareSize: CGSize) -> CGSize {
		return CGSize(width: minimumSquareSize.width * 2, height: minimumSquareSize.height * 2)
	}


	/// Generates the cache to improve the layout performance.
	/// - Parameter subviews: list of subviews
	/// - Returns: cache, which is the size of the minimumSquare and the standardSquare
	public func makeCache(subviews: Subviews) -> Cache {
		let minimumSquareSize = minimumSquareSize(toFit: subviews)
		let standardSquareSize = standardSquareSize(from: minimumSquareSize)

		return (standardSquareSize, minimumSquareSize)
	}


	/// Calculates the smallest subview's height. This height indicates the height of the square in **half** display type and ``DoubleTile``.
	/// - Parameter sizes: list of sizes of the subviews
	/// - Returns: height of the smallest tile in the layout
	func minimumHeight(of sizes: [CGSize]) -> CGFloat {
		return sizes.map({item in max(item.width, item.height)})
			.max(by: {$0 < $1}) ?? 1
	}


	/// Calculates the size of the layout. the height of the layout would be equal to the height of a standard square which will be calculated here **func standardSquareSize(from minimumSquareSize: CGSize) -> CGSize** and the minimum required with for showing the items would be sum of all display types
	/// - Parameters:
	///   - proposal: the size that parent view will propose to the layout
	///   - blocks: all the display types that will be shown
	///   - cache: the cache
	/// - Returns: minimum required size of the layout view
	func sizeThatFitsBlocks(proposal: ProposedViewSize, blocks: [BlockType], cache: inout Cache) -> CGSize {
		let (standardSquareSize, minimumSquareSize) = cache
		let widthNeeded = blocks.map { tmp in
			switch tmp {
			case .blockCustom(let width):
				return width
			case .double:
				return  minimumSquareSize.height
			case .block:
				return standardSquareSize.width
			}
		}
		.reduce(0.0, +)

		return CGSize(width: widthNeeded, height: standardSquareSize.height)
	}

	/// Calculates the size of the layout. the height of the layout would be equal to the height of a standard square which will be calculated here **func standardSquareSize(from minimumSquareSize: CGSize) -> CGSize** and the minimum required with for showing the items would be sum of all display types
	/// - Parameters:
	///   - proposal: the size that parent view will propose to the layout
	///   - blocks: all the subviews that will be shown
	///   - cache: the cache
	/// - Returns: minimum required size of the layout view
	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
		let blocks = self.blocks ?? subviews.map{$0[BlockTypeKey.self]}
		return sizeThatFitsBlocks(proposal: proposal, blocks: blocks, cache: &cache)
	}

	/// Squares are building blocks of the HorizontalTileGrid, the minimum square size that our layout can show is the
	/// half size
	private func minimumSquareSize(toFit subviews: Subviews) -> CGSize {
		let sizes = sizes(of: subviews)
		let minHeight = minimumHeight(of: sizes)
		return .init(width: minHeight, height: minHeight)
	}

	/// Calculates and manages the position of each subview inside the layout view
	/// - Parameters:
	///   - bounds: the bounds of the layout view
	///   - proposal: the proposed size of the layout view which is the one that we returns from this function **	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize**
	///   - blocks: list of all display types
	///   - cache: cache
	/// - Returns: returns a list of the positions. Each item in this list represents the position of one subview in the layout view
	func calculatePlaceSubviews(in bounds: CGRect, proposal: ProposedViewSize, blocks: [BlockType], cache: inout Cache) -> [CGRect] {
		var calculatedPlaces: [CGRect] = []
		let (standardSquareSize, minimumSquareSize) = cache
		var traversedX = bounds.minX

		blocks.indices.forEach { blockIndex in
			let point: CGPoint
			let size: CGSize
			switch blocks[blockIndex] {
			case .double:
				size = CGSize(width: minimumSquareSize.width, height: minimumSquareSize.height)
				// Bottom Cell
				point = CGPoint(x: traversedX + minimumSquareSize.width.half, y: bounds.minY + minimumSquareSize.height.half + minimumSquareSize.height)

				// Top Cell
				var topCellPoint = point
				topCellPoint.y = point.y - minimumSquareSize.height

				traversedX += minimumSquareSize.width
				calculatedPlaces.append(CGRect(origin: topCellPoint, size: size))
			case .blockCustom(let width):
				size = CGSize(width: width, height: standardSquareSize.height)
				point = CGPoint(x: traversedX + width.half, y: bounds.midY)
				traversedX += width
			case .block:
				size = CGSize(width: standardSquareSize.width, height: standardSquareSize.height)
				point = CGPoint(x: traversedX + standardSquareSize.width.half, y: bounds.minY + standardSquareSize.height.half)
				traversedX += standardSquareSize.width
			}
			calculatedPlaces.append(CGRect(origin: point, size: size))
		}
		return calculatedPlaces
	}

	/// Calculates and manages the position of each subview inside the layout view
	/// - Parameters:
	///   - bounds: the bounds of the layout view
	///   - proposal: the proposed size of the layout view which is the one that we returns from this function **	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize**
	///   - subviews: list of all subviews
	///   - cache: cache
	/// - Returns: returns a list of the positions. Each item in this list represents the position of one subview in the layout view
	public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
		let blocks = self.blocks ?? subviews.map{$0[BlockTypeKey.self]}
		let calculated = calculatePlaceSubviews(in: bounds, proposal: proposal, blocks: blocks, cache: &cache)
		zip(subviews, calculated).forEach { view, proposedSizePosition in
			view.place(at: proposedSizePosition.origin, anchor: .center, proposal: ProposedViewSize(width: proposedSizePosition.size.width, height: proposedSizePosition.size.height))
		}
	}
}

