//
//  ProfileView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {

    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @State var phoneBgColor = Color(#colorLiteral(red: 0, green: 0.5647153854, blue: 0.3137319386, alpha: 1))
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                imageTopView
                accountSection
                realEstateSection
                bookmarksSection
                infoSection
                logoutSection
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }.overlay {
            loadingView
        }
    }
}

// MARK: -PreviewProvider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
    }
}

// MARK: -ProfileView Extension
extension ProfileView {

    // MARK: -ImageSection
    private var userImage: some View {
        Button {

        } label: {
            userProfileImage
                .padding(4)
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 0.5)
                }
                .overlay (
                    Image(systemName: "pencil.and.outline")
                        .foregroundColor(.blue)
                    , alignment: .bottomTrailing
                )
        }.buttonStyle(.borderless)
    }

    private var userProfileImage: some View {

        WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
    }

    private var imageTopView: some View {
        Section {
            HStack {
                Spacer()
                userImage
                Spacer()
            }.listRowBackground(Color.clear)
        }
    }

    // MARK: -Account Section
    private var accountSection: some View {
        Section {
            userEmail
            userName
            userNumber
        } header: {
            Text("ACCOUNT INFO")
        } footer: {
            Text("You can update your account information")
        }
    }

    private var userEmail: some View {
        HStack(spacing: 10) {
            Image(systemName: "envelope")
            Text(firebaseUserManager.user.email)
        }
    }

    private var userName: some View {
        NavigationLink {
            UpdateUsernameView(userName: $firebaseUserManager.user.username)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "person")
                Text(firebaseUserManager.user.username)
            }
        }
    }

    private var userNumber: some View {
        NavigationLink {

        } label: {
            HStack(spacing: 10) {
                Image(systemName: "phone")
                Text(firebaseUserManager.user.phoneNumber)
            }
        }
    }

    // MARK: -Real Estate Section
    private var realEstateSection: some View {
        Section {
            myRealEstate
        } header: {
            Text("REAL ESTATE")
        } footer: {
            Text("You can manage your properties at anytime, when you sell,rent or invest")
        }
    }

    private var myRealEstate: some View {
        NavigationLink {

        } label: {
            HStack(spacing: 10) {
                Image(systemName: "building")
                Text("My Real Estate")
            }
        }
    }

    // MARK: -Bookmarks Section
    private var bookmarksSection: some View {
        Section {
            savedRealEstate
        } header: {
            Text("BOOKMARKS")
        } footer: {
            Text("Visit real estates you have booked")
        }
    }

    private var savedRealEstate: some View {
        NavigationLink {

        } label: {
            HStack(spacing: 10) {
                Image(systemName: "bookmark.fill")
                Text("Saved Real Estate")
            }
        }
    }

    // MARK: - Info Section
    private var infoSection: some View {
        Section {
            VStack {
                HStack {
                    VStack {
                        WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                            .padding(2)
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                            }

                        Text(firebaseUserManager.user.username)
                    }

                    VStack {
                        HStack {
                            Button {

                            } label: {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text("Email")
                                }
                                .foregroundColor(.white)
                                .frame(width: 136, height: 34)
                                .background(Color.blue.cornerRadius(5))
                            }
                            .buttonStyle(.borderless)

                            Button {

                            } label: {
                                HStack {
                                    Image(systemName: "bubble.left")
                                    Text("Whatsapp")
                                }
                                .foregroundColor(.white)
                                .frame(width: 136, height: 34)
                                .background(Color.indigo.cornerRadius(5))
                            }
                            .buttonStyle(.borderless)
                        }

                        Button {

                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "phone")
                                Text(firebaseUserManager.user.phoneNumber)
                            }
                            .foregroundColor(.white)
                            .frame(width: 280, height: 34)
                            .background(phoneBgColor.cornerRadius(5))
                        }
                        .buttonStyle(.borderless)
                    }
                }

                ForEach($firebaseUserManager.user.dayTimeAvailability, id: \.self) { $dayTime in
                    HStack {
                        Text(dayTime.day.title)
                        DatePicker("", selection: $dayTime.fromTime, displayedComponents: .hourAndMinute)
                        Text("-").padding(.leading, 12)
                        DatePicker("", selection: $dayTime.toTime, displayedComponents: .hourAndMinute)
                    }
                }

                Divider()

                Button {
                    isLoading.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        firebaseUserManager.updateDayTimeAvailability()
                        isLoading.toggle()
                    }
                } label: {
                    HStack() {
                        Spacer()
                        Text("Update Schedule")
                        Spacer()
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue.cornerRadius(5))
                }.buttonStyle(.borderless)
            }

        } header: {
            Text("INFO SECTION")
        } footer: {
            Text("When people visit your properties, your contact info will be displayed as it shown")
        }
    }

    // MARK: - Logout Section
    private var logoutSection: some View {
        Section {
            Button {
                isLoading.toggle()
                firebaseUserManager.logout { isSuccess in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if isSuccess {
                            isLoading.toggle()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isLoading.toggle()
                        }
                    }
                }
            } label: {
                HStack() {
                    Spacer()
                    Text("Logout")
                    Spacer()
                }
                .foregroundColor(.red)
            }
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(2)

                Text("Please Wait ...")
            }
        }.isHidden(!isLoading, remove: !isLoading)
    }
}
