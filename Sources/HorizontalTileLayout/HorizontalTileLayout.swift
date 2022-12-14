//
//  HorizontalTileLayout.swift
//
//
//  Created by Farshad Macbook M1 Pro on 12/2/22.
//

import SwiftUI
/// HorizontalTileLayout layouts it's subviews horizontally based on the subview display type. if no height is provided to HorizontalTileLayout, the height of the list would be equal to the biggest subview and the with of this layout would be equal to the sum of all display type widths.
/// There are three ``DisplayType``:
///
///
/// **Full(width: CGFloat)**:
/// 	This subview will have a custom width. it will fill the HorizontalTileLayout and a width eqal to the provided value.
///
/// **HalfSquare**:
/// 	If a subview is of type HalfSquare, Layout devides the available height in half and places the item on top or bottom space based on the order of appreance of the item in list. Layout would always start from top half, places the suview on the top half and goes to the next view, if the next item is a another halfSqure again, the layout places the new item in the bottom half, but if the next item is not of halfSqure display type, the bottom half would be empty
///
///	**FullSqaure**:
///		This display type is a standard sqaure and provides a space of Width=Height=HorizontalTileLayout height.
///		This display type is a standard sqaure and provides a space of Width=Height=HorizontalTileLayout height.
///
public struct HorizontalTileLayout: Layout {
	private let templates: [DisplayType]?


	/// Initialize the layout with an optional array of the display types. if the arrays is null, the layout expects it's subviews to be one of these three views ``BlockTile``, ``CustomTile``, ``StandardSqaureTile`` or a custom view with ``HorizontalTileDisplayKey`` LayoutValueKey.
	/// - Parameter templates: an optional array of display types, in case of present of display type array, the subviews of the layout can be any view, and the number of visible items would be eqaual to number of item in DisplayType array. It means that the layout would only display the views that has one representation display type inside the DisplayType array.
	public init(templates: [DisplayType]? = nil) {
		self.templates = templates
	}


	/// Calculates the size of the subviews and returns the a list of sizes which indicates how much space each subview needs to be able to show it's contents.
	/// - Parameter subviews: an array of subview proxies
	/// - Returns: list of CGSizes that would indicates the size of the subview
	func sizes(of subviews: Subviews) -> [CGSize]  {
		subviews
			.map({$0.sizeThatFits(.unspecified)})
	}

	
	public typealias Cache = (standardSquare: CGSize, minimumSqaure: CGSize)

	/// Caclulates and returns the size of the standard square
	/// - Parameter minimumSqaureSize: size of the smallest displayable sqaure in the layout. This is the size of one of the sqaures in **halfSqure** display type and ``BlockTile``.
	/// - Returns: the size of the standard sqaure. This size will be use for displaying the **Sqaure** display type and ``StandardSqaureTile``
	func standardSqaureSize(from minimumSqaureSize: CGSize) -> CGSize {
		return CGSize(width: minimumSqaureSize.width * 2, height: minimumSqaureSize.height * 2)
	}


	/// Generates the cache to improve the layouting performance.
	/// - Parameter subviews: list of subviews
	/// - Returns: cache, which is the size of the minimumSqaure and the standardSqaure
	public func makeCache(subviews: Subviews) -> Cache {
		let minimumSqaureSize = minimumSqaureSize(toFit: subviews)
		let standardSqaureSize = standardSqaureSize(from: minimumSqaureSize)

		return (standardSqaureSize, minimumSqaureSize)
	}


	/// Calculates the smallest subview's height. This height indicates the height of the sqaure in **halfSqure** display type and ``BlockTile``.
	/// - Parameter sizes: list of sizes of the subviews
	/// - Returns: height of the smallest tile in the layout
	func minheight(of sizes: [CGSize]) -> CGFloat {
		return sizes.map({item in max(item.width, item.height)})
			.max(by: {$0 < $1}) ?? 1
	}


