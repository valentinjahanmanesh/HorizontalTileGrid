![Simulator Screen Recording - iPhone 14 - 2022-12-14 at 00](https://user-images.githubusercontent.com/13612410/207546510-d40ac8e1-7a02-4014-9293-74b8452a25a8.gif)

HorizontalTileGrid is a SwiftUI view that layouts its subviews horizontally like a list of tiles based on the each subview display type and custom width.

# How To Use

To use the HorizontalTileGrid library in your iOS16 SwiftUI project, follow these steps:

In your Xcode project, go to the "File" menu and select "Swift Packages" followed by "Add Package Dependency."

In the search field, enter the URL for the HorizontalTileGrid library: `https://github.com/farshadjahanmanesh/HorizontalTileGrid`

Select the version of the library you want to use and click "Next."

In your SwiftUI code, import the HorizontalTileGrid library by adding the following line at the top of your file:

```swift
    import HorizontalTileGrid
```

To create a horizontal tile layout, use the HorizontalTileGrid view and pass it an array of views to be laid out horizontally. For example:

```swift
    ScrollView(.horizontal) {
        HorizontalTileGrid(templates: self.restaurantsLayout) {
            ForEach(restaurants) { food in
                RestaurantItemView(food: food)
                    .padding(1)
            }
        }
    }
    .scrollIndicators(.hidden)
```

By default, the views will be laid out horizontally with equal widths. You can customize the widths by passing a widths array to the HorizontalTileGrid view. For example:

```swift
	public var restaurantsLayout: [HorizontalTileLayout.BlockType] {
		(0..<restaurants.count).map({index in
			index == 0 ? .fullCustom(width: 400) :
			(index % 5 == 0 ? .full : .block)})
	}
```

In this example, "Item 1" will have a fixed width of 100 points, "Item 2" will have a flexible width that takes up the remaining space, and "Item 3" will have a fixed width of 200 points.

You can also customize the spacing between the views by passing a spacing parameter to the HorizontalTileGrid view. For example:

```swift

	private func randomTile() -> HorizontalTileLayout.BlockType {
		switch (0...2)
			.randomElement() {
		case 0: return .block
		case 1: return .fullCustom(width: CGFloat((200...300).randomElement()!))
		default: return .full
		}
	}
```
