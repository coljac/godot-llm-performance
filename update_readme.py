import csv
import re
import os
from collections import defaultdict
from datetime import datetime

# Define model display names
MODEL_NAMES = {
    "gpt-4.1": "ChatGPT 4.1",
    "o3-mini": "o3-mini",
    "claude-3.7-sonnet-20250219": "Sonnet 3.7",
    "gemini-pro-exp-03-25": "Gemini Pro 2.5",
    "deepseek-reasoner": "Deepseek R1"
}

# Reverse mapping from display names to model IDs
REVERSE_MODEL_NAMES = {v: k for k, v in MODEL_NAMES.items()}

# Define task categories
TASK_CATEGORIES = {
    "1": "2D",
    "2": "3D",
    "3": "3D",
    "4": "2D",
    "5": "2D",
    "6": "3D",
    "7": "3D",
    "8": "Control",
    "9": "Control"
}

# Define status symbol mapping
STATUS_SYMBOLS = {
    "Y": "✅",
    "N": "❌",
    "-": "-",
    "P": "😐"
}

def read_csv(filename):
    """Read the benchmark results CSV file."""
    results = []
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Convert status letters to symbols
            for field in ['script', 'scene', 'shader']:
                if row[field] in STATUS_SYMBOLS:
                    row[field] = STATUS_SYMBOLS[row[field]]
            results.append(row)
    return results

