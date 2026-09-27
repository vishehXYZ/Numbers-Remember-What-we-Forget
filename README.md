# Numbers Remember What We Forget

This project began as a generative art experiment created in Processing.

The visual system explores numbers, movement, repetition, glitch, disappearance, transformation, fast-moving lines, and saturated geometric forms. It was developed with large-scale projection and video mapping in mind.

After the generative artwork was rendered into video, a Morse-code sound layer was added to the final video. When translated, the Morse code says:

**“Numbers remember what we forget.”**

The phrase extends the work conceptually by connecting the visual language of numbers with memory, traces, repetition, and forgetting.

## Technical Details

- Processing 4
- Java Mode
- Resolution: 3840 × 2160
- Frame rate: 30 fps
- Duration: 10 seconds
- Total frames: 300
- No external Processing libraries required

## Output

The sketch exports an image sequence automatically:

```text
frames/frame_0001.png
frames/frame_0002.png
...
frames/frame_0300.png
```

## Run

1. Open `NumbersRememberWhatWeForget.pde` in Processing 4.
2. Use Java Mode.
3. Press Run.
4. The sketch renders 300 PNG frames and exits automatically.

## Convert to MP4

Using FFmpeg:

```bash
ffmpeg -framerate 30 -i frames/frame_%04d.png -c:v libx264 -pix_fmt yuv420p -crf 18 NumbersRememberWhatWeForget.mp4
```

## Notes

The generated `frames` folder is excluded from GitHub because hundreds of full-resolution PNG files would make the repository unnecessarily large.
