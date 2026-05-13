#!/usr/bin/env python3
"""Generate app icons for Our Story couple app with warm embrace design"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

def create_gradient_background(size, color1, color2, direction='radial'):
    """Create gradient background"""
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    pixels = img.load()
    width, height = size
    
    for y in range(height):
        for x in range(width):
            if direction == 'radial':
                dist = math.sqrt((x - width/2)**2 + (y - height/2)**2)
                max_dist = math.sqrt((width/2)**2 + (height/2)**2)
                ratio = min(1.0, dist / max_dist)
            else:
                ratio = y / height
            
            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            a = int(color1[3] * (1 - ratio) + color2[3] * ratio) if len(color1) > 3 else 255
            
            pixels[x, y] = (r, g, b, a)
    
    return img

def draw_cat(draw, x, y, size, facing_right=True, color='#F8B4C4'):
    """Draw a cute simplified cat"""
    body_color = color
    ear_color = '#E8A0A8'
    
    scale = size / 100
    
    if facing_right:
        # Body (oval)
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
        
        # Eyes (closed, happy)
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
        # Mirror image for left cat
        draw.ellipse([x - 30*scale, y - 15*scale, x + 30*scale, y + 25*scale], 
                     fill=body_color, outline=body_color)
        draw.ellipse([x - 55*scale, y - 35*scale, x - 10*scale, y + 10*scale],
                     fill=body_color, outline=body_color)
        
        # Ears
        draw.polygon([(x - 15*scale, y - 30*scale), 
                      (x - 25*scale, y - 50*scale),
                      (x - 35*scale, y - 30*scale)],
                     fill=ear_color)
        draw.polygon([(x - 35*scale, y - 30*scale),
                      (x - 50*scale, y - 55*scale),
                      (x - 60*scale, y - 30*scale)],
                     fill=ear_color)
        
        # Inner ears
        draw.polygon([(x - 20*scale, y - 32*scale),
                      (x - 25*scale, y - 42*scale),
                      (x - 32*scale, y - 32*scale)],
                     fill='#FFE4E8')
        draw.polygon([(x - 40*scale, y - 32*scale),
                      (x - 50*scale, y - 47*scale),
                      (x - 55*scale, y - 32*scale)],
                     fill='#FFE4E8')
        
        # Eyes (closed, happy)
        draw.arc([x - 53*scale, y - 18*scale, x - 38*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)
        draw.arc([x - 35*scale, y - 18*scale, x - 20*scale, y - 5*scale],
                 0, math.pi, fill='#8B7355', width=2)
        
        # Nose
        draw.polygon([(x - 35*scale, y + 2*scale),
                      (x - 38*scale, y + 8*scale),
                      (x - 32*scale, y + 8*scale)],
                     fill='#E8A0A8')
        
        # Whiskers
        for i in [-1, 1]:
            draw.line([x - 35*scale, y + 5*scale, x - 55*scale, y + (5+i*3)*scale],
                     fill='#D4C4B0', width=1)
            draw.line([x - 35*scale, y + 8*scale, x - 55*scale, y + (8+i*3)*scale],
                     fill='#D4C4B0', width=1)
        
        # Tail
        draw.line([x + 25*scale, y, x + 45*scale, y - 25*scale],
                 fill=body_color, width=int(8*scale))
        draw.line([x + 45*scale, y - 25*scale, x + 35*scale, y - 40*scale],
                 fill=body_color, width=int(6*scale))

def draw_heart(draw, cx, cy, size, color='#FF6B8A'):
    """Draw a heart shape"""
    x = cx - size/2
    y = cy - size/2
    
    points = []
    width = size
    height = size * 0.9
    
    for i in range(len(points), 50):
        t = i / 50.0 * 2 * math.pi
        if t < math.pi:
            x1 = width/2 * (2 * math.cos(t) - math.cos(2*t)) / 2 + width/2
            y1 = height/2 * (2 * math.sin(t) - math.sin(2*t)) / 2 + height/2
            points.append((cx - width/2 + x1, cy - height/2 + y1))
    
    # Simple heart using bezier approximation
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

def create_icon(size):
    """Create app icon for given size"""
    img = create_gradient_background(
        (size, size),
        (255, 245, 230, 255),  # Cream
        (255, 228, 232, 255),   # Soft pink
        'radial'
    )
    draw = ImageDraw.Draw(img)
    
    center = size // 2
    
    # Draw two cats cuddling
    cat_size = size * 0.45
    
    # Left cat (facing right)
    draw_cat(draw, center - size*0.08, center + size*0.05, cat_size, True, '#F8B4C4')
    
    # Right cat (facing left)
    draw_cat(draw, center + size*0.08, center + size*0.05, cat_size, False, '#F8B4C4')
    
    # Small heart in the middle
    heart_size = size * 0.15
    draw_heart(draw, center, center - size*0.08, heart_size, '#FF6B8A')
    
    # Add subtle glow effect
    for i in range(3):
        overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)
        glow_size = size * (0.3 + i * 0.05)
        glow_pos = (center - glow_size/2, center - size*0.1 - glow_size/2)
        overlay_draw.ellipse(
            [glow_pos[0], glow_pos[1], glow_pos[0] + glow_size, glow_pos[1] + glow_size * 0.9],
            fill=(255, 107, 138, 20 - i*5)
        )
        img = Image.alpha_composite(img, overlay)
    
    return img

def create_splash():
    """Create splash screen image"""
    width, height = 1080, 1920
    
    img = create_gradient_background(
        (width, height),
        (255, 253, 245, 255),  # Warm white
        (255, 228, 232, 255),   # Soft pink
        'vertical'
    )
    draw = ImageDraw.Draw(img)
    
    # Title "Our Story"
    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 120)
        subtitle_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 48)
    except:
        title_font = ImageFont.load_default()
        subtitle_font = ImageFont.load_default()
    
    title = "Our Story"
    subtitle = "属于我们的故事"
    
    # Get text bounding box
    title_bbox = draw.textbbox((0, 0), title, font=title_font)
    title_width = title_bbox[2] - title_bbox[0]
    title_x = (width - title_width) // 2
    
    subtitle_bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
    subtitle_width = subtitle_bbox[2] - subtitle_bbox[0]
    subtitle_x = (width - subtitle_width) // 2
    
    # Draw heart above title
    heart_size = 150
    draw_heart(draw, width//2, height//3 - 100, heart_size, '#FF6B8A')
    
    # Draw title
    draw.text((title_x, height//3), title, font=title_font, fill=(139, 115, 85, 255))
    
    # Draw subtitle
    draw.text((subtitle_x, height//3 + 150), subtitle, font=subtitle_font, fill=(139, 115, 85, 180))
    
    # Draw cute cats at bottom
    cat_size = 300
    draw_cat(draw, width//2 - 50, height - 250, cat_size, True, '#F8B4C4')
    draw_cat(draw, width//2 + 50, height - 250, cat_size, False, '#F8B4C4')
    
    return img

def main():
    """Generate all icons"""
    base_path = "/workspace/our_story"
    
    # Icon sizes for Android mipmap directories
    icon_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }
    
    # Generate app icons
    print("Generating app icons...")
    for dir_name, size in icon_sizes.items():
        icon = create_icon(size)
        output_path = f"{base_path}/android/app/src/main/res/{dir_name}/ic_launcher.png"
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        icon.save(output_path, "PNG")
        print(f"  Created {output_path} ({size}x{size})")
    
    # Also create adaptive icon foreground
    print("\nGenerating adaptive icon foreground...")
    foreground = create_icon(1024)
    foreground_path = f"{base_path}/android/app/src/main/res/drawable/ic_launcher_foreground.png"
    foreground.save(foreground_path, "PNG")
    print(f"  Created {foreground_path}")
    
    # Create splash screen
    print("\nGenerating splash screen...")
    splash = create_splash()
    splash_path = f"{base_path}/android/app/src/main/res/drawable/splash.png"
    splash.save(splash_path, "PNG")
    print(f"  Created {splash_path}")
    
    print("\n✨ All icons generated successfully!")

if __name__ == "__main__":
    main()
