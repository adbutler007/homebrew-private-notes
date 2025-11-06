cask "private-notes" do
  version "0.1.0"
  sha256 "ed1fde8e19e5b6411705e77c39573779b3b8a8eb5a1b5851d46750d0a3ac629b"

  url "https://github.com/adbutler007/private_notes/releases/download/v#{version}/PrivateNotes-#{version}.zip"
  name "Private Notes"
  desc "Privacy-first audio transcription and summarization for sales calls"
  homepage "https://github.com/adbutler007/private_notes"

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64
  depends_on formula: "ollama"

  app "Private Notes.app"

  postflight do
    puts <<~EOS
      ====================================
      Private Notes installed!
      ====================================

      Downloading AI model (this may take 3-5 minutes for ~4GB)...
    EOS

    # Auto-download the LLM model
    system_command "/opt/homebrew/bin/ollama",
                   args: ["pull", "qwen3:4b-instruct"],
                   print_stdout: true

    puts <<~EOS

      ✓ Model download complete!

      Optional: Install BlackHole for Zoom/Teams audio:
        brew install --cask blackhole-2ch

      Launch Private Notes from Applications or menu bar.

      Documentation: https://github.com/adbutler007/private_notes/tree/main/audio_summary_app
    EOS
  end

  zap trash: [
    "~/Library/Preferences/com.privatenotes.app.plist",
    "~/Library/Application Support/Private Notes",
    "~/Documents/Meeting Summaries",
  ]

  caveats <<~EOS
    Private Notes is a menu bar application.
    Look for the icon in your menu bar after launching.

    Privacy Note:
    - Audio and transcripts are NEVER saved to disk
    - Only summaries and structured data are persisted
    - All AI processing happens on-device (no cloud)

    For Zoom/Teams audio capture, install BlackHole:
      brew install --cask blackhole-2ch
  EOS
end
