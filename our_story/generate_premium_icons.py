#!/usr/bin/env python3
"""Generate beautiful app icons for Our Story with premium hand-drawn style"""

from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import math
import os

def create_warm_gradient(size, color1, color2, direction='radial'):
    """Create warm gradient background with premium feel"""
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    pixels = img.load()
    width, height = size

    for y in range(height):
        for x in range(width):
            if direction == 'radial':
                dx = (x - width/2) / (width/2)
                dy = (y - height/2) / (height/2)
                dist = math.sqrt(dx*dx + dy*dy)
                ratio = min(1.0, dist * 0.8)
            else:
                ratio = y / height

            ratio = max(0, min(1, ratio))

            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            a = 255

            pixels[x, y] = (r, g, b, a)

    return img

def draw_cute_cat(draw, x, y, size, facing_right=True, body_color='#F8B4C4', eye_color='#8B7355'):
    """Draw premium hand-drawn style cute cat"""
    s = size / 120  # Scale factor

    # Colors
    light_pink = '#FFE4E8'
    darker_pink = '#E8A0A8'
    nose_color = '#E8A0A8'

    if facing_right:
        # Body - soft oval with slight gradient effect
        body_points = [
            (x - 35*s, y + 5*s),
            (x - 25*s, y + 30*s),
            (x + 15*s, y + 30*s),
            (x + 30*s, y + 15*s),
            (x + 30*s, y - 5*s),
            (x + 15*s, y - 20*s),
            (x - 20*s, y - 20*s),
            (x - 35*s, y - 5*s),
        ]
        draw.polygon(body_points, fill=body_color)

        # Head - rounded
        draw.ellipse([x + 5*s, y - 45*s, x + 65*s, y + 15*s],
                     fill=body_color)

        # Left ear (pointing up-right)
        ear1 = [
            (x + 15*s, y - 40*s),
            (x + 30*s, y - 65*s),
            (x + 40*s, y - 42*s),
        ]
        draw.polygon(ear1, fill=darker_pink)
        # Inner ear
        ear1_inner = [
            (x + 20*s, y - 42*s),
            (x + 28*s, y - 55*s),
            (x + 35*s, y - 42*s),
        ]
        draw.polygon(ear1_inner, fill=light_pink)

        # Right ear (pointing up-right)
        ear2 = [
            (x + 35*s, y - 42*s),
            (x + 55*s, y - 70*s),
            (x + 58*s, y - 38*s),
        ]
        draw.polygon(ear2, fill=darker_pink)
        # Inner ear
        ear2_inner = [
            (x + 40*s, y - 42*s),
            (x + 52*s, y - 58*s),
            (x + 55*s, y - 40*s),
        ]
        draw.polygon(ear2_inner, fill=light_pink)

        # Eyes - happy closed curves
        draw.arc([x + 18*s, y - 25*s, x + 35*s, y - 8*s],
                 math.pi * 0.1, math.pi * 0.9, fill=eye_color, width=2)
        draw.arc([x + 38*s, y - 25*s, x + 55*s, y - 8*s],
                 math.pi * 0.1, math.pi * 0.9, fill=eye_color, width=2)

        # Nose - tiny triangle
        draw.polygon([
            (x + 35*s, y - 2*s),
            (x + 32*s, y + 5*s),
            (x + 38*s, y + 5*s),
        ], fill=nose_color)

        # Blush marks
        draw.ellipse([x + 15*s, y - 5*s, x + 22*s, y + 2*s],
                     fill=(255, 180, 180, 128))
        draw.ellipse([x + 48*s, y - 5*s, x + 55*s, y + 2*s],
                     fill=(255, 180, 180, 128))

        # Mouth - cute smile
        draw.arc([x + 30*s, y + 3*s, x + 42*s, y + 12*s],
                 math.pi * 0.1, math.pi * 0.8, fill=nose_color, width=1)

        # Whiskers
        whiskers = [
            ((x + 40*s, y - 2*s), (x + 65*s, y - 5*s)),
            ((x + 40*s, y + 2*s), (x + 65*s, y + 2*s)),
            ((x + 40*s, y + 6*s), (x + 62*s, y + 10*s)),
        ]
        for start, end in whiskers:
            draw.line([start, end], fill='#D4C4B0', width=1)

        # Tail - curved
        tail_path = [
            (x - 30*s, y + 10*s),
            (x - 50*s, y - 10*s),
            (x - 45*s, y - 35*s),
            (x - 35*s, y - 45*s),
        ]
        for i in range(len(tail_path) - 1):
            draw.line([tail_path[i], tail_path[i+1]],
                     fill=body_color, width=int(8*s))

    else:  # Mirror for left cat
        # Body
        body_points = [
            (x + 35*s, y + 5*s),
            (x + 25*s, y + 30*s),
            (x - 15*s, y + 30*s),
            (x - 30*s, y + 15*s),
            (x - 30*s, y - 5*s),
            (x - 15*s, y - 20*s),
            (x + 20*s, y - 20*s),
            (x + 35*s, y - 5*s),
        ]
        draw.polygon(body_points, fill=body_color)

        # Head
        draw.ellipse([x - 65*s, y - 45*s, x - 5*s, y + 15*s],
                     fill=body_color)

        # Left ear
        ear1 = [
            (x - 40*s, y - 40*s),
            (x - 55*s, y - 70*s),
            (x - 58*s, y - 38*s),
        ]
        draw.polygon(ear1, fill=darker_pink)
        ear1_inner = [
            (x - 40*s, y - 42*s),
            (x - 52*s, y - 58*s),
            (x - 55*s, y - 40*s),
        ]
        draw.polygon(ear1_inner, fill=light_pink)

        # Right ear
        ear2 = [
            (x - 35*s, y - 42*s),
            (x - 30*s, y - 65*s),
            (x - 15*s, y - 42*s),
        ]
        draw.polygon(ear2, fill=darker_pink)
        ear2_inner = [
            (x - 35*s, y - 42*s),
            (x - 28*s, y - 55*s),
            (x - 20*s, y - 42*s),
        ]
        draw.polygon(ear2_inner, fill=light_pink)

        # Eyes
        draw.arc([x - 55*s, y - 25*s, x - 38*s, y - 8*s],
                 math.pi * 0.1, math.pi * 0.9, fill=eye_color, width=2)
        draw.arc([x - 35*s, y - 25*s, x - 18*s, y - 8*s],
                 math.pi * 0.1, math.pi * 0.9, fill=eye_color, width=2)

        # Nose
        draw.polygon([
            (x - 35*s, y - 2*s),
            (x - 38*s, y + 5*s),
            (x - 32*s, y + 5*s),
        ], fill=nose_color)

        # Blush
        draw.ellipse([x - 55*s, y - 5*s, x - 48*s, y + 2*s],
                     fill=(255, 180, 180, 128))
        draw.ellipse([x - 22*s, y - 5*s, x - 15*s, y + 2*s],
                     fill=(255, 180, 180, 128))

        # Mouth
        draw.arc([x - 42*s, y + 3*s, x - 30*s, y + 12*s],
                 math.pi * 0.1, math.pi * 0.8, fill=nose_color, width=1)

        # Whiskers
        whiskers = [
            ((x - 40*s, y - 2*s), (x - 65*s, y - 5*s)),
            ((x - 40*s, y + 2*s), (x - 65*s, y + 2*s)),
            ((x - 40*s, y + 6*s), (x - 62*s, y + 10*s)),
        ]
        for start, end in whiskers:
            draw.line([start, end], fill='#D4C4B0', width=1)

        # Tail
        tail_path = [
            (x + 30*s, y + 10*s),
            (x + 50*s, y - 10*s),
            (x + 45*s, y - 35*s),
            (x + 35*s, y - 45*s),
        ]
        for i in range(len(tail_path) - 1):
            draw.line([tail_path[i], tail_path[i+1]],
                     fill=body_color, width=int(8*s))

