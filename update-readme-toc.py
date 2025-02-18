import os
from pathlib import Path

def generate_toc(start_path):
    toc = ["## Table of Contents", ""]
    ignored = {'.git', '__pycache__', 'node_modules', '.idea', '.vscode'}
    
    for root, dirs, files in os.walk(start_path, topdown=True):
        # Remove ignored directories
        dirs[:] = [d for d in dirs if d not in ignored]
        
        # Get relative path
        rel_path = os.path.relpath(root, start_path)
        if rel_path == '.':
            continue
            
        # Calculate depth for indentation
        depth = len(Path(rel_path).parts)
        indent = "  " * (depth - 1) if depth > 0 else ""  # No indent for top level
        
        # Add directory with proper Markdown list syntax
        toc.append(f"{indent}- 📁 **{os.path.basename(root)}/**")
        
        # Add files with proper Markdown list syntax
        for file in sorted(files):
            if not file.startswith('.'):
                toc.append(f"{indent}- 📄 {file}")
    
    # Add extra empty line at the end
    toc.append("")
    return "\n".join(toc)

def update_readme(content):
    readme_path = "README.md"
    try:
        # Create README if it doesn't exist
        if not os.path.exists(readme_path):
            print("Creating new README.md")
            with open(readme_path, 'w', encoding='utf-8') as f:
                f.write("# Scripts\n\nScripts to improve developer experience.\n\n" + content)
            return
            
        # Read existing README
        with open(readme_path, 'r', encoding='utf-8') as f:
            existing = f.read()
            
        # If there's no ToC yet, append it
        if "## Table of Contents" not in existing:
            print("Adding new Table of Contents")
            final_content = f"{existing.strip()}\n\n{content}"
        else:
            # Replace only the Table of Contents section
            print("Updating existing Table of Contents")
            parts = existing.split("## Table of Contents")
            before_toc = parts[0]
            
            # Find the end of ToC section (next heading or EOF)
            remaining = parts[1]
            next_heading_pos = remaining.find("\n#")
            if (next_heading_pos != -1):
                after_toc = remaining[next_heading_pos:]
            else:
                after_toc = ""
                
            final_content = f"{before_toc.strip()}\n\n{content}{after_toc}"
        
        # Write the updated content
        with open(readme_path, 'w', encoding='utf-8') as f:
            f.write(final_content)
                
    except Exception as e:
        print(f"Error updating README: {e}")

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    toc = generate_toc(script_dir)
    update_readme(toc)
