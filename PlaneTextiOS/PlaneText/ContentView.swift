//
//  ContentView.swift
//  PlaneText
//
//  Created by Alex Choi on 05/08/2025.
//

import SwiftUI
import Darwin

func digTXT(domain: String, completion: @escaping ([String]) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        var answer = [UInt8](repeating: 0, count: 1024)
        let len = res_query(domain, ns_c_in, ns_t_txt, &answer, Int32(answer.count))

        guard len > 0 else {
            completion(["Query failed"])
            return
        }

        var msg = ns_msg()
        if ns_initparse(&answer, len, &msg) < 0 {
            completion(["Parse failed"])
            return
        }

        var results: [String] = []
        let count = ns_msg_count(msg, ns_s_an)

        for i in 0..<count {
            var rr = ns_rr()
            if ns_parserr(&msg, ns_s_an, Int32(i), &rr) == 0 {
                let rdata = ns_rr_rdata(rr)
                let txtLength = Int(rdata.pointee)
                let txtData = Data(bytes: rdata.advanced(by: 1), count: txtLength)
                if let txtString = String(data: txtData, encoding: .utf8) {
                    results.append(txtString)
                }
            }
        }

        completion(results)
    }
}

struct ContentView: View {
    @State private var txtRecords: [String] = ["Querying..."]

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("DNS TXT Result:")
                .font(.headline)

            ForEach(txtRecords, id: \.self) { record in
                Text(record)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .onAppear {
            // Replace with your domain
            digTXT(domain: "what-is-an-extreme-day-trip.ch.at") { records in
                DispatchQueue.main.async {
                    txtRecords = records
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
