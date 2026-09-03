import argparse
import matplotlib.pyplot as plt
import pandas as pd
from pathlib import Path
import sys

def read_data(input_dir, file_pattern="tmpout.*"):
    """Finds matching files and extracts the second column into a DataFrame."""
    files = list(Path(input_dir).glob(file_pattern))

    if not files:
        print(f"Error: No files found matching '{file_pattern}'.")
        sys.exit(1)

    print(f"Found {len(files)} file(s). Processing...")

    data_frames = []
    for file in files:
        try:
            # sep=r'\s+' handles varying whitespace; usecols=[1] gets the 2nd column
            #df = pd.read_csv(file, sep=r'\s+', header=None, usecols=[1], names=['Value'])
            df = pd.read_csv(file, sep=r'\s+', header=None, index_col=0)
            df.columns = [file]
            data_frames.append(df)
        except Exception as e:
            print(f"Failed to read {file}: {e}")

    if not data_frames:
        print("Error: No valid data could be extracted.")
        sys.exit(1)

    # Combine into one DataFrame and return it along with the file count
    return pd.concat(data_frames, axis=1)

def compute_statistics(df):
    """Computes and prints basic descriptive statistics."""
    stats = df.T.describe().T
    
    print("\n---------- Latency Statistics ----------")
    print(stats.to_string())
    print("-" * 70)
    
    return stats

def plot_boxplot(df, machine_name, output_dir, output_image="combined_boxplot.png"):
    """Generates a box plot from pre-computed statistical quantities."""
    run_count = int(df["count"].iloc[0])

    # Convert dataframe rows into the dictionary format expected by bxp()
    box_data = []
    for index, row in df.iterrows():
        box_data.append({
            'label': str(index),  # The index (file size) becomes the x-axis label
            'whislo': row['min'],
            'q1': row['25%'],
            'med': row['50%'],
            'q3': row['75%'],
            'whishi': row['max']
        })

    fig, ax = plt.subplots(figsize=(12, 6))
    
    # Draw the boxplots using the statistical summaries
    bp = ax.bxp(box_data, patch_artist=True, showfliers=False)
    
    # Apply styling
    for patch in bp['boxes']:
        patch.set_facecolor('lightblue')
        
    ax.set_title(f"{machine_name} Latency by Packet Size ({run_count} Runs)")
    ax.set_xlabel("Packet Size (bytes)")
    ax.set_ylabel("Latency (us)")
    
    # Rotate x-axis labels if the numbers overlap
    plt.xticks(rotation=45)
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    outpath = Path(output_dir).joinpath(output_image)

    plt.savefig(outpath, dpi=300, bbox_inches='tight')
    print(f"\nBox plot successfully saved as '{output_image}'.")
    
    plt.show()

def main():
    parser = argparse.ArgumentParser(description="Read latency data files, compute statistics, and plot boxplots.")
    parser.add_argument("-m", "--machine", required=True, help="Machine name to include in the plot title")
    parser.add_argument("-d", "--dir", required=True, help="Directory containing the latency data files")
    parser.add_argument("-o", "--outdir", required=True, help="Directory to save image file")
    
    args = parser.parse_args()
    
    # 1. Read the data
    combined_df = read_data(args.dir)
    
    # 2. Compute statistics
    stats_df = compute_statistics(combined_df)

    # 3. Plot the data
    img_outpath = Path(args.outdir)
    plot_boxplot(stats_df, args.machine, img_outpath)

if __name__ == "__main__":
    main()
