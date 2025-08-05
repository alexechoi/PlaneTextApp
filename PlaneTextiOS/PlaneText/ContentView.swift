//
//  ContentView.swift
//  PlaneText
//
//  Created by Alex Choi on 05/08/2025.
//

import SwiftUI
import Foundation
import Network

func digTXT(domain: String, completion: @escaping ([String]) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        // For now, simulate the DNS TXT query with a mock response
        // This is a placeholder since low-level DNS resolver functions aren't available
        
        // Simulate network delay
        Thread.sleep(forTimeInterval: 1.0)
        
        // Mock response for testing - replace with actual DNS query implementation
        let mockResults = [
            "Testing DNS TXT query for domain: \(domain)",
            "This is a simulated response",
            "Replace with actual DNS implementation"
        ]
        
        DispatchQueue.main.async {
            completion(mockResults)
        }
    }
}

struct ContentView: View {
    @State private var txtRecords: [String] = ["Tap button to query..."]
    @State private var isQuerying = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("DNS TXT Query Test")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Domain: what-is-an-extreme-day-trip.ch.at")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button(action: {
                performDNSQuery()
            }) {
                HStack {
                    if isQuerying {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    Text(isQuerying ? "Querying..." : "Run DNS TXT Query")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(isQuerying)

            Divider()

            Text("Results:")
                .font(.headline)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(txtRecords, id: \.self) { record in
                        Text(record)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxHeight: 200)
        }
        .padding()
    }
    
    private func performDNSQuery() {
        isQuerying = true
        txtRecords = ["Querying..."]
        
        digTXT(domain: "what-is-an-extreme-day-trip.ch.at") { records in
            DispatchQueue.main.async {
                isQuerying = false
                txtRecords = records.isEmpty ? ["No TXT records found"] : records
            }
        }
    }
}

#Preview {
    ContentView()
}
