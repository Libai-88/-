#!/usr/bin/env python3
"""Generate splash icon for flutter_native_splash"""

from PIL import Image, ImageDraw
import math
import os

def create_gradient_background(size, color1, color2):
    """Create gradient background"""
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    pixels = img.load()
    width, height = size

    for y in range(height):
        for x in range(width):
            dist = math.sqrt((x - width/2)**2 + (y - height/2)**2)
            max_dist = math.sqrt((width/2)**2 + (height/2)**2)
            ratio = min(1.0, dist / max_dist)

            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            a = 255

            pixels[x, y] = (r, g, b, a)

    return img

def draw_cat(draw, x, y, size, facing_right=True, color='#F8B4C4'):
    """Draw a cute simplified cat"""
    scale = size / 100
    body_color = color
    ear_color = '#E8A0A8'

    if facing_right:
        # Body
        draw.ellipse([x - 30*scale, y - 15*scale, x + 30*scale, y + 25*scale],
                     fill=body_color, outline=body_color)

        # Head
        draw.ellipse([x + 10*scale, y - 35*scale, x + 55*scale, y + 10*scale],
                     fill=body_color, outline=body_color)

        # Ears
        draw.polygon([(x + 15*scale, y - 30*scale),
                      (x + 25*scale, y - 50*scale),
                      (x + 35*scale, y - 30*scale)],
                     fill=ear_color)
        draw.polygon([(x + 35*scale, y - 30*scale),
                      (x + 50*scale, y - 55*scale),
                      (x + 60*scale, y - 30*scale)],
                     fill=ear_color)

        # Inner ears
        draw.polygon([(x + 20*scale, y - 32*scale),
                      (x + 25*scale, y - 42*scale),
                      (x + 32*scale, y - 32*scale)],
                     fill='#FFE4E8')
        draw.polygon([(x + 40*scale, y - 32*scale),
                      (x + 50*scale, y - 47*scale),
                      (x + 55*scale, y - 32*scale)],
                     fill='#FFE4E8')

        # Eyes (happy arcs)
        draw.arc([x + 20*scale, y - 18*scale, x + 35*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)
        draw.arc([x + 38*scale, y - 18*scale, x + 53*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)

        # Nose
        draw.polygon([(x + 35*scale, y + 2*scale),
                      (x + 32*scale, y + 8*scale),
                      (x + 38*scale, y + 8*scale)],
                     fill='#E8A0A8')

        # Whiskers
        for i in [-1, 1]:
            draw.line([x + 35*scale, y + 5*scale, x + 55*scale, y + (5+i*3)*scale],
                     fill='#D4C4B0', width=1)
            draw.line([x + 35*scale, y + 8*scale, x + 55*scale, y + (8+i*3)*scale],
                     fill='#D4C4B0', width=1)

        # Tail
        draw.line([x - 25*scale, y, x - 45*scale, y - 25*scale],
                 fill=body_color, width=int(8*scale))
        draw.line([x - 45*scale, y - 25*scale, x - 35*scale, y - 40*scale],
                 fill=body_color, width=int(6*scale))
    else:
        # Mirror for left cat
        draw.ellipse([x - 30*scale, y - 15*scale, x + 30*scale, y + 25*scale],
                     fill=body_color, outline=body_color)
        draw.ellipse([x - 55*scale, y - 35*scale, x - 10*scale, y + 10*scale],
                     fill=body_color, outline=body_color)

        draw.polygon([(x - 15*scale, y - 30*scale),
                      (x - 25*scale, y - 50*scale),
                      (x - 35*scale, y - 30*scale)],
                     fill=ear_color)
        draw.polygon([(x - 35*scale, y - 30*scale),
                      (x - 50*scale, y - 55*scale),
                      (x - 60*scale, y - 30*scale)],
                     fill=ear_color)

        draw.polygon([(x - 20*scale, y - 32*scale),
                      (x - 25*scale, y - 42*scale),
                      (x - 32*scale, y - 32*scale)],
                     fill='#FFE4E8')
        draw.polygon([(x - 40*scale, y - 32*scale),
                      (x - 50*scale, y - 47*scale),
                      (x - 55*scale, y - 32*scale)],
                     fill='#FFE4E8')

        draw.arc([x - 53*scale, y - 18*scale, x - 38*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)
        draw.arc([x - 35*scale, y - 18*scale, x - 20*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)

        draw.polygon([(x - 35*scale, y + 2*scale),
                      (x - 38*scale, y + 8*scale),
                      (x - 32*scale, y + 8*scale)],
                     fill='#E8A0A8')

        for i in [-1, 1]:
            draw.line([x - 35*scale, y + 5*scale, x - 55*scale, y + (5+i*3)*scale],
                     fill='#D4C4B0', width=1)
            draw.line([x - 35*scale, y + 8*scale, x - 55*scale, y + (8+i*3)*scale],
                     fill='#D4C4B0', width=1)

        draw.line([x + 25*scale, y, x + 45*scale, y - 25*scale],
                 fill=body_color, width=int(8*scale))
        draw.line([x + 45*scale, y - 25*scale, x + 35*scale, y - 40*scale],
                 fill=body_color, width=int(6*scale))

def draw_heart(draw, cx, cy, size, color='#FF6B8A'):
    """Draw a heart shape"""
    heart_points = []
    heart_points.append((cx, cy + size * 0.3))
    heart_points.append((cx - size * 0.05, cy + size * 0.15))
    heart_points.append((cx - size * 0.3, cy + size * 0.1))
    heart_points.append((cx - size * 0.4, cy - size * 0.05))
    heart_points.append((cx - size * 0.3, cy - size * 0.3))
    heart_points.append((cx, cy - size * 0.5))
    heart_points.append((cx + size * 0.3, cy - size * 0.3))
    heart_points.append((cx + size * 0.4, cy - size * 0.05))
    heart_points.append((cx + size * 0.3, cy + size * 0.1))
    heart_points.append((cx + size * 0.05, cy + size * 0.15))

    draw.polygon(heart_points, fill=color)

def create_splash_icon():
    """Create splash icon"""
    size = 512
    img = create_gradient_background(
        (size, size),
        (255, 245, 230, 255),
        (255, 228, 232, 255),
    )
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Draw two cats cuddling
    cat_size = size * 0.5
    draw_cat(draw, center - size*0.1, center + size*0.08, cat_size, True, '#F8B4C4')
    draw_cat(draw, center + size*0.1, center + size*0.08, cat_size, False, '#F8B4C4')

    # Heart in the middle
    heart_size = size * 0.18
    draw_heart(draw, center, center - size*0.12, heart_size, '#FF6B8A')

    # Add subtle glow
    for i in range(3):
        overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)
        glow_size = size * (0.25 + i * 0.05)
        overlay_draw.ellipse(
            [center - glow_size/2, center - size*0.12 - glow_size/2,
             center + glow_size/2, center - size*0.12 + glow_size * 0.45],
            fill=(255, 107, 138, 15 - i*4)
        )
        img = Image.alpha_composite(img, overlay)

    return img

def main():
    print("Generating splash icon...")
    splash_icon = create_splash_icon()
    output_path = "/workspace/our_story/assets/splash_icon.png"
    splash_icon.save(output_path, "PNG")
    print(f"  Created {output_path}")

    # Also copy to drawable for reference
    import shutil
    shutil.copy(output_path, "/workspace/our_story/android/app/src/main/res/drawable/splash_icon.png")
    print("  Copied to android/app/src/main/res/drawable/")

    print("\n✨ Splash icon generated successfully!")

if __name__ == "__main__":
    main()
