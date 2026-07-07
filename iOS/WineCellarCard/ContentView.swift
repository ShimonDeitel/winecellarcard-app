import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: BottleEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.name.isEmpty ? "Untitled" : entry.name)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            Text(entry.vintage)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Wine Cellar Card")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No bottles yet", systemImage: "tray", description: Text("Tap + to add your first bottle."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: BottleEntry?

    @State private var name: String = ""
    @State private var vintage: String = ""
    @State private var region: String = ""
    @State private var drinkByYear: String = ""

    init(isPresented: Binding<Bool>, editing: BottleEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _name = State(initialValue: e.name) }
        if let e = editing { _vintage = State(initialValue: e.vintage) }
        if let e = editing { _region = State(initialValue: e.region) }
        if let e = editing { _drinkByYear = State(initialValue: e.drinkByYear) }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("addNameField")
                TextField("Vintage", text: $vintage)
                    .accessibilityIdentifier("addVintageField")
                TextField("Region", text: $region)
                    .accessibilityIdentifier("addRegionField")
                TextField("Drink by year", text: $drinkByYear)
                    .accessibilityIdentifier("addDrinkByYearField")
            }
            .navigationTitle(editing == nil ? "Add Bottle" : "Edit Bottle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.name = name
                            e.vintage = vintage
                            e.region = region
                            e.drinkByYear = drinkByYear
                            store.update(e)
                        } else {
                            let entry = BottleEntry(name: name, vintage: vintage, region: region, drinkByYear: drinkByYear)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
