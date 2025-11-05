cask "private-notes" do
  version "0.1.0"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"

  url "https://github.com/adbutler007/private_notes/releases/download/v#{version}/PrivateNotes-#{version}.zip"
  name "Private Notes"
  desc "Privacy-first audio transcription and summarization for sales calls"
  homepage "https://github.com/adbutler007/private_notes"

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64

  depends_on formula: "ollama"
  depends_on cask: "blackhole-2ch", optional: true

  app "Private Notes.app"

  postflight do
    puts <<~EOS
      ====================================
      Private Notes installed!
      ====================================

      First-time setup:

      1. Download the LLM model:
         ollama pull qwen3:4b-instruct

      2. (Optional) Install BlackHole for Zoom/Teams audio:
         brew install --cask blackhole-2ch

      3. Launch Private Notes from Applications or menu bar

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
