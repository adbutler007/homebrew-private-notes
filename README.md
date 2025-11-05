# Private Notes Homebrew Tap

Homebrew formula for [Private Notes](https://github.com/adbutler007/private_notes) - Privacy-first audio transcription and summarization.

## Installation

```bash
brew tap adbutler007/private-notes
brew install --cask private-notes
ollama pull qwen3:4b-instruct
```

Then launch **Private Notes** from your Applications folder or menu bar.

## What is Private Notes?

Private Notes is a macOS menu bar application that:

- **Transcribes** audio in real-time using MLX Whisper (Apple Silicon optimized)
- **Summarizes** meetings using on-device AI (Ollama)
- **Extracts** structured data (contacts, companies, deals)
- **Exports** to CSV for CRM integration
- **Protects privacy** - audio/transcripts never saved, only summaries

Perfect for sales discovery calls, client meetings, and interviews.

## Requirements

- macOS 11.0+ (Big Sur or later)
- Apple Silicon (M1/M2/M3/M4)
- ~4GB disk space for AI models
- ~16GB RAM recommended

## Documentation

- **[User Guide](https://github.com/adbutler007/private_notes/blob/main/audio_summary_app/USER_GUIDE.md)** - Complete usage instructions
- **[Main Repository](https://github.com/adbutler007/private_notes)** - Source code and documentation

## Optional: Zoom/Teams Integration

To capture Zoom/Teams audio:

```bash
brew install --cask blackhole-2ch
```

See the [User Guide](https://github.com/adbutler007/private_notes/blob/main/audio_summary_app/USER_GUIDE.md#zoomteams-integration) for setup instructions.

## Privacy & Security

- ✅ All processing happens on-device (no cloud)
- ✅ Audio is never saved to disk
- ✅ Transcripts held in RAM only
- ✅ Only summaries and structured data are persisted
- ✅ No telemetry or tracking

## Support

- **Issues**: [GitHub Issues](https://github.com/adbutler007/private_notes/issues)
- **Documentation**: [User Guide](https://github.com/adbutler007/private_notes/blob/main/audio_summary_app/USER_GUIDE.md)

## License

MIT
