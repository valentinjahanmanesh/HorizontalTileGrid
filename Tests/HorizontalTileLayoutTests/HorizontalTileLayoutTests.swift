import XCTest
@testable import HorizontalTileLayout
final class HorizontalTileLayoutTests: XCTestCase {
	func testStandardSqaureShouldBeAbleToContainFourMinimumSqaureSize() {
		let templates: [HorizontalTileLayout.DisplayType] = [.halfSquare, .halfSquare, .halfSquare]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		let cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)

		XCTAssertEqual(cache.standardSquare.width, cache.minimumSqaure.width * 2)
		XCTAssertEqual(cache.standardSquare.height, cache.minimumSqaure.height * 2)
	}

	// MARK: doubleInColumn
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsLessOrEqual4Double() {
		var templates: [HorizontalTileLayout.DisplayType] = [.halfSquare, .halfSquare, .halfSquare]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let sizeToContain3DoubleColumn = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(sizeToContain3DoubleColumn, cache.standardSquare)

		templates = [.halfSquare, .halfSquare, .halfSquare, .halfSquare]
		let sizeToContain4DoubleColumn = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(sizeToContain4DoubleColumn, cache.standardSquare)

		templates = [.halfSquare, .halfSquare]
		let sizeToContain2DoubleColumn = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(sizeToContain2DoubleColumn, .init(width: cache.minimumSqaure.width, height: cache.standardSquare.height))

		templates = [.halfSquare]
		let sizeToContain1DoubleColumn = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(sizeToContain1DoubleColumn, .init(width: cache.minimumSqaure.width, height: cache.standardSquare.height))
	}

	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsOdd() {
		let templates: [HorizontalTileLayout.DisplayType] = [.halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.minimumSqaure.width * CGFloat((templates.count / 2) + 1), height: cache.standardSquare.height))
	}

	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsEvenButNotDevidableBy4() {
		let templates: [HorizontalTileLayout.DisplayType] = [.halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.minimumSqaure.width * CGFloat(templates.count / 2), height: cache.standardSquare.height))
	}

	// MARK: StandardSize
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTemplatesContainsOnlySingleStandard() {
		let templates: [HorizontalTileLayout.DisplayType] = [.fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare, .fullSquare]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.standardSquare.width * CGFloat(templates.count), height: cache.standardSquare.height))
	}

	// MARK: CustomWidth
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTemplatesContainsOnlyFullWidth() {
		let tileWidth: [CGFloat] = [200,125,100,230,423,5343]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({.full(width: $0)})
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(size, .init(width: tileWidth.reduce(0, +), height: cache.standardSquare.height))
	}

	// MARK: Mix of tiles
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTemplatesContainsMixOfTiles() {
		let templates: [HorizontalTileLayout.DisplayType] = [.full(width: 100), .fullSquare, .fullSquare, .halfSquare, .halfSquare, .halfSquare, .fullSquare, .full(width: 430),.full(width: 540), .halfSquare, .halfSquare, .fullSquare,.halfSquare, .fullSquare, .halfSquare, .halfSquare, .halfSquare, .halfSquare,]
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		XCTAssertEqual(size, .init(width: 2670, height: cache.standardSquare.height))
	}

	// MARK: Place items
	func test_shouldPlaceTheItemsCorrectly_whenOnlyCustomWithItemsInside() {
		let tileWidth: [CGFloat] = [200,125,100,230,423,5343]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({.full(width: $0)})
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), templates: templates, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: tileWidth[0].half, y: containerPosition.midY), size: .init(width: tileWidth[0], height: size.height)))
		XCTAssertEqual(places[1], .init(origin: .init(x: tileWidth[0] + tileWidth[1].half, y: containerPosition.midY), size: .init(width: tileWidth[1], height: size.height)))
		XCTAssertEqual(places[2], .init(origin: .init(x: tileWidth[0] + tileWidth[1] + tileWidth[2].half, y: containerPosition.midY), size: .init(width: tileWidth[2], height: size.height)))
		XCTAssertEqual(places[3], .init(origin: .init(x: tileWidth[0] + tileWidth[1] + tileWidth[2] + tileWidth[3].half, y: containerPosition.midY), size: .init(width: tileWidth[3], height: size.height)))
	}

	func test_shouldPlaceTheItemsCorrectly_whenOnlySquareItemsInside() {
		let tileWidth: [CGFloat] = [200,200,200,200,200]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({_ in .fullSquare})
		let sut = HorizontalTileLayout(templates: templates)
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), templates: templates, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.standardSquare.width + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[2], .init(origin: .init(x: (cache.standardSquare.width * 2) + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[3], .init(origin: .init(x: (cache.standardSquare.width * 3) + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
	}

	func test_shouldPlaceTheItemsCorrectly_whenOnlyDoubleItemsInside() {
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSqaure.width,minimumSqaure.width, minimumSqaure.width, minimumSqaure.width, minimumSqaure.width, minimumSqaure.width, minimumSqaure.width]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({_ in .halfSquare})
		let sut = HorizontalTileLayout(templates: templates)

		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), templates: templates, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.minimumSqaure.width.half, y: containerPosition.midY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[2], .init(origin: .init(x: cache.minimumSqaure.width + cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[3], .init(origin: .init(x: cache.minimumSqaure.width + cache.minimumSqaure.width.half, y: containerPosition.midY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[4], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[5], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.minimumSqaure.width.half, y: containerPosition.midY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[6], .init(origin: .init(x: (cache.minimumSqaure.width * 3) + cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
	}

	func test_shouldPlaceTheItemsCorrectly_whenAMixOfTileItemsInside() {
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSqaure.width, minimumSqaure.width, minimumSqaure.width]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({_ in .halfSquare}) + [.fullSquare, .full(width: 200), .halfSquare, .full(width: 242)]
		let sut = HorizontalTileLayout(templates: templates)

		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), templates: templates, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.minimumSqaure.width.half, y: containerPosition.midY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[2], .init(origin: .init(x: cache.minimumSqaure.width + cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[3], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[4], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 100, y: containerPosition.midY), size: .init(width: 200, height: cache.standardSquare.height)))
		XCTAssertEqual(places[5], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 200 + cache.minimumSqaure.width.half, y: containerPosition.minY + cache.minimumSqaure.height.half), size: cache.minimumSqaure))
		XCTAssertEqual(places[6], .init(origin: .init(x: (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 200 + cache.minimumSqaure.width + 121, y: containerPosition.midY), size: .init(width: 242, height: cache.standardSquare.height)))
	}

	func test_shouldPlaceTheItemsCorrectly_whenAMixOfTileItemsInsideAndContainerMinXIsNotZero() {
		let minimumSqaure: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSqaure.width, minimumSqaure.width, minimumSqaure.width]
		let templates: [HorizontalTileLayout.DisplayType] = tileWidth.map({_ in .halfSquare}) + [.fullSquare, .full(width: 200), .halfSquare, .full(width: 242)]
		let sut = HorizontalTileLayout(templates: templates)

		var cache: HorizontalTileLayout.Cache = (standardSquare: sut.standardSqaureSize(from: minimumSqaure), minimumSqaure: minimumSqaure)
		let size = sut.sizeThatFitsTemplates(proposal: .init(width: 100, height: 100), templates: templates, cache: &cache)
		let containerPosition = CGRect(x: 100, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: containerPosition, proposal: .init(width: size.width, height: size.height), templates: templates, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: containerPosition.minX + cache.minimumSqaure.width.half,
													  y: containerPosition.minY + cache.minimumSqaure.height.half),
										size: cache.minimumSqaure))

		XCTAssertEqual(places[1],  .init(origin: .init(x: containerPosition.minX + cache.minimumSqaure.width.half,
													   y: containerPosition.midY + cache.minimumSqaure.height.half),
										 size: cache.minimumSqaure))

		XCTAssertEqual(places[2], .init(origin: .init(x: containerPosition.minX + cache.minimumSqaure.width + cache.minimumSqaure.width.half,
													  y: containerPosition.minY + cache.minimumSqaure.height.half),
										size: cache.minimumSqaure))

		XCTAssertEqual(places[3], .init(origin: .init(x:  containerPosition.minX + (cache.minimumSqaure.width * 2) + cache.standardSquare.width.half,
													  y: containerPosition.midY),
										size: cache.standardSquare))

		XCTAssertEqual(places[4], .init(origin: .init(x: containerPosition.minX + (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 100,
													  y: containerPosition.midY),
										size: .init(width: 200, height: cache.standardSquare.height)))

		XCTAssertEqual(places[5], .init(origin: .init(x: containerPosition.minX + (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 200 + cache.minimumSqaure.width.half,
													  y: containerPosition.minY + cache.minimumSqaure.height.half),
										size: cache.minimumSqaure))

		XCTAssertEqual(places[6], .init(origin: .init(x: containerPosition.minX + (cache.minimumSqaure.width * 2) + cache.standardSquare.width + 200 + cache.minimumSqaure.width + 121,
													  y: containerPosition.midY),
										size: .init(width: 242, height: cache.standardSquare.height)))
	}
}
