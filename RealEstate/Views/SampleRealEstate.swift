//
//  SampleRealEstate.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-20.
//

import SwiftUI
import LoremSwiftum
import MapKit
import AVKit
import SDWebImageSwiftUI

struct SampleRealEstate: View {
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager: FirebaseRealEstateManager
    @State private var phoneBgColor = Color(#colorLiteral(red: 0, green: 0.5647153854, blue: 0.3137319386, alpha: 1))
    @State private var selectedMediaType: MediaType = .Photos
    @Binding var realEstate: RealEstate
    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var images: [UIImage]
    @Binding var videoUrl: URL?
    @Binding var isShowingAddingRealEstateView: Bool
    @State private var isLoading: Bool = false

    var body: some View {
        ScrollView {

            Picker(selection: $selectedMediaType) {
                ForEach(MediaType.allCases, id: \.self) { mediaType in
                    Text(mediaType.title)
                }
            } label: {
            }.labelsHidden()
                .pickerStyle(.segmented)


            switch selectedMediaType {
            case .Photos:
                if !images.isEmpty {
                    TabView {
                        ForEach(images, id: \.self) { uiImage in
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 20,
                                       height: 340)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .offset(y: -20)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 400)
                    .overlay(
                        VStack {
                            HStack {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("\(images.count)")
                                }.padding(8)
                                    .background(Material.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Spacer()
                                Image(systemName: "bookmark")
                                    .padding(8)
                                    .background(Material.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            Spacer()
                            HStack {
                                HStack {
                                    Image(systemName: realEstate.saleCategory.imageName)
                                    Text(realEstate.saleCategory.title)
                                }.padding(8)
                                    .background(Material.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Spacer()
                                Text("\(realEstate.price)")
                                    .padding(8)
                                    .background(Material.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }.padding()
                            .padding(.bottom, 40)
                    )
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .opacity(0.4)
                        .padding(.vertical, 18)
                }
            case .Videos:
                if let videoUrl {
                    VideoPlayer(player: AVPlayer(url: URL(string: realEstate.videoUrlString)!))
                        .frame(width: UIScreen.main.bounds.width - 20,
                               height: 340)
                } else {
                    Image(systemName: "play.slash")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .padding(.vertical, 18)
                }
            }

            GroupedView(realEstate: $realEstate)

            VStack(alignment: .leading) {
                HStack {
                    Text("Location")
                        .foregroundColor(.orange)
                        .font(.title)
                    Spacer()
                }

                Map(coordinateRegion: $coordinateRegion, annotationItems: [realEstate]) { realEstate in
                    MapAnnotation(coordinate: realEstate.location) {
                        HStack {
                            Image(systemName: "info.circle")
                                .resizable().scaledToFill()
                                .frame(width: 20, height: 20)
                                .font(.system(size: 14, weight: .bold, design: .rounded))

                            Text("100000 SEK")
                                .font(.system(size: 18, weight: .semibold))
                                .minimumScaleFactor(0.8)
                                .foregroundColor(.white)

                            Image(systemName: "info.circle")
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
                }.frame(width: UIScreen.main.bounds.width - 50, height: 240)
                    .cornerRadius(12)
                    .onAppear {
                        coordinateRegion.center    = realEstate.location
                        coordinateRegion.span      = realEstate.city.extraZoomLevel
                    }
            }

            Divider()

            VStack(alignment: .leading) {

                HStack {
                    VStack {
                        WebImage(url: URL(string: firebaseUserManager.user.profileImageUrl))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                            .padding(2)
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                            }

                        Text(firebaseUserManager.user.username)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Button {

                            } label: {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text(firebaseUserManager.user.email)
                                }
                                .foregroundColor(.white)
                                .frame(width: 155, height: 34)
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
                                .frame(width: 155, height: 34)
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
                            .frame(width: 320, height: 34)
                            .background(phoneBgColor.cornerRadius(5))
                        }
                        .buttonStyle(.borderless)
                    }.padding(.leading, 6)
                }

                ForEach(firebaseUserManager.user.dayTimeAvailability, id: \.self) { dayTimeSelection in
                    HStack {
                        Text(dayTimeSelection.day.title)
                        Spacer()
                        Text(dayTimeSelection.fromTime.convertDate(formattedString: .timeOnly))
                        Text("-")
                        Text(dayTimeSelection.toTime.convertDate(formattedString: .timeOnly))
                    }
                    Divider()
                }
            }.padding(.horizontal, 4)
                .padding(.top, 8)

            Button {
                isLoading.toggle()
                guard let videoUrl = videoUrl else { return }
                realEstate.ownerId = firebaseUserManager.user.id
                firebaseRealEstateManager.addRealEstate(
                    realEstate: realEstate,
                    images: images,
                    videoUrl: videoUrl) { isSuccess in
                        isLoading.toggle()
                        if isSuccess {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.isShowingAddingRealEstateView = false
                            }
                        }
                    }
            } label: {
                Text("Uplaod my Real Estate")
                    .foregroundColor(.white)
                    .frame(width: 280, height: 48)
                    .background(Color.blue.cornerRadius(8))
            }
        }
        .overlay {
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
        .navigationTitle("Title")
    }
}

struct SampleRealEstate_Previews: PreviewProvider {
    static var previews: some View {
        SampleRealEstate(
            realEstate: .constant(realEstateSample),
            coordinateRegion: .constant(.init(
                center: realEstateSample.location,
                span: realEstateSample.city.zoomLevel)),
            images: .constant([UIImage(named: "Image 1")!, UIImage(named: "Image 2")!, UIImage(named: "Image 3")!, UIImage(named: "Image 4")!, UIImage(named: "Image 5")!, UIImage(named: "Image 6")!,]),
            videoUrl: .constant(nil),
            isShowingAddingRealEstateView: .constant(false)
        ).preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
    }
}
