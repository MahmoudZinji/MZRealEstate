//
//  AddRealEstateView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-16.
//

import SwiftUI
import PhotosUI
import AVKit
import MapKit
import LoremSwiftum

class AddRealEstateViewModel: ObservableObject {
    @Published var realEstate = RealEstate()
    @Published var images: [UIImage] = []
    @Published var selection: [PhotosPickerItem] = []
    @Published var isShowingVideoPicker: Bool = false
    @Published var videoUrl: URL?
    @Published var refreshMapViewId = UUID()
    @Published var coordinateRegion: MKCoordinateRegion = .init(center: .init(latitude: 0.0,longitude: 0.0),
                                                                span: .init(latitudeDelta: 0.0, longitudeDelta: 0.0))
}

struct AddRealEstateView: View {

    @State private var phoneBgColor = Color(#colorLiteral(red: 0, green: 0.5647153854, blue: 0.3137319386, alpha: 1))
    @StateObject var viewModel = AddRealEstateViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State var dayTimeSelection: [DayTimeSelection] = [
        .init(day: .monday, fromTime: Date(), toTime: Date()),
        .init(day: .tuesday, fromTime: Date(), toTime: Date()),
        .init(day: .wednesday, fromTime: Date(), toTime: Date()),
        .init(day: .thursday, fromTime: Date(), toTime: Date()),
        .init(day: .friday, fromTime: Date(), toTime: Date())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    AddRealEstateUpperView(viewModel: viewModel)

                    VStack {

                        HStack {
                            Text("Price: ")
                                .foregroundColor(.yellow)
                            Spacer()
                        }.padding(.horizontal, 4)

                        HStack {
                            Text("Amount: ")
                            TextField("0.0", value: $viewModel.realEstate.price, format: .number)

                        }.padding(.horizontal, 4)
                    }.padding(.horizontal, 4)

                    Divider()

                    VStack {

                        HStack {
                            Text("Photos: ")
                                .foregroundColor(.yellow)
                            Spacer()
                        }

                        LazyVGrid(columns: [GridItem.init(.adaptive(minimum: 140))]) {
                            ForEach(viewModel.images, id: \.self) { image in
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 180)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                    Button {
                                        withAnimation(.spring()) {
                                            if let deletePhotoIndex = viewModel.images.firstIndex(of: image) {
                                                viewModel.images.remove(at: deletePhotoIndex)
                                            }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .foregroundColor(.red)
                                            .frame(width: 160, height: 40)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.red, lineWidth: 0.8)
                                            )
                                    }

                                }.padding(.vertical, 8)
                            }

                            PhotosPicker(selection: $viewModel.selection,
                                         maxSelectionCount: 6,
                                         matching: .images,
                                         preferredItemEncoding: .automatic) {
                                VStack {
                                    VStack {
                                        Image(systemName: viewModel.images.count == 0 ? "icloud.and.arrow.up" : "plus")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                        Label(viewModel.images.count == 0 ? "Upload" : "Add More", systemImage: "photo.stack")
                                    }
                                    .frame(width: 180, height: 180)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                    )

                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color.clear)
                                        .frame(width: 160, height: 40)
                                }
                            }.onChange(of: viewModel.selection) { _ in
                                for item in viewModel.selection {
                                    Task {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            guard let uiImage = UIImage(data: data) else { return }
                                                viewModel.images.append(uiImage)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 4)

                    Divider()

                    VStack {
                        HStack {
                            Text("Video: ")
                                .foregroundColor(.yellow)
                            Spacer()
                        }

                        if let videoUrl = viewModel.videoUrl {
                            VideoPlayer(player: AVPlayer(url: videoUrl))
                                .frame(width: UIScreen.main.bounds.width - 50, height: 140)
                        }

                        if viewModel.videoUrl != nil {
                            Button {
                                withAnimation(.spring()) {
                                    viewModel.videoUrl = nil
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .foregroundColor(.red)
                                    .frame(width: 160, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.red, lineWidth: 0.8)
                                    )
                            }
                        }

                        Button {
                            viewModel.isShowingVideoPicker.toggle()
                        } label: {
                            VStack {
                                Image(systemName: "icloud.and.arrow.up")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)

                                Label("Upload", systemImage: "play.circle")
                            }.isHidden(viewModel.videoUrl != nil, remove: viewModel.videoUrl != nil)
                            .frame(width: UIScreen.main.bounds.width - 50, height: 140)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            )
                        }.mediaImporter(isPresented: $viewModel.isShowingVideoPicker, allowedMediaTypes: .videos) { result in
                            switch result {
                            case .success(let videoUrl):
                                DispatchQueue.main.async {
                                    self.viewModel.videoUrl = videoUrl
                                }
                            case .failure(let error):
                                print("DEBUG: Failed uploading a video \(error)")
                            }
                        }
                    }.padding(.horizontal, 4)

                    Divider()

                    VStack(alignment: .center) {
                        HStack {
                            Text("Appliances")
                                .foregroundColor(.orange)
                                .font(.title)
                            Spacer()
                        }

                        HStack(spacing: 12){

                            Menu {
                                ForEach(0...10, id: \.self) { beds in
                                    Button {
                                        viewModel.realEstate.beds = beds
                                    } label:  {
                                        switch beds {
                                        case 0,1:
                                            Text("\(beds) Bed")
                                        default:
                                            Text("\(beds) Beds")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "bed.double.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Beds: \(viewModel.realEstate.beds)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach(0...10, id: \.self) { baths in
                                    Button {
                                        viewModel.realEstate.baths = baths
                                    } label:  {
                                        switch baths {
                                        case 0,1:
                                            Text("\(baths) bath")
                                        default:
                                            Text("\(baths) Baths")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "shower.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Baths: \(viewModel.realEstate.baths)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.orange)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach(0...10, id: \.self) { livingRooms in
                                    Button {
                                        viewModel.realEstate.livingRooms = livingRooms
                                    } label:  {
                                        switch livingRooms {
                                        case 0,1:
                                            Text("\(livingRooms) livingRoom")
                                        default:
                                            Text("\(livingRooms) livingRooms")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "sofa.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Rooms: \(viewModel.realEstate.livingRooms)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.purple)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach((50...2000).filter{$0.isMultiple(of: 50)}, id: \.self) { spaces in
                                    Button {
                                        viewModel.realEstate.space = spaces
                                    } label:  {
                                        switch spaces {
                                        case 0,1:
                                            Text("\(spaces) space")
                                        default:
                                            Text("\(spaces) spaces")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "ruler.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Area: \(viewModel.realEstate.space)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.gray)
                                .cornerRadius(8)
                            }
                        }

                        HStack(spacing: 12){

                            Menu {
                                ForEach(0...10, id: \.self) { ovens in
                                    Button {
                                        viewModel.realEstate.ovens = ovens
                                    } label:  {
                                        switch ovens {
                                        case 0,1:
                                            Text("\(ovens) oven")
                                        default:
                                            Text("\(ovens) ovens")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "cooktop.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Ovens: \(viewModel.realEstate.ovens)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.green)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach(0...10, id: \.self) { fridges in
                                    Button {
                                        viewModel.realEstate.fridges = fridges
                                    } label:  {
                                        switch fridges {
                                        case 0,1:
                                            Text("\(fridges) fridge")
                                        default:
                                            Text("\(fridges) fridges")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "refrigerator.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Fridges: \(viewModel.realEstate.fridges)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.pink)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach(0...10, id: \.self) { microwaves in
                                    Button {
                                        viewModel.realEstate.microwaves = microwaves
                                    } label:  {
                                        switch microwaves {
                                        case 0,1:
                                            Text("\(microwaves) microwave")
                                        default:
                                            Text("\(microwaves) microwaves")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "microwave.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("Micro: \(viewModel.realEstate.microwaves)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.brown)
                                .cornerRadius(8)
                            }

                            Menu {
                                ForEach(0...10, id: \.self) { airConditions in
                                    Button {
                                        viewModel.realEstate.airConditions = airConditions
                                    } label:  {
                                        switch airConditions {
                                        case 0,1:
                                            Text("\(airConditions) AC")
                                        default:
                                            Text("\(airConditions) ACs")
                                        }
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "air.conditioner.horizontal.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.down")
                                        Text("AC: \(viewModel.realEstate.airConditions)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.indigo)
                                .cornerRadius(8)
                            }
                        }
                    }.padding(.horizontal, 4)

                    Divider()

                    VStack {
                        HStack {
                            Text("Info: ")
                                .foregroundColor(.yellow)
                            Spacer()
                        }

                        TextField("Type Here", text: $viewModel.realEstate.description, axis: .vertical)
                            .padding()
                            .frame(minHeight: 80, alignment: .topLeading)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 0.2)
                            }
                    }.padding(.horizontal, 8)
                }
                Divider()

                AmentitiesAddRealEstateView(viewModel: viewModel)

                Divider()
                Group {

                    MapUIKitView(realEstate: $viewModel.realEstate)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                        .cornerRadius(12)
                        .id(self.viewModel.refreshMapViewId)
                        .overlay(
                            Image(systemName:"mappin.and.ellipse")
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle()), alignment: .center
                        ).onChange(of: viewModel.realEstate
                            .city) { _ in
                                self.viewModel.refreshMapViewId = UUID()
                            }
                    HStack {
                        Text("Lat: \(viewModel.realEstate.location.latitude)")
                        Text(" - ")
                        Text("Long: \(viewModel.realEstate.location.longitude)")
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

                    }.padding(.horizontal, 12)
                }

                NavigationLink {
                    SampleRealEstate(realEstate: $viewModel.realEstate,
                                     coordinateRegion: $viewModel.coordinateRegion,
                                     images: $viewModel.images,
                                     videoUrl: $viewModel.videoUrl)
                } label: {
                    Text("Show Sample Before Upload")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 48)
                        .background(Color.blue.cornerRadisu(8))
                        .padding()
                }.padding()


            }
            .navigationTitle("Add Real Estate")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct AddRealEstateView_Previews: PreviewProvider {
    static var previews: some View {
        AddRealEstateView()
            .preferredColorScheme(.dark)
    }
}

struct AddRealEstateUpperView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        AddLocationView(viewModel: viewModel)
        Divider()
        AddTypeView(viewModel: viewModel)
        Divider()
        AddSaleView(viewModel: viewModel)
        Divider()
        AddSalesView(viewModel: viewModel)
        Divider()
    }
}

struct AddLocationView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        VStack {

            HStack {
                Text("Location: ")
                    .foregroundColor(.yellow)
                Spacer()
            }.padding(.horizontal, 4)

            HStack {
                Text("City: ")
                Spacer()
                Menu {
                    ForEach(City.allCases, id: \.self) { city  in
                        Button {
                            viewModel.realEstate.city = city
                        } label: {
                            Text(city.title)
                        }

                    }
                } label: {
                    HStack {
                        Text(viewModel.realEstate.city.title)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                }

            }.padding(.horizontal, 4)
        }.padding(.horizontal, 4)
    }
}

struct AddTypeView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        VStack {

            HStack {
                Text("Type: ")
                    .foregroundColor(.yellow)
                Spacer()
            }.padding(.horizontal, 4)

            HStack {
                Text("Category: ")
                Spacer()
                Menu {
                    ForEach(RealEstateType.allCases, id: \.self) { realEstateType  in
                        Button {
                            viewModel.realEstate.type = realEstateType
                        } label: {
                            Label(realEstateType.title, systemImage: realEstateType.imageName)
                        }

                    }
                } label: {
                    HStack {
                        Text(viewModel.realEstate.type.title)
                        Image(systemName: viewModel.realEstate.type.imageName)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                }

            }.padding(.horizontal, 4)
        }.padding(.horizontal, 4)
    }
}

struct AddSaleView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        VStack {

            HStack {
                Text("Sale: ")
                    .foregroundColor(.yellow)
                Spacer()
            }.padding(.horizontal, 4)

            HStack {
                Text("Offer: ")
                Spacer()
                Menu {
                    ForEach(SaleCategory.allCases, id: \.self) { saleCategory  in
                        Button {
                            viewModel.realEstate.saleCategory = saleCategory
                        } label: {
                            Label(saleCategory.title, systemImage: saleCategory.imageName)
                        }

                    }
                } label: {
                    HStack {
                        Text(viewModel.realEstate.saleCategory.title)
                        Image(systemName: viewModel.realEstate.saleCategory.imageName)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                }

            }.padding(.horizontal, 4)
        }.padding(.horizontal, 4)
    }
}

struct AddSalesView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        VStack {

            HStack {
                Text("Duration: ")
                    .foregroundColor(.yellow)
                Spacer()
            }.padding(.horizontal, 4)

            HStack {
                Text("Time:")
                Spacer()
                Menu {
                    ForEach(OfferType.allCases, id: \.self) { offerType  in
                        Button {
                            viewModel.realEstate.offer = offerType
                        } label: {
                            Text(offerType.title)
                        }

                    }
                } label: {
                    HStack {
                        Text(viewModel.realEstate.offer.title)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                }

            }.padding(.horizontal, 4)
        }.padding(.horizontal, 4)
    }
}

struct AmentitiesAddRealEstateView: View {

    var viewModel: AddRealEstateViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Amentities")
                    .foregroundColor(.orange)
                    .font(.title)
                Spacer()
            }

            HStack(spacing: 8){

                Button {
                    viewModel.realEstate.isSmart.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "entry.lever.keypad.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        Text("Smart")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)

                        Image(systemName: viewModel.realEstate.isSmart ? "checmark.square.fill" : "square")
                            .foregroundColor(viewModel.realEstate.isSmart ? .green : .white)
                            .padding(.top, 4)
                    }.frame(width: 60)
                        .foregroundColor(.white)
                }.buttonStyle(.borderless)


                Divider()

                Button {
                    viewModel.realEstate.hasWiFi.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "wifi")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        Text("Wifi")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)

                        Image(systemName: viewModel.realEstate.hasWiFi ? "checmark.square.fill" : "square")
                            .foregroundColor(viewModel.realEstate.hasWiFi ? .green : .white)
                            .padding(.top, 4)
                    }.frame(width: 60)
                        .foregroundColor(.white)
                }.buttonStyle(.borderless)

                Divider()

                Button {
                    viewModel.realEstate.hasPool.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "figure.pool.swim")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        Text("Pool")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)

                        Image(systemName: viewModel.realEstate.hasPool ? "checmark.square.fill" : "square")
                            .foregroundColor(viewModel.realEstate.hasPool ? .green : .white)
                            .padding(.top, 4)
                    }.frame(width: 60)
                        .foregroundColor(.white)
                }.buttonStyle(.borderless)

                Divider()

                Button {
                    viewModel.realEstate.hasElevator.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "figure.walk.arrival")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        Text("Elevator")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)

                        Image(systemName: viewModel.realEstate.hasElevator ? "checmark.square.fill" : "square")
                            .foregroundColor(viewModel.realEstate.hasElevator ? .green : .white)
                            .padding(.top, 4)
                    }.frame(width: 60)
                        .foregroundColor(.white)
                }.buttonStyle(.borderless)

                Divider()

                Button {
                    viewModel.realEstate.hasGym.toggle()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        Text("Gym")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 8)

                        Image(systemName: viewModel.realEstate.hasGym ? "checmark.square.fill" : "square")
                            .foregroundColor(viewModel.realEstate.hasGym ? .green : .white)
                            .padding(.top, 4)
                    }.frame(width: 60)
                        .foregroundColor(.white)
                }.buttonStyle(.borderless)
            }

            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)

                Menu {
                    ForEach(0...10, id: \.self) { age in
                        Button {
                            viewModel.realEstate.age = age
                        } label: {
                            switch age {
                            case 0,1:
                                Text("\(age) Year")
                            default:
                                Text("\(age) Years")
                            }
                        }
                    }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "building.2.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)

                        HStack(spacing: 2) {
                            Image(systemName: "chevron.down")
                            Text("\(viewModel.realEstate.age) Years")
                                .font(.system(size: 14, weight: .semibold))
                        }.padding(.top, 6)
                    }.padding(.horizontal, 10)
                }.foregroundColor(.white)
                    .padding(.top, 8)


                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }.padding(.top, 16)

        }.padding(.horizontal, 4)
    }
}

// UIViewRepresentable used for UIKit Views
struct MapUIKitView: UIViewRepresentable {

    let mapView = MKMapView()
    @Binding var realEstate: RealEstate

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(.init(center: realEstate.city.coordinate,
                                span: realEstate.city.zoomLevel),
                          animated: true)
        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {

        var parent: MapUIKitView
        var gestureRecognizer = UILongPressGestureRecognizer()

        init(_ parent: MapUIKitView) {
            self.parent = parent
            super.init()
            // if you want to make the user tap and hold to get the location
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.realEstate.location = mapView.centerCoordinate
            print("DEBUG: User Coordinate \(mapView.centerCoordinate) ")
        }
    }
}
