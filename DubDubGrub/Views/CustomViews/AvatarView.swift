//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/25/23.
//

import SwiftUI

struct AvatarView: View {
    var image: UIImage
    var size: CGFloat
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: PlaceHolderImage.avatar, size: 90)
    }
}
