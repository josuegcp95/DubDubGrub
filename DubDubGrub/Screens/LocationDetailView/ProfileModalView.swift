//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/19/23.
//

import SwiftUI

struct ProfileModalView: View {
    
    @Binding var isShowingProfileModal: Bool
    var profile: DDGProfile
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 20)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal)
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                Text(profile.bio)
                    .lineLimit(3)
                    .padding()
            }
            .frame(width: 300, height: 300)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation { isShowingProfileModal = false }

                } label: {
                    XDismissButton()
                }

            }
            
            Image(uiImage: profile.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black, radius: 4, x: 0, y: 6)
                .offset(y: -150)
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(isShowingProfileModal: .constant(.random()), profile: DDGProfile(record: MockData.profile))
    }
}
