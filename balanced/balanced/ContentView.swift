//
//  ContentView.swift
//  Aktueller_Kontostand
//
//  Created by Patrick Bien on 23.01.22.
//
import CoreData
import SwiftUI




struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label

            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            
    }
    
    
}



let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)



struct ContentView: View {
    
    
    
    @State var betrag = 0.0
    @State var ausgabeTextColor = Color.white
    @State var abziehenButtonColor = Color.green
    @State var zweck = ""
    @EnvironmentObject var bank: Bank

    

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        return formatter
    }()
    
    var body: some View {
        
        
        VStack{
            
            
            HStack{
                TextField("Preis +/- €",value: $betrag, formatter: formatter)
                    .padding(.leading, 1.0)
                Image(systemName: "plus.square")
                    .foregroundColor(Color.green.opacity(0.5))
                    .font(.largeTitle)
                
                
                
                Button("hinzufügen") {
                    einzahlen(euro: Double(betrag))
                    
                }
                
                .buttonStyle(GrowingButton())
                .foregroundColor(.white)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                
                
                
//                .buttonBorderShape(.capsule)
//                .tint(abziehenButtonColor)
                
                
                Button ("abziehen") {
                    auszahlen(euro: Double(betrag))
                }
                
                    .foregroundColor(.white)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                    .tint(abziehenButtonColor)
                
                    
                Image(systemName: "creditcard.trianglebadge.exclamationmark")
                    .foregroundColor(Color.red)
                    .onAppear()
                    
                
                Image(systemName: "minus.square")
                    .foregroundColor(Color.green.opacity(0.5))
                    .font(.largeTitle)
            }
            
            //Knopf ohne Funktion nur zur Designseinheitlichkeit ein Knopf
          
            HStack{
                
                Image(systemName: "banknote")
                    .foregroundColor(.green.opacity(0.6))
                    
                
                Button("Der Kontostand beträgt:"){}
                .buttonStyle(.bordered)
                .tint(Color.green)
                .foregroundColor(.white)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .padding(15)
            
                Image(systemName: "banknote")
                    .foregroundColor(.green.opacity(0.6))
                    
                
            
            }
            
            Text("Der aktuelle Kontostand beträgt: \(formatter.string(from:NSNumber(value:bank.saldo))!)")
                .foregroundColor(ausgabeTextColor)
            
            TextField("(Hier den Zweck eingeben)", text: $zweck) {
                
            }
            
            
            
            VStack(alignment: .leading){
                List(bank.transactions) { transaction in
                    HStack {
                        ScrollView{
                            ForEach(0..<1) {_ in
                                Text ("\(transaction.zweck)")
                                    .foregroundColor(Color.green.opacity(0.5)).padding()
                                Text (transaction.preis, format: .currency(code: "EUR"))
                                    .foregroundColor(Color.red)
                                
                            }
                        }
                    }
                }
            }
            
            
        
  /*
           
            Image("Scrooge_McDuck")
                .resizable()
                .opacity(0.1)
                .scaledToFit()
                .background()

     */
            
            VStack {
                
                HStack {
                    
                    
                    
                }
                
            
            
                HStack{
                    
                    Image(systemName: "hand.tap")
                        .foregroundColor(.green.opacity(0.5))
                    
                    Link("2023 codingstudios® by Patrick Bien", destination: URL(string: "https://codingstudios.click")!)
                        .foregroundColor(.green.opacity(0.5))
                        .font(.system(size: 12, weight: .light, design: .serif))
                        .padding()
                    
                    
                    Image(systemName: "cursorarrow.rays")
                        .foregroundColor(.green.opacity(0.5))
                    
                    Image(systemName: "arrow.up.forward.app")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.largeTitle)
                        .padding()
                    
                    }
                }
            }
            
            
        }
        
        
        func einzahlen(euro: Double)  {
            bank.saldo = bank.saldo  + euro
            checkDebt()
           bank.einzahlen(geld: euro, beschreibung: zweck)
            sync()
        }
      
    
    
        func auszahlen(euro: Double)  {
            bank.saldo  = bank.saldo  - euro
            checkDebt()
            bank.einzahlen(geld: euro, beschreibung: zweck )
            sync()
        }
        
        func kontostand() -> Double{
            return Double(bank.saldo )
        }
        
        func checkDebt(){
            if bank.saldo  >= 0 {
                ausgabeTextColor = .green
                abziehenButtonColor = .green
               
            }else {
                ausgabeTextColor = .red
                abziehenButtonColor = .gray
             

                
            }
        }
        func sync() {
            
            let saldoAsString =  String(bank.saldo)
            print(saldoAsString)
            writeSaldoToFile(saldoString: saldoAsString)
        }
        
    func writeSaldoToFile(saldoString: String) {
        do {
            let fileURL = try getFile()
            print("writing to: \(fileURL)")
            try saldoString.write(to:fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("cannot write \(saldoString)")
        }
        
            
        
    }
        
    func getFile() throws -> URL{
        return try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("saldo.txt")
        
        
            
        
        
    }
    
        
    }
    
    
    
    
    
    
    
    
    

