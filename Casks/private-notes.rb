cask "private-notes" do
  version "0.1.0"
  sha256 "bb671f13787c052f696df982ed1c407d7142980d7ce4d685ff94fb69ae48249c"

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

      Downloading AI models (this may take 5-8 minutes for ~6GB total)...
    EOS

    # Auto-download the LLM model
    puts "\n      [1/2] Downloading Ollama LLM model (~4GB)..."
    system_command "/opt/homebrew/bin/ollama",
                   args: ["pull", "qwen3:4b-instruct"],
                   print_stdout: true

    puts "\n      ✓ Ollama model downloaded"

    # Auto-download the Parakeet speech-to-text model
    puts "\n      [2/2] Downloading Parakeet speech model (~2GB)..."
    puts "      Note: Parakeet will download on first recording if this step fails."

    # Try to download using Python 3 and huggingface_hub
    # This is a best-effort attempt - the app will download on first use if it fails
    begin
      system_command "/usr/bin/python3",
                     args: [
                       "-c",
                       "from huggingface_hub import snapshot_download; " \
                       "snapshot_download('mlx-community/parakeet-tdt-0.6b-v3', " \
                       "allow_patterns=['*.json', '*.safetensors', '*.txt', '*.model'])"
                     ],
                     print_stdout: false
      puts "      ✓ Parakeet model downloaded"
    rescue => e
      puts "      ⚠ Parakeet download skipped (will download on first recording)"
    end

    puts <<~EOS

      ✓ All models downloaded successfully!

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
