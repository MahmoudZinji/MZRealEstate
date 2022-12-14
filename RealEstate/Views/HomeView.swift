//
//  HomeView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-07.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit
import LoremSwiftum

struct MyStore {
    var location: CLLocationCoordinate2D
    var lat: Double
    var long: Double
}

struct HomeView: View {

    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager: FirebaseRealEstateManager
    @State private var popupBGColor = Color(#colorLiteral(red: 0.1333310306, green: 0.141177088, blue: 0.1607830822, alpha: 1))
//    @State private var myRealEstates: [RealEstate] = [
//        .init(location: .init(latitude: 25.874972, longitude: 43.496640)),
//        .init(location: .init(latitude: 25.867424, longitude: 43.498050))
//    ]
    @StateObject var locationManager = LocationManager()

    @State private var selectedRealEstate: RealEstate?
    @State private var isShowingProfileView = false
    @State private var isShowingAuthView = false
    @State private var isShowingAddingRealEstateView = false
    @State private var isShowingFilterView = false

    var body: some View {

        NavigationView {
            Map(
                coordinateRegion: $locationManager.region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: $firebaseRealEstateManager.realEstates) { $realEstate in
                    MapAnnotation(coordinate: realEstate.location) {
                        NavigationLink {
                            RealEstateDetailView(realEstate: $realEstate,
                                                 coordinateRegion: locationManager.region)

                            .onDisappear {
                                withAnimation(.spring()) {
                                    locationManager.region.span = realEstate.city.zoomLevel
                                }
                            }
                        } label: {
                            HStack {
                                if !realEstate.images.isEmpty {
                                    WebImage(url: URL(string: realEstate.images.first ?? "" ))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .scaledToFill()
                                        .frame(width: 100, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    Image(systemName: "photo")
                                }
                                Divider()
                                Spacer()


                                VStack(alignment: .leading, spacing: 2) {

                                    HStack {
                                        Text("\(realEstate.price)")
                                        Text("???")
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
                                        HStack {
                                            HStack(spacing: 4){
                                                Image(systemName: "bed.double.fill")
                                                Text("\(realEstate.beds)")
                                            }
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .semibold))
                                            .frame(width: 50, height: 50)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                        }

                                        HStack {
                                            HStack(spacing: 4){
                                                Image(systemName: "shower")
                                                Text("\(realEstate.baths)")
                                            }
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .semibold))
                                            .frame(width: 50, height: 50)
                                            .background(Color.orange)
                                            .cornerRadius(8)
                                        }

                                        HStack {
                                            HStack(spacing: 4){
                                                Image(systemName: "photo.on.rectangle.angled")
                                                Text("\(realEstate.images.count)")
                                            }
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .semibold))
                                            .frame(width: 50, height: 50)
                                            .background(Color.purple)
                                            .cornerRadius(8)
                                        }

                                        HStack {
                                            HStack(spacing: 4){
                                                Image(systemName: "ruler.fill")
                                                Text("\(realEstate.space)")
                                            }
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .semibold))
                                            .frame(width: 50, height: 50)
                                            .background(Color.gray)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .padding(6)
                            .background(popupBGColor.cornerRadius(12))
                            .padding(.bottom, -14)
                        }
                        .foregroundColor(.white)
                        .overlay(
                            Button {
                                withAnimation {
                                    selectedRealEstate = nil
                                }
                            } label: {
                                Image(systemName: "eye.slash")
                                    .foregroundColor(.yellow)
                                    .padding(6)
                            }, alignment: .topTrailing
                        )
                        .scaleEffect(selectedRealEstate == realEstate ? 1 : 0)
                        .opacity(selectedRealEstate == realEstate ? 1 : 0)
                        .animation(.spring(), value: selectedRealEstate == realEstate)

                        Button {
                            withAnimation(.spring()) {
                                selectedRealEstate = realEstate
                                locationManager.region.center = realEstate.location
                            }
                        } label: {
                            HStack {
                                Image(systemName: "info.circle")
                                    .resizable().scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))

                                Text("\(realEstate.price)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .minimumScaleFactor(0.8)
                                    .foregroundColor(.white)

                                Image(systemName: realEstate.type.imageName)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 12)
                            .padding()
                            .background(
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.green)
                                    Triangle()
                                        .fill(Color.green)
                                        .frame(width: 20, height: 20)
                                        .rotationEffect(.init(degrees: 180))
                                }
                            )
                        }
                    }
                }
                .ignoresSafeArea()
                .overlay(
                    userUpperOverlaySection, alignment: .top
                )
                .overlay(
                    mapZoomFilterOverlaySection
                    , alignment: .bottomTrailing
                )
        }
        .sheet(isPresented: $isShowingFilterView) {
            MapFilterView()
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
        }
        .fullScreenCover(isPresented: $isShowingAuthView,
                         onDismiss: firebaseUserManager.fetchUser) {
            AuthView()
        }
        .fullScreenCover(isPresented: $isShowingProfileView) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $isShowingAddingRealEstateView) {
            AddRealEstateView(isShowingAddingRealEstateView: $isShowingAddingRealEstateView)
        }
    }
}

// MARK: -Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
            .preferredColorScheme(.dark)
    }
}

// MARK: -HomeView Extension
extension HomeView {

    private var userImage: some View {
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
            .padding(4)
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 0.5)
            }
    }

    private var userUpperOverlaySection: some View {
        HStack {
            Button {
                if firebaseUserManager.user.id == "" {
                    isShowingAuthView.toggle()
                } else {
                    isShowingProfileView.toggle()
                }
            } label: {
                userImage
                    .padding()
            }
            .padding(.bottom, 8)
            Text(firebaseUserManager.user.username)
            Spacer()

            Button {
                isShowingAddingRealEstateView.toggle()
            } label: {
                Text("Add Real Estate")
            }.padding(.trailing, 12)
        }
        .frame(height: 50)
        .background(Material.ultraThinMaterial)
    }

    private var mapZoomFilterOverlaySection: some View {
        VStack(spacing: 18) {
            Button {
                withAnimation(.spring(blendDuration: 1.5)) {
                    if let center = locationManager.userLocation?.coordinate {
                        locationManager.region.center = center
                    }
                }
            } label: {
                Image(systemName: "scope")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
            }

            Divider()

            Button {

            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
            }
        }.frame(width: 50, height: 120)
            .background(Material.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.6), lineWidth: 0.5)
            )
            .padding()
    }
}
