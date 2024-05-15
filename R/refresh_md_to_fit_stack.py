import re

def convert_markdown_to_html(markdown_text):
    # 将插入图片的Markdown语法转换为HTML语法
    pattern = r"[^`\"]!\[(.*?)\]\((.*?)\){(.*?)}"
    matches = re.findall(pattern, markdown_text)
    for match in matches:
        title = match[0]
        src = match[1]
        attributes = match[2].split(",")
        attr_dict = dict([tuple(attribute.split("=")) for attribute in attributes])
        html_tag = f'<img src="{src}" title="{title}"'
        for key, value in attr_dict.items():
            html_tag += f' {key}="{value}"'
        html_tag += "/>"
        markdown_text = markdown_text.replace(f"![{title}]({src}){{{match[2]}}}", html_tag)
    return markdown_text

def convert_markdown_to_html2(markdown_text):
    # 将插入图片的Markdown语法转换为HTML语法
    pattern = r"[^`\"]!\[(.*?)\]\((.*?)\)"
    matches = re.findall(pattern, markdown_text)
    for match in matches:
        title = match[0]
        src = match[1]
        #attributes = match[2].split(",")
        #attr_dict = dict([tuple(attribute.split("=")) for attribute in attributes])
        html_tag = f'<img src="{src}" title="{title}"'
        # for key, value in attr_dict.items():
        #     html_tag += f' {key}="{value}"'
        html_tag += "/>"
        markdown_text = markdown_text.replace(f"![{title}]({src})", html_tag)
    return markdown_text

def convert_latex_to_md(latex_text):
    markdown_text=re.sub(r'[^`]`\\\((.*?)\\\)`',r'$\1$',latex_text)
    return markdown_text

def convert_markdown_file_to_html(file_path):
    # 读取Markdown文件
    with open(file_path, "r", encoding="utf-8") as f:
        markdown_text = f.read()

    # 将Markdown语法转换为HTML语法
    html_text = convert_markdown_to_html(markdown_text)
    html_text = convert_markdown_to_html2(html_text)
    html_text = convert_latex_to_md(html_text)
    # 将HTML文本写入文件
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(html_text)


#更新所有新保存的md文件
if __name__ == "__main__":
    import os
    import datetime
    
    # 定义要查找的目录
    directory = './content/'
    
    # 存储所有新保存的md文件
    new_md_files = []
    
    # 读取上一次检查的时间戳
    if os.path.isfile('last_check_time.txt'):
        with open('last_check_time.txt', 'r') as f:
            last_check_time = datetime.datetime.strptime(f.read(), '%Y-%m-%d %H:%M:%S.%f')
    else:
        last_check_time = datetime.datetime.now()
    
    # 递归查找目录下的所有文件
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                mod_time = datetime.datetime.fromtimestamp(os.path.getmtime(file_path))
                if mod_time > last_check_time:
                    new_md_files.append(file_path)
    
    # 打印所有新保存的md文件
    # for file_path in new_md_files:
    #     print("更新的.md文件：", file_path)
    for file_path in new_md_files:
        convert_markdown_file_to_html(file_path)
        
    # 更新上一次检查的时间戳
    last_check_time = datetime.datetime.now()
    # 将上一次检查的时间戳保存到文件中
    with open('last_check_time.txt', 'w') as f:
        f.write(last_check_time.strftime('%Y-%m-%d %H:%M:%S.%f'))
