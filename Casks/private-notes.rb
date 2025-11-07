cask "private-notes" do
  version "0.1.0"
  sha256 "363d327ac5e80d216d7c4ffd9f4aa647c6c84f0e249fb8236fd984fc63f21a80"

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

      Removing macOS quarantine attribute...
    EOS

    # Remove quarantine attribute to bypass Gatekeeper (app is not code-signed)
    system_command "xattr",
                   args: ["-cr", "#{appdir}/Private Notes.app"]

    puts <<~EOS
      ✓ Quarantine removed

      Downloading AI model (this may take 3-5 minutes for ~4GB)...
    EOS

    # Auto-download the LLM model
    system_command "/opt/homebrew/bin/ollama",
                   args: ["pull", "qwen3:4b-instruct"],
                   print_stdout: true

    puts <<~EOS

      ✓ Model download complete!

    EOS

    # Check if BlackHole is already installed
    blackhole_installed = system("/opt/homebrew/bin/brew list --cask blackhole-2ch > /dev/null 2>&1")

    if blackhole_installed
      puts "      ✓ BlackHole already installed"
    else
      puts <<~EOS

      BlackHole is recommended for capturing Zoom/Teams audio.
      Would you like to install it now? (y/N):
      EOS

      response = $stdin.gets.chomp.downcase

      if response == 'y' || response == 'yes'
        puts "\n      Installing BlackHole..."
        system_command "/opt/homebrew/bin/brew",
                       args: ["install", "--cask", "blackhole-2ch"],
                       print_stdout: true
        puts "      ✓ BlackHole installed!"
      else
        puts "      Skipping BlackHole installation."
        puts "      You can install it later with: brew install --cask blackhole-2ch"
      end
    end

    puts <<~EOS

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

    Note: This app is not code-signed. Homebrew automatically removes the
    quarantine attribute during installation to allow it to run.

    Privacy Note:
    - Audio and transcripts are NEVER saved to disk
    - Only summaries and structured data are persisted
    - All AI processing happens on-device (no cloud)

    System Audio Setup (for Zoom/Teams):
    - BlackHole creates a virtual audio device to capture system audio
    - If not installed during setup, you can install it later:
        brew install --cask blackhole-2ch
    - After installing, configure your meeting app to output to "BlackHole 2ch"
    - Set Private Notes to record from "BlackHole 2ch" in audio settings
  EOS
end
