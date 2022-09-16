//
//  UpdateUsernameView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-14.
//

import SwiftUI

struct UpdateUsernameView: View {

    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @Binding var userName: String
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            TextField("Enter username", text: $userName)
                .modifier(AuthTextFieldModifier())
            Button {
                isLoading.toggle()
                firebaseUserManager.updateUserName(username: userName) { isSuccess in
                    if isSuccess {
                        isLoading.toggle()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isLoading.toggle()
                    }
                }
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue.cornerRadius(5))
            }
        }
        .overlay{
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
}

struct UpdateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUsernameView(userName: .constant("Mahmoud"))
            .environmentObject(FirebaseUserManager())
            .preferredColorScheme(.dark)
    }
}
