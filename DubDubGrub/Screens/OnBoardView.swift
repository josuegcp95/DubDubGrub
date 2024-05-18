//
//  OnBoardView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 7/6/23.
//

import SwiftUI

struct OnBoardView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24) {
            
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    XDismissButton()
                }
                .padding()
            }
            
            Spacer()
            
            LogoView(frameWidth: 250)
            
            VStack(alignment: .leading, spacing: 0) {
                OnboardInfoView(imageName: "building.2.crop.circle",
                                title: "Restaurant Locations",
                                description: "Find places to dine around the convention center")
                
                OnboardInfoView(imageName: "checkmark.circle",
                                title: "Check In",
                                description: "Let other iOS Devs know where you are")
                
                OnboardInfoView(imageName: "person.2.circle",
                                title: "Find Friends",
                                description: "See where other iOS Devs are and join the party")
            }
            Spacer()
        }
    }
}

struct OnBoardView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView()
    }
}

struct OnboardInfoView: View {
    var imageName: String
    var title: String
    var description: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .bold()
                    .font(.title3)
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2...)
                    .minimumScaleFactor(0.85)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
    }
}
