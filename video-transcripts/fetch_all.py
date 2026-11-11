"""Collect ICT playlist transcripts into .txt files, one per video (yt-ta 1.x)."""
import json, re, time
from pathlib import Path

OUT = Path(__file__).parent
IDS = ["sIcsLFSNoXM", "U8xH2dEgH5A", "YESqIoA7Wyg", "MlMsG7li9zY", "g3oDYq4P9ZE",
       "ZVUDpCyvxfQ", "3OivsP1j_UE", "sgAnVR6RSDg", "75S4vwD4P1U", "uDJI2AbyyCs",
       "DMUiDBnTYc8", "bbWPoajy2MY", "CHIK5oBRKiw", "TCFvsZeYvV8", "1YRs4Z1lMws",
       "wik00c9_2nk", "27S9gjgcSlI", "iEaMbuFZb24", "ubCe509_JLY", "FGkb_50BfT8",
       "MPeeE55rNOw", "0OjlQ91TZiU", "MsuEQQl7L6s"]

from youtube_transcript_api import YouTubeTranscriptApi

def fmt(raw):
    return re.sub(r"\s+", " ", " ".join(
        f"[{int(c['start'])//60:02d}:{int(c['start'])%60:02d}] {c['text']}" for c in raw))

results = []
for n, vid in enumerate(IDS, 1):
    text, err = None, ""
    for attempt, delay in enumerate((0, 8, 25)):
        if delay:
            time.sleep(delay)
        try:
            api = YouTubeTranscriptApi()
            t = api.fetch(vid)          # auto-prefers manual captions, falls back to generated
            text = fmt(t.to_raw_data())
            err = ""
            break
        except Exception as e:
            err = f"{type(e).__name__}: {e}"
    status = "ok" if text else "failed"
    OUT.joinpath(f"{n:02d}_{vid}.txt").write_text(text or "", encoding="utf-8")
    results.append({"i": n, "id": vid, "status": status, "chars": len(text or ""), "error": err})
    print(f"{n:02d}/{len(IDS)} {vid} -> {status}" + (f" ({err})" if err else f" ({len(text)} chars)"), flush=True)

(OUT / "index.json").write_text(json.dumps(results, indent=2), encoding="utf-8")
fails = [r["id"] for r in results if r["status"] == "failed"]
print("DONE. Failed:", fails if fails else "none")
