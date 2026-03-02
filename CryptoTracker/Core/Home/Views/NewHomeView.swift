import SwiftUI

struct NewHomeView: View {
    @State private var selectedMood: Int? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    moodSection
                    primaryAction
                    statsRow
                    dailyPrompt
                    recentEntries
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

extension NewHomeView {
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning, Alex")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Text(dateString)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            HStack(spacing: 16) {
                Button {
                    // Bell action
                } label: {
                    Image(systemName: "bell.fill")
                        .font(.title3.weight(.medium))
                        .foregroundColor(Color.theme.accent)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                Button {
                    // Gear action
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title3.weight(.medium))
                        .foregroundColor(Color.theme.accent)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("How are you today?")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Text("Choose the mood that best describes you")
                    .font(.footnote.weight(.medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            HStack(spacing: 16) {
                ForEach(moods.indices, id: \.self) { index in
                    let mood = moods[index]
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            if selectedMood == index {
                                selectedMood = nil
                            } else {
                                selectedMood = index
                            }
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Text(mood.emoji)
                                .font(.largeTitle)
                            Text(mood.label)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.primary)
                        }
                        .frame(width: 64, height: 88)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(LinearGradient(
                                        colors: selectedMood == index
                                            ? [Color.theme.accent.opacity(0.25), Color.theme.accent.opacity(0.10)]
                                            : [Color.theme.accent.opacity(0.10), Color.theme.accent.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                if selectedMood == index {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(Color.theme.accent, lineWidth: 2)
                                        .shadow(color: Color.theme.accent.opacity(0.5), radius: 5, x: 0, y: 0)
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .accessibilityLabel("\(mood.label) mood")
                    .accessibilityAddTraits(selectedMood == index ? .isSelected : [])
                }
            }
        }
    }

    private var primaryAction: some View {
        Button {
            // Log Check-in action
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2.weight(.semibold))
                Text("Log Check-in")
                    .font(.title3.weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.theme.accent)
                    .shadow(color: Color.theme.accent.opacity(0.5), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }

    private var statsRow: some View {
        HStack(spacing: 16) {
            statCard(title: "5 days", badgeText: "+1%", badgeColor: .green, subtitle: nil)
            statCard(title: "42 entries", badgeText: nil, badgeColor: nil, subtitle: "Total")
        }
    }

    private func statCard(title: String, badgeText: String?, badgeColor: Color?, subtitle: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 6) {
                Text(title)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                if let badgeText, let badgeColor {
                    Text(badgeText)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(badgeColor)
                        )
                        .accessibilityLabel("\(badgeText) change")
                }
            }
            if let subtitle {
                Text(subtitle)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    private var dailyPrompt: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Prompt")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.theme.accent)
            Text("“What moment today are you most grateful for?”")
                .font(.body.weight(.medium))
                .foregroundColor(Color.theme.secondaryText)
                .italic()
            Button {
                // Answer Prompt action
            } label: {
                HStack(spacing: 4) {
                    Text("Answer Prompt")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                    Image(systemName: "chevron.right")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
    }

    private var recentEntries: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Entries")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.theme.accent)

            ForEach(sampleEntries) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.title)
                                .font(.headline.weight(.semibold))
                                .foregroundColor(Color.theme.accent)
                            Text(entry.subtitle)
                                .font(.caption.weight(.medium))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        Spacer()
                    }
                    Text(entry.preview)
                        .font(.body)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(3)
                }
                .padding(16)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            }
        }
    }

    // MARK: - Helpers

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    private var moods: [(emoji: String, label: String)] {
        [
            ("😞", "Sad"),
            ("😐", "Meh"),
            ("🙂", "OK"),
            ("😊", "Good"),
            ("😃", "Great")
        ]
    }

    private struct Entry: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let preview: String
    }

    private var sampleEntries: [Entry] {
        [
            Entry(
                title: "Morning Reflection",
                subtitle: "2 hours ago",
                preview: "Today I felt really energized after my morning run. It set a great tone for the rest of the day."
            ),
            Entry(
                title: "Gratitude Note",
                subtitle: "Yesterday",
                preview: "I'm thankful for my friends and family who always support me no matter what."
            )
        ]
    }
}

#Preview {
    NewHomeView()
}
