//
//  MapFilterView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-29.
//

import SwiftUI

struct MapFilterView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var firebaseUserManager: FirebaseUserManager
    @EnvironmentObject var firebaseRealEstateManager: FirebaseRealEstateManager
    @State private var backgroundColor: Color = Color(#colorLiteral(red: 0.1058823541, green: 0.1058823541, blue: 0.1058823541, alpha: 1))
    @State private var selectedCity: City = .arrass
    @State private var realEstateType: RealEstateType = .apartment

    @State var numberOfspace: Int = 0
    @State var numberOfbaths: Int = 0
    @State var numberOfrooms: Int = 0
    @State var numberOfbedrooms: Int = 0
    @State var numberOfovens: Int = 0
    @State var numberOffridges: Int = 0
    @State var numberOfairconditions: Int = 0
    @State var numberOfmicros: Int = 0

    @State var isSmart: Bool = false
    @State var hasWifi: Bool = false
    @State var hasPool: Bool = false
    @State var hasElevator: Bool = false
    @State var buildingAge: Int = 0
    @State var hasGym: Bool = false

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {

                VStack {
                    HStack {
                        Text("Location")
                            .foregroundColor(.yellow)
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    HStack {
                        Text("City: ")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            ForEach(City.allCases, id: \.self) { city in
                                Button {
                                    selectedCity = city
                                } label: {
                                    Text("(\(firebaseRealEstateManager.realEstates.filter{$0.city == city}.count)) ") +
                                    Text(city.title)
                                }

                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("(\(firebaseRealEstateManager.realEstates.filter{$0.city == selectedCity}.count))")
                                Text(selectedCity.title)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.white)
                            .frame(width: 140, alignment: .trailing)
                        }
                    }.padding(.horizontal, 10)
                }.padding(.horizontal, 8)

                Divider()

                VStack {
                    HStack {
                        Text("Type")
                            .foregroundColor(.yellow)
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    HStack {
                        Text("Category: ")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            ForEach(RealEstateType.allCases, id: \.self) { type in
                                Button {
                                    realEstateType = type
                                } label: {
                                    HStack {
                                        Text("(\(firebaseRealEstateManager.realEstates.filter{$0.type == type}.count)) ")
                                        Text(realEstateType.title)
                                        Image(systemName: realEstateType.imageName)
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("(\(firebaseRealEstateManager.realEstates.filter{$0.type == realEstateType}.count)")
                                Text(realEstateType.title)
                                Image(systemName: realEstateType.imageName)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.white)
                            .frame(width: 180, alignment: .trailing)
                        }
                    }.padding(.horizontal, 10)
                }.padding(.horizontal, 8)

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
                                    numberOfbedrooms = beds
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
                                    Text("Beds: \(numberOfbedrooms)")
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
                                    numberOfbaths = baths
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
                                    Text("Baths: \(numberOfbaths)")
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
                                    numberOfrooms = livingRooms
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
                                    Text("Rooms: \(numberOfrooms)")
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
                                    numberOfspace = spaces
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
                                    Text("Area: \(numberOfspace)")
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
                                    numberOfovens = ovens
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
                                    Text("Ovens: \(numberOfovens)")
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
                                    numberOffridges = fridges
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
                                    Text("Fridges: \(numberOffridges)")
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
                                    numberOfmicros = microwaves
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
                                    Text("Micro: \(numberOfmicros)")
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
                                    numberOfairconditions = airConditions
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
                                    Text("AC: \(numberOfairconditions)")
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

                VStack(alignment: .leading) {
                    HStack {
                        Text("Amentities")
                            .foregroundColor(.orange)
                            .font(.title)
                        Spacer()
                    }

                    HStack(spacing: 8){

                        Button {
                            isSmart.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 2) {
                                Image(systemName: "entry.lever.keypad.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)

                                Text("Smart")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.top, 8)

                                Image(systemName: isSmart ? "checmark.square.fill" : "square")
                                    .foregroundColor(isSmart ? .green : .white)
                                    .padding(.top, 4)
                            }.frame(width: 60)
                                .foregroundColor(.white)
                        }.buttonStyle(.borderless)


                        Divider()

                        Button {
                            hasWifi.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 2) {
                                Image(systemName: "wifi")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)

                                Text("Wifi")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.top, 8)

                                Image(systemName: hasWifi ? "checmark.square.fill" : "square")
                                    .foregroundColor(hasWifi ? .green : .white)
                                    .padding(.top, 4)
                            }.frame(width: 60)
                                .foregroundColor(.white)
                        }.buttonStyle(.borderless)

                        Divider()

                        Button {
                            hasPool.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 2) {
                                Image(systemName: "figure.pool.swim")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)

                                Text("Pool")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.top, 8)

                                Image(systemName: hasPool ? "checmark.square.fill" : "square")
                                    .foregroundColor(hasPool ? .green : .white)
                                    .padding(.top, 4)
                            }.frame(width: 60)
                                .foregroundColor(.white)
                        }.buttonStyle(.borderless)

                        Divider()

                        Button {
                            hasElevator.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 2) {
                                Image(systemName: "figure.walk.arrival")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)

                                Text("Elevator")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.top, 8)

                                Image(systemName: hasElevator ? "checmark.square.fill" : "square")
                                    .foregroundColor(hasElevator ? .green : .white)
                                    .padding(.top, 4)
                            }.frame(width: 60)
                                .foregroundColor(.white)
                        }.buttonStyle(.borderless)

                        Divider()

                        Button {
                            hasGym.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 2) {
                                Image(systemName: "dumbbell.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)

                                Text("Gym")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.top, 8)

                                Image(systemName: hasGym ? "checmark.square.fill" : "square")
                                    .foregroundColor(hasGym ? .green : .white)
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
                                    buildingAge = age
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
                                    Text("\(buildingAge) Years")
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

                }.padding(.horizontal, 8)

                Button {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                        firebaseRealEstateManager.realEstates = filteredRealEstates
                    }
                } label: {
                    Text("Apply for (\(filteredRealEstates.count))")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(#colorLiteral(red: 0, green: 0.3294245005, blue: 0.5803793669, alpha: 1)))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }.padding(.top, 18)


                HStack {
                    Spacer()
                }
            }
            .background(backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
        }.overlay {
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

    var filteredRealEstates: [RealEstate] {
        firebaseRealEstateManager.realEstates
            .filter {
                $0.city == selectedCity
                && $0.type == realEstateType
            }

            .filter {
                $0.beds >= numberOfbedrooms
                && $0.baths >= numberOfbaths
            }

            .filter {
                $0.hasGym == hasGym
                || $0.hasPool == hasPool
                || $0.isSmart == isSmart
                || $0.hasElevator == hasElevator
                || $0.hasWiFi == hasWifi
            }

            .filter {
                $0.age >= buildingAge
            }
    }
}

struct MapFilterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseUserManager())
            .environmentObject(FirebaseRealEstateManager())
    }
}
