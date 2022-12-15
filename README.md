![Simulator Screen Recording - iPhone 14 - 2022-12-14 at 00](https://user-images.githubusercontent.com/13612410/207546510-d40ac8e1-7a02-4014-9293-74b8452a25a8.gif)

HorizontalTileLayout is a SwiftUI view that layouts its subviews horizontally like a list of tiles based on the each subview display type and custom width.

# How To Use

To use the HorizontalTileLayout library in your iOS16 SwiftUI project, follow these steps:

In your Xcode project, go to the "File" menu and select "Swift Packages" followed by "Add Package Dependency."

In the search field, enter the URL for the HorizontalTileLayout library: `https://github.com/farshadjahanmanesh/HorizontalTileLayout`

Select the version of the library you want to use and click "Next."

In your SwiftUI code, import the HorizontalTileLayout library by adding the following line at the top of your file:

```swift
    import HorizontalTileLayout
```

To create a horizontal tile layout, use the HorizontalTileLayout view and pass it an array of views to be laid out horizontally. For example:

```swift
    ScrollView(.horizontal) {
        HorizontalTileLayout(templates: self.restaurantsLayout) {
            ForEach(restaurants) { food in
                RestaurantItemView(food: food)
                    .padding(1)
            }
        }
    }
    .scrollIndicators(.hidden)
```

By default, the views will be laid out horizontally with equal widths. You can customize the widths by passing a widths array to the HorizontalTileLayout view. For example:

```swift
   public var restaurantsLayout: [HorizontalTileLayout.DisplayType] {
		(0..<restaurants.count).map({_ in randomTile()})
   }
```

In this example, "Item 1" will have a fixed width of 100 points, "Item 2" will have a flexible width that takes up the remaining space, and "Item 3" will have a fixed width of 200 points.

You can also customize the spacing between the views by passing a spacing parameter to the HorizontalTileLayout view. For example:

```swift
   private func randomTile() -> HorizontalTileLayout.DisplayType {
		switch (0...2)
			.randomElement() {
		case 0: return .doubleInColumn
		case 1: return .full(width: CGFloat((200...300).randomElement()!))
		default: return .square
		}
	}
```

In this example, the

```swift
ScrollView(.horizontal) {
    HorizontalTileLayout {
        StandardSquareTile {
            RestaurantItemView(food: restaurants[0])
                .padding(1)
        }

        StandardSquareTile {
            RestaurantItemView(food: restaurants[1])
                .padding(1)
        }

        CustomTile(width: 300) {
            RestaurantItemView(food: restaurants[2])
                .padding(1)
        }
    }
}
.scrollIndicators(.hidden)
```
