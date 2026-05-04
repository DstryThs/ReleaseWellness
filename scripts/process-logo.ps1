# Stopgap logo processor.
# Takes the JPEG that was extracted from the fake-SVG, chroma-keys the
# off-white background to transparent, then uses alpha-based bbox detection
# (with noise filtering) to emit two clean PNGs:
#   public/release-wellness-logo.png  — full lockup (mark + wordmark + tagline)
#   public/release-wellness-mark.png  — just the tree-ring mark
#
# Replace with a real vector when her designer sends one.

Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class LogoProcessor {
    public static int[] Process(
        string inPath, string outLockup, string outMark,
        int Rbg, int Gbg, int Bbg,
        int threshLow, int threshHigh, int pad
    ) {
        Bitmap src;
        using (var img = Image.FromFile(inPath)) {
            src = new Bitmap(img);
        }
        int W = src.Width, H = src.Height;
        var rect = new Rectangle(0, 0, W, H);
        var srcData = src.LockBits(rect, ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        byte[] bytes = new byte[W * H * 4];
        Marshal.Copy(srcData.Scan0, bytes, 0, bytes.Length);
        src.UnlockBits(srcData);

        // Pass 1: chroma-key the whole image to ARGB with feathered alpha.
        byte[] keyed = new byte[W * H * 4];
        int range = threshHigh - threshLow;
        for (int i = 0; i < W * H; i++) {
            int o = i * 4;
            int b = bytes[o], g = bytes[o + 1], r = bytes[o + 2];
            int d = Math.Max(Math.Abs(r - Rbg), Math.Max(Math.Abs(g - Gbg), Math.Abs(b - Bbg)));
            int alpha = 255;
            if (d <= threshLow) alpha = 0;
            else if (d < threshHigh) alpha = (int)Math.Round(((double)(d - threshLow) / range) * 255);
            keyed[o] = (byte)b;
            keyed[o + 1] = (byte)g;
            keyed[o + 2] = (byte)r;
            keyed[o + 3] = (byte)alpha;
        }

        // Pass 2: compute per-column and per-row opaque pixel counts.
        int[] colCounts = new int[W];
        int[] rowCounts = new int[H];
        for (int y = 0; y < H; y++) {
            for (int x = 0; x < W; x++) {
                int o = (y * W + x) * 4;
                if (keyed[o + 3] > 128) {
                    colCounts[x]++;
                    rowCounts[y]++;
                }
            }
        }

        // Noise filter: a column "counts" only if it has at least 5% of rows
        // opaque AND at least one neighbor within 4 cols also has >= 2% opaque.
        int colMin = Math.Max(3, (int)(H * 0.05));
        int rowMin = Math.Max(3, (int)(W * 0.01));
        bool[] colReal = new bool[W];
        bool[] rowReal = new bool[H];
        for (int x = 0; x < W; x++) {
            if (colCounts[x] >= colMin) {
                bool hasNeighbor = false;
                for (int dx = -4; dx <= 4; dx++) {
                    if (dx == 0) continue;
                    int nx = x + dx;
                    if (nx >= 0 && nx < W && colCounts[nx] >= colMin / 2) { hasNeighbor = true; break; }
                }
                colReal[x] = hasNeighbor;
            }
        }
        for (int y = 0; y < H; y++) {
            if (rowCounts[y] >= rowMin) {
                bool hasNeighbor = false;
                for (int dy = -4; dy <= 4; dy++) {
                    if (dy == 0) continue;
                    int ny = y + dy;
                    if (ny >= 0 && ny < H && rowCounts[ny] >= rowMin / 2) { hasNeighbor = true; break; }
                }
                rowReal[y] = hasNeighbor;
            }
        }

        // Tight bbox from filtered cols/rows.
        int top = H, bottom = 0, left = W, right = 0;
        for (int y = 0; y < H; y++) {
            if (rowReal[y]) {
                if (y < top) top = y;
                if (y > bottom) bottom = y;
            }
        }
        for (int x = 0; x < W; x++) {
            if (colReal[x]) {
                if (x < left) left = x;
                if (x > right) right = x;
            }
        }
        top = Math.Max(0, top - pad);
        bottom = Math.Min(H - 1, bottom + pad);
        left = Math.Max(0, left - pad);
        right = Math.Min(W - 1, right + pad);
        int cropW = right - left + 1;
        int cropH = bottom - top + 1;

        // Save full lockup with the tight bbox.
        var outBmp = new Bitmap(cropW, cropH, PixelFormat.Format32bppArgb);
        var outRect = new Rectangle(0, 0, cropW, cropH);
        var outData = outBmp.LockBits(outRect, ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
        byte[] outBytes = new byte[cropW * cropH * 4];
        for (int y = 0; y < cropH; y++) {
            for (int x = 0; x < cropW; x++) {
                int si = ((y + top) * W + (x + left)) * 4;
                int oi = (y * cropW + x) * 4;
                outBytes[oi] = keyed[si];
                outBytes[oi + 1] = keyed[si + 1];
                outBytes[oi + 2] = keyed[si + 2];
                outBytes[oi + 3] = keyed[si + 3];
            }
        }
        Marshal.Copy(outBytes, 0, outData.Scan0, outBytes.Length);
        outBmp.UnlockBits(outData);
        outBmp.Save(outLockup, ImageFormat.Png);

        // Find the right edge of the mark by walking filtered cols from `left`,
        // looking for a sustained gap (>= 10 consecutive non-real cols).
        int markRight = left;
        int gapCount = 0;
        int gapWidth = 12;
        bool inMark = false;
        for (int x = left; x <= right; x++) {
            if (colReal[x]) {
                inMark = true;
                gapCount = 0;
                markRight = x;
            } else if (inMark) {
                gapCount++;
                if (gapCount >= gapWidth) break;
            }
        }
        int markCropR = Math.Min(W - 1, markRight + pad);
        int markCropL = left;
        int markPxW = markCropR - markCropL + 1;

        // Re-find tight top/bottom within the mark's column range.
        int mTop = H, mBottom = 0;
        for (int y = top; y <= bottom; y++) {
            int rowOpaque = 0;
            for (int x = markCropL; x <= markCropR; x++) {
                int o = (y * W + x) * 4;
                if (keyed[o + 3] > 128) rowOpaque++;
            }
            if (rowOpaque >= 3) {
                if (y < mTop) mTop = y;
                if (y > mBottom) mBottom = y;
            }
        }
        mTop = Math.Max(0, mTop - pad);
        mBottom = Math.Min(H - 1, mBottom + pad);
        int markPxH = mBottom - mTop + 1;

        var markBmp = new Bitmap(markPxW, markPxH, PixelFormat.Format32bppArgb);
        var markRect = new Rectangle(0, 0, markPxW, markPxH);
        var markData = markBmp.LockBits(markRect, ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
        byte[] markBytes = new byte[markPxW * markPxH * 4];
        for (int y = 0; y < markPxH; y++) {
            for (int x = 0; x < markPxW; x++) {
                int si = ((y + mTop) * W + (x + markCropL)) * 4;
                int oi = (y * markPxW + x) * 4;
                markBytes[oi] = keyed[si];
                markBytes[oi + 1] = keyed[si + 1];
                markBytes[oi + 2] = keyed[si + 2];
                markBytes[oi + 3] = keyed[si + 3];
            }
        }
        Marshal.Copy(markBytes, 0, markData.Scan0, markBytes.Length);
        markBmp.UnlockBits(markData);
        markBmp.Save(outMark, ImageFormat.Png);

        markBmp.Dispose();
        outBmp.Dispose();
        src.Dispose();
        return new int[] { cropW, cropH, markPxW, markPxH };
    }
}
'@ -ReferencedAssemblies System.Drawing

$src = "C:\Users\miker\Desktop\ReleaseWellness\docs\brand\assets\logo\_extracted-from-svg.jpg"
$outLockup = "C:\Users\miker\Desktop\ReleaseWellness\public\release-wellness-logo.png"
$outMark = "C:\Users\miker\Desktop\ReleaseWellness\public\release-wellness-mark.png"

# Background sampled from corners: ~#F6F5F3
$result = [LogoProcessor]::Process($src, $outLockup, $outMark, 246, 245, 243, 6, 30, 8)
"Lockup PNG: $outLockup ($($result[0]) x $($result[1]))"
"Mark PNG:   $outMark ($($result[2]) x $($result[3]))"