def extract_previous_rankings(readme_path):
    """Extract previous rankings from the README.md file."""
    previous_rankings = {}
    
    try:
        with open(readme_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Look for the leaderboard table
        leaderboard_match = re.search(r"## Leaderboard.*?\n\n\|.*?\n\|.*?\n(.*?)\n\n", content, re.DOTALL)
        if leaderboard_match:
            leaderboard_rows = leaderboard_match.group(1).strip().split('\n')
            
            for row in leaderboard_rows:
                # Extract rank and model name from the row
                match = re.match(r"\|\s*(\d+).*?\|\s*([^|]+?)\s*\|", row)
                if match:
                    rank = int(match.group(1))
                    model_display = match.group(2).strip()
                    
                    # Convert display name to model ID
                    if model_display in REVERSE_MODEL_NAMES:
                        model_id = REVERSE_MODEL_NAMES[model_display]
                        previous_rankings[model_id] = rank
                    else:
                        # Handle custom model names not in our mapping
                        for model_id, name in MODEL_NAMES.items():
                            if name in model_display:
                                previous_rankings[model_id] = rank
                                break
    except Exception as e:
        print(f"Warning: Could not extract previous rankings: {e}")
    
    return previous_rankings

def calculate_leaderboard(results):
    """Calculate the leaderboard scores by category."""
    scores = defaultdict(lambda: defaultdict(int))
    counts = defaultdict(lambda: defaultdict(int))
    
    for result in results:
        model = result['model']
        task = result['task']
        score = int(result['score'])
        
        category = TASK_CATEGORIES.get(task, "Other")
        scores[model][category] += score
        counts[model][category] += 1
    
    # Calculate averages
    leaderboard = {}
    for model in scores:
        leaderboard[model] = {}
        total_score = 0
        total_count = 0
        
        for category in ["2D", "3D", "Control", "Shader"]:
            if counts[model][category] > 0:
                avg_score = scores[model][category] / counts[model][category]
                leaderboard[model][category] = round(avg_score, 1)
                total_score += scores[model][category]
                total_count += counts[model][category]
            else:
                leaderboard[model][category] = ""
        
        if total_count > 0:
            leaderboard[model]["Total"] = round(total_score / total_count, 1)
        else:
            leaderboard[model]["Total"] = ""
    
    return leaderboard

def generate_leaderboard_table(leaderboard, previous_rankings):
    """Generate the leaderboard table markdown with rankings and movement indicators."""
    # Get today's date
    today = datetime.now().strftime("%Y-%m-%d")
    
    # Sort models by total score (descending)
    sorted_models = sorted(
        leaderboard.keys(),
        key=lambda m: float(leaderboard[m]["Total"]) if leaderboard[m]["Total"] else 0,
        reverse=True
    )
    
    # Generate table header with date
    table = f"## Leaderboard (updated: {today})\n\n"
    table += "| Rank | Model      | 2D | 3D | Control | Shader | Total |\n"
    table += "|------|------------|----|----|---------|--------|-------|\n"
    
    # Generate table rows with rank and movement indicators
    for idx, model_id in enumerate(sorted_models):
        model_name = MODEL_NAMES.get(model_id, model_id)
        current_rank = idx + 1
        
        # Determine movement indicator
        if model_id in previous_rankings:
            prev_rank = previous_rankings[model_id]
            if current_rank < prev_rank:
                movement = "↑"  # Moved up
            elif current_rank > prev_rank:
                movement = "↓"  # Moved down
            else:
                movement = "-"  # No change
        else:
            movement = "NEW"  # New entry
        
        # Format the rank with movement indicator
        rank_display = f"{current_rank} {movement}"
        
        # Build the table row
        row = f"| {rank_display} | {model_name} |"
        for category in ["2D", "3D", "Control", "Shader", "Total"]:
            row += f" {leaderboard[model_id][category]} |"
        table += row + "\n"
    
    return table

def generate_model_tables(results):
    """Generate individual model result tables."""
    model_tables = {}
    
    for model_id in set(r['model'] for r in results):
        model_name = MODEL_NAMES.get(model_id, model_id)
        model_results = [r for r in results if r['model'] == model_id]
        
        table = "| Task | Script | Scene | Shader | Score |  Notes |\n"
        table += "|------|--------|-------|--------|-------|--------|\n"
        
        for result in sorted(model_results, key=lambda r: int(r['task'])):
            row = f"| {result['task']} | {result['script']} | {result['scene']} | {result['shader']} | {result['score']} | {result['notes']} |\n"
            table += row
        
        model_tables[model_id] = table
    
    return model_tables

def update_readme(readme_path, leaderboard_table, model_tables):
    """Update the README.md file with new tables."""
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Update leaderboard
    leaderboard_pattern = r"## Leaderboard.*?\n\n\|.*?\n\|.*?\n(.*?)\n\n"
    updated_content = re.sub(
        leaderboard_pattern,
        f"{leaderboard_table}\n\n",
        content,
        flags=re.DOTALL
    )
    
    # Update model tables
    for model_id, table in model_tables.items():
        model_name = MODEL_NAMES.get(model_id, model_id)
        
        # Handle special cases for model headers
        if model_id == "gpt-4.1":
            header = "### GPT 4.1"
        elif model_id == "o3-mini":
            header = "### o3-mini"
        elif model_id == "claude-3.7-sonnet-20250219":
            header = "### Sonnet 3.7"
        elif model_id == "gemini-pro-exp-03-25":
            header = "### Gemini Pro 2.5"
        elif model_id == "deepseek-reasoner":
            header = "### Deepseek R1"
        else:
            header = f"### {model_name}"
        
        # Fix the regex pattern by using raw string
        model_pattern = re.escape(header) + r"\n\n\|.*?\n\|.*?\n(.*?)\n\n"
        
        if re.search(model_pattern, updated_content, re.DOTALL):
            updated_content = re.sub(
                model_pattern,
                f"{header}\n\n{table}\n\n",
                updated_content,
                flags=re.DOTALL
            )
        else:
            # If the model section doesn't exist, add it before "## The tasks"
            updated_content = updated_content.replace(
                "## The tasks",
                f"{header}\n\n{table}\n\n## The tasks"
            )
    
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)

def main():
    readme_path = 'README.md'
    results = read_csv('benchmark_results.csv')
    previous_rankings = extract_previous_rankings(readme_path)
    leaderboard = calculate_leaderboard(results)
    leaderboard_table = generate_leaderboard_table(leaderboard, previous_rankings)
    model_tables = generate_model_tables(results)
    update_readme(readme_path, leaderboard_table, model_tables)
    print("README.md has been updated successfully!")

if __name__ == "__main__":
    main()

