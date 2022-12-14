![Simulator Screen Recording - iPhone 14 - 2022-12-14 at 00](https://user-images.githubusercontent.com/13612410/207546510-d40ac8e1-7a02-4014-9293-74b8452a25a8.gif)


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
    HorizontalTileLayout(views: [
        Text("Item 1"),
        Text("Item 2"),
        Text("Item 3")
    ])
```
By default, the views will be laid out horizontally with equal widths. You can customize the widths by passing a widths array to the HorizontalTileLayout view. For example:
```swift
    HorizontalTileLayout(views: [
        Text("Item 1"),
        Text("Item 2"),
        Text("Item 3")
    ], widths: [.fixed(100), .flexible, .fixed(200)])
```
In this example, "Item 1" will have a fixed width of 100 points, "Item 2" will have a flexible width that takes up the remaining space, and "Item 3" will have a fixed width of 200 points.

You can also customize the spacing between the views by passing a spacing parameter to the HorizontalTileLayout view. For example:
```swift
    HorizontalTileLayout(views: [
        Text("Item 1"),
        Text("Item 2"),
        Text("Item 3")
    ], spacing: 16)
```
In this example, the
