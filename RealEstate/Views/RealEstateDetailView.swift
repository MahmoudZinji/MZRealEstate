//
//  RealEstateDetailView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-15.
//

import SwiftUI
import LoremSwiftum
import MapKit
import AVKit

enum MediaType: String, CaseIterable {
    case Photos
    case Videos

    var title: String {
        switch self {
        case .Photos:
            return "Photos"
        case .Videos:
            return "Video"
        }
    }
}

struct RealEstateDetailView: View {

    @State private var phoneBgColor = Color(#colorLiteral(red: 0, green: 0.5647153854, blue: 0.3137319386, alpha: 1))
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @Binding var realEstate: RealEstate
    @State private var selectedMediaType: MediaType = .Photos
    @Binding var coordinateRegion: MKCoordinateRegion
    @State var dayTimeSelection: [DayTimeSelection] = [
        .init(day: .monday, fromTime: Date(), toTime: Date()),
        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
        .init(day: .thursday, fromTime: Date(), toTime: Date()),
        .init(day: .friday, fromTime: Date(), toTime: Date())
    ]

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
                TabView {
                    ForEach(realEstate.images, id: \.self) { imageName in
                        Image(imageName)
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
            case .Videos:
                VideoPlayer(player: AVPlayer(url: URL(string: realEstate.videoUrlString)!))
                    .frame(width: UIScreen.main.bounds.width - 20,
                           height: 340)
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
                        Image("people-1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                            .padding(2)
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 0.5)
                            }

                        Text(Lorem.firstName)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Button {

                            } label: {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text("Email")
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
                                Text("46704090609")
                            }
                            .foregroundColor(.white)
                            .frame(width: 320, height: 34)
                            .background(phoneBgColor.cornerRadius(5))
                        }
                        .buttonStyle(.borderless)
                    }.padding(.leading, 6)
                }

                ForEach(dayTimeSelection, id: \.self) { dayTimeSelection in
                    HStack {
                        Text(dayTimeSelection.day.title)
                        Spacer()
                        Text(dayTimeSelection.fromTime.convertDate(formattedString: .timeOnly))
                        Text("-")
                        Text(dayTimeSelection.toTime.convertDate(formattedString: .timeOnly))
                    }
                    Divider()
                }
            }
        }
        .navigationTitle("Title")
    }
}

struct RealEstateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RealEstateDetailView(
                realEstate: .constant(realEstateSample),
                coordinateRegion: .constant(.init(center: City.arrass.coordinate,
                                                span: City.arrass.extraZoomLevel)))
        }
        .environmentObject(FirebaseUserManager())
        .preferredColorScheme(.dark)
    }
}

let realEstateSample: RealEstate = .init(
    images: ["Image 1", "Image 2", "Image 3", "Image 4", "Image 5"],
    description: Lorem.paragraph,
    beds: Int.random(in: 1...4),
    baths: Int.random(in: 1...4),
    livingRooms: Int.random(in: 1...4),
    space: Int.random(in: 1...4),
    ovens: Int.random(in: 1...4),
    fridges: Int.random(in: 1...4),
    microwaves: Int.random(in: 1...4),
    airConditions: Int.random(in: 1...4),
    isSmart: true,
    hasWiFi: true,
    hasPool: true,
    hasElevator: true,
    hasGym: true,
    age: Int.random(in: 1...4),
    location: City.arrass.coordinate,
    saleCategory: .rent,
    city: .arrass,
    type: .apartment,
    offer: .monthly,
    isAvailable: true,
    price: 120000,
    videoUrlString: "https://bit.ly/swswift"
)

struct ApplianceView: View {

    @Binding var realEstate: RealEstate

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Appliances")
                    .foregroundColor(.orange)
                    .font(.title)
                Spacer()
            }

            HStack(spacing: 12){
                VStack {
                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Beds: \(realEstate.beds)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.blue)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "shower.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Baths: \(realEstate.baths)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.orange)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "sofa.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Rooms: \(realEstate.livingRooms)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.purple)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "ruler.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Area: \(realEstate.space)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.gray)
                .cornerRadius(8)
            }

            HStack(spacing: 12){
                VStack {
                    Image(systemName: "cooktop.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Ovens: \(realEstate.ovens)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.green)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "refrigerator.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Fridges: \(realEstate.fridges)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.pink)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "microwave.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("Micro: \(realEstate.microwaves)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.brown)
                .cornerRadius(8)

                VStack {
                    Image(systemName: "air.conditioner.horizontal.fill")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("AC: \(realEstate.airConditions)")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(width: 90, height: 50)
                .background(Color.indigo)
                .cornerRadius(8)
            }
        }.padding(.horizontal, 4)

    }
}

struct AmentitiesView: View {

    @Binding var realEstate: RealEstate

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Amentities")
                    .foregroundColor(.orange)
                    .font(.title)
                Spacer()
            }

            HStack(spacing: 8){

                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "entry.lever.keypad.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("Smart")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 8)

                    Image(systemName: realEstate.isSmart ? "checmark.square.fill" : "xmar.square.fill")
                        .foregroundColor(realEstate.isSmart ? .green : .red)
                        .padding(.top, 4)
                }.frame(width: 60)

                Divider()

                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "wifi")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("Wifi")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 8)

                    Image(systemName: realEstate.hasWiFi ? "checmark.square.fill" : "xmar.square.fill")
                        .foregroundColor(realEstate.hasWiFi ? .green : .red)
                        .padding(.top, 4)
                }.frame(width: 60)

                Divider()

                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "figure.pool.swim")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("Pool")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 8)

                    Image(systemName: realEstate.hasPool ? "checmark.square.fill" : "xmar.square.fill")
                        .foregroundColor(realEstate.hasPool ? .green : .red)
                        .padding(.top, 4)
                }.frame(width: 60)

                Divider()

                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "figure.walk.arrival")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("Elevator")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 8)

                    Image(systemName: realEstate.hasElevator ? "checmark.square.fill" : "xmar.square.fill")
                        .foregroundColor(realEstate.hasElevator ? .green : .red)
                        .padding(.top, 4)
                }.frame(width: 60)

                Divider()

                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "dumbbell.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("Gym")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 8)

                    Image(systemName: realEstate.hasGym ? "checmark.square.fill" : "xmar.square.fill")
                        .foregroundColor(realEstate.hasGym ? .green : .red)
                        .padding(.top, 4)
                }.frame(width: 60)
            }

            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)

                VStack(spacing: 2) {
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)

                    Text("\(realEstate.age) Years")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.top, 6)
                }.padding(.horizontal, 10)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }.padding(.top, 16)

        }.padding(.horizontal, 4)
    }
}

struct InfoView: View {

    @Binding var realEstate: RealEstate

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Info")
                    .foregroundColor(.orange)
                    .font(.title)
                Spacer()
            }
            Text(realEstate.description)
                .font(.system(size: 16, weight: .semibold))
                .multilineTextAlignment(.leading)
                .padding(.leading, 4)
        }.padding(.horizontal, 4)
    }
}

struct GroupedView: View {

    @Binding var realEstate: RealEstate

    var body: some View {
        Divider()

        InfoView(realEstate: $realEstate)

        Divider()

        ApplianceView(realEstate: $realEstate)

        Divider()

        AmentitiesView(realEstate: $realEstate)

        Divider()
    }
}
