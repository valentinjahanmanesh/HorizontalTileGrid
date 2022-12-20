//
//  CustomWidthBlockTile.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import SwiftUI
public struct CustomWidthBlockTile<Content: View> : View {
	private var width: CGFloat
	@ViewBuilder var content: ()->Content
	public init(width: CGFloat, @ViewBuilder builder: @escaping () -> Content) {
		self.content = builder
		self.width = width
	}

	public var body: some View {
		content()
			.layoutValue(key: BlockTypeKey.self, value: .fullCustom(width: width))
	}
}
