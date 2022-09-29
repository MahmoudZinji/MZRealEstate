//
//  MyRealEstateView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyRealEstateView: View {

    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager: FirebaseRealEstateManager

    var body: some View {
        ScrollView {
            ForEach($firebaseRealEstateManager.myRealEstates) { $realEstate in
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
                                    Text("\(realEstate.bed)")
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
                        Menu {
                            ForEach(SaleCategory.allCases, id: \.self) { saleCategory in
                                Button {
                                    switch saleCategory {
                                    case .investment:
                                        realEstate.saleCategory = .investment
                                    case .rent:
                                        realEstate.saleCategory = .rent
                                    case .sale:
                                        realEstate.saleCategory = .sale
                                    }
                                    if realEstate.isAvailable {
                                        realEstate.isAvailable = false
                                        firebaseRealEstateManager.markRealEstateAs(realEstate: realEstate)
                                    } else {
                                        realEstate.isAvailable = true
                                        firebaseRealEstateManager.reAddRealEstate(realEstate: realEstate)
                                    }
                                } label: {
                                    switch realEstate.saleCategory {
                                    case .investment:
                                        if realEstate.isAvailable {
                                            Label("Mark as \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        } else {
                                            Label("Offer for \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        }
                                    case .rent:
                                        if realEstate.isAvailable {
                                            Label("Mark as \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        } else {
                                            Label("Offer for \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        }
                                    case .sale:
                                        if realEstate.isAvailable {
                                            Label("Mark as \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        } else {
                                            Label("Offer for \(saleCategory.markedTitle)", systemImage: saleCategory.imageName)
                                        }
                                    }

                                }
                            }

                            Divider()

                            Button(role: .destructive) {

                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        , alignment: .topTrailing
                    )

                    .overlay(
                        Text(realEstate.saleCategory.markedTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .frame(width: 380, height: 50)
                            .background(realEstate.saleCategory.saleColor.opacity(0.8))
                            .cornerRadius(12)
                            .rotationEffect(.init(degrees: -10))
                            .isHidden(realEstate.isAvailable, remove: realEstate.isAvailable)
                        , alignment: .leading
                    )

                Divider()
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("My Real Estate")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyRealEstateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyRealEstateView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(FirebaseUserManager())
        .environmentObject(FirebaseRealEstateManager())
    }
}