def draw_heart(draw, cx, cy, size, color='#FF6B8A'):
    """Draw a beautiful heart"""
    s = size / 100

    # Heart using bezier-like curve
    points = []
    for i in range(0, 360, 10):
        angle = math.radians(i)
        if i < 180:
            # Left lobe
            x = cx + 35*s * math.sin(angle)
            y = cy - 30*s * math.cos(angle) + 15*s * math.sin(angle)
        else:
            # Right lobe
            x = cx + 35*s * math.sin(math.radians(360-i))
            y = cy - 30*s * math.cos(math.radians(360-i)) + 15*s * math.sin(math.radians(360-i))

    # Simple heart polygon
    heart = [
        (cx, cy + 30*s),
        (cx - 25*s, cy + 5*s),
        (cx - 40*s, cy - 10*s),
        (cx - 40*s, cy - 25*s),
        (cx - 25*s, cy - 40*s),
        (cx, cy - 30*s),
        (cx + 25*s, cy - 40*s),
        (cx + 40*s, cy - 25*s),
        (cx + 40*s, cy - 10*s),
        (cx + 25*s, cy + 5*s),
    ]
    draw.polygon(heart, fill=color)

def add_glow(img, cx, cy, intensity=0.15):
    """Add subtle glow effect around center"""
    overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    for radius in range(80, 20, -10):
        alpha = int(intensity * 30 * (80 - radius) / 60)
        draw.ellipse(
            [cx - radius, cy - radius * 0.9,
             cx + radius, cy + radius * 0.9],
            fill=(255, 107, 138, alpha)
        )

    return Image.alpha_composite(img, overlay)

