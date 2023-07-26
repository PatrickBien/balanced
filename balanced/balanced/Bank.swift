//
//  Bank.swift
//  Saldo Look Pro XY
//
//  Created by Patrick Bien on 27.02.22.
//

import Foundation

struct Transaktion : Identifiable {
    let id = UUID()
    let zweck : String
    let preis : Double
}

class Bank: ObservableObject {
    @Published var saldo = Double()
    @Published var transactions = [Transaktion]()
    
    init(){
        print("opening Spardosn")
        saldo = readSaldoFromFile()
        print("Read from vault \(saldo)")
        
    }
    
    func einzahlen(geld: Double, beschreibung: String) {
        transactions.append(Transaktion(zweck: beschreibung, preis: geld))
    }
    
    func readSaldoFromFile() -> Double {
        do {
            let fileURL = try getFile()
            let saldoAsString = try String(contentsOf: fileURL, encoding: .utf8)
            print("The available Information is \(fileURL) and saldo \(saldoAsString)")
            return Double(saldoAsString)!
            
        } catch {
            print(error)
            print("cannot read file")
            return 0;
        }
    }
    
    func getFile() throws -> URL{
        return try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("saldo.txt")
    }
}


