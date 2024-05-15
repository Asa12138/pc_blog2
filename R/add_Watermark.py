
from PIL import Image, ImageDraw, ImageFont
import os
import argparse

def add_watermark(img_path, text, output_folder, position,font, font_size, font_color, opacity):
    img = Image.open(img_path)
    draw = ImageDraw.Draw(img)
    width, height = img.size
    if font_size<1:
        font_size=int(font_size*width)
    font = ImageFont.truetype(font+'.ttf', font_size)
    textwidth, textheight = draw.textsize(text, font)
    x = width - textwidth - position[0]
    y = height - textheight - position[1]
    draw.text((x, y), text, font=font,
              fill=(font_color[0], font_color[1], font_color[2], opacity))
    img_name = os.path.basename(img_path)
    img_name_without_ext = os.path.splitext(img_name)[0]
    img_ext = os.path.splitext(img_name)[1]
    new_img_name = img_name_without_ext + '' + img_ext
    new_img_path = os.path.join(output_folder, new_img_name)
    img.save(new_img_path)

def add_watermark_folder(folder_path, text, output_folder,
                         position,font, font_size,
                         font_color, opacity):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.jpg') or file.endswith('.png'):
                img_path = os.path.join(root, file)
                add_watermark(img_path,
                              text,
                              output_folder,
                              position,
                              font,
                              font_size,
                              font_color,
                              opacity)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Add watermark to images.')
    parser.add_argument('path', type=str,
                        help='path to image or folder')
    parser.add_argument('text', type=str,
                        help='watermark text')
    parser.add_argument('--output_folder', type=str,
                        default='add_watermark',
                        help='output folder name')
    parser.add_argument('--position', type=int,
                        nargs=2,
                        default=[10, 10],
                        help='position of watermark')
    parser.add_argument('--font', type=str,
                        default='Arial',
                        help='font of watermark')
    parser.add_argument('--font_size', type=float,
                        default=36,
                        help='font size of watermark')
    parser.add_argument('--font_color', type=int,
                        nargs=3,
                        default=[255, 255, 255],
                        help='font color of watermark')
    parser.add_argument('--opacity', type=int,
                        default=255,
                        help='opacity of watermark')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)

    if os.path.isfile(args.path):
        add_watermark(args.path,
                      args.text,
                      args.output_folder,
                      args.position,
                      args.font,
                      args.font_size,
                      args.font_color,
                      args.opacity)
        
    elif os.path.isdir(args.path):
        add_watermark_folder(args.path,
                             args.text,
                             args.output_folder,
                             args.position,
                             args.font,
                             args.font_size,
                             args.font_color,
                             args.opacity)