def create_premium_icon(size):
    """Create premium app icon"""
    img = create_warm_gradient(
        (size, size),
        (255, 245, 235, 255),  # Warm cream
        (255, 220, 225, 255),   # Soft blush
    )
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Draw cats
    cat_size = size * 0.48
    draw_cute_cat(draw, center - size*0.08, center + size*0.06, cat_size, True)
    draw_cute_cat(draw, center + size*0.08, center + size*0.06, cat_size, False)

    # Heart
    heart_size = size * 0.16
    draw_heart(draw, center, center - size*0.06, heart_size)

    # Glow
    img = add_glow(img, center, center - size*0.06)

    return img

def create_launcher_background(size):
    """Create launcher icon background"""
    return create_warm_gradient(
        (size, size),
        (255, 245, 235, 255),
        (255, 220, 225, 255),
    )

def main():
    base_path = "/workspace/our_story"

    # Icon sizes
    icon_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }

    print("Generating premium app icons...")

    # Generate PNG icons
    for dir_name, size in icon_sizes.items():
        icon = create_premium_icon(size)
        output_path = f"{base_path}/android/app/src/main/res/{dir_name}/ic_launcher.png"
        icon.save(output_path, "PNG")
        print(f"  ✓ {output_path} ({size}x{size})")

    # Generate adaptive icon foreground (high res)
    print("\nGenerating adaptive icon foreground...")
    foreground = create_premium_icon(1024)
    fg_path = f"{base_path}/android/app/src/main/res/drawable/ic_launcher_foreground.png"
    foreground.save(fg_path, "PNG")
    print(f"  ✓ {fg_path}")

    # Generate adaptive icon background
    background = create_launcher_background(1024)
    bg_path = f"{base_path}/android/app/src/main/res/drawable/ic_launcher_background.png"
    background.save(bg_path, "PNG")
    print(f"  ✓ {bg_path}")

    # Generate splash image
    print("\nGenerating splash screen...")
    splash_size = (1080, 1920)
    splash = create_warm_gradient(splash_size, (255, 253, 250, 255), (255, 235, 240, 255), 'vertical')
    splash_draw = ImageDraw.Draw(splash)

    # Add heart
    draw_heart(splash_draw, splash_size[0]//2, splash_size[1]//3 - 50, 180)

    # Add cats
    cat_size = 400
    draw_cute_cat(splash_draw, splash_size[0]//2 - 80, splash_size[1] - 350, cat_size, True)
    draw_cute_cat(splash_draw, splash_size[0]//2 + 80, splash_size[1] - 350, cat_size, False)

    splash_path = f"{base_path}/android/app/src/main/res/drawable/splash.png"
    splash.save(splash_path, "PNG")
    print(f"  ✓ {splash_path}")

    print("\n" + "="*50)
    print("✨ Premium icons generated successfully!")
    print("="*50)

if __name__ == "__main__":
    main()