	/// Calculates the size of the layout. the height of the layout would be equal to the height of a standard sqaure which will be calculated here **func standardSqaureSize(from minimumSqaureSize: CGSize) -> CGSize** and the minimum required with for showing the items would be sum of all display types
	/// - Parameters:
	///   - proposal: the size that parent view will propose to the layout
	///   - templates: all the display types that will be shown
	///   - cache: the cache
	/// - Returns: minimum required size of the layout view
	func sizeThatFitsTemplates(proposal: ProposedViewSize, templates: [DisplayType], cache: inout Cache) -> CGSize {
		let (standardSqaureSize, minimumSqaureSize) = cache
		var isNextDouble: Bool = false
		let widthNeeded = templates.map { tmp in
			switch tmp {
			case .full(let width):
				isNextDouble = false
				return width
			case .halfSquare:
				if isNextDouble {
					isNextDouble = false
					return 0
				}
				isNextDouble = true
				return  minimumSqaureSize.height
			case .fullSquare:
				isNextDouble = false
				return standardSqaureSize.width
			}
		}
		.reduce(0.0, +)

		return CGSize(width: widthNeeded, height: standardSqaureSize.height)
	}

	/// Calculates the size of the layout. the height of the layout would be equal to the height of a standard sqaure which will be calculated here **func standardSqaureSize(from minimumSqaureSize: CGSize) -> CGSize** and the minimum required with for showing the items would be sum of all display types
	/// - Parameters:
	///   - proposal: the size that parent view will propose to the layout
	///   - templates: all the subviews that will be shown
	///   - cache: the cache
	/// - Returns: minimum required size of the layout view
	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
		let templates = self.templates ?? subviews.map{$0[HorizontalTileDisplayKey.self]}
		return sizeThatFitsTemplates(proposal: proposal, templates: templates, cache: &cache)
	}

	/// Sqaures are bulding blocks of the view, minimum sqaure size that our layout can show is the
	/// doubledColomns size
	private func minimumSqaureSize(toFit subviews: Subviews) -> CGSize {
		let sizes = sizes(of: subviews)
		let minHeight = minheight(of: sizes)
		return .init(width: minHeight, height: minHeight)
	}

	/// Calculates and manages the position of each subview inside the layout view
	/// - Parameters:
	///   - bounds: the bounds of the layout view
	///   - proposal: the proposed size of the layout view which is the one that we returns from this function **	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize**
	///   - templates: list of all display types
	///   - cache: cache
	/// - Returns: returns a list of the positions. Each item in this list represents the position of one subview in the layout view
	func calculatePlaceSubviews(in bounds: CGRect, proposal: ProposedViewSize, templates: [DisplayType], cache: inout Cache) -> [CGRect] {
		var calculatedPlaces: [CGRect] = []
		let (standardSqaureSize, minimumSqaureSize) = cache
		var traversedX = bounds.minX
		var nextCellInDoubledColumnPosition: CGPoint? = nil
		templates.indices.forEach { templateIndex in
			let point: CGPoint
			let size: CGSize
			switch templates[templateIndex] {
			case .halfSquare:
				size = CGSize(width: minimumSqaureSize.width, height: minimumSqaureSize.height)
				if let nextSlotPoint = nextCellInDoubledColumnPosition {
					point = nextSlotPoint
					nextCellInDoubledColumnPosition = nil
				} else {
					point = CGPoint(x: traversedX + minimumSqaureSize.width.half, y: bounds.minY + minimumSqaureSize.height.half)
					nextCellInDoubledColumnPosition = point
					nextCellInDoubledColumnPosition!.y = point.y + minimumSqaureSize.height
					traversedX += minimumSqaureSize.width
				}

			case .full(let width):
				nextCellInDoubledColumnPosition = nil
				size = CGSize(width: width, height: standardSqaureSize.height)
				point = CGPoint(x: traversedX + width.half, y: bounds.midY)
				traversedX += width
			case .fullSquare:
				nextCellInDoubledColumnPosition = nil
				size = CGSize(width: standardSqaureSize.width, height: standardSqaureSize.height)
				point = CGPoint(x: traversedX + standardSqaureSize.width.half, y: bounds.minY + standardSqaureSize.height.half)
				traversedX += standardSqaureSize.width
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
		let templates = self.templates ?? subviews.map{$0[HorizontalTileDisplayKey.self]}
		let calculated = calculatePlaceSubviews(in: bounds, proposal: proposal, templates: templates, cache: &cache)
		zip(subviews, calculated).forEach { view, proposedSizePosition in
			view.place(at: proposedSizePosition.origin, anchor: .center, proposal: ProposedViewSize(width: proposedSizePosition.size.width, height: proposedSizePosition.size.height))
		}
	}
}

