//
//  AuthView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-06.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

struct AuthView: View {

    @State private var isNewUser: Bool = true
    @State private var email = ""
    @State private var password = ""
    @State private var userName = ""
    @State private var profileImage: UIImage?
    @State private var selection: [PhotosPickerItem] = []
    @State private var isLoading: Bool = false

    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            authMainView
                .animation(.spring(), value: isNewUser)
                .navigationTitle("")
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

// MARK: -Preview
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(FirebaseUserManager())
            .preferredColorScheme(.dark)
    }
}

// MARK: -AuthTextFieldModifier
struct AuthTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 0.5)
            }
            .padding()
    }
}

// MARK: -AuthView Extension
extension AuthView {

    private var authMainView: some View {
        ScrollView {
            headerView
            pickerView
            imagePickerView
            emailTextField
            userNameTextField
            passwordTextField
            authButton
        }
    }

    private var headerView: some View {
        HStack {
            Text("Welcome to \nReal Estate")
                .font(.system(size: 40, weight: .semibold, design: .default))
            Spacer()
        }.padding(.horizontal, 8)
    }

    private var pickerView: some View {
        Picker(selection: $isNewUser) {
            Text("Login")
                .tag(false)
            Text("SignUp")
                .tag(true)
        } label: {
        }.pickerStyle(.segmented)
    }

    private var imagePickerView: some View {
        PhotosPicker(selection: $selection,
                     maxSelectionCount: 1,
                     matching: .images,
                     preferredItemEncoding: .automatic) {
            if let profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 0.5)
                    )
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
            }
        }.padding(.top)
            .onChange(of: selection) { newValue in
                for item in selection {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            profileImage = UIImage(data: data)
                        }
                    }
                }
            }
            .isHidden(!isNewUser, remove: !isNewUser)
    }

    private var emailTextField: some View {
        TextField("Email", text: $email)
            .modifier(AuthTextFieldModifier())
    }

    private var userNameTextField: some View {
        TextField("Username", text: $userName)
            .modifier(AuthTextFieldModifier())
            .isHidden(!isNewUser, remove: !isNewUser)
    }

    private var passwordTextField: some View {
        SecureField("Password", text: $password)
            .modifier(AuthTextFieldModifier())
    }

    private var authButton: some View {
        Button {
            isLoading.toggle()
            guard let location = locationManager.userLocation?.coordinate else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if isNewUser {
                    firebaseUserManager.createNewUser(
                        email: email,
                        password: password,
                        username: userName,
                        profileImage: profileImage,
                        location: location
                    ) { isSuccess in
                            if isSuccess {
                                isLoading.toggle()
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                isLoading.toggle()
                            }
                        }
                } else {
                    firebaseUserManager.logUserIn(email: email, password: password) { isSuccess in
                        if isSuccess {
                            isLoading.toggle()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isLoading.toggle()
                        }
                    }
                }
            }
        } label: {
            Text(isNewUser ? "Sign Up" : "Login")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue.cornerRadius(5))
                .cornerRadius(5)
                .padding()
        }
    }

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
