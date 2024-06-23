//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Josue Cruz on 6/23/23.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            VStack (spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)
                
                HStack {
                    AddressView(address: viewModel.location.address)
                    Spacer()
                }
                .padding(.horizontal)
                
                DescriptionView(text: viewModel.location.description)
                
                ZStack {
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    
                    HStack(spacing: 20) {
                        Button {
                            viewModel.getDirectionsToLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        .accessibilityLabel(Text("Get directions"))
                        
                        Link(destination: URL(string: viewModel.location.websiteURL)!, label:  {
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        })
                        .accessibilityRemoveTraits(.isButton)
                        .accessibilityLabel(Text("Go to website"))
                        
                        Button {
                            viewModel.callLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                                .accessibilityLabel(Text("Call location"))
                        }
                        if let _ = CloudKitManager.shared.profileRecordID {
                            Button {
                                viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkOut : .checkIn)
                                playHaptic()
                            } label: {
                                LocationActionButton(color: viewModel.isCheckedIn ? .grubRed : .brandPrimary,
                                                     imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark")
                                .accessibilityLabel(Text(viewModel.isCheckedIn ? "Check out of location" : "Check into location"))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Text("Who's Here?")
                    .bold()
                    .font(.title2)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(Text("Who's here? \(viewModel.checkedInProfiles.count) checked in"))
                    .accessibilityHint("bottom section is scrollable")
                
                ZStack {
                    if viewModel.checkedInProfiles.isEmpty {
                        Text("Nobody's Here 😶‍🌫️")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(viewModel.checkedInProfiles) { profile in
                                    firstNameAvatarView(profile: profile)
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityAddTraits(.isButton)
                                        .accessibilityLabel(Text("Show's \(profile.firstName) profile pop up."))
                                        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.selectedProfile = profile
                                            }
                                        }
                                }
                            }
                        }
                    }
                    if viewModel.isLoading { LoadingView() }
                }
                Spacer()
            }
            .accessibilityHidden(viewModel.isShowingProfileModal)
            
            if viewModel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: viewModel.selectedProfile!)
                    .transition(.opacity.combined(with: .slide))
                    .zIndex(1)
            }
        }
        
        .onAppear {
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
        
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
    }
}

struct BannerImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}

struct AddressView: View {
    var address: String
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DescriptionView: View {
    var text: String
    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}

struct LocationActionButton: View {
    var color: Color
    var imageName: String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
        }
        .foregroundColor(.white)
    }
}

struct firstNameAvatarView: View {
    var profile: DDGProfile
    var body: some View {
        VStack {
            AvatarView(image: profile.avatarImage, size: 64)
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}
