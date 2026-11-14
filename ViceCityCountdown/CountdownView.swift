import SwiftUI
struct CountdownView: View {
  @AppStorage("selectedTimezone") private var zoneID = "Australia/Melbourne"
  @State private var now = Date()
  private let zones = ["Australia/Melbourne", "Australia/Sydney", "Australia/Brisbane", "Australia/Adelaide", "Australia/Perth", "Pacific/Auckland", "America/New_York", "America/Los_Angeles", "America/Chicago", "Europe/London", "Europe/Paris", "Asia/Tokyo", "Asia/Singapore", "Asia/Dubai"]
  private var release: Date {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: zoneID) ?? .current
    return cal.date(from: DateComponents(year: 2026, month: 11, day: 19))!
  }
  private var remaining: (Int,Int,Int,Int) {
    let s = max(0, Int(ceil(release.timeIntervalSince(now))))
    return (s / 86400, s % 86400 / 3600, s % 3600 / 60, s % 60)
  }
  var body: some View {
    ZStack {
      GeometryReader { geo in
        if UIImage(named: "vice-city-sunset") != nil {
          Image("vice-city-sunset").resizable().scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height).clipped()
        } else {
          LinearGradient(colors: [.purple, .pink, .orange, .indigo], startPoint: .top, endPoint: .bottom)
        }
      }.ignoresSafeArea()
      LinearGradient(colors: [.black.opacity(0.25), .clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
      VStack(spacing: 22) {
        Spacer()
        Text("GRAND THEFT AUTO").font(.system(size: 26, weight: .black, design: .rounded)).tracking(2)
        Text("VI").font(.system(size: 90, weight: .black, design: .serif)).foregroundStyle(.pink)
          .shadow(color: .purple, radius: 18)
        Text("THE COUNTDOWN").font(.caption.bold()).tracking(5)
        HStack(spacing: 9) {
          counter(remaining.0, "DAYS")
          counter(remaining.1, "HOURS")
          counter(remaining.2, "MINS")
          counter(remaining.3, "SECS")
        }
        .padding(14).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
        VStack(spacing: 8) {
          Text("YOUR TIME ZONE").font(.caption.bold()).tracking(2)
          Picker("Time zone", selection: $zoneID) {
            ForEach(zones, id: \.self) { z in Text(z.replacingOccurrences(of: "_", with: " ")).tag(z) }
          }.tint(.white).pickerStyle(.menu)
          Text("19 NOVEMBER 2026 • 12:00 AM").font(.caption).foregroundStyle(.white.opacity(0.85))
          Text("Countdown uses local midnight in the selected time zone. Exact game unlock time is unconfirmed.")
            .font(.system(size: 11)).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.75))
        }.padding().frame(maxWidth: .infinity).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        Spacer()
        Text("UNOFFICIAL FAN COUNTDOWN").font(.system(size: 10, weight: .bold)).tracking(2).foregroundStyle(.white.opacity(0.7))
      }.padding(22)
    }
    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { now = $0 }
  }
  private func counter(_ value: Int, _ label: String) -> some View {
    VStack(spacing: 7) {
      Text(String(format: "%02d", value)).font(.system(size: 28, weight: .heavy, design: .rounded)).monospacedDigit()
      Text(label).font(.system(size: 9, weight: .bold)).tracking(1)
    }.frame(maxWidth: .infinity)
  }
}
