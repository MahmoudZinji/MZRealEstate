//
//  BookMarkedRealEstateView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookMarkedRealEstateView: View {
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager: FirebaseRealEstateManager
    @State private var isShowingConfirmationDialogue: Bool = false
    @State private var selectedRealEstate: RealEstate?

    var body: some View {
        ScrollView {
            ForEach($firebaseRealEstateManager.bookmarkedRealEstates) { $realEstate in
                NavigationLink {
                    RealEstateDetailView(realEstate: $realEstate)
                } label: {
                    HStack {
                        WebImage(url: URL(string: realEstate.images.first ?? "" ))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(width: 100, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Divider()

                        VStack(alignment: .leading, spacing: 2) {

                            HStack {
                                Text("\(realEstate.price)")
                                Text("•")
                                HStack(spacing: 4){
                                    Image(systemName: realEstate.saleCategory.imageName)
                                    Text(realEstate.saleCategory.title)
                                }
                                .foregroundColor(.cyan)
                                .font(.system(size: 12, weight: .semibold))
                            }

                            Text(realEstate.description)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 2)
                                .multilineTextAlignment(.leading)

                            HStack(spacing: 4){
                                Image(systemName: realEstate.type.imageName)
                                Text(realEstate.type.title)
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))

                            Divider()

                            HStack {
                                HStack(spacing: 4){
                                    Image(systemName: "bed.double.fill")
                                    Text("\(realEstate.beds)")
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 60, height: 28)
                                .background(Color.blue)
                                .cornerRadius(8)


                                HStack(spacing: 4){
                                    Image(systemName: "shower")
                                    Text("\(realEstate.baths)")
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 60, height: 28)
                                .background(Color.orange)
                                .cornerRadius(8)



                                HStack(spacing: 4){
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("\(realEstate.images.count)")
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 60, height: 28)
                                .background(Color.purple)
                                .cornerRadius(8)


                                HStack(spacing: 4){
                                    Image(systemName: "ruler.fill")
                                    Text("\(realEstate.space)")
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 60, height: 28)
                                .background(Color.gray)
                                .cornerRadius(8)

                            }

                        }
                        Spacer()

                        Image(systemName: "chevron.right")
                            .opacity(0.6)
                            .padding(.trailing, 8)

                    }
                }.foregroundColor(Color(.label))
                    .overlay(
                        Button {
                            selectedRealEstate = realEstate
                            isShowingConfirmationDialogue.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "bookmark")
                                Text("Remove")
                            }.font(.system(size: 14))
                            .foregroundColor(.red)
                        }
                        , alignment: .topTrailing
                    )

                Divider()
                    .padding(.vertical, 8)
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingConfirmationDialogue, actions: {
            Button {
                if let selectedRealEstate {
                    firebaseRealEstateManager.removeRealEstateFromBookmarks(realEstate: selectedRealEstate)
                }
            } label: {
                Text("Yes, Remove It")
            }
        }, message: {
            if let selectedRealEstate {
                Text("Are you sure you want to remove the unit with price of \(selectedRealEstate.price)")
            }
        })
        .navigationTitle("My Real Estate")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookMarkedRealEstateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookMarkedRealEstateView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(FirebaseUserManager())
        .environmentObject(FirebaseRealEstateManager())
    }
}
