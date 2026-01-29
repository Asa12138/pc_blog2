import os
from PIL import Image, ImageOps  # 导入ImageOps
import webp

def convert_to_webp(input_folder, output_folder, quality=80):
    # 遍历文件夹下的所有文件
    for filename in os.listdir(input_folder):
        # 确保文件是 jpg 或 png 格式
        if filename.lower().endswith(('.jpg', '.jpeg', '.png', '.JPG')):
            input_path = os.path.join(input_folder, filename)
            
            # 读取图片
            im = Image.open(input_path)
            
            # 🔧 关键修复：根据EXIF信息自动旋转图片至正确方向
            im = ImageOps.exif_transpose(im)
            
            # 构建输出路径
            output_path = os.path.join(output_folder, f"{os.path.splitext(filename)[0]}.webp")

            # 保存为 WebP 格式
            webp.save_image(im, output_path, quality=quality)
            print(f"{filename} 转换完成")

if __name__ == "__main__":
    # 输入文件夹和输出文件夹的路径
    input_folder_path = "/Users/asa/Documents/GitHub/Asa_web/images/2512Christmas/"
    output_folder_path = "/Users/asa/Documents/GitHub/Asa_web/images/2512Christmas/"

    # 创建输出文件夹（如果不存在）
    if not os.path.exists(output_folder_path):
        os.makedirs(output_folder_path)

    # 调用函数进行转换
    convert_to_webp(input_folder_path, output_folder_path, quality=80)
