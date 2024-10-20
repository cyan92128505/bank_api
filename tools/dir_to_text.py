import os
import argparse

def directory_to_text(startpath, ignore_dirs=None, ignore_files=None):
    if ignore_dirs is None:
        ignore_dirs = set()
    if ignore_files is None:
        ignore_files = set()
    
    output = []
    for root, dirs, files in os.walk(startpath):
        dirs[:] = [d for d in dirs if d not in ignore_dirs]
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        output.append(f'{indent}{os.path.basename(root)}/')
        subindent = ' ' * 4 * (level + 1)
        for f in sorted(files):
            if f not in ignore_files:
                output.append(f'{subindent}{f}')
    return '\n'.join(output)

def main():
    parser = argparse.ArgumentParser(description='Convert directory structure to text.')
    parser.add_argument('path', help='The path to the directory')
    parser.add_argument('--ignore-dirs', nargs='*', default=['.git', '__pycache__', 'venv'],
                        help='Directories to ignore (default: .git __pycache__ venv)')
    parser.add_argument('--ignore-files', nargs='*', default=['.gitignore', '.DS_Store'],
                        help='Files to ignore (default: .gitignore .DS_Store)')
    parser.add_argument('--output', help='Output file (if not specified, prints to console)')

    args = parser.parse_args()

    text_structure = directory_to_text(args.path, set(args.ignore_dirs), set(args.ignore_files))

    if args.output:
        with open(args.output, 'w') as f:
            f.write(text_structure)
        print(f"Directory structure has been written to {args.output}")
    else:
        print(text_structure)

if __name__ == "__main__":
    main()